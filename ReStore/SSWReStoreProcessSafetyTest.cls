"Filed out from Dolphin Smallalk"!

SSWReStoreAbstractQueryTest subclass: #SSWReStoreProcessSafetyTest
	instanceVariableNames: 'semaphore'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreProcessSafetyTest guid: (GUID fromString: '{3a616df7-8491-46b5-9637-0bb45a632205}')!
SSWReStoreProcessSafetyTest comment: ''!
!SSWReStoreProcessSafetyTest categoriesForClass!Unclassified! !
!SSWReStoreProcessSafetyTest methodsFor!

firstActiveReStore

	^SSWReStore activeReStores do: [ :each | ^each]!

setUp

	semaphore := Semaphore new.
	self wrappedMethod: nil.

	super setUp!

tearDown

	self wrappedMethod ifNotNil: 
		[ :method |
		method methodClass methodDictionary at: method selector put: method.
		method methodClass flushMethodCache].

	(SSWReStoreProcessSafetyTest>>#yieldAfterWrappedMethod) recompile.

	super tearDown!

testBeginDuringBegin

	"During a beginTransaction, at the end of rolling back an active dumb transaction, a higher priority process can initiate a new dumb transaction, which then leads to us getting a nesting error when we try to start our transaction."

	| john |

	john := self john.

	"Start a dumb transaction here"
	john firstName.

	"Arrange for a new dumb transaction to be started immediately after the current one is rolled back"
	[semaphore wait. 
	john firstName] forkAt: Processor activeProcess priority + 1.

	self wrappedMethod: (SSWReStore>>#softRollback).

	"Previously gave error 'Nesting of transaction not supported' "
	self shouldnt: [reStore beginTransaction] raise: Error description: 'Nesting of transaction not supported'!

testGlobablProxyLookupWhenSuspended

	"Verify global proxy lookup (i.e. when not referencing a particular ReStore instance) works when one or more active ReStore instances have their transactionMutex stuck in a suspended process.
	This can happen during development e.g. when debugging, and prevents proxy lookup for any ReStores from working (subject to ordering of the activeReStores set)"

	| otherReStores priorReStore john lookupProcess proxy |

	"Set up other ReStores until we get one before ours"
	otherReStores := OrderedCollection new.
	[priorReStore := SSWReStore new.
	otherReStores add: priorReStore.
	self initReStore: priorReStore.
	priorReStore connect.
	self addClassesTo: priorReStore.
	self firstActiveReStore == priorReStore] whileFalse.

	"Suspend priorReStore in the transactionMutex"
	[priorReStore transactionCritical: [Processor activeProcess suspend]] forkAt: Processor activeProcess priority + 1.
	self deny: priorReStore transactionMutex owner isActive.

	john := self john.
	self assert: john isDBProxy.

	lookupProcess := [proxy :=SSWReStore proxyForObject: john ifNone: [nil]] forkAt: Processor activeProcess priority + 1.

	lookupProcess isTerminated ifFalse: 
		[lookupProcess terminate.
		self signalFailure: 'Proxy lookup was locked'].

	self assert: proxy notNil.
	self assert: proxy identicalTo: john.

	priorReStore transactionMutex owner resume.
	otherReStores do: [ :each | each disconnect]!

testGlobablProxyProxyLookup

	"Verify global proxy lookup (i.e. when not referencing a particular ReStore instance) works when passed a proxy rather than an object (the normal case).
	This handles the situation where a proxy is flipped in one process whilst lookup occurs in another"

	| john |

	john := self john.
	
	self assert: john isDBProxy.
	self assert: (SSWReStore proxyForObject: john ifNone: [nil]) identicalTo: john!

testInconsistentProxySwap

	"Verify detection of an invalid proxy swap attempt"

	|  john proxy |

	john := self john.
	proxy := john _proxiedObject.

	self assert: john isDBProxy.
	self deny: proxy isDBProxy.

	john firstName.

	"john and proxy should now have swapped to match the variable names"
	self deny: john isDBProxy.
	self assert: proxy isDBProxy.

	"Sending a message via the proxy should raise an error since it is already swapped to the object"
	self should: [proxy firstName] raise: Error.

	reStore rollbackTransaction.

	"Should now be OK"
	self assert: john isDBProxy.
	self shouldnt: [john firstName] raise: Error!

testInconsistentProxyUnswap

	"Verify detection of an invalid proxy unswap attempt"

	|  john proxy |

	john := self john.

	"Should not be able to unswap an unswapped proxy"
	proxy := john _proxiedObject.
	self assert: john isDBProxy.
	self should: [john _unswap] raise: Error.

	john firstName.

	"Swapped - should now be possible"
	self deny: john isDBProxy.
	self assert: proxy isDBProxy.
	self shouldnt: [proxy _unswap] raise: Error!

testObjectLookupDuringTransaction

	"Verify object lookup in one process is blocked whilst a transaction occurs in another"

	| john id process wasTransactionInProgress |

	john := self john.
	id := john _id.

	process := 
		[self deny: reStore isTransactionInProgress.
		semaphore wait. 
		"Execution should restart here when the object is referenced as part of the commit, but should immediately block on the lookup, until the store transaction below is complete"
		self assert: reStore isTransactionInProgress.
		self assert: (reStore cachedObjectOfClass: SimplePerson withID: id ifAbsent: [nil]) notNil.
		wasTransactionInProgress := reStore isTransactionInProgress] forkAt: Processor activeProcess priority + 1.

	self wrappedMethod: (SSWDBProxy>>#__referenced).
	john storeIn: reStore.

	"Execution resumes here once the higher priority process has terminated"
	self assert: process isTerminated.
	self deny: wasTransactionInProgress!

testProxyDoesNotUnderstandWhenPreempted

	"Verify no error occurs and the message is still executed if a proxy is swapped by a higher priority process right at the start of processing a doesNotUnderstand:"

	| john dnu result |

	john := self john.
	
	"We simulate this situation by evaluating SSWDBProxy>>#doesNotUnderstand: with an unproxied object"
	john firstName.
	self deny: john isDBProxy.

	"Make a local copy of the method in the unproxied object'ss class in order to invoke it"
	dnu := (SSWDBProxy>>#doesNotUnderstand:) copy.
	dnu methodClass: john class.

	self shouldnt: [result := dnu value: john withArguments: {Message selector: #surname}] raise: Error.
	self assert: result equals: 'Smith'!

testProxyLookupDuringTransaction

	"Verify proxy lookup in one process is blocked whilst a transaction occurs in another"

	| john version process proxy wasTransactionInProgress |

	john := self john.
	version := john _version.
	
	process := 
		[self deny: reStore isTransactionInProgress.
		semaphore wait. 
		"Execution should restart here when the object is referenced as part of the commit, but should immediately block on the _dbProxyIn: lookup, and shouldn't resume until the store transaction below is complete"
		self assert: reStore isTransactionInProgress.
		proxy := john _dbProxyIn: reStore.
		wasTransactionInProgress := reStore isTransactionInProgress] forkAt: Processor activeProcess priority + 1.

	john surname: 'updated'.
	self wrappedMethod: (SSWDBProxy>>#__referenced).

	john storeIn: reStore.

	"Execution resumes here once the higher priority process has terminated"
	self assert: process isTerminated.
	self assert: proxy isDBProxy.
	self deny: wasTransactionInProgress.
	self assert: proxy _version equals: (version + 1).!

testProxyProxyLookup

	"Verify  proxy lookup works when passed a proxy rather than an object (the normal case).
	This handles the situation where a proxy is flipped in one process whilst lookup occurs in another"

	| john |

	john := self john.
	
	self assert: john isDBProxy.
	self assert: (reStore activeProxyForObject: john ifNone: [nil]) identicalTo: john!

testQueryingDuringTransaction

	"Verify querying in one process is blocked whilst a transaction occurs in another"

	| storedInstances john process wasTransactionInProgress |

	storedInstances := SimplePerson storedInstancesIn: reStore.
	john := self john.

	process := 
		[self deny: reStore isTransactionInProgress.
		semaphore wait. 
		"Execution should restart here when the object is referenced as part of the commit, but should immediately block on the lookup, until the store transaction below is complete"
		self assert: reStore isTransactionInProgress.
		self assert: (storedInstances select: [ :each | each surname = 'Brown']) size = 2.
		wasTransactionInProgress := reStore isTransactionInProgress] forkAt: Processor activeProcess priority + 1.

	self wrappedMethod: (SSWDBProxy>>#__referenced).
	john storeIn: reStore.

	"Execution resumes here once the higher priority process has terminated"
	self assert: process isTerminated.
	self deny: wasTransactionInProgress!

wrappedMethod

	^(##(self)>>#yieldAfterWrappedMethod) literalAt: 1!

wrappedMethod: aCompiledMethod

	| wrapper |

	(SSWReStoreProcessSafetyTest>>#yieldAfterWrappedMethod) recompile.
	wrapper := SSWReStoreProcessSafetyTest>>#yieldAfterWrappedMethod.

	wrapper
		isImmutable: false;
		literalAt: (wrapper literals indexOf: 'wrappedMethod') put: aCompiledMethod;
		literalAt: (wrapper literals indexOf: 'semaphore') put: (aCompiledMethod ifNotNil: [semaphore]);
		isImmutable: true.

	aCompiledMethod isNil ifFalse: 
		[aCompiledMethod methodClass methodDictionary at: aCompiledMethod selector put: wrapper.
		aCompiledMethod methodClass flushMethodCache]!

yieldAfterWrappedMethod

	| result |

	result := 'wrappedMethod' value: self withArguments: #().
	'semaphore' signal.

	^result! !
!SSWReStoreProcessSafetyTest categoriesForMethods!
firstActiveReStore!accessing!private! !
setUp!public!running! !
tearDown!public!running! !
testBeginDuringBegin!public!unit tests! !
testGlobablProxyLookupWhenSuspended!public!unit tests! !
testGlobablProxyProxyLookup!public!unit tests! !
testInconsistentProxySwap!public!unit tests! !
testInconsistentProxyUnswap!public!unit tests! !
testObjectLookupDuringTransaction!public!unit tests! !
testProxyDoesNotUnderstandWhenPreempted!public!unit tests! !
testProxyLookupDuringTransaction!public!unit tests! !
testProxyProxyLookup!public!unit tests! !
testQueryingDuringTransaction!public!unit tests! !
wrappedMethod!accessing!public! !
wrappedMethod:!accessing!public! !
yieldAfterWrappedMethod!helpers!private! !
!


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

	john := (SimplePerson storedInstancesIn: reStore) detect: [ :each | each firstName = 'John'].

	"Start a dumb transaction here"
	john firstName.

	"Arrange for a new dumb transaction to be started immediately after the current one is rolled back"
	[semaphore wait. 
	john firstName] forkAt: Processor activeProcess priority + 1.

	self wrappedMethod: (SSWReStore>>#softRollback).

	"Previously gave error 'Nesting of transaction not supported' "
	self shouldnt: [reStore beginTransaction] raise: Error description: 'Nesting of transaction not supported'!

testGlobablProxyProxyLookup

	"Verify global proxy lookup (i.e. when not referencing a particular ReStore instance) works when passed a proxy rather than an object (the normal case).
	This handles the situation where a proxy is flipped in one process whilst lookup occurs in another"

	| john |

	john := (SimplePerson storedInstancesIn: reStore) detect: [ :each | each firstName = 'John'].
	
	self assert: john isDBProxy.
	self assert: (SSWReStore proxyForObject: john ifNone: [nil]) identicalTo: john!

testObjectLookupDuringTransaction

	"Verify object lookup in one process is blocked whilst a transaction occurs in another"

	| john id process wasTransactionInProgress |

	john := (SimplePerson storedInstancesIn: reStore) detect: [ :each | each firstName = 'John'].
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

testProxyLookupDuringTransaction

	"Verify proxy lookup in one process is blocked whilst a transaction occurs in another"

	| john version process proxy wasTransactionInProgress |

	john := (SimplePerson storedInstancesIn: reStore) detect: [ :each | each firstName = 'John'].
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

	john := (SimplePerson storedInstancesIn: reStore) detect: [ :each | each firstName = 'John'].
	
	self assert: john isDBProxy.
	self assert: (reStore activeProxyForObject: john ifNone: [nil]) identicalTo: john!

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
setUp!public!running! !
tearDown!public!running! !
testBeginDuringBegin!public!unit tests! !
testGlobablProxyProxyLookup!public!unit tests! !
testObjectLookupDuringTransaction!public!unit tests! !
testProxyLookupDuringTransaction!public!unit tests! !
testProxyProxyLookup!public!unit tests! !
wrappedMethod!accessing!public! !
wrappedMethod:!accessing!public! !
yieldAfterWrappedMethod!helpers!private! !
!


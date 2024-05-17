"Filed out from Dolphin Smallalk"!

SSWReStore2Test subclass: #SSWReStoreObjectAPITests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreObjectAPITests guid: (GUID fromString: '{4ddc6940-d762-4d55-b7eb-02267d50e20b}')!
SSWReStoreObjectAPITests comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreObjectAPITests categoriesForClass!Unclassified! !
!SSWReStoreObjectAPITests methodsFor!

_test05CommitFailureRefreshAndRollbackDirectedToProxy: aBoolean

	"Private - aBoolean controls whether the store message is directed to the real object or the proxy.
	Direct to the proxy previously failed to raise a StoreFailure exception, leaving a transaction in an open state"

	| obj1 obj1A oldName oldSingleName newName newSingleName failureRaised |

	obj1 := self _testCreateObject.

	"Update in the other session"
	self refreshDelay.
	obj1A := (OwnerTest storedInstancesIn: reStore2) first.
	obj1A single2 name: 'BLOCK UPDATE'.
	self assert: obj1A store.

	self refreshDelay.

	"Blocked clashing update should fail"
	oldName := obj1 name.
	oldSingleName := obj1 single2 name.
	newName := oldName, 'AAA'.
	newSingleName := oldSingleName, 'AAA'.
	obj1 name: newName.
	obj1 single2 name: newSingleName.

	aBoolean ifTrue: [reStore abandonTransaction].
	self deny: obj1 store.

	"Default handling abandons the transaction but leaves objects in the changed state"
	self deny: ReStore isTransactionInProgress.
	self assert: obj1 name = newName.
	self assert: obj1 single2 name = newSingleName.

	aBoolean ifTrue: [reStore abandonTransaction].
	failureRaised := false.

	"Retry with commit failure handling to rollback and refresh"
	[obj1 store] on: StoreFailure do: 
		[ :failedTransaction | 
		failureRaised := true.
		self assert: failedTransaction failedObjects asArray = {obj1 single2}.
		failedTransaction rollbackAndRefresh].

	self assert: failureRaised.

	"We should now be in the same state as the other session"
	self assert: obj1 name = obj1A name.
	self assert: obj1 single2 name = obj1A single2 name!

_test06StoreFailureRefreshAndRollforwardDirectedToProxy: aBoolean

	"Private - aBoolean controls whether the store message is directed to the real object or the proxy.
	Direct to the proxy previously failed to raise a StoreFailure exception, leaving a transaction in an open state"

	| obj1 obj1A oldName oldSingleName newName newSingleName failureRaised |

	obj1 := self _testCreateObject.

	"Update in the other session"
	self refreshDelay.
	obj1A := (OwnerTest storedInstancesIn: reStore2) first.
	obj1A single2 name: 'BLOCK UPDATE'.
	self assert: obj1A store.

	oldName := obj1 name.
	oldSingleName := obj1 single2 name.
	newName := oldName, 'AAA'.
	newSingleName := oldSingleName, 'AAA'.

	"Blocked clashing update should fail"
	self refreshDelay.
	obj1 name: newName.
	obj1 single2 name: newSingleName.

	aBoolean ifTrue: [reStore abandonTransaction].
	self deny: obj1 store.

	"Default handling abandons the transaction but leaves objects in the changed state"
	self deny: ReStore isTransactionInProgress.
	self assert: obj1 name = newName.
	self assert: obj1 single2 name = newSingleName.

	aBoolean ifTrue: [reStore abandonTransaction].
	failureRaised := false.

	"Retry with failure handling to refresh and rollforward"
	[obj1 store] on: StoreFailure do: 
		[ :failedTransaction | 
		failureRaised := true.
		self assert: failedTransaction failedObjects asArray = {obj1 single2}.
		failedTransaction refreshAndRollforward.
		self assert: failedTransaction commit].

	self assert: failureRaised.

	self assert: obj1 name = newName.
	self assert: obj1 single2 name = newSingleName.

	"Verify in the other session"
	self refreshDelay.
	obj1A refresh.

	self assert: obj1A name = newName.
	self assert: obj1A single2 name = newSingleName!

_testCreateObject

	| obj1 |

	obj1 := OwnerTest template name: 'owner1'.
	obj1 single2: (Test new name: 'test1').

	self assert: obj1 hasChanged.
	self assert: obj1 store.

	reStore simulateReconnect.

	obj1 := OwnerTest storedInstances lookup: [ :each | each name = 'owner1'].

	self assert: obj1 notNil.
	self assert: obj1 single2 notNil.
	self assert: obj1 single2 name = 'test1'.

	^obj1!

_testCreateObjects

	| obj1 obj2 |

	obj1 := OwnerTest template name: 'owner1'.
	obj2 := OwnerTest template name: 'owner2'.
	obj1 single2: (Test new name: 'test1').
	obj2 single2: (Test new name: 'test2').

	self assert: {obj1. obj2} storeAll.

	reStore simulateReconnect.

	obj1 := OwnerTest storedInstances lookup: [ :each | each name = 'owner1'].
	obj2 := OwnerTest storedInstances lookup: [ :each | each name = 'owner2'].

	self assert: obj1 notNil.
	self assert: obj1 single2 notNil.
	self assert: obj1 single2 name = 'test1'.

	self assert: obj2 notNil.
	self assert: obj2 single2 notNil.
	self assert: obj2 single2 name = 'test2'.

	^{obj1. obj2}!

createReStore

	"Private - Use the default instance"

	reStore := ReStore!

test01Store

	| obj1 |

	obj1 := self _testCreateObject.

	obj1 name: 'owner1A'.
	obj1 single2 name: 'test1A'.

	self assert: obj1 store.

	reStore simulateReconnect.
	
	obj1 := OwnerTest storedInstances first.
	self assert: obj1 name = 'owner1A'.
	self assert: obj1 single2 name = 'test1A'
!

test02Rollback

	| obj1 prevName prevSingleName |

	obj1 := self _testCreateObject.
	prevName := obj1 name.
	prevSingleName := obj1 single2 name.

	obj1 name: prevName, 'AAA'.
	obj1 single2 name: prevSingleName, 'BBB'.

	obj1 rollback.

	self assert: obj1 name = prevName.
	self assert: obj1 single2 name = prevSingleName!

test03Refresh

	| obj1 obj1A prevName prevSingleName |

	obj1 := self _testCreateObject.
	prevName := obj1 name.
	prevSingleName := obj1 single2 name.

	"Update in the other session"
	self refreshDelay.
	obj1A := (OwnerTest storedInstancesIn: reStore2) first.
	obj1A name: obj1 name, 'AAA'.
	obj1A single2 name: obj1 single2 name, 'BBB'.
	self assert: obj1A store.

	"No change yet"
	self assert: obj1 name = prevName.
	self assert: obj1 single2 name = prevSingleName.

	self refreshDelay.
	obj1 refresh.

	"Check the refresh has picked up the changes"
	self assert: obj1 name = obj1A name.
	self assert: obj1 single2 name = obj1A single2 name!

test04HasChanged

	| obj1 obj1A prevName prevSingleName |

	obj1 := self _testCreateObject.
	prevName := obj1 name.
	prevSingleName := obj1 single2 name.

	"No change yet"
	self deny: obj1 hasChanged.

	"Change the top-level object"
	obj1 name: prevName, 'AAA'.
	self assert: obj1 hasChanged.

	"Store; object becomes unchanged"
	self assert: obj1 store.
	self deny: obj1 hasChanged.

	"Change the internal object"
	obj1 single2 name: prevSingleName, 'AAA'.
	self assert: obj1 single2 hasChanged.
	self assert: obj1 hasChanged.

	"Store; objects become unchanged"
	self assert: obj1 store.
	self deny: obj1 single2 hasChanged.
	self deny: obj1 hasChanged!

test05CommitFailureRefreshAndRollback

	self _test05CommitFailureRefreshAndRollbackDirectedToProxy: false!

test05CommitFailureRefreshAndRollbackDirectedToProxy

	self _test05CommitFailureRefreshAndRollbackDirectedToProxy: true!

test06StoreFailureRefreshAndRollforward

	self _test06StoreFailureRefreshAndRollforwardDirectedToProxy: false!

test06StoreFailureRefreshAndRollforwardDirectedToProxy

	self _test06StoreFailureRefreshAndRollforwardDirectedToProxy: true!

test08CantPersistCollection

	"Can't persist a collection independently of its owner"

	| obj1 |

	obj1 := OwnerTest template name: 'owner1'.

	self should: [obj1 ordered store] raise: Error description: ([Object errorNotPersistent] on: Error do: [ :exc | exc return: exc description])!

test09UnstoreUnproxied

	| obj1 prevName prevSingleName prevCount prevSingleCount |

	obj1 := self _testCreateObject.
	prevName := obj1 name.
	prevSingleName := obj1 single2 name.

	prevCount := (OwnerTest storedInstances satisfying: [ :each | each name = prevName]) size.
	prevSingleCount := (Test storedInstances satisfying: [ :each | each name = prevSingleName]) size.

	self deny: obj1 isDBProxy.
	self assert: obj1 unstore.

	self assert: (OwnerTest storedInstances satisfying: [ :each | each name = prevName]) size = (prevCount - 1).
	self assert: (Test storedInstances satisfying: [ :each | each name = prevSingleName]) size = (prevSingleCount - 1)!

test10UnstoreProxied

	| obj1 prevName prevSingleName prevCount prevSingleCount |

	obj1 := self _testCreateObject.
	prevName := obj1 name.
	prevSingleName := obj1 single2 name.

	prevCount := (OwnerTest storedInstances satisfying: [ :each | each name = prevName]) size.
	prevSingleCount := (Test storedInstances satisfying: [ :each | each name = prevSingleName]) size.

	reStore softRollback.

	self assert: obj1 isDBProxy.
	self assert: obj1 unstore.

	self assert: (OwnerTest storedInstances satisfying: [ :each | each name = prevName]) size = (prevCount - 1).
	self assert: (Test storedInstances satisfying: [ :each | each name = prevSingleName]) size = (prevSingleCount - 1)!

test11StoreAll

	| objs obj1 obj2 |

	objs := self _testCreateObjects.
	obj1 := objs first.
	obj2 := objs second.

	obj1 name: 'owner1A'.
	obj1 single2 name: 'test1A'.
	obj2 name: 'owner2A'.
	obj2 single2 name: 'test2A'.

	self assert: objs storeAll.

	reStore simulateReconnect.
	
	obj1 := OwnerTest storedInstances lookup: [ :each | each name = 'owner1A'].
	obj2 := OwnerTest storedInstances lookup: [ :each | each name = 'owner2A'].

	self assert: obj1 notNil.
	self assert: obj1 single2 name = 'test1A'.

	self assert: obj2 notNil.
	self assert: obj2 single2 name = 'test2A'!

test12RollbackAll

	| objs obj1 obj2 prevName1 prevSingleName1 prevName2 prevSingleName2 |

	objs := self _testCreateObjects.
	obj1 := objs first.
	obj2 := objs second.

	prevName1 := obj1 name.
	prevSingleName1 := obj1 single2 name.
	prevName2 := obj2 name.
	prevSingleName2 := obj2 single2 name.

	obj1 name: prevName1, 'AAA'.
	obj1 single2 name: prevSingleName1, 'BBB'.
	obj2 name: prevName2, 'CCC'.
	obj2 single2 name: prevSingleName2, 'DDD'.

	objs rollbackAll.

	self assert: obj1 name = prevName1.
	self assert: obj1 single2 name = prevSingleName1.
	self assert: obj2 name = prevName2.
	self assert: obj2 single2 name = prevSingleName2!

test13RefreshAll

	| objs obj1 obj2 obj1A obj2A prevName1 prevSingleName1 prevName2 prevSingleName2 |

	objs := self _testCreateObjects.
	obj1 := objs first.
	obj2 := objs second.

	prevName1 := obj1 name.
	prevSingleName1 := obj1 single2 name.
	prevName2 := obj2 name.
	prevSingleName2 := obj2 single2 name.

	"Update in the other session"
	self refreshDelay.
	obj1A := (OwnerTest storedInstancesIn: reStore2) detect: [ :e | e name = prevName1].
	obj1A name: obj1 name, 'AAA'.
	obj1A single2 name: obj1 single2 name, 'BBB'.
	obj2A := (OwnerTest storedInstancesIn: reStore2) detect: [ :e | e name = prevName2].
	obj2A name: obj1 name, 'AAA'.
	obj2A single2 name: obj1 single2 name, 'BBB'.
	self assert: {obj1A. obj2A} storeAll.

	"No change yet"
	self assert: obj1 name = prevName1.
	self assert: obj1 single2 name = prevSingleName1.
	self assert: obj2 name = prevName2.
	self assert: obj2 single2 name = prevSingleName2.

	self refreshDelay.
	objs refreshAll.

	"Check the refresh has picked up the changes"
	self assert: obj1 name = obj1A name.
	self assert: obj1 single2 name = obj1A single2 name.
	self assert: obj2 name = obj2A name.
	self assert: obj2 single2 name = obj2A single2 name!

test14HasAnyChanged

	| objs obj1 obj2 prevName1 prevSingleName1 prevName2 prevSingleName2 |

	objs := self _testCreateObjects.
	obj1 := objs first.
	obj2 := objs second.

	prevName1 := obj1 name.
	prevSingleName1 := obj1 single2 name.
	prevName2 := obj2 name.
	prevSingleName2 := obj2 single2 name.

	"No change yet"
	self deny: objs hasAnyChanged.

	"Change the top-level objects"
	obj1 name: prevName1, 'AAA'.
	self assert: objs hasAnyChanged.
	self assert: {obj1} hasAnyChanged.
	self deny: {obj2} hasAnyChanged.
	obj2 name: prevName2, 'AAA'.
	self assert: objs hasAnyChanged.
	self assert: {obj1} hasAnyChanged.
	self assert: {obj2} hasAnyChanged.
	
	"Store; objects become unchanged"
	self assert: objs storeAll.
	self deny: objs hasAnyChanged.

	"Change the internal objects"
	obj1 single2 name: prevSingleName1, 'AAA'.
	self assert: objs hasAnyChanged.
	self assert: {obj1} hasAnyChanged.
	self deny: {obj2} hasAnyChanged.
	obj2 single2 name: prevSingleName2, 'AAA'.
	self assert: objs hasAnyChanged.
	self assert: {obj1} hasAnyChanged.
	self assert: {obj2} hasAnyChanged.
	
	"Store; objects become unchanged"
	self assert: objs storeAll.
	self deny: objs hasAnyChanged!

test15StoreWithTransaction

	"Test use of store/unstore methods with an open transaction"

	| objs obj1 id1 obj1a obj2 obj3 |

	objs := self _testCreateObjects.
	obj1 := objs first.
	id1 := obj1 _id.
	obj2 := objs second.
	
	obj1 name: 'owner1A'.
	obj1 single2 name: 'test1A'.
	obj3 := OwnerTest template name: 'owner3'.
	obj3 single2: (Test new name: 'test3').

	reStore beginTransaction.

	self assert: obj1 isDBProxy.
	self assert: obj2 isDBProxy.

	obj1 store.
	obj2 unstore.
	obj3 store.

	self assert: reStore commitTransaction.

	reStore simulateReconnect.
	
	"Ensure changes were persisted"
	obj1 := OwnerTest storedInstances lookup: [ :each | each name = 'owner1'].
	obj1a := OwnerTest storedInstances lookup: [ :each | each name = 'owner1A'].
	obj2 := OwnerTest storedInstances lookup: [ :each | each name = 'owner2'].
	obj3 := OwnerTest storedInstances lookup: [ :each | each name = 'owner3'].

	self assert: obj1 isNil.

	self assert: obj1a notNil.
	self assert: obj1a single2 name equals: 'test1A'.
	self assert: obj1a _id = id1.

	self assert: obj2 isNil.

	self assert: obj3 notNil.
	self assert: obj3 name equals: 'owner3'.
	self assert: obj3 single2 name equals: 'test3'!

test16StoreWithTransactionNonProxied

	"Test use of store/unstore methods with an open transaction"

	| objs obj1 id1 obj1a obj2 obj3 |

	objs := self _testCreateObjects.
	obj1 := objs first.
	id1 := obj1 _id.
	obj2 := objs second.
		
	obj1 name: 'owner1A'.
	obj1 single2 name: 'test1A'.
	obj3 := OwnerTest template name: 'owner3'.
	obj3 single2: (Test new name: 'test3').

	reStore beginTransaction.

	"Reference existing objects first so we're not dealing with proxies (compared to test15)"
	self assert: obj1 name equals: 'owner1A'.
	self assert: obj1 single2 name equals: 'test1A'.
	self assert: obj2 name equals: 'owner2'.

	self deny: obj1 isDBProxy.
	self deny: obj1 single2 isDBProxy.
	self deny: obj2 isDBProxy.

	obj1 store.
	obj2 unstore.
	obj3 store.

	self assert: reStore commitTransaction.

	reStore simulateReconnect.
	
	"Ensure changes were persisted"
	obj1 := OwnerTest storedInstances lookup: [ :each | each name = 'owner1'].
	obj1a := OwnerTest storedInstances lookup: [ :each | each name = 'owner1A'].
	obj2 := OwnerTest storedInstances lookup: [ :each | each name = 'owner2'].
	obj3 := OwnerTest storedInstances lookup: [ :each | each name = 'owner3'].

	self assert: obj1 isNil.

	self assert: obj1a notNil.
	self assert: obj1a single2 name equals: 'test1A'.
	self assert: obj1a _id = id1.

	self assert: obj2 isNil.

	self assert: obj3 notNil.
	self assert: obj3 name equals: 'owner3'.
	self assert: obj3 single2 name equals: 'test3'!

test17StoreWithTransactionRollback

	"Test use of store/unstore methods with an open transaction which is rolled back"

	| objs obj1 obj1a obj2 obj3 |

	objs := self _testCreateObjects.
	obj1 := objs first.
	obj2 := objs second.
	
	obj1 name: 'owner1A'.
	obj1 single2 name: 'test1A'.
	obj3 := OwnerTest template name: 'owner3'.
	obj3 single2: (Test new name: 'test3').

	reStore beginTransaction.

	self assert: obj1 isDBProxy.
	self assert: obj2 isDBProxy.

	obj1 store.
	obj2 unstore.
	obj3 store.

	reStore rollbackTransaction.

	reStore simulateReconnect.

	"Ensure nothing was changed"	
	obj1 := OwnerTest storedInstances lookup: [ :each | each name = 'owner1'].
	obj1a := OwnerTest storedInstances lookup: [ :each | each name = 'owner1A'].
	obj2 := OwnerTest storedInstances lookup: [ :each | each name = 'owner2'].
	obj3 := OwnerTest storedInstances lookup: [ :each | each name = 'owner3'].

	self assert: obj1 notNil.
	self assert: obj1 single2 name equals: 'test1'.

	self assert: obj1a isNil.

	self assert: obj2 notNil.
	self assert: obj2 single2 name equals: 'test2'.

	self assert: obj3 isNil!

test18StoreWithTransactionRollbackNonProxied

	"Test use of store/unstore methods with an open transaction which is rolled back"

	| objs obj1 obj1a obj2 obj3 |

	objs := self _testCreateObjects.
	obj1 := objs first.
	obj2 := objs second.
	
	obj1 name: 'owner1A'.
	obj1 single2 name: 'test1A'.
	obj3 := OwnerTest template name: 'owner3'.
	obj3 single2: (Test new name: 'test3').

	reStore beginTransaction.

	"Reference existing objects first so we're not dealing with proxies (compared to test17)"
	self assert: obj1 name equals: 'owner1A'.
	self assert: obj1 single2 name equals: 'test1A'.
	self assert: obj2 name equals: 'owner2'.

	self deny: obj1 isDBProxy.
	self deny: obj1 single2 isDBProxy.
	self deny: obj2 isDBProxy.

	obj1 store.
	obj2 unstore.
	obj3 store.

	reStore rollbackTransaction.

	reStore simulateReconnect.
	
	"Ensure nothing was changed"
	obj1 := OwnerTest storedInstances lookup: [ :each | each name = 'owner1'].
	obj1a := OwnerTest storedInstances lookup: [ :each | each name = 'owner1A'].
	obj2 := OwnerTest storedInstances lookup: [ :each | each name = 'owner2'].
	obj3 := OwnerTest storedInstances lookup: [ :each | each name = 'owner3'].

	self assert: obj1 notNil.
	self assert: obj1 single2 name equals: 'test1'.

	self assert: obj1a isNil.

	self assert: obj2 notNil.
	self assert: obj2 single2 name equals: 'test2'.

	self assert: obj3 isNil!

test19UnstoreAll

	| objs obj1 obj2 prevName1 prevSingleName1 prevName2 prevSingleName2 prevCount1 prevSingleCount1 prevCount2 prevSingleCount2 |

	objs := self _testCreateObjects.
	obj1 := objs first.
	obj2 := objs second.

	prevName1 := obj1 name.
	prevSingleName1 := obj1 single2 name.
	prevName2 := obj2 name.
	prevSingleName2 := obj2 single2 name.

	prevCount1 := (OwnerTest storedInstances satisfying: [ :each | each name = prevName1]) size.
	prevSingleCount1 := (Test storedInstances satisfying: [ :each | each name = prevSingleName1]) size.
	prevCount2 := (OwnerTest storedInstances satisfying: [ :each | each name = prevName2]) size.
	prevSingleCount2 := (Test storedInstances satisfying: [ :each | each name = prevSingleName2]) size.

	self assert: objs unstoreAll.

	self assert: (OwnerTest storedInstances satisfying: [ :each | each name = prevName1]) size = (prevCount1 - 1).
	self assert: (Test storedInstances satisfying: [ :each | each name = prevSingleName1]) size = (prevSingleCount1 - 1).
	self assert: (OwnerTest storedInstances satisfying: [ :each | each name = prevName2]) size = (prevCount2 - 1).
	self assert: (Test storedInstances satisfying: [ :each | each name = prevSingleName2]) size = (prevSingleCount2 - 1)! !
!SSWReStoreObjectAPITests categoriesForMethods!
_test05CommitFailureRefreshAndRollbackDirectedToProxy:!private!unit tests! !
_test06StoreFailureRefreshAndRollforwardDirectedToProxy:!private!unit tests! !
_testCreateObject!private!running! !
_testCreateObjects!private!running! !
createReStore!private!running! !
test01Store!public!unit tests! !
test02Rollback!public!unit tests! !
test03Refresh!public!unit tests! !
test04HasChanged!public!unit tests! !
test05CommitFailureRefreshAndRollback!public!unit tests! !
test05CommitFailureRefreshAndRollbackDirectedToProxy!public!unit tests! !
test06StoreFailureRefreshAndRollforward!public!unit tests! !
test06StoreFailureRefreshAndRollforwardDirectedToProxy!public!unit tests! !
test08CantPersistCollection!public!unit tests! !
test09UnstoreUnproxied!public!unit tests! !
test10UnstoreProxied!public!unit tests! !
test11StoreAll!public!unit tests! !
test12RollbackAll!public!unit tests! !
test13RefreshAll!public!unit tests! !
test14HasAnyChanged!public!unit tests! !
test15StoreWithTransaction!public!unit tests! !
test16StoreWithTransactionNonProxied!public!unit tests! !
test17StoreWithTransactionRollback!public!unit tests! !
test18StoreWithTransactionRollbackNonProxied!public!unit tests! !
test19UnstoreAll!public!unit tests! !
!


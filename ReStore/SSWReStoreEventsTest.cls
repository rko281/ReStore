"Filed out from Dolphin Smallalk"!

SSWReStore2Test subclass: #SSWReStoreEventsTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreEventsTest guid: (GUID fromString: '{fb1ae6d2-ca97-4be2-ba25-dfad925c1b9b}')!
SSWReStoreEventsTest comment: ''!
!SSWReStoreEventsTest categoriesForClass!Unclassified! !
!SSWReStoreEventsTest methodsFor!

_testOnRecovery

	| obj |

	obj := (TestWithEvents storedInstancesIn: reStore) first.

	self assert: obj name = 'test'.
	self assert: obj _count notNil.
	self assert: obj _count equals: obj items size.

	^obj!

addClassesTo: aReStore

	aReStore
		addClass: TestWithEvents;
		addClass: TestWithEventsItem!

createTestData

	TestWithEvents new
		name: 'test';
		items: ((1 to: 5) collect: [ :index | TestWithEventsItem new name: index displayString; yourself]);
		storeIn: reStore.

	reStore simulateReconnect!

testOnAboutToUnstore

	| obj toUnstore prevCount |

	obj := self _testOnRecovery.
	prevCount := obj count.

	toUnstore := obj items last.

	reStore beginTransaction.
	toUnstore owner: obj; unstore.
	self assert: toUnstore name equals: '<unstored>'.

	"onUnstored should not have triggered yet"
	self assert: (obj items includes: toUnstore).

	reStore commitTransaction.

	"onUnstored on item should now have updated obj"
	self assert: obj _count notNil.
	self assert: obj count equals: prevCount - 1.
	self deny: (obj items includes: toUnstore)!

testOnRecovery

	| now obj |

	now := DateAndTime now.

	obj := self _testOnRecovery.

	"Also test onRecovered setting recoveryTime"
	self assert: (obj recoveryTime >= now).
	obj items do: [ :each | self assert: each recoveryTime >= now]!

testOnRefresh

	| obj prevCount obj2 |

	obj := self _testOnRecovery.
	prevCount := obj count.

	"update in other session"
	obj2 := (TestWithEvents storedInstancesIn: reStore2) first.
	obj2 items add: (TestWithEventsItem new name: '99').
	obj2 store.

	self assert: obj _count equals: prevCount.

	"onRefresh should nil the cache"
	obj refresh.
	self assert: obj _count isNil.
	self assert: obj count equals: prevCount + 1!

testOnRollback

	| now obj prevCount |

	obj := self _testOnRecovery.
	prevCount := obj count.
	now := DateAndTime now.
	
	"update"
	obj items removeLast.

	self assert: obj _count equals: prevCount.

	"onRollback should nil the cache"
	obj refresh.
	self assert: obj _count isNil.
	self assert: obj count equals: prevCount.

	"...but not reset recoveryTime"
	self assert: (obj recoveryTime < now).
	obj items do: [ :each | self assert: (each recoveryTime < now)]!

testOnUnstore

	| obj toUnstore prevCount |

	obj := self _testOnRecovery.
	prevCount := obj count.

	toUnstore := obj items last.
	toUnstore owner: obj; unstore.

	"onUnstored on item should have updated obj"
	self assert: obj _count notNil.
	self assert: obj count equals: prevCount - 1.
	self deny: (obj items includes: toUnstore)! !
!SSWReStoreEventsTest categoriesForMethods!
_testOnRecovery!helpers!private! !
addClassesTo:!public!running! !
createTestData!public!running! !
testOnAboutToUnstore!public!unit tests! !
testOnRecovery!public!unit tests! !
testOnRefresh!public!unit tests! !
testOnRollback!public!unit tests! !
testOnUnstore!public!unit tests! !
!


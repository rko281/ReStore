﻿"Filed out from Dolphin Smalltalk 7"!

SSWReStoreTest subclass: #SSWReStoreUpdateClashTest
	instanceVariableNames: 'reStore2'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreUpdateClashTest guid: (GUID fromString: '{3f3df8b6-c14c-4029-aa65-b67ff6425b7c}')!
SSWReStoreUpdateClashTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreUpdateClashTest categoriesForClass!Unclassified! !
!SSWReStoreUpdateClashTest methodsFor!

prvTestOwnerTest: anOwnerTest in: aReStore

	| oldName oldNumber |

	oldName := anOwnerTest name.
	oldNumber := anOwnerTest number.

	self deny: aReStore isTransactionInProgress.
	self deny: (aReStore haveAnyChanged: (Array with: anOwnerTest)).

	anOwnerTest name: ('xxx', oldName, 'xxx').
	self assert: (aReStore haveAnyChanged: (Array with: anOwnerTest)).

	aReStore rollbackAll: (Array with: anOwnerTest).
	self deny: (aReStore haveAnyChanged: (Array with: anOwnerTest)).
	self assert: anOwnerTest name = oldName.

	anOwnerTest number: (oldNumber + 123).
	self assert: (aReStore haveAnyChanged: (Array with: anOwnerTest)).

	aReStore rollbackAll: (Array with: anOwnerTest).
	self deny: (aReStore haveAnyChanged: (Array with: anOwnerTest)).
	self assert: (anOwnerTest number = oldNumber).

	anOwnerTest name: ('xxx', oldName, 'xxx').
	self assert: (aReStore commitAll: (Array with: anOwnerTest)).
	self deny: (aReStore haveAnyChanged: (Array with: anOwnerTest)).

	anOwnerTest number: (oldNumber + 123).
	aReStore commitAll: (Array with: anOwnerTest).
	self deny: (aReStore haveAnyChanged: (Array with: anOwnerTest)).

	aReStore refreshAll: (Array with: anOwnerTest).
	self assert: (anOwnerTest name = ('xxx', oldName, 'xxx')).
	self assert: (anOwnerTest number = (oldNumber + 123))!

prvTestTest: aTest in: aReStore

	| oldName |

	oldName := aTest name.

	self deny: (aReStore haveAnyChanged: (Array with: aTest)).

	aTest name: ('xxx', oldName, 'xxx').
	self assert: (aReStore haveAnyChanged: (Array with: aTest)).

	aReStore rollbackAll: (Array with: aTest).
	self deny: (aReStore haveAnyChanged: (Array with: aTest)).
	self assert: aTest name = oldName.

	aTest name: ('xxx', oldName, 'xxx').
	self assert: (aReStore commitAll: (Array with: aTest)).
	self deny: (aReStore haveAnyChanged: (Array with: aTest)).

	aReStore refreshAll: (Array with: aTest).
	self assert: (aTest name = ('xxx', oldName, 'xxx'))!

setUp

	super setUp.

	reStore2 := SSWReStore new.
	self initReStore: reStore2.

	reStore2 connect.
	reStore2 addClass: Test; addClass: OwnedTest; addClass: OwnerTest.

	self createStandardTestInstance.
	reStore simulateReconnect.
	self refreshDelay!

tearDown

	super tearDown.
	reStore2 isNil ifFalse: 
		[self releaseReStore: reStore2.
		reStore2 := nil]!

test01DetectAndMerge

	"Check detect and pass (independent changes)"

	| inst1 inst2 origName |

	inst1 := (reStore instancesOf: OwnerTest) asOrderedCollection first.
	inst2 := (reStore2 instancesOf: OwnerTest) asOrderedCollection first.
	origName := inst1 name.

	self assert: (reStore evaluateAsTransaction: [inst1 number: 11]).
	self assert: (reStore2 evaluateAsTransaction: [inst2 name: 'test1:2']).

	self assert: (inst1 isDBProxy).
	self assert: (inst1 _proxiedObject number = 11).		"Change persisted"
	self assert: (inst1 _copyObject number = 11).		"...and copied"
	self assert: (inst1 _proxiedObject name = origName).	"Change not picked up till refresh"
	self assert: (inst1 _copyObject name = origName).	"Changed not picked up till refresh"

	self assert: (inst2 isDBProxy).
	self assert: (inst2 _proxiedObject number = 11).		"Change in session1 picked up and merged"
	self assert: (inst2 _copyObject number = 11).		"...and copied"
	self assert: (inst2 _proxiedObject name = 'test1:2').	"Change persisted"
	self assert: (inst2 _copyObject name = 'test1:2').	"...and copied"

	self refreshDelay.
	reStore refreshAllObjects. 
	reStore2 refreshAllObjects. 

	self assert: (inst1 number = 11).
	self assert: (inst1 name = 'test1:2').
	self assert: (inst2 number = 11).
	self assert: (inst2 name = 'test1:2').

	self prvTestOwnerTest: inst2 in: reStore2!

test02DetectNoMerge

	"Check detect and fail (independent changes but merge prevented)"
	
	| inst1 inst2 oldNumber |

	inst1 := (reStore instancesOf: OwnerTest) asOrderedCollection first.
	inst2 := (reStore2 instancesOf: OwnerTest) asOrderedCollection first.
	oldNumber := inst1 number.

	"OwnerTest blocks updates on instances with this name..."
	self assert: (reStore evaluateAsTransaction: [inst1 name: 'blockMerge']).
	"...so the following will fail"
	self deny: (reStore2 evaluateAsTransaction: [inst2 number: 99]). 

	reStore2 rollbackAndRefreshTransaction.
	self deny: (reStore2 hasTransaction).
	self assert: (inst2 isDBProxy).
	self assert: (inst2 name = 'blockMerge').
	self assert: (inst2 number = oldNumber).
	
	reStore refreshAllObjects.

	self assert: (inst1 name = 'blockMerge').
	self assert: (inst2 number = oldNumber).
	self assert: (inst2 name = 'blockMerge').

	self prvTestOwnerTest: inst2 in: reStore2
	!

test03DetectFailRollback

	"Check detect-fail-rollback"

	| inst1 inst2 oldSingle |

	inst1 := (reStore instancesOf: OwnerTest) asOrderedCollection first.
	inst2 := (reStore2 instancesOf: OwnerTest) asOrderedCollection first.
	oldSingle := inst2 single1 name.

	self assert: (reStore evaluateAsTransaction: [inst1 name: 'test2:1']).
	self deny: (reStore2 evaluateAsTransaction: [inst2 name: 'test2:2'. inst2 single1 name: 'single2:2']).

	reStore2 rollbackAndRefreshTransaction.
	self deny: (reStore2 hasTransaction).
	self assert: (inst1 isDBProxy).
	self assert: (inst2 isDBProxy).
	self assert: (inst2 name = 'test2:1').
	self assert: (inst2 single1 name = oldSingle).

	reStore refreshAllObjects.

	self assert: (inst1 name = 'test2:1').
	self assert: (inst2 name = 'test2:1').
	self deny: (inst2 name = 'single2:2').

	self prvTestOwnerTest: inst2 in: reStore2.
	self prvTestTest: inst2 single1 in: reStore2!

test04DetectFailRollforward

	"Check detect-fail-rollforward"

	| inst1 inst2 |

	inst1 := (reStore instancesOf: OwnerTest) asOrderedCollection first.
	inst2 := (reStore2 instancesOf: OwnerTest) asOrderedCollection first.

	self assert: (reStore evaluateAsTransaction: [inst1 name: 'test3:1']).
	self deny: (reStore2 evaluateAsTransaction: [inst2 name: 'test3:2'. inst2 single1 name: 'single3:2']).

	reStore2 refreshAndRollforwardTransaction.
	self assert: (reStore2 commitTransaction).

	self assert: (inst1 isDBProxy).
	self assert: (inst2 isDBProxy).
	self assert: (inst2 single1 isDBProxy).

	reStore simulateReconnect.
	reStore2 simulateReconnect.

	inst1 := (reStore instancesOf: OwnerTest) asOrderedCollection first.
	inst2 := (reStore2 instancesOf: OwnerTest) asOrderedCollection first.
	
	"self refreshDelay."

	self assert: (inst1 name = 'test3:2').
	self assert: (inst2 name = 'test3:2').
	self assert: (inst2 single1 name = 'single3:2')!

test05DetectFailAndHandle

	"Check detect-fail-handle-pass"

	| inst1 inst2 |

	inst1 := (reStore instancesOf: OwnerTest) asOrderedCollection first.
	inst2 := (reStore2 instancesOf: OwnerTest) asOrderedCollection first.
	inst1 single1 name.
	inst2 single1 name.

	self assert: (reStore evaluateAsTransaction: [inst1 single1 name: 'single4:1']).
	self assert: (reStore2 evaluateAsTransaction: [inst2 name: 'test4:2'. inst2 single1 name: 'single4:2']).

	self assert: (inst1 isDBProxy).
	self assert: (inst1 isDBProxy).
	self assert: (inst1 single1 isDBProxy).
	self assert: (inst1 single1 _proxiedObject name = 'single4:1').	"Change not picked up till refresh"
	self assert: (inst1 single1 _copyObject name = 'single4:1').		"Change not picked up till refresh"

	self assert: (inst2 single1 isDBProxy).
	self assert: (inst2 single1 _proxiedObject name = 'single4:2 (overriden single4:1)').  "Clash handled"
	self assert: (inst2 single1 _copyObject name = 'single4:2 (overriden single4:1)').	"...and copied"

	self refreshDelay.
	reStore refreshAllObjects.
	reStore2 refreshAllObjects.

	self assert: (inst1 single1 name = 'single4:2 (overriden single4:1)').
	self assert: (inst2 single1 name = 'single4:2 (overriden single4:1)').
	self assert: (inst2 name = 'test4:2')!

test06DetectFailNoHandle

	"Check detect-fail-handle-fail"

	| inst1 inst2 oldName oldSingle |

	inst1 := (reStore instancesOf: OwnerTest) asOrderedCollection first.
	inst2 := (reStore2 instancesOf: OwnerTest) asOrderedCollection first.

	inst1 single1 name.
	oldName := inst2 name.
	oldSingle := inst2 single1 name.

	self assert: (reStore evaluateAsTransaction: [inst1 name: 'test5:1'. inst1 single1 name: 'BLOCK5:1']).
	self deny: (reStore2 evaluateAsTransaction: [inst2 name: 'test5:2'. inst2 single1 name: 'single5:2']).
	reStore2 rollbackTransaction.

	self assert: (inst1 isDBProxy).
	self assert: (inst2 isDBProxy).
	self assert: (inst1 single1 isDBProxy).
	self assert: (inst2 name = oldName).
	self assert: (inst2 single1 isDBProxy).
	self assert: (inst2 single1 _proxiedObject name = oldSingle).
	self assert: (inst2 single1 _copyObject name = oldSingle).

	self refreshDelay.
	reStore refreshAllObjects.
	reStore2 refreshAllObjects.

	self assert: (inst1 single1 name = 'BLOCK5:1').
	self assert: (inst2 single1 name = 'BLOCK5:1').
	self assert: (inst2 name = 'test5:1').

	self prvTestOwnerTest: inst2 in: reStore2.
	self prvTestTest: inst2 single1 in: reStore2!

test07DetectFailWithDeleteRollback

	"Check detect-fail handling of transaction with a deletion (previously handled incorrectly)"

	| inst1 inst2 single2 cls id |

	inst1 := (reStore instancesOf: OwnerTest) asOrderedCollection first.
	inst2 := (reStore2 instancesOf: OwnerTest) asOrderedCollection first.

	single2 := inst2 single1.
	cls := single2 class.
	id := single2 _id.

	self assert: (reStore evaluateAsTransaction: [inst1 name: 'test7:1']).
	self deny: (reStore2 evaluateAsTransaction: [inst2 name: 'test7:2'. inst2 single1 unstore]).

	"Check internal state - previously the failed unstored proxy was lost"
	self assert: (reStore2 cachedObjectOfClass: cls withID: id ifAbsent: [nil]) == single2.

	reStore2 rollbackTransaction.

	self assert: single2 isPersistent.
	self deny: single2 _dbProxy _isDeleted.
	self assert: ((reStore2 instancesOf: cls) detect: [ :each | each _id = id]) == single2!

test08DetectFailWithDeleteRollforward

	"Check detect-fail-rollforward handling of transaction with a deletion (previously handled incorrectly)"

	| inst1 inst2 single2 cls id |

	inst1 := (reStore instancesOf: OwnerTest) asOrderedCollection first.
	inst2 := (reStore2 instancesOf: OwnerTest) asOrderedCollection first.

	single2 := inst2 single1.
	cls := single2 class.
	id := single2 _id.

	self assert: (reStore evaluateAsTransaction: [inst1 name: 'test8:1']).
	self deny: (reStore2 evaluateAsTransaction: [inst2 name: 'test8:2'. inst2 single1 unstore]).

	"Check internal state - previously the failed unstored proxy was lost"
	self assert: (reStore2 cachedObjectOfClass: cls withID: id ifAbsent: [nil]) == single2.

	reStore2 refreshAndRollforwardTransaction; commitTransaction.

	self deny: inst2 single1 isPersistent.
	self deny: ((reStore2 instancesOf: inst2 single1 class) anySatisfy: [ :each | each _id = id])!

test10ObjectNextIDClash

	"Check update clashes to the NEXT_ID table are correctly handled, and without failing the transaction"

	| record1 record2 nextID obj1 obj2 |

	record1 := reStore tableRecordFor: (reStore tableForClass: Test).
	record2 := reStore2 tableRecordFor: (reStore2 tableForClass: Test).

	self assert: record1 nextID equals: record2 nextID.

	"Create new instances in both reStores; ensure commits succeed and nextIDs are updated accordingly in the order of commit"
	nextID := record1 nextID.
	obj1 := Test new name: 'one'.
	obj2 := Test new name: 'two'.

	self assert: (obj1 storeIn: reStore).
	self assert: (obj2 storeIn: reStore2).

	self assert: obj1 _id equals: nextID.
	self assert: obj2 _id equals: nextID + 1.

	self assert: record1 nextID equals: nextID + 1.
	self assert: record2 nextID equals: nextID + 2.

	"Try again reversing order"
	nextID := record2 nextID. "record2 is most up-to-date"
	obj1 := Test new name: 'three'.
	obj2 := Test new name: 'four'.

	self assert: (obj2 storeIn: reStore2).
	self assert: (obj1 storeIn: reStore).

	self assert: obj2 _id equals: nextID.
	self assert: obj1 _id equals: nextID + 1.

	self assert: record2 nextID equals: nextID + 1.
	self assert: record1 nextID equals: nextID + 2!

test11CollectionNextIDClash

	"Check update clashes to the NEXT_ID table for collection tables are correctly handled, and without failing the transaction"

	| inst1 inst2 record1 record2 nextID |

	inst1 := (reStore instancesOf: OwnerTest) asOrderedCollection first.
	inst2 := (reStore2 instancesOf: OwnerTest) asOrderedCollection first.

	record1 := reStore tableRecordFor: ((reStore tableForClass: OwnerTest) collectionAccessing: #ordered) collectionTable.
	record2 := reStore2 tableRecordFor: ((reStore2 tableForClass: OwnerTest) collectionAccessing: #ordered) collectionTable.

	self assert: record1 nextID equals: record2 nextID.

	"Add new instances in both reStores; ensure commits succeed and nextIDs are updated accordingly in the order of commit"
	nextID := record1 nextID.
	inst1 ordered add: (Test new name: 'one').
	inst2 ordered add: (Test new name: 'two').

	self assert: inst1 store.
	self assert: inst2 store.

	self assert: inst1 ordered _collectionEntries last entryID equals: nextID.
	self assert: inst2 ordered _collectionEntries last entryID equals: nextID + 1.

	self assert: record1 nextID equals: nextID + 1.
	self assert: record2 nextID equals: nextID + 2.

	"Try again reversing order"
	nextID := record2 nextID. "record2 is most up-to-date"
	inst1 ordered add: (Test new name: 'one').
	inst2 ordered add: (Test new name: 'two').

	self assert: inst2 store.
	self assert: inst1 store.

	self assert: inst2 ordered _collectionEntries last entryID equals: nextID.
	self assert: inst1 ordered _collectionEntries last entryID equals: nextID + 1.

	self assert: record2 nextID equals: nextID + 1.
	self assert: record1 nextID equals: nextID + 2!

test12RollforwardNextIDAllocations

	"Check originally-allocated IDs are preserved following detect-fail-rollforward"

	| inst1 inst2 new2 id |

	inst1 := (reStore instancesOf: OwnerTest) asOrderedCollection first.
	inst2 := (reStore2 instancesOf: OwnerTest) asOrderedCollection first.
	new2 := Test new name: 'new2'.

	self assert: (reStore evaluateAsTransaction: [inst1 name: 'test3:1']).
	self deny: (reStore2 evaluateAsTransaction: [inst2 name: 'test3:2'. new2 storeIn: reStore2]).

	id := new2 _id id.
	reStore2 refreshAndRollforwardTransaction.
	self assert: (reStore2 commitTransaction).

	self assert: new2 _id equals: id! !
!SSWReStoreUpdateClashTest categoriesFor: #prvTestOwnerTest:in:!public!Running! !
!SSWReStoreUpdateClashTest categoriesFor: #prvTestTest:in:!public!Running! !
!SSWReStoreUpdateClashTest categoriesFor: #setUp!public!Running! !
!SSWReStoreUpdateClashTest categoriesFor: #tearDown!public!Running! !
!SSWReStoreUpdateClashTest categoriesFor: #test01DetectAndMerge!public!unit tests! !
!SSWReStoreUpdateClashTest categoriesFor: #test02DetectNoMerge!public!unit tests! !
!SSWReStoreUpdateClashTest categoriesFor: #test03DetectFailRollback!public!unit tests! !
!SSWReStoreUpdateClashTest categoriesFor: #test04DetectFailRollforward!public!unit tests! !
!SSWReStoreUpdateClashTest categoriesFor: #test05DetectFailAndHandle!public!unit tests! !
!SSWReStoreUpdateClashTest categoriesFor: #test06DetectFailNoHandle!public!unit tests! !
!SSWReStoreUpdateClashTest categoriesFor: #test07DetectFailWithDeleteRollback!public!unit tests! !
!SSWReStoreUpdateClashTest categoriesFor: #test08DetectFailWithDeleteRollforward!public!unit tests! !
!SSWReStoreUpdateClashTest categoriesFor: #test10ObjectNextIDClash!public!unit tests! !
!SSWReStoreUpdateClashTest categoriesFor: #test11CollectionNextIDClash!public!unit tests! !
!SSWReStoreUpdateClashTest categoriesFor: #test12RollforwardNextIDAllocations!public!unit tests! !

"Filed out from Dolphin Smalltalk 7"!

SSWReStoreTest subclass: #SSWReStoreDataIDTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreDataIDTest guid: (GUID fromString: '{f5d07b7c-08c7-401c-9818-185ec77d38c7}')!
SSWReStoreDataIDTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreDataIDTest categoriesForClass!Unclassified! !
!SSWReStoreDataIDTest methodsFor!

addClassesTo: aReStore

	aReStore addClass: ReStoreTestWithID!

setUp

	"Write data with assigned id"

	| obj2 obj7 obj9 |

	super setUp.

	reStore destroyAllClasses; synchronizeAllClasses.
	
	obj2 := ReStoreTestWithID name: 'dave' nmbr: 2.
	obj7 := ReStoreTestWithID name: 'john' nmbr: 7.
	obj9 := ReStoreTestWithID name: 'jim' nmbr: 9.

	obj2 other: obj7.

	reStore commitAll: (Array with: obj2 with: obj7 with: obj9).
	
	reStore simulateReconnect!

test1VerifySetUp

	"Write setUp data is correct"

	| obj2 |

	obj2 := (reStore instancesOf: ReStoreTestWithID) detect: [:each | each name = 'dave'].

	self assert: obj2 nmbr = 2.
	self assert: obj2 other nmbr = 7.
	self assert: obj2 other name = 'john'!

test2DuplicateCheck

	"Check can't update to a duplicate assigned ID"

	reStore connection beginRWTxn.
	self should: [reStore connection exec: 'update re_store_test_with_id set nmbr = 7 where nmbr = 2'] raise: reStore dbErrorClass.
	reStore connection rollbackTxn!

test3Update

	"Check update"

	| obj2 |

	obj2 := (reStore instancesOf: ReStoreTestWithID) detect: [:each | each name = 'dave'].

	self assert: obj2 nmbr = 2.
	self assert: obj2 other nmbr = 7.
	self assert: obj2 other name = 'john'.

	reStore connection
		beginRWTxn;
		exec: 'update re_store_test_with_id set other = 9 where nmbr = 2';
		commitTxn.

	reStore simulateReconnect.
	
	obj2 := (reStore instancesOf: ReStoreTestWithID) detect: [:each | each name = 'dave'].

	self assert: obj2 nmbr = 2.
	self assert: obj2 other nmbr = 9.
	self assert: obj2 other name = 'jim'!

test4Query

	| insts matches |

	insts := reStore instancesOf: ReStoreTestWithID.

	matches := insts select: [ :e | e nmbr = 2].
	self assert: (matches size = 1).
	self assert: (matches first name = 'dave').

	matches := insts select: [ :e | e nmbr = 99].
	self assert: matches isEmpty!

test5QueryByExample

	| template matches |

	template := ReStoreTestWithID new nmbr: 7.

	matches := template similarInstancesIn: reStore.
	self assert: (matches size = 1).
	self assert: (matches first name = 'john').

	template name: 'john'.
	matches := template similarInstancesIn: reStore.
	self assert: (matches size = 1).
	self assert: (matches first name = 'john').

	template name: 'xyz'.
	matches := template similarInstancesIn: reStore.
	self assert: matches isEmpty.

	template := ReStoreTestWithID new nmbr: 100.
	matches := template similarInstancesIn: reStore.
	self assert: matches isEmpty.

	template name: 'john'.
	matches := template similarInstancesIn: reStore.
	self assert: matches isEmpty!

test6VerifyIDInCopy

	"Test issue where data ID value was not set in copyObject"

	| obj2 |

	obj2 := (reStore instancesOf: ReStoreTestWithID) detect: [:each | each name = 'dave'].

	self assert: (obj2 _dbProxy _copyObject nmbr = 2).
	self assert: (obj2 other _dbProxy _copyObject nmbr = 7)!

test7VerifyAssignedID

	"Test an automatically-assigned ID makes it into a new instance when stored"

	| newObj recoveredObj |

	self assert: (reStore evaluateAsTxn: [(reStore connection exec: 'update next_id set next_id = 99 where table_name like ''re_store_test_with_id''') numRows = 1]).

	"Verify ID is fully assigned to new instances"
	newObj := ReStoreTestWithID new name: 'assign_test_1'.
	self assert: newObj nmbr isNil.

	self assert: (reStore commit: newObj).
	self assert: newObj nmbr = 99.
	self assert: newObj _dbProxy _copyObject nmbr = 99.

	newObj := ReStoreTestWithID new name: 'assign_test_2'.
	self assert: newObj nmbr isNil.
	self assert: (reStore commit: newObj).
	self assert: newObj nmbr = 100.
	self assert: newObj _dbProxy _copyObject nmbr = 100.

	reStore simulateReconnect.

	"Verify ID persisted in DB"
	recoveredObj := (reStore instancesOf: ReStoreTestWithID) detect: [ :e | e name = 'assign_test_1'].
	self assert: recoveredObj nmbr = 99.

	recoveredObj := (reStore instancesOf: ReStoreTestWithID) detect: [ :e | e name = 'assign_test_2'].
	self assert: recoveredObj nmbr = 100.

	"Check NEXT_ID table was updated correctly"
	newObj := ReStoreTestWithID new name: 'assign_test_3'.
	self assert: newObj nmbr isNil.
	self assert: (reStore commit: newObj).
	self assert: newObj nmbr = 101! !
!SSWReStoreDataIDTest categoriesFor: #addClassesTo:!public!running! !
!SSWReStoreDataIDTest categoriesFor: #setUp!public! !
!SSWReStoreDataIDTest categoriesFor: #test1VerifySetUp!public!unit tests! !
!SSWReStoreDataIDTest categoriesFor: #test2DuplicateCheck!public!unit tests! !
!SSWReStoreDataIDTest categoriesFor: #test3Update!public!unit tests! !
!SSWReStoreDataIDTest categoriesFor: #test4Query!public!unit tests! !
!SSWReStoreDataIDTest categoriesFor: #test5QueryByExample!public!unit tests! !
!SSWReStoreDataIDTest categoriesFor: #test6VerifyIDInCopy!public! !
!SSWReStoreDataIDTest categoriesFor: #test7VerifyAssignedID!public! !


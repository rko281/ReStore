"Filed out from Dolphin Smallalk"!

SSWReStoreDataIDTest subclass: #SSWReStoreStringDataIDTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreStringDataIDTest guid: (GUID fromString: '{40160522-c06e-4a7c-8dfc-4a33d6f1872d}')!
SSWReStoreStringDataIDTest comment: ''!
!SSWReStoreStringDataIDTest categoriesForClass!Unclassified! !
!SSWReStoreStringDataIDTest methodsFor!

test2DuplicateCheck

	"Check can't update to a duplicate assigned ID"

	reStore connection beginRWTxn.
	self should: [reStore connection exec: 'update re_store_test_with_string_id set name = ''john'' where name = ''dave'''] raise: reStore dbErrorClass.
	reStore connection rollbackTxn!

test3Update

	"Check update"

	| obj2 |

	obj2 := self testInstances detect: [:each | each name = 'dave'].

	self assert: obj2 nmbr equals: 2.
	self assert: obj2 other nmbr equals: 7.
	self assert: obj2 other name equals: 'john'.

	reStore connection
		beginRWTxn;
		exec: 'update re_store_test_with_string_id set other = ''jim'' where nmbr = 2';
		commitTxn.

	reStore simulateReconnect.
	
	obj2 := self testInstances detect: [:each | each name = 'dave'].

	self assert: obj2 nmbr equals: 2.
	self assert: obj2 other nmbr equals: 9.
	self assert: obj2 other name equals: 'jim'!

test4Query

	| matches |

	matches := self testInstances select: [ :e | e name = 'dave'].
	self assert: matches size equals: 1.
	self assert: matches first nmbr equals: 2.

	matches := self testInstances select: [ :e | e name = 'jon'].
	self assert: matches isEmpty!

test5QueryByExample

	| template matches |

	template := self testClass new name: 'john'.

	matches := template similarInstancesIn: reStore.
	self assert: matches size equals: 1.
	self assert: matches first nmbr equals: 7.

	template nmbr: 7.
	matches := template similarInstancesIn: reStore.
	self assert: matches size equals: 1.
	self assert: matches first name equals: 'john'.

	template nmbr: 100.
	matches := template similarInstancesIn: reStore.
	self assert: matches isEmpty.

	template := self testClass new name: 'jon'.
	matches := template similarInstancesIn: reStore.
	self assert: matches isEmpty.

	template nmbr: 7.
	matches := template similarInstancesIn: reStore.
	self assert: matches isEmpty!

test6VerifyIDInCopy

	"Test issue where data ID value was not set in copyObject"

	| obj2 |

	obj2 := self testInstances detect: [:each | each nmbr = 2].

	self assert: obj2 _dbProxy _copyObject name equals: 'dave'.
	self assert: obj2 other _dbProxy _copyObject name equals: 'john'!

test7VerifyAssignedID

	"Test an automatically-assigned ID makes it into a new instance when stored"

	| newObj recoveredObj |

	self testClass counter: 5.

	"Verify ID is fully assigned to new instances"
	newObj := self testClass new nmbr: 998.
	self assert: newObj name isNil.

	self assert: (newObj storeIn: reStore).
	self assert: newObj name equals: 'new 6'.
	self assert: newObj _dbProxy _copyObject name equals: 'new 6'.

	newObj := self testClass new nmbr: 999.
	self assert: newObj name isNil.
	self assert: (newObj storeIn: reStore).
	self assert: newObj name equals: 'new 7'.
	self assert: newObj _dbProxy _copyObject name equals: 'new 7'.

	reStore simulateReconnect.

	"Verify ID persisted in DB"
	recoveredObj := self testInstances detect: [ :e | e nmbr = 998].
	self assert: recoveredObj name equals: 'new 6'.

	recoveredObj := self testInstances detect: [ :e | e nmbr = 999].
	self assert: recoveredObj name equals: 'new 7'!

testClass

	^ReStoreTestWithStringID! !
!SSWReStoreStringDataIDTest categoriesForMethods!
test2DuplicateCheck!public!unit tests! !
test3Update!public!unit tests! !
test4Query!public!unit tests! !
test5QueryByExample!public!unit tests! !
test6VerifyIDInCopy!public!unit tests! !
test7VerifyAssignedID!public!unit tests! !
testClass!constants!public! !
!


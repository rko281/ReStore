"Filed out from Dolphin Smallalk"!

SSWReStoreGenericTest subclass: #SSWReStoreBaseCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreBaseCollectionTest guid: (GUID fromString: '{9cd19d47-604e-461d-8442-c96b5f543f6d}')!
SSWReStoreBaseCollectionTest comment: ''!
!SSWReStoreBaseCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreBaseCollectionTest methodsFor!

_testCommit: aTestObject

	self assert: aTestObject component class equals: self collectionClass.
	self assert: aTestObject component size equals: 6.
	self assert: (aTestObject component asSortedCollection: [ :a :b | a ifNil: [true] ifNotNil: [b ifNil: [false] ifNotNil: [a < b]]]) asArray equals: #(nil nil 'Alan' 'Barry' 'Colin' 'Daisy').
	#('Alan' 'Barry' 'Colin' nil 'Daisy' nil) keysAndValuesDo: [ :key :value | self assert: (aTestObject component at: key) equals: value]!

_testVerifySetup: aTestObject

	self assert: aTestObject component class equals: self collectionClass.
	self assert: aTestObject component size equals: 4.
	self assert: (aTestObject component asSortedCollection: [ :a :b | a ifNil: [true] ifNotNil: [b ifNil: [false] ifNotNil: [a < b]]]) asArray equals: #(nil 'Alan' 'Barry' 'Colin').
	#('Alan' 'Barry' 'Colin' nil) keysAndValuesDo: [ :key :value | self assert: (aTestObject component at: key) equals: value]!

addToCollection: anObject

	"Return the key"

	^self addToCollection: anObject at: testObject component size + 1!

addToCollection: anObject at: anInteger

	testObject component add: anObject beforeIndex: anInteger.

	^anInteger!

collectionClass

	^OrderedCollection!

componentDefinition

	^OrderedCollection of: (String maxSize: 64)!

removeFromCollection: anObject

	"Return the key of the removed object"

	^self removeFromCollection: anObject at: (testObject component indexOf: anObject)!

removeFromCollection: anObject at: anInteger

	"Return the key/index of the removed object"

	"key has no meaning here"
	testObject component remove: anObject.
	^anInteger!

templateTestObject

	| template |

	testObject := GenericTest new.
	testObject component: self collectionClass new.

	"nil previously caused issues"
	#('Alan' 'Barry' 'Colin' nil) do: [ :name | self addToCollection: name].

	template := testObject.
	testObject := nil.
	^template
	!

testCommit

	self 
		addToCollection: 'Daisy';
		addToCollection: nil.

	testObject store.

	self fetchTestObjects.

	self _testCommit: testObject!

testHasChanged

	| key |

	self deny: testObject hasChanged.

	key := self removeFromCollection: 'Alan'.
	self assert: testObject hasChanged. 
	self addToCollection: 'Alan' at: key.
	self deny: testObject hasChanged.

	key := self removeFromCollection: nil.
	self assert: testObject hasChanged. 
	self addToCollection: nil at: key.
	self deny: testObject hasChanged.

	self addToCollection: 'Daisy'.
	self assert: testObject hasChanged. 
	self removeFromCollection: 'Daisy'.
	self deny: testObject hasChanged.

	key := self addToCollection: nil.
	self assert: testObject hasChanged. 
	self removeFromCollection: nil at: key.
	self deny: testObject hasChanged.

!

testRefresh

	self _testVerifySetup: testObject2.

	self 
		addToCollection: 'Daisy';
		addToCollection: nil.

	testObject store.

	"No change yet"
	self _testVerifySetup: testObject2.

	"Refresh and re-test"
	testObject2 refresh.
	self _testCommit: testObject2!

testRollback

	self 
		addToCollection: 'Daisy';
		addToCollection: nil.

	testObject rollback.

	self testVerifySetup!

testVerifySetup

	self _testVerifySetup: testObject! !
!SSWReStoreBaseCollectionTest categoriesForMethods!
_testCommit:!helpers!private!unit tests! !
_testVerifySetup:!helpers!private!unit tests! !
addToCollection:!helpers!private! !
addToCollection:at:!helpers!private! !
collectionClass!accessing!public! !
componentDefinition!accessing!public! !
removeFromCollection:!helpers!private!unit tests! !
removeFromCollection:at:!helpers!private!unit tests! !
templateTestObject!accessing!public! !
testCommit!public!unit tests! !
testHasChanged!public!unit tests! !
testRefresh!public!unit tests! !
testRollback!public!unit tests! !
testVerifySetup!public!unit tests! !
!


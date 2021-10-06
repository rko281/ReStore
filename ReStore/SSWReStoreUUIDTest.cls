"Filed out from Dolphin Smallalk"!

SSWReStoreAlternativeIDTest subclass: #SSWReStoreUUIDTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreUUIDTest guid: (GUID fromString: '{b8dfe59b-605d-4c60-b54d-452c2d59aab9}')!
SSWReStoreUUIDTest comment: ''!
!SSWReStoreUUIDTest categoriesForClass!Unclassified! !
!SSWReStoreUUIDTest methodsFor!

testClass

	^UUIDOwnedTest!

testQueryUUID_ID

	| obj id |

	obj := self testInstances detect: [:each | each name = 'test'].
	id := obj _id.

	self assert: (self testInstances detect: [:each | each _id = id] ifNone: [nil]) identicalTo: obj.
	self assert: (self testInstances detect: [:each | each _id = GUID newUnique] ifNone: [nil]) equals: nil!

testVerifyIDIsUUID

	| obj id |

	obj := self testInstances detect: [:each | each name = 'test'].

	id := obj _id.
	self assert: (id class name = #GUID or: [id class name = #UUID]). "Dolphin/Pharo"! !
!SSWReStoreUUIDTest categoriesForMethods!
testClass!public!running! !
testQueryUUID_ID!public!unit tests! !
testVerifyIDIsUUID!public!unit tests! !
!


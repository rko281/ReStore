"Filed out from Dolphin Smallalk"!

SSWReStoreAlternativeIDTest subclass: #SSWReStoreStringIDTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreStringIDTest guid: (GUID fromString: '{460667f5-4ef3-4e16-9644-9ee692b6d3d0}')!
SSWReStoreStringIDTest comment: ''!
!SSWReStoreStringIDTest categoriesForClass!Unclassified! !
!SSWReStoreStringIDTest methodsFor!

testClass

	^StringIDOwnedTest!

testQueryStringID

	| obj id |

	obj := self testInstances detect: [:each | each name = 'test'].
	id := obj _id.

	self assert: (self testInstances detect: [:each | each _id = id] ifNone: [nil]) identicalTo: obj.
	self assert: (self testInstances detect: [:each | each _id = 'blahblah'] ifNone: [nil]) equals: nil!

testVerifyIDIsString

	| obj id |

	obj := self testInstances detect: [:each | each name = 'test'].

	id := obj _id.
	self assert: (id isKindOf: String).
	self assert: (Integer readFrom: id readStream) > (Time millisecondClockValue - 10000) "Allow 10secs from creating test data to here"! !
!SSWReStoreStringIDTest categoriesForMethods!
testClass!constants!public! !
testQueryStringID!public!unit tests! !
testVerifyIDIsString!public!unit tests! !
!


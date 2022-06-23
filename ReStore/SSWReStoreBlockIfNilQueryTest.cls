"Filed out from Dolphin Smallalk"!

SSWReStoreQueryTest subclass: #SSWReStoreBlockIfNilQueryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreBlockIfNilQueryTest guid: (GUID fromString: '{de3aecde-4c07-453a-8e11-c3500522c99a}')!
SSWReStoreBlockIfNilQueryTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreBlockIfNilQueryTest categoriesForClass!Unclassified! !
!SSWReStoreBlockIfNilQueryTest methodsFor!

testCollectPersistentObjectIfNil

	| results |

	results := (SimplePerson storedInstancesIn: reStore) collect: [ :each | each || (each friend ifNil: [each])].

	self assert: 
		(results allSatisfy: 
			[ :each || person personOrFriend |
			person := each first.
			personOrFriend := each last.
			person friend isNil 
				ifTrue: [personOrFriend == person]
				ifFalse: [personOrFriend == person friend]])
		!

testCollectSimpleObjectIfNil

	| persons john results |

	persons := SimplePerson storedInstancesIn: reStore.
	john := persons detect: [ :each | each fullName = 'John Smith'].
	self assert: (john age: nil; store).

	results := persons collect: [ :each | each || (each age ifNil: [-1])].

	self assert: (results allSatisfy: [ :each | (each first age isNil and: [each last = -1]) or: [each first age notNil and: [each last = each first age]]])!

testCollectSimpleObjectWithFunctionIfNil

	| persons results |

	persons := SimplePerson storedInstancesIn: reStore.

	results := persons collect: [ :each | each || (each emailAddress ifNil: [each firstName, '@unknown.com'])].

	self assert: (results allSatisfy: [ :each | (each first emailAddress isNil and: [each last = (each first firstName, '@unknown.com')]) or: [each first emailAddress notNil and: [each last = each first emailAddress]]])!

testSelectPersistentObjectIfNil

	| persons john results |

	persons := SimplePerson storedInstancesIn: reStore.
	john := persons detect: [ :each | each fullName = 'John Smith'].
	self assert: (john friend: nil; store).

	results := persons select: [ :each | (each friend ifNil: [each]) = john].

	self assert: results size = 2.
	self assert: (results allSatisfy: [ :each | each == john or: [each friend == john]])!

testSelectSimpleObjectIfNil

	| persons john results |

	persons := SimplePerson storedInstancesIn: reStore.
	john := persons detect: [ :each | each fullName = 'John Smith'].
	self assert: (john age: nil; store).

	results := persons select: [ :each | (each age ifNil: [20]) = 20].

	self assert: results size = 2.
	self assert: (results allSatisfy: [ :each | each = john or: [each age = 20]])!

testSelectSimpleObjectWithFunctionIfNil

	| persons results |

	persons := SimplePerson storedInstancesIn: reStore.

	results := persons select: [ :each | '*@something' match: (each emailAddress ifNil: [each firstName, '@something'])].

	self assert: results size = 2.
	self assert: (results allSatisfy: [ :each | each emailAddress isNil or: [each emailAddress endsWith: '@something']])! !
!SSWReStoreBlockIfNilQueryTest categoriesForMethods!
testCollectPersistentObjectIfNil!public!unit tests! !
testCollectSimpleObjectIfNil!public!unit tests! !
testCollectSimpleObjectWithFunctionIfNil!public!unit tests! !
testSelectPersistentObjectIfNil!public!unit tests! !
testSelectSimpleObjectIfNil!public!unit tests! !
testSelectSimpleObjectWithFunctionIfNil!public!unit tests! !
!

!SSWReStoreBlockIfNilQueryTest class methodsFor!

shouldInheritSelectors

	^false! !
!SSWReStoreBlockIfNilQueryTest class categoriesForMethods!
shouldInheritSelectors!public! !
!


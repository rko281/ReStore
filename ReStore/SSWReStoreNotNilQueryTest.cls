"Filed out from Dolphin Smalltalk 7"!

SSWReStoreQueryTest subclass: #SSWReStoreNotNilQueryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreNotNilQueryTest guid: (GUID fromString: '{fd275512-2cef-492e-80d2-499ec3937094}')!
SSWReStoreNotNilQueryTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreNotNilQueryTest categoriesForClass!Unclassified! !
!SSWReStoreNotNilQueryTest methodsFor!

testAndNotNilCondition

	| instances john results |

	instances := SimplePerson storedInstancesIn: reStore.

	john := instances detect: [ :each | each firstName = 'John'].
	john test: (Test new name: 'jTest').
	john store.

	results := instances select: [ :each | each firstName = 'John' and: [each test notNil]].
	self assert: (results size = 1).
	self assert: (results first firstName = 'John').

	results := instances select: [ :each | each firstName = 'David' and: [each test notNil]].
	self assert: results isEmpty!

testMethodNotNilAndCondition

	| instances john results |

	instances := SimplePerson storedInstancesIn: reStore.

	john := instances detect: [ :each | each firstName = 'John'].
	john test: (Test new name: 'jTest').
	john store.

	results := instances select: [ :each | each firstName = 'John' and: [each hasTest]].
	self assert: (results size = 1).
	self assert: (results first firstName = 'John').

	results := instances select: [ :each | each firstName = 'David' and: [each hasTest]].
	self assert: results isEmpty!

testMethodNotNilAndJointCondition

	"Test the combination of notNil followed by a block and: condition (two inlined non-standard message sends, resulting in a single conditional jump bytecode) implemented in a method"

	| instances results |

	instances := SimplePerson storedInstancesIn: reStore.

	results := instances select: [ :each | each friend notNil].
	self deny: results isEmpty.

	results := instances select: [ :each | each firstName = 'Jim'].
	self deny: results isEmpty.

	results := instances select: [ :each | each friendNotNilAndJim].
	self assert: results isEmpty!

testMethodNotNilCondition

	| instances john results |

	instances := SimplePerson storedInstancesIn: reStore.

	john := instances detect: [ :each | each firstName = 'John'].
	john test: (Test new name: 'jTest').
	john store.

	results := instances select: [ :each | each hasTest & (each firstName = 'John')].
	self assert: results size = 1.
	self assert: results first firstName = 'John'.

	results := instances select: [ :each | each hasTest & (each firstName = 'David')].
	self assert: results isEmpty.

	results := instances select: [ :each | each hasTest not & (each firstName = 'John')].
	self assert: results isEmpty.

	results := instances select: [ :each | each hasTest not & (each firstName = 'David')].
	self assert: results size = 1.
	self assert: results first firstName = 'David'!

testMethodNotNilOrCondition

	| instances john results |

	instances := SimplePerson storedInstancesIn: reStore.

	john := instances detect: [ :each | each firstName = 'John'].
	john test: (Test new name: 'jTest').
	john store.

	results := instances select: [ :each | each firstName = 'John' or: [each hasTest]].
	self assert: results size = 1.
	self assert: (results first firstName = 'John').

	results := instances select: [ :each | each firstName = 'David' or: [each hasTest]].
	self assert: results size = 2.
	self assert: ((results collect: [ :e | e firstName]) asSortedCollection asArray = #('David' 'John'))!

testMethodNotNilOrJointCondition

	"Test the combination of notNil followed by a block or: condition (two inlined non-standard message sends, resulting in a single conditional jump bytecode) implemented in a method"

	| instances results |

	instances := SimplePerson storedInstancesIn: reStore.

	results := instances select: [ :each | each friend notNil].
	self deny: results isEmpty.

	results := instances select: [ :each | each firstName = 'Jim'].
	self deny: results isEmpty.

	results := instances select: [ :each | each friendNotNilOrJim].
	self assert: results size = 3!

testNotNilAndCondition

	| instances results |

	instances := SimplePerson storedInstancesIn: reStore.

	results := instances select: [ :each | each friend notNil].
	self deny: results isEmpty.

	results := instances select: [ :each | each firstName = 'David'].
	self deny: results isEmpty.

	results := instances select: [ :each | each friend notNil and: [each firstName = 'David']].
	self assert: results isEmpty!

testNotNilAndNonInlinedAndCondition

	| instances results |

	instances := SimplePerson storedInstancesIn: reStore.

	results := instances select: [ :each | (each friend notNil and: [each firstName = 'John']) & (each surname = 'Brown')].
	self assert: results isEmpty!

testNotNilAndNonInlinedOrCondition

	| instances results |

	instances := SimplePerson storedInstancesIn: reStore.

	results := instances select: [ :each | (each friend notNil and: [each firstName = 'John']) | (each surname = 'Brown')].
	self assert: (results size = 3).!

testNotNilDeepFieldCondition

	"Test the use of notNil on a nested field"

	| instances john results |

	instances := SimplePerson storedInstancesIn: reStore.

	instances asOrderedCollection do: [ :each | each test: (Test new name: nil)]; storeAll.
	john := instances detect: [ :each | each firstName = 'John'].
	john test: (Test new name: john fullName).
	john store.

	results := instances select: [ :each | each test name notNil].
	self assert: results size = 1.
	self assert: results first firstName = 'John'.

	results := instances select: [ :each | each test name = each firstName].
	self assert: results isEmpty.

	results := instances select: [ :each | each test name notNil & (each test name = each firstName)].
	self assert: results isEmpty.

	results := instances select: [ :each | each test name notNil & (each test name = each fullName)].
	self assert: results size = 1.
	self assert: results first firstName = 'John'.

	"Test the block or: for completeness, moving the isNil test to the end as is required"
	results := instances select: [ :each | each test name = each fullName or: [each test name notNil]].
	self assert: results size = 1.
	self assert: results first firstName = 'John'!

testNotNilFieldFirstCondition

	| instances john results |

	instances := SimplePerson storedInstancesIn: reStore.
	instances asOrderedCollection do: [ :each | each surname: nil]; storeAll.

	john := instances detect: [ :each | each firstName = 'John'].
	john 
		surname: 'Smith';
		test: (Test new name: 'jTest').
	john store.

	results := instances select: [ :each | each surname notNil & (each firstName = 'John')].
	self assert: results size = 1.
	self assert: results first firstName = 'John'.

	results := instances select: [ :each | each surname notNil & (each firstName = 'David')].
	self assert: results isEmpty.

	results := instances select: [ :each | each surname notNil | each test isNil].
	self assert: results size = 4.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('David' 'Jim' 'John' 'Zoe'))!

testNotNilFieldLastCondition

	| instances john results |

	instances := SimplePerson storedInstancesIn: reStore.
	instances asOrderedCollection do: [ :each | each surname: nil]; storeAll.

	john := instances detect: [ :each | each firstName = 'John'].
	john 
		surname: 'Smith';
		test: (Test new name: 'jTest').
	john store.

	results := instances select: [ :each | (each firstName = 'John') & each surname notNil].
	self assert: results size = 1.
	self assert: results first firstName = 'John'.

	results := instances select: [ :each | each test notNil & each surname notNil].
	self assert: results size = 1.
	self assert: results first firstName = 'John'.

	results := instances select: [ :each | (each firstName = 'David') & each surname notNil].
	self assert: results isEmpty.

	results := instances select: [ :each | (each firstName = 'David') | each surname notNil].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('David' 'John'))!

testNotNilFieldMidCondition

	| instances john results |

	instances := SimplePerson storedInstancesIn: reStore.
	instances asOrderedCollection do: [ :each | each surname: nil]; storeAll.

	john := instances detect: [ :each | each firstName = 'John'].
	john surname: 'Smith'; test: (Test new name: 'jTest').
	john store.

	results := instances select: [ :each | (each firstName = 'John') & each surname notNil & each test notNil].
	self assert: results size = 1.
	self assert: results first firstName = 'John'.

	results := instances select: [ :each | (each firstName = 'David') & each surname notNil & each test notNil].
	self assert: results isEmpty.

	results := instances select: [ :each | (each firstName = 'David') | each surname notNil | (each firstName = 'Zoe')].
	self assert: results size = 3.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('David' 'John' 'Zoe'))!

testNotNilFieldSoleCondition

	| instances john results |

	instances := SimplePerson storedInstancesIn: reStore.
	instances asOrderedCollection do: [ :each | each surname: nil]; storeAll.

	john := instances detect: [ :each | each firstName = 'John'].
	john surname: 'Smith'.
	john store.

	results := instances select: [ :each | each surname notNil].
	self assert: (results size = 1).
	self assert: (results first firstName = 'John')!

testNotNilFirstCondition

	| instances john results |

	instances := SimplePerson storedInstancesIn: reStore.

	john := instances detect: [ :each | each firstName = 'John'].
	john test: (Test new name: 'jTest').
	john store.

	results := instances select: [ :each | each test notNil & (each firstName = 'John')].
	self assert: (results size = 1).
	self assert: (results includes: john).

	results := instances select: [ :each | each test notNil & (each firstName = 'David')].
	self assert: results isEmpty.

	results := instances select: [ :each | each test notNil | (each firstName = 'David')].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('David' 'John'))!

testNotNilLastCondition

	| instances john results |

	instances := SimplePerson storedInstancesIn: reStore.

	john := instances detect: [ :each | each firstName = 'John'].
	john test: (Test new name: 'jTest').
	john store.

	self shouldnt: [results := instances select: [ :each | (each firstName = 'John') & each test notNil]] raise: Error.
	self assert: (results size = 1).
	self assert: (results includes: john).

	self shouldnt: [results := instances select: [ :each | (each firstName = 'David') & each test notNil]] raise: Error.
	self assert: results isEmpty.

	results := instances select: [ :each | (each firstName = 'David') | each test notNil].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('David' 'John'))!

testNotNilMidCondition

	| instances john results |

	instances := SimplePerson storedInstancesIn: reStore.

	john := instances detect: [ :each | each firstName = 'John'].
	john test: (Test new name: 'jTest').
	john store.

	self shouldnt: [results := instances select: [ :each | (each firstName = 'John') & each test notNil & (each surname = 'Smith')]] raise: Error.
	self assert: (results size = 1).
	self assert: (results includes: john).

	self shouldnt: [results := instances select: [ :each | (each firstName = 'John') & each test notNil & (each surname = 'Smythe')]] raise: Error.
	self assert: results isEmpty.

	self shouldnt: [results := instances select: [ :each | (each firstName = 'David') & each test notNil & (each surname = 'Smythe')]] raise: Error.
	self assert: results isEmpty!

testNotNilMultipleConditions

	| instances jim results |

	instances := SimplePerson storedInstancesIn: reStore.
	jim := instances detect: [ :each | each firstName = 'Jim'].
	jim test: (Test new name: 'test').
	jim store.

	results := instances select: [ :each | (each friend notNil or: [each test notNil]) or: [each firstName = 'John']].
	self assert: (results size = 3).

	results := instances select: [ :each | (each friend notNil and: [each test notNil]) or: [each firstName = 'John']].
	self assert: (results size = 1).

	results := instances select: [ :each | (each friend notNil or: [each test notNil]) and: [each firstName = 'John']].
	self assert: (results size = 1).

	results := instances select: [ :each | (each friend notNil and: [each test notNil]) and: [each firstName = 'John']].
	self assert: (results size = 0).
!

testNotNilOrCondition

	| instances results |

	instances := SimplePerson storedInstancesIn: reStore.

	results := instances select: [ :each | each friend notNil].
	self assert: (results size = 2).

	results := instances select: [ :each | each firstName = 'David'].
	self assert: (results size = 1).

	results := instances select: [ :each | each friend notNil or: [each firstName = 'David']].
	self assert: (results size = 3)!

testNotNilOrNonInlinedAndCondition

	| instances results |

	instances := SimplePerson storedInstancesIn: reStore.

	results := instances select: [ :each | (each friend notNil or: [each firstName = 'David']) & (each firstName = 'Zoe')].
	self assert: (results size = 1).
	self assert: (results first fullName = 'Zoe Brown')!

testNotNilOrNonInlinedOrCondition

	| instances results |

	instances := SimplePerson storedInstancesIn: reStore.

	results := instances select: [ :each | (each friend notNil or: [each firstName = 'David']) | (each firstName = 'Jim')].
	self assert: (results size = 4)!

testNotNilSoleCondition

	| instances john results |

	instances := SimplePerson storedInstancesIn: reStore.

	john := instances detect: [ :each | each firstName = 'John'].
	john test: (Test new name: 'jTest').
	john store.

	self shouldnt: [results := instances select: [ :each | each test notNil]] raise: Error.
	self assert: (results size = 1).
	self assert: (results includes: john)! !
!SSWReStoreNotNilQueryTest categoriesFor: #testAndNotNilCondition!public!unit tests! !
!SSWReStoreNotNilQueryTest categoriesFor: #testMethodNotNilAndCondition!public!unit tests! !
!SSWReStoreNotNilQueryTest categoriesFor: #testMethodNotNilAndJointCondition!public!unit tests! !
!SSWReStoreNotNilQueryTest categoriesFor: #testMethodNotNilCondition!public!unit tests! !
!SSWReStoreNotNilQueryTest categoriesFor: #testMethodNotNilOrCondition!public!unit tests! !
!SSWReStoreNotNilQueryTest categoriesFor: #testMethodNotNilOrJointCondition!public!unit tests! !
!SSWReStoreNotNilQueryTest categoriesFor: #testNotNilAndCondition!public!unit tests! !
!SSWReStoreNotNilQueryTest categoriesFor: #testNotNilAndNonInlinedAndCondition!public!unit tests! !
!SSWReStoreNotNilQueryTest categoriesFor: #testNotNilAndNonInlinedOrCondition!public!unit tests! !
!SSWReStoreNotNilQueryTest categoriesFor: #testNotNilDeepFieldCondition!public!unit tests! !
!SSWReStoreNotNilQueryTest categoriesFor: #testNotNilFieldFirstCondition!public!unit tests! !
!SSWReStoreNotNilQueryTest categoriesFor: #testNotNilFieldLastCondition!public!unit tests! !
!SSWReStoreNotNilQueryTest categoriesFor: #testNotNilFieldMidCondition!public!unit tests! !
!SSWReStoreNotNilQueryTest categoriesFor: #testNotNilFieldSoleCondition!public!unit tests! !
!SSWReStoreNotNilQueryTest categoriesFor: #testNotNilFirstCondition!public!unit tests! !
!SSWReStoreNotNilQueryTest categoriesFor: #testNotNilLastCondition!public!unit tests! !
!SSWReStoreNotNilQueryTest categoriesFor: #testNotNilMidCondition!public!unit tests! !
!SSWReStoreNotNilQueryTest categoriesFor: #testNotNilMultipleConditions!public!unit tests! !
!SSWReStoreNotNilQueryTest categoriesFor: #testNotNilOrCondition!public!unit tests! !
!SSWReStoreNotNilQueryTest categoriesFor: #testNotNilOrNonInlinedAndCondition!public!unit tests! !
!SSWReStoreNotNilQueryTest categoriesFor: #testNotNilOrNonInlinedOrCondition!public!unit tests! !
!SSWReStoreNotNilQueryTest categoriesFor: #testNotNilSoleCondition!public!unit tests! !

!SSWReStoreNotNilQueryTest class methodsFor!

shouldInheritSelectors

	^false! !
!SSWReStoreNotNilQueryTest class categoriesFor: #shouldInheritSelectors!public! !


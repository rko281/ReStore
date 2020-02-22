"Filed out from Dolphin Smalltalk 7"!

SSWReStoreQueryTest subclass: #SSWReStoreCollectQueryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreCollectQueryTest guid: (GUID fromString: '{146d8f73-d660-4910-93d4-85279d043bcb}')!
SSWReStoreCollectQueryTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreCollectQueryTest categoriesForClass!Unclassified! !
!SSWReStoreCollectQueryTest methodsFor!

testComplexMathFunctionCollectQuery

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results := instances collect: [ :each | each firstName || (each age + each firstName size)].

	self assert: (results size = 4).
	results := results asSortedCollection: [ :a :b | a first <= b first].

	self assert: (results first = #('David' 45)).
	self assert: (results second = #('Jim' 33)).
	self assert: (results third = #('John' 24)).
	self assert: (results last = #('Zoe' 23)).!

testFunctionCollectQuery

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results := instances collect: [ :each | each fullName || each fullName size ].

	self assert: (results detect: [ :each | each first = 'John Smith']) last = ('John Smith' size).
	self assert: (results detect: [ :each | each first = 'Zoe Brown']) last = ('Zoe Brown' size).
	self assert: (results detect: [ :each | each first = 'Jim Brown']) last = ('Jim Brown' size).
	self assert: (results detect: [ :each | each first = 'David Smythe']) last = ('David Smythe' size)!

testIsNilFirstCollectQuery

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results := instances collect: [ :each | each friend isNil || each fullName].

	self deny: (results detect: [ :each | each last = 'John Smith']) first.
	self deny: (results detect: [ :each | each last = 'Zoe Brown']) first.

	self assert: (results detect: [ :each | each last = 'Jim Brown']) first.
	self assert: (results detect: [ :each | each last = 'David Smythe']) first!

testIsNilInlinedOrCollectQuery

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results := instances collect: [ :each | (each friend isNil or: [each firstName = 'John']) || each fullName].

	self assert: (results detect: [ :each | each last = 'John Smith']) first.
	self assert: (results detect: [ :each | each last = 'Jim Brown']) first.
	self assert: (results detect: [ :each | each last = 'David Smythe']) first.

	self deny: (results detect: [ :each | each last = 'Zoe Brown']) first!

testIsNilLastCollectQuery

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results := instances collect: [ :each | each fullName || each friend isNil].

	self deny: (results detect: [ :each | each first = 'John Smith']) last.
	self deny: (results detect: [ :each | each first = 'Zoe Brown']) last.

	self assert: (results detect: [ :each | each first = 'Jim Brown']) last.
	self assert: (results detect: [ :each | each first = 'David Smythe']) last!

testIsNilMultipleCollectQuery

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results := instances collect: [ :each | each friend isNil || each emailAddress isNil || each fullName].

	self deny: (results detect: [ :each | each last = 'John Smith']) first.
	self deny: (results detect: [ :each | each last = 'Zoe Brown']) first.

	self deny: (results detect: [ :each | each last = 'John Smith']) second.
	self assert: (results detect: [ :each | each last = 'Zoe Brown']) second.

	self assert: (results detect: [ :each | each last = 'Jim Brown']) first.
	self assert: (results detect: [ :each | each last = 'David Smythe']) first.

	self deny: (results detect: [ :each | each last = 'Jim Brown']) second.
	self deny: (results detect: [ :each | each last = 'David Smythe']) second!

testIsNilOrCollectQuery

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results := instances collect: [ :each | (each friend isNil | (each firstName = 'John')) || each fullName].

	self assert: (results detect: [ :each | each last = 'John Smith']) first.
	self assert: (results detect: [ :each | each last = 'Jim Brown']) first.
	self assert: (results detect: [ :each | each last = 'David Smythe']) first.

	self deny: (results detect: [ :each | each last = 'Zoe Brown']) first!

testJoinedFieldCollectQuery

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results := instances collect: [ :each | each firstName || each friend firstName || each surname || each friend surname].

	self assert: (results size = 4).
	results := results asSortedCollection: [ :a :b | a first <= b first].

	self assert: (results first = (Array with: 'David' with: nil with: 'Smythe' with: nil)).
	self assert: (results second = (Array with: 'Jim' with: nil with: 'Brown' with: nil)).

	self assert: (results third first = 'John').
	self assert: (results third second = 'David').
	self assert: (results third third = 'Smith').
	self assert: (results third last = 'Smythe').

	self assert: (results last first = 'Zoe').
	self assert: (results last second = 'John').
	self assert: (results last third = 'Brown').
	self assert: (results last last = 'Smith')!

testJoinedFieldFirstCollectQuery

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results := instances collect: [ :each | each friend firstName || each friend surname || each firstName|| each surname].

	self assert: (results size = 4).
	results := results asSortedCollection: [ :a :b | a third <= b third].

	self assert: (results first = (Array with: nil with: nil with: 'David' with: 'Smythe')).
	self assert: (results second = (Array with: nil with: nil with: 'Jim' with: 'Brown')).

	self assert: (results third first = 'David').
	self assert: (results third second = 'Smythe').
	self assert: (results third third = 'John').
	self assert: (results third last = 'Smith').

	self assert: (results last first = 'John').
	self assert: (results last second = 'Smith').
	self assert: (results last third = 'Zoe').
	self assert: (results last last = 'Brown')!

testJoinedFieldOnlyCollectQuery

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results := instances collect: [ :each | each friend firstName || each friend surname].

	self assert: (results size = 4).

	self assert: (results occurrencesOf: #(nil nil)) = 2.
	self assert: (results anySatisfy: [ :each | each first = 'David' and: [each last = 'Smythe']]).
	self assert: (results anySatisfy: [ :each | each first = 'John' and: [each last = 'Smith']])!

testMathFunctionCollectQuery

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results := instances collect: [ :each | each firstName || (each age + 5)].

	self assert: (results size = 4).
	results := results asSortedCollection: [ :a :b | a first <= b first].

	self assert: (results first = #('David' 45)).
	self assert: (results second = #('Jim' 35)).
	self assert: (results third = #('John' 25)).
	self assert: (results last = #('Zoe' 25)).!

testMultipleConditionalFirstCollectQuery

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results := instances collect: [ :each | each friend isNil || (each surname = 'Brown') || each fullName].

	self deny: (results detect: [ :each | each last = 'John Smith']) first.
	self deny: (results detect: [ :each | each last = 'Zoe Brown']) first.

	self assert: (results detect: [ :each | each last = 'Jim Brown']) first.
	self assert: (results detect: [ :each | each last = 'David Smythe']) first.

	self assert: (results detect: [ :each | each last = 'Jim Brown']) second.
	self assert: (results detect: [ :each | each last = 'Zoe Brown']) second.

	self deny: (results detect: [ :each | each last = 'John Smith']) second.
	self deny: (results detect: [ :each | each last = 'David Smythe']) second

!

testMultipleConditionalLastCollectQuery

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results := instances collect: [ :each | each fullName || each friend isNil || (each surname = 'Brown')].

	self deny: (results detect: [ :each | each first = 'John Smith']) second.
	self deny: (results detect: [ :each | each first = 'Zoe Brown']) second.

	self assert: (results detect: [ :each | each first = 'Jim Brown']) second.
	self assert: (results detect: [ :each | each first = 'David Smythe']) second.

	self assert: (results detect: [ :each | each first = 'Jim Brown']) last.
	self assert: (results detect: [ :each | each first = 'Zoe Brown']) last.

	self deny: (results detect: [ :each | each first = 'John Smith']) last.
	self deny: (results detect: [ :each | each first = 'David Smythe']) last

!

testMultipleConditionalOnSameFieldCollectQuery

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results := instances collect: [ :each | each fullName || each friend isNil || each friend friend isNil].

	self deny: (results detect: [ :each | each first = 'John Smith']) second. "John -> David"
	self deny: (results detect: [ :each | each first = 'Zoe Brown']) second. "Zoe -> John"
	self assert: (results detect: [ :each | each first = 'Jim Brown']) second. "Jim -> nil"
	self assert: (results detect: [ :each | each first = 'David Smythe']) second. "David -> nil"

	self deny: (results detect: [ :each | each first = 'Zoe Brown']) last. "Zoe -> John -> David"
	self assert: (results detect: [ :each | each first = 'John Smith']) last. "John -> David -> nil"
	self assert: (results detect: [ :each | each first = 'Jim Brown']) last. "Jim -> nil -> nil"
	self assert: (results detect: [ :each | each first = 'David Smythe']) last "David -> nil -> nil"!

testMultipleFieldCollectQuery

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results := instances collect: [ :each | each firstName || each surname || each age || each fullName].

	self assert: (results size = 4).
	results := results asSortedCollection: [ :a :b | a first <= b first].

	self assert: (results first = #('David' 'Smythe' 40 'David Smythe')).
	self assert: (results second = #('Jim' 'Brown' 30 'Jim Brown')).
	self assert: (results third = #('John' 'Smith' 20 'John Smith')).
	self assert: (results last = #('Zoe' 'Brown' 20 'Zoe Brown')).!

testMultipleInlinedFunctionCollectQuery

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results := instances collect: [ :each | (each surname = 'Brown' and: [each age = 20]) || each fullName].

	self assert: (results detect: [ :each | each last = 'Zoe Brown']) first = true.
	self assert: (results detect: [ :each | each last = 'John Smith']) first = false.
	self assert: (results detect: [ :each | each last = 'Jim Brown']) first = false.
	self assert: (results detect: [ :each | each last = 'David Smythe']) first = false!

testMultipleInlinedMethodFunctionCollectQuery

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results := instances collect: [ :each | each isBrown20 || each fullName].

	self assert: (results detect: [ :each | each last = 'Zoe Brown']) first = true.
	self assert: (results detect: [ :each | each last = 'John Smith']) first = false.
	self assert: (results detect: [ :each | each last = 'Jim Brown']) first = false.
	self assert: (results detect: [ :each | each last = 'David Smythe']) first = false!

testNotNilFirstCollectQuery

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results := instances collect: [ :each | each friend notNil || each fullName].

	self assert: (results detect: [ :each | each last = 'John Smith']) first.
	self assert: (results detect: [ :each | each last = 'Zoe Brown']) first.

	self deny: (results detect: [ :each | each last = 'Jim Brown']) first.
	self deny: (results detect: [ :each | each last = 'David Smythe']) first!

testNotNilLastCollectQuery

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results := instances collect: [ :each | each fullName || each friend notNil].

	self assert: (results detect: [ :each | each first = 'John Smith']) last.
	self assert: (results detect: [ :each | each first = 'Zoe Brown']) last.

	self deny: (results detect: [ :each | each first = 'Jim Brown']) last.
	self deny: (results detect: [ :each | each first = 'David Smythe']) last!

testObjectFieldCollectQuery

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results := instances collect: [ :each | each firstName || each friend].

	self assert: (results size = 4).
	results := results asSortedCollection: [ :a :b | a first <= b first].

	self assert: (results first = (Array with: 'David' with: nil)).
	self assert: (results second = (Array with: 'Jim' with: nil)).

	self assert: (results third first = 'John').
	self assert: (results third last fullName = 'David Smythe').

	self assert: (results last first = 'Zoe').
	self assert: (results last last fullName = 'John Smith')!

testObjectFieldOnlyCollectQuery

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results := instances collect: [ :each | each friend].

	self assert: (results size = 4).
	self assert: (results occurrencesOf: nil) = 2.
	self assert: (results anySatisfy: [ :each | each notNil and: [each fullName = 'David Smythe']]).
	self assert: (results anySatisfy: [ :each | each notNil and: [each fullName = 'John Smith']])!

testSingleConditionCollectQuery

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results := instances collect: [ :each | each surname = 'Brown'].

	self assert: (results size = 4).
	self assert: ((results select: [ :each | each]) size = 2).
	self assert: ((results reject: [ :each | each]) size = 2)!

testSingleFieldCollectQuery

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results := instances collect: [ :each | each surname].

	self assert: (results size = 4).
	self assert: (results asSortedCollection asArray = #('Brown' 'Brown' 'Smith' 'Smythe'))!

testSingleInlinedFunctionCollectQuery

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results := instances collect: [ :each | each surname = 'Brown' and: [each age = 20]].

	self assert: (results size = 4).
	self assert: (results select: [ :each | each]) size = 1.
	self assert: (results reject: [ :each | each]) size = 3!

testThisObjectFieldOnlyCollectQuery

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results := instances collect: [ :each | each].

	self assert: (results size = 4).
	self assert: (((results asSortedCollection: [ :a :b | a fullName < b fullName]) collect: [ :each | each fullName]) asArray = self sortedPersonFullNames)! !
!SSWReStoreCollectQueryTest categoriesFor: #testComplexMathFunctionCollectQuery!public!unit tests! !
!SSWReStoreCollectQueryTest categoriesFor: #testFunctionCollectQuery!public!unit tests! !
!SSWReStoreCollectQueryTest categoriesFor: #testIsNilFirstCollectQuery!public!unit tests! !
!SSWReStoreCollectQueryTest categoriesFor: #testIsNilInlinedOrCollectQuery!public!unit tests! !
!SSWReStoreCollectQueryTest categoriesFor: #testIsNilLastCollectQuery!public!unit tests! !
!SSWReStoreCollectQueryTest categoriesFor: #testIsNilMultipleCollectQuery!public!unit tests! !
!SSWReStoreCollectQueryTest categoriesFor: #testIsNilOrCollectQuery!public!unit tests! !
!SSWReStoreCollectQueryTest categoriesFor: #testJoinedFieldCollectQuery!public!unit tests! !
!SSWReStoreCollectQueryTest categoriesFor: #testJoinedFieldFirstCollectQuery!public!unit tests! !
!SSWReStoreCollectQueryTest categoriesFor: #testJoinedFieldOnlyCollectQuery!public!unit tests! !
!SSWReStoreCollectQueryTest categoriesFor: #testMathFunctionCollectQuery!public!unit tests! !
!SSWReStoreCollectQueryTest categoriesFor: #testMultipleConditionalFirstCollectQuery!public!unit tests! !
!SSWReStoreCollectQueryTest categoriesFor: #testMultipleConditionalLastCollectQuery!public!unit tests! !
!SSWReStoreCollectQueryTest categoriesFor: #testMultipleConditionalOnSameFieldCollectQuery!public!unit tests! !
!SSWReStoreCollectQueryTest categoriesFor: #testMultipleFieldCollectQuery!public!unit tests! !
!SSWReStoreCollectQueryTest categoriesFor: #testMultipleInlinedFunctionCollectQuery!public!unit tests! !
!SSWReStoreCollectQueryTest categoriesFor: #testMultipleInlinedMethodFunctionCollectQuery!public!unit tests! !
!SSWReStoreCollectQueryTest categoriesFor: #testNotNilFirstCollectQuery!public!unit tests! !
!SSWReStoreCollectQueryTest categoriesFor: #testNotNilLastCollectQuery!public!unit tests! !
!SSWReStoreCollectQueryTest categoriesFor: #testObjectFieldCollectQuery!public!unit tests! !
!SSWReStoreCollectQueryTest categoriesFor: #testObjectFieldOnlyCollectQuery!public!unit tests! !
!SSWReStoreCollectQueryTest categoriesFor: #testSingleConditionCollectQuery!public!unit tests! !
!SSWReStoreCollectQueryTest categoriesFor: #testSingleFieldCollectQuery!public!unit tests! !
!SSWReStoreCollectQueryTest categoriesFor: #testSingleInlinedFunctionCollectQuery!public!unit tests! !
!SSWReStoreCollectQueryTest categoriesFor: #testThisObjectFieldOnlyCollectQuery!public!unit tests! !

!SSWReStoreCollectQueryTest class methodsFor!

shouldInheritSelectors

	^false! !
!SSWReStoreCollectQueryTest class categoriesFor: #shouldInheritSelectors!public! !


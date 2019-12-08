"Filed out from Dolphin Smalltalk 7"!

SSWReStoreQueryTest subclass: #SSWReStoreBlockAndOrQueryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreBlockAndOrQueryTest guid: (GUID fromString: '{66089025-90b0-4513-bbdd-e379dc2de400}')!
SSWReStoreBlockAndOrQueryTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreBlockAndOrQueryTest categoriesForClass!Unclassified! !
!SSWReStoreBlockAndOrQueryTest methodsFor!

testBlockAnd

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results :=  instances select: [ :each | each firstName = 'Zoe' and: [each surname = 'Brown']].
	self assert: results size = 1.
	self assert: (results first fullName = 'Zoe Brown').

	results :=  instances select: [ :each | each firstName = 'John' and: [each surname = 'Smith' and: [each age = 20]]].
	self assert: results size = 1.
	self assert: (results first fullName = 'John Smith')

!

testBlockAndNonBlockOrBlockAndCombination

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results :=  instances select: [ :each | (each firstName = 'John' and: [each age = 20]) | (each surname = 'Brown' and: [each age = 30])].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('Jim' 'John')).

	results :=  instances select: [ :each | (each firstName = 'John' and: [each age = 20]) | (each firstName = 'David' and: [each age = 30])].
	self assert: results size = 1.
	self assert: results first fullName = 'John Smith'.

	"Bigger tests"
	results :=  instances select: [ :each | (each firstName = 'John' and: [each surname = 'Smith' and: [each age = 20]]) | (each firstName = 'David' and: [each surname = 'Smythe' and: [each age = 40]])].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('David' 'John')).

	results :=  instances select: [ :each | (each firstName = 'John' and: [each surname = 'Smith' and: [each age = 20]]) | (each firstName = 'David' and: [(each surname = 'Smythe') & (each age = 40)])].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('David' 'John')).

	results :=  instances select: [ :each | (each firstName = 'John' and: [each surname = 'Smith' and: [each age = 20]]) | ((each firstName = 'David') & ((each surname = 'Smythe') and: [each age = 40]))].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('David' 'John')).

	results :=  instances select: [ :each | (each firstName = 'John' and: [(each surname = 'Smith') & (each age = 20)]) | ((each firstName = 'David') & ((each surname = 'Smythe') and: [each age = 40]))].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('David' 'John')).

	results :=  instances select: [ :each | (each firstName = 'John' & ((each surname = 'Smith') and: [each age = 20])) | ((each firstName = 'David') & ((each surname = 'Smythe') and: [each age = 40]))].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('David' 'John')).

	results :=  instances select: [ :each | (each firstName = 'John' & ((each surname = 'Smith') and: [each age = 20])) |  (each firstName = 'David' and: [(each surname = 'Smythe') & (each age = 40)])].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('David' 'John')).


	results :=  instances select: [ :each | (each firstName = 'Jon' and: [each surname = 'Smith' and: [each age = 20]]) | (each firstName = 'David' and: [each surname = 'Smythe' and: [each age = 40]])].
	self assert: results size = 1.
	self assert: results first fullName = 'David Smythe'.

	results :=  instances select: [ :each | (each firstName = 'John' and: [each surname = 'Smithe' and: [each age = 20]]) | (each firstName = 'David' and: [each surname = 'Smythe' and: [each age = 40]])].
	self assert: results size = 1.
	self assert: results first fullName = 'David Smythe'.

	results :=  instances select: [ :each | (each firstName = 'John' and: [each surname = 'Smith' and: [each age = 21]]) | (each firstName = 'David' and: [each surname = 'Smythe' and: [each age = 40]])].
	self assert: results size = 1.
	self assert: results first fullName = 'David Smythe'!

testBlockAndNonBlockOrCombination

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	"Test different orders with different results"
	results :=  instances select: [ :each | (each firstName = 'John' and: [each age = 20]) | (each firstName = 'David')].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('David' 'John')).

	results :=  instances select: [ :each | ((each firstName = 'John') & (each age = 20)) or: [each firstName = 'David']].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('David' 'John')).


	results :=  instances select: [ :each | each age = 20 and: [(each firstName = 'John') | (each firstName = 'David')]].
	self assert: results size = 1.
	self assert: results first firstName = 'John'.

	results :=  instances select: [ :each | (each age = 20) & ((each firstName = 'John') or: [each firstName = 'David'])].
	self assert: results size = 1.
	self assert: results first firstName = 'John'.


	results :=  instances select: [ :each | each age = 20 and: [(each firstName = 'John') | (each firstName = 'Zoe')]].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('John' 'Zoe')).

	results :=  instances select: [ :each | each age = 20 & ((each firstName = 'John') or: [each firstName = 'Zoe'])].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('John' 'Zoe'))!

testBlockAndOrAndCombination

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results :=  instances select: [ :each | (each firstName = 'John' and: [each age = 20]) or: [each firstName = 'David' and: [each age = 40]]].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('David' 'John')).

	results :=  instances select: [ :each | (each firstName = 'John' and: [each age = 20]) or: [each firstName = 'David' and: [each age = 30]]].
	self assert: results size = 1.
	self assert: results first fullName = 'John Smith'.

	"Bigger tests"
	results :=  instances select: [ :each | (each firstName = 'John' and: [each surname = 'Smith' and: [each age = 20]]) or: [each firstName = 'David' and: [each surname = 'Smythe' and: [each age = 40]]]].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('David' 'John')).

	results :=  instances select: [ :each | (each firstName = 'Jon' and: [each surname = 'Smith' and: [each age = 20]]) or: [each firstName = 'David' and: [each surname = 'Smythe' and: [each age = 40]]]].
	self assert: results size = 1.
	self assert: results first fullName = 'David Smythe'.

	results :=  instances select: [ :each | (each firstName = 'John' and: [each surname = 'Smithe' and: [each age = 20]]) or: [each firstName = 'David' and: [each surname = 'Smythe' and: [each age = 40]]]].
	self assert: results size = 1.
	self assert: results first fullName = 'David Smythe'.

	results :=  instances select: [ :each | (each firstName = 'John' and: [each surname = 'Smith' and: [each age = 21]]) or: [each firstName = 'David' and: [each surname = 'Smythe' and: [each age = 40]]]].
	self assert: results size = 1.
	self assert: results first fullName = 'David Smythe'!

testBlockAndOrCombination

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	"Test different orders with different results"
	results :=  instances select: [ :each | (each firstName = 'John' and: [each age = 20]) or: [each firstName = 'David']].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('David' 'John')).

	results :=  instances select: [ :each | each age = 20 and: [each firstName = 'John' or: [each firstName = 'David']]].
	self assert: results size = 1.
	self assert: results first firstName = 'John'.

	results :=  instances select: [ :each | each age = 20 and: [each firstName = 'John' or: [each firstName = 'Zoe']]].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('John' 'Zoe'))!

testBlockOr

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results :=  instances select: [ :each | each firstName = 'Zoe' or: [each firstName = 'John']].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('John' 'Zoe')).

	results :=  instances select: [ :each | each firstName = 'Zoe' or: [each firstName = 'John' or: [each firstName = 'Jim']]].
	self assert: results size = 3.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('Jim' 'John' 'Zoe'))!

testBlockOrAndCombination

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	"Test different bracketing orders with different results"
	results :=  instances select: [ :each | each firstName = 'David' or: [each firstName = 'John' and: [each age = 20]]].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('David' 'John')).

	results :=  instances select: [ :each | (each firstName = 'David' or: [each firstName = 'John']) and: [each age = 20]].
	self assert: results size = 1.
	self assert: results first firstName = 'John'.

	results :=  instances select: [ :each | (each firstName = 'David' or: [each firstName = 'John' or: [each firstName = 'Zoe']]) and: [each age = 20]].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('John' 'Zoe')).
!

testBlockOrAndOrCombination

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results :=  instances select: [ :each | (each firstName = 'John' or: [each firstName = 'David']) and: [each age = 40 or: [each age = 20]]].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('David' 'John')).

	results :=  instances select: [ :each | (each firstName = 'John' or: [each firstName = 'David']) and: [each age = 40 or: [each age = 30]]].
	self assert: results size = 1.
	self assert: results first fullName = 'David Smythe'.

	"Bigger test"
	results :=  instances select: [ :each | (each firstName = 'Jim' or: [each firstName = 'John' or: [each firstName = 'David']]) and: [each age = 40 or: [each age = 30 or: [each age = 20]]]].
	self assert: results size = 3.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('David' 'Jim' 'John')).!

testBlockOrNonBlockAndCombination

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	"Test different bracketing orders with different results"
	results :=  instances select: [ :each | each firstName = 'David' or: [(each firstName = 'John') & (each age = 20)]].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('David' 'John')).
	results :=  instances select: [ :each | (each firstName = 'David') | (each firstName = 'John' and: [each age = 20])].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('David' 'John')).


	results :=  instances select: [ :each | (each firstName = 'David' or: [each firstName = 'John']) & (each age = 20)].
	self assert: results size = 1.
	self assert: results first firstName = 'John'.
	results :=  instances select: [ :each | ((each firstName = 'David') | (each firstName = 'John')) and: [each age = 20]].
	self assert: results size = 1.
	self assert: results first firstName = 'John'.


	results :=  instances select: [ :each | (each firstName = 'David' or: [each firstName = 'John' or: [each firstName = 'Zoe']]) & (each age = 20)].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('John' 'Zoe')).
	results :=  instances select: [ :each | ((each firstName = 'David') | (each firstName = 'John') | (each firstName = 'Zoe')) and: [each age = 20]].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('John' 'Zoe')).
!

testMixBlockNonBlockAndOrCombinations

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results :=  instances select: [ :each | (each firstName = 'John' and: [each age = 20]) | ((each surname = 'Brown') & (each age = 30))].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('Jim' 'John')).

	results :=  instances select: [ :each | ((each firstName = 'John') & (each age = 20)) | (each firstName = 'David' and: [each age = 30])].
	self assert: results size = 1.
	self assert: results first fullName = 'John Smith'.

	"Bigger tests"
	results :=  instances select: [ :each | (each firstName = 'John' and: [(each surname = 'Smith') & (each age = 20)]) | (each firstName = 'David' and: [each surname = 'Smythe' and: [each age = 40]])].
	self assert: results size = 2.
	self assert: ((results collect: [ :each | each firstName]) asSortedCollection asArray = #('David' 'John')).

	results :=  instances select: [ :each | (each firstName = 'Jon' and: [each surname = 'Smith' and: [each age = 20]]) | (each firstName = 'David' & (each surname = 'Smythe' and: [each age = 40]))].
	self assert: results size = 1.
	self assert: results first fullName = 'David Smythe'.

	results :=  instances select: [ :each | (each firstName = 'John' and: [each surname = 'Smithe' and: [each age = 20]]) | ((each firstName = 'David') & (each surname = 'Smythe') & (each age = 40))].
	self assert: results size = 1.
	self assert: results first fullName = 'David Smythe'.

	results :=  instances select: [ :each | (each firstName = 'John' and: [each surname = 'Smithe' and: [each age = 20]]) or: [(each firstName = 'David') & (each surname = 'Smythe') & (each age = 40)]].
	self assert: results size = 1.
	self assert: results first fullName = 'David Smythe'.

	results :=  instances select: [ :each | ((each firstName = 'John') & (each surname = 'Smith') & (each age = 21)) | (each firstName = 'David' and: [each surname = 'Smythe' and: [each age = 40]])].
	self assert: results size = 1.
	self assert: results first fullName = 'David Smythe'.

	results :=  instances select: [ :each | ((each firstName = 'John') & (each surname = 'Smith') & (each age = 21)) or: [each firstName = 'David' and: [each surname = 'Smythe' and: [each age = 40]]]].
	self assert: results size = 1.
	self assert: results first fullName = 'David Smythe'.

	results :=  instances select: [ :each | ((each firstName = 'John') & (each surname = 'Smith') & (each age = 21)) or: [(each firstName = 'David') & (each surname = 'Smythe') & (each age = 40)]].
	self assert: results size = 1.
	self assert: results first fullName = 'David Smythe'! !
!SSWReStoreBlockAndOrQueryTest categoriesFor: #testBlockAnd!public!unit tests! !
!SSWReStoreBlockAndOrQueryTest categoriesFor: #testBlockAndNonBlockOrBlockAndCombination!public!unit tests! !
!SSWReStoreBlockAndOrQueryTest categoriesFor: #testBlockAndNonBlockOrCombination!public!unit tests! !
!SSWReStoreBlockAndOrQueryTest categoriesFor: #testBlockAndOrAndCombination!public!unit tests! !
!SSWReStoreBlockAndOrQueryTest categoriesFor: #testBlockAndOrCombination!public!unit tests! !
!SSWReStoreBlockAndOrQueryTest categoriesFor: #testBlockOr!public!unit tests! !
!SSWReStoreBlockAndOrQueryTest categoriesFor: #testBlockOrAndCombination!public!unit tests! !
!SSWReStoreBlockAndOrQueryTest categoriesFor: #testBlockOrAndOrCombination!public!unit tests! !
!SSWReStoreBlockAndOrQueryTest categoriesFor: #testBlockOrNonBlockAndCombination!public!unit tests! !
!SSWReStoreBlockAndOrQueryTest categoriesFor: #testMixBlockNonBlockAndOrCombinations!public!unit tests! !

!SSWReStoreBlockAndOrQueryTest class methodsFor!

shouldInheritSelectors

	^false! !
!SSWReStoreBlockAndOrQueryTest class categoriesFor: #shouldInheritSelectors!public! !


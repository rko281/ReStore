"Filed out from Dolphin Smalltalk 7"!

SSWReStoreQueryTest subclass: #SSWReStoreJoinQueryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreJoinQueryTest guid: (GUID fromString: '{209e4cdf-86ec-4bd4-9e1d-65ff8dd9aca7}')!
SSWReStoreJoinQueryTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreJoinQueryTest categoriesForClass!Unclassified! !
!SSWReStoreJoinQueryTest methodsFor!

testCollectWithAlreadyJoinedTable

	"Previously-failing case - where collect: requiring joins is used with a collection with joined table(s), the last joined table could be lost when adding a result on another table not requiring a join"

	| persons david zoe results friendNames |

	persons := reStore instancesOf: SimplePerson.

	"Make the data a bit more interesting"
	david := persons detect: [ :each | each firstName = 'David'].
	zoe := persons detect: [ :each | each firstName = 'Zoe'].
	david address: (SimpleAddress new postcode: 'A1 1AA'); store.
	zoe address: (SimpleAddress new postcode: 'A1 1AA'); store.

	"Description of previously-problematic query block:
	1) The Address table is joined due to the condition in the satisfying: block.
	2) Next the Person table is joined to handle the friend part of the collect: block.
	3) The reference to address does not add the Address table since it is already included via the satsifying block.
	4) The isNil test drops the last-added table since it is not required for the isNil test and it thinks this is the first encounter with the Address table - not the case here, since Address was not encountered and joined in the satisfying: block.
	5) Instead the Person (friend) table is incorrectly dropped, resulting in invalid SQL.
	This is fixed by seeding the block parser's fieldEncounters collection with the joining fields for the referenced tables - see SSWDBBlockParser>>reset. 
	This prevents the parser considering re-encountered joined tables as the first encounter of that field, which prevents the table being dropped - see SSWDBBlockReceiver>>finalField"
	self shouldnt: [results := (persons satisfying: [ :each | each address postcode = 'A1 1AA']) collect: [ :each | each friend firstName || each address isNil]] raise: Error.

	self assert: results size= 2.
	friendNames := results collect: [ :each | each first].
	self assert: (friendNames includes: nil).
	self assert: (friendNames includes: 'John').
	self assert: ((results collect: [ :each | each last]) asArray = {false. false})!

testJoinFieldMultipleConditional

	"Ensure a query with multiple conditionals on a join field does not result in the joined table being included"

	| instances john query results |

	instances := reStore instancesOf: SimplePerson.
	john := instances detect: [ :each | each firstName = 'John'].

	"Although the query references the link to the friend table, the table itself is not required.
	Inline the internals of SSWDBInstancesCollection>>select: so we can check the internals of the query"
	query := instances parser selectQueryFrom: [ :each |(each friend isNil) | (each friend = john)].
	self assert: (query tables size = 1).

	results := OrderedCollection new.
	instances fetchObjectsWithQuery: query into: results.

	self assert: (results size = 3).
	self assert: ((results collect: [ :e | e firstName]) asSortedCollection asArray = #('David' 'Jim' 'Zoe'))!

testJoinFieldReusedConditional

	"Ensure a query with a conditional on a join field does not result in an earlier required use of that join field being removed"

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	results := instances select: [ :each | each friend firstName = 'David' or: [each friend isNil]].

	self assert: (results size = 3).
	self assert: ((results collect: [ :e | e firstName]) asSortedCollection asArray = #('David' 'Jim' 'John'))!

testJoinFieldSoleConditional

	"Ensure a query with a sole conditional on a join field does not result in the joined table being included"

	| instances query results |

	instances := reStore instancesOf: SimplePerson.

	"Although the query references the link to the friend table, the table itself is not required.
	Inline the internals of SSWDBInstancesCollection>>select: so we can check the internals of the query"
	query := instances parser selectQueryFrom: [ :each | each friend isNil].
	self assert: (query tables size = 1).

	results := OrderedCollection new.
	instances fetchObjectsWithQuery: query into: results.

	self assert: (results size = 2).
	self assert: ((results collect: [ :e | e firstName]) asSortedCollection asArray = #('David' 'Jim'))!

testMultipleJoinFieldConditional

	"Ensure a query with multiple conditionals on a join field actually uses the correct joined tables (previously failing case)"

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	"Previously, the reused friend join was ignored on the last conditional, resulting in the conditional being on the test join 
	(thus returning all persons, since none have a populated test inst var)"
	results := instances select: [ :each | (each friend firstName = 'David') | (each test name = 'x') | (each friend isNil)].

	self assert: (results size = 3).
	self assert: ((results collect: [ :e | e firstName]) asSortedCollection asArray = #('David' 'Jim' 'John'))!

testNestedJoinFieldConditional

	"Ensure a query with conditionals the same join/table combination, but nested, is handled correctly (previously failing case)"

	| instances results |

	instances := reStore instancesOf: SimplePerson.

	"John's friend = david
	Zoe's friend = john"
	results := instances select: [ :each | (each friend firstName = 'David') | (each friend friend firstName = 'David')].

	self assert: (results size = 2).
	self assert: ((results collect: [ :e | e firstName]) asSortedCollection asArray = #('John' 'Zoe'))!

testSatisfyingWithAlreadyJoinedTable

	"Previously-failing case - where satisfying: requiring joins is used with a collection with already-joined table(s), the last joined table could be lost when adding a result on another table not requiring a join"

	| persons david zoe results |

	persons := reStore instancesOf: SimplePerson.

	"Make the data a bit more interesting"
	david := persons detect: [ :each | each firstName = 'David'].
	zoe := persons detect: [ :each | each firstName = 'Zoe'].
	david address: (SimpleAddress new postcode: 'A1 1AA'); store.
	zoe address: (SimpleAddress new postcode: 'A1 1AA'); store.

	"Description of previously-problematic query block:
	1) The Address table is joined due to the condition in the first satisfying: block.
	2) Next the Person table is joined to handle the friend part of the second satisfying: block.
	3) The reference to address does not add the Address table since it is already included via the satsifying block.
	4) The isNil test drops the last-added table since it is not required for the isNil test and it thinks this is the first encounter with the Address table - not the case here, since Address was not encountered and joined in the satisfying: block.
	5) Instead the Person (friend) table is incorrectly dropped, resulting in invalid SQL.
	This is fixed by seeding the block parser's fieldEncounters collection with the joining fields for the referenced tables - see SSWDBBlockParser>>reset. 
	This prevents the parser considering re-encountered joined tables as the first encounter of that field, which prevents the table being dropped - see SSWDBBlockReceiver>>finalField"
	results := (persons satisfying: [ :each | each address postcode = 'A1 1AA']) satisfying: [ :each | (each friend firstName = 'John') | each address isNil].

	self shouldnt: [self assert: (results size = 1)] raise: Error.
	self shouldnt: [self assert: (results asOrderedCollection includes: zoe)] raise: Error!

testSelectWithAlreadyJoinedTable

	"Previously-failing case - where select: requiring joins is used with a collection with already-joined table(s), the last joined table could be lost when adding a result on another table not requiring a join"

	| persons david zoe results |

	persons := reStore instancesOf: SimplePerson.

	"Make the data a bit more interesting"
	david := persons detect: [ :each | each firstName = 'David'].
	zoe := persons detect: [ :each | each firstName = 'Zoe'].
	david address: (SimpleAddress new postcode: 'A1 1AA'); store.
	zoe address: (SimpleAddress new postcode: 'A1 1AA'); store.

	"Description of previously-problematic query block:
	1) The Address table is joined due to the condition in the satisfying: block.
	2) Next the Person table is joined to handle the friend part of the select: block.
	3) The reference to address does not add the Address table since it is already included via the satsifying block.
	4) The isNil test drops the last-added table since it is not required for the isNil test and it thinks this is the first encounter with the Address table - not the case here, since Address was not encountered and joined in the satisfying: block.
	5) Instead the Person (friend) table is incorrectly dropped, resulting in invalid SQL.
	This is fixed by seeding the block parser's fieldEncounters collection with the joining fields for the referenced tables - see SSWDBBlockParser>>reset. 
	This prevents the parser considering re-encountered joined tables as the first encounter of that field, which prevents the table being dropped - see SSWDBBlockReceiver>>finalField"
	self shouldnt: [results := (persons satisfying: [ :each | each address postcode = 'A1 1AA']) select: [ :each | (each friend firstName = 'John') | each address isNil]] raise: Error.

	self assert: results size= 1.
	self assert: (results includes: zoe)! !
!SSWReStoreJoinQueryTest categoriesFor: #testCollectWithAlreadyJoinedTable!public!unit tests! !
!SSWReStoreJoinQueryTest categoriesFor: #testJoinFieldMultipleConditional!public!unit tests! !
!SSWReStoreJoinQueryTest categoriesFor: #testJoinFieldReusedConditional!public!unit tests! !
!SSWReStoreJoinQueryTest categoriesFor: #testJoinFieldSoleConditional!public!unit tests! !
!SSWReStoreJoinQueryTest categoriesFor: #testMultipleJoinFieldConditional!public!unit tests! !
!SSWReStoreJoinQueryTest categoriesFor: #testNestedJoinFieldConditional!public!unit tests! !
!SSWReStoreJoinQueryTest categoriesFor: #testSatisfyingWithAlreadyJoinedTable!public!unit tests! !
!SSWReStoreJoinQueryTest categoriesFor: #testSelectWithAlreadyJoinedTable!public!unit tests! !

!SSWReStoreJoinQueryTest class methodsFor!

shouldInheritSelectors

	^false! !
!SSWReStoreJoinQueryTest class categoriesFor: #shouldInheritSelectors!public! !


"Filed out from Dolphin Smalltalk 7"!

SSWReStoreDeleteRelatedCollectionTest subclass: #SSWReStoreDeleteRelatedGeneralCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreDeleteRelatedGeneralCollectionTest guid: (GUID fromString: '{991edb93-79cc-4b0f-979d-a6a87c7d42c3}')!
SSWReStoreDeleteRelatedGeneralCollectionTest comment: ''!
!SSWReStoreDeleteRelatedGeneralCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreDeleteRelatedGeneralCollectionTest methodsFor!

deleteQueriesCount

	"How many queries to delete a collection?"
	^1!

ordersCollectionDefinition

	"General (non-owned) collection"

	^(OrderedCollection of: SimpleProductOrder related)!

testDeleteProxiedCollection

	| collectionTable allEntriesCount customer2ID customer2EntriesCount |

	collectionTable := ((reStore tableForClass: SimplePerson) collectionAccessing: #orders) collectionTable name.
	allEntriesCount := (reStore executeSQL: 'select count(id) from <1s>' << collectionTable) results first contents first.
	customer2ID := customer2 _id.
	customer2EntriesCount := (reStore executeSQL: 'select count(id) from <1s> where source_id = <2d>' << {collectionTable. customer2ID}) results first contents first.

	super testDeleteProxiedCollection.

	"Verify the collection table entries have been deleted"
	self assert: (reStore executeSQL: 'select count(id) from <1s>' << collectionTable) results first contents first equals: (allEntriesCount - customer2EntriesCount).
	self assert: (reStore executeSQL: 'select count(id) from <1s> where source_id = <2d>' << {collectionTable. customer2ID}) results first contents first equals: 0!

testDeleteUnproxiedCollection

	| collectionTable allEntriesCount customer1ID customer1EntriesCount |

	collectionTable := ((reStore tableForClass: SimplePerson) collectionAccessing: #orders) collectionTable name.
	allEntriesCount := (reStore executeSQL: 'select count(id) from <1s>' << collectionTable) results first contents first.
	customer1ID := customer1 _id.
	customer1EntriesCount := (reStore executeSQL: 'select count(id) from <1s> where source_id = <2d>' << {collectionTable. customer1ID}) results first contents first.

	super testDeleteUnproxiedCollection.

	"Verify the collection table entries have been deleted"
	self assert: (reStore executeSQL: 'select count(id) from <1s>' << collectionTable) results first contents first equals: (allEntriesCount - customer1EntriesCount).
	self assert: (reStore executeSQL: 'select count(id) from <1s> where source_id = <2d>' << {collectionTable. customer1ID}) results first contents first equals: 0! !
!SSWReStoreDeleteRelatedGeneralCollectionTest categoriesFor: #deleteQueriesCount!constants!public! !
!SSWReStoreDeleteRelatedGeneralCollectionTest categoriesFor: #ordersCollectionDefinition!constants!public! !
!SSWReStoreDeleteRelatedGeneralCollectionTest categoriesFor: #testDeleteProxiedCollection!public!unit tests! !
!SSWReStoreDeleteRelatedGeneralCollectionTest categoriesFor: #testDeleteUnproxiedCollection!public!unit tests! !

!SSWReStoreDeleteRelatedGeneralCollectionTest class methodsFor!

testSelectors

	^self myTestSelectors! !
!SSWReStoreDeleteRelatedGeneralCollectionTest class categoriesFor: #testSelectors!public! !


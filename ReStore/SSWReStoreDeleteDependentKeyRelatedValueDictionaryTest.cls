"Filed out from Dolphin Smalltalk 7"!

SSWReStoreDeleteRelatedDictionaryTest subclass: #SSWReStoreDeleteDependentKeyRelatedValueDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreDeleteDependentKeyRelatedValueDictionaryTest guid: (GUID fromString: '{1ef44832-b9d6-41a5-abc8-4e68a40304f7}')!
SSWReStoreDeleteDependentKeyRelatedValueDictionaryTest comment: ''!
!SSWReStoreDeleteDependentKeyRelatedValueDictionaryTest categoriesForClass!Unclassified! !
!SSWReStoreDeleteDependentKeyRelatedValueDictionaryTest methodsFor!

deleteQueriesCount

	"How many queries to delete a collection?"
	^reStore sqlDialect supportsDeleteWithJoin
		ifTrue: [1 "single query for entries and keys"]
		ifFalse: [2 "one query for entries, one for keys"]!

ordersCollectionDefinition

	^Dictionary of: (SimpleAddress dependent -> SimpleProductOrder related)!

testDeleteProxiedCollection

	| keyTable allKeysCount customer2EntriesCount |

	keyTable := (reStore tableForClass: SimpleAddress) name.
	allKeysCount := (reStore executeSQL: 'select count(id_) from <1s>' << keyTable) results first contents first.
	customer2EntriesCount := (reStore executeSQL: 'select count(id) from <1s> where source_id = <2d>' << {((reStore tableForClass: SimplePerson) collectionAccessing: #orders) collectionTable name. customer2 _id}) results first contents first.

	super testDeleteProxiedCollection.

	"Verify the keys have been deleted"
	self assert: (reStore executeSQL: 'select count(id_) from <1s>' << keyTable) results first contents first equals: (allKeysCount - customer2EntriesCount)!

testDeleteUnproxiedCollection

	| keyTable allKeysCount customer1EntriesCount |

	keyTable := (reStore tableForClass: SimpleAddress) name.
	allKeysCount := (reStore executeSQL: 'select count(id_) from <1s>' << keyTable) results first contents first.
	customer1EntriesCount := (reStore executeSQL: 'select count(id) from <1s> where source_id = <2d>' << {((reStore tableForClass: SimplePerson) collectionAccessing: #orders) collectionTable name. customer1 _id}) results first contents first.

	super testDeleteUnproxiedCollection.

	"Verify the keys have been deleted"
	self assert: (reStore executeSQL: 'select count(id_) from <1s>' << keyTable) results first contents first equals: (allKeysCount - customer1EntriesCount)! !
!SSWReStoreDeleteDependentKeyRelatedValueDictionaryTest categoriesFor: #deleteQueriesCount!constants!public! !
!SSWReStoreDeleteDependentKeyRelatedValueDictionaryTest categoriesFor: #ordersCollectionDefinition!constants!public! !
!SSWReStoreDeleteDependentKeyRelatedValueDictionaryTest categoriesFor: #testDeleteProxiedCollection!public!unit tests! !
!SSWReStoreDeleteDependentKeyRelatedValueDictionaryTest categoriesFor: #testDeleteUnproxiedCollection!public!unit tests! !


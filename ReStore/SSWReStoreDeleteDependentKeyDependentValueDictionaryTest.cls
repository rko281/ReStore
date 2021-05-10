"Filed out from Dolphin Smalltalk 7"!

SSWReStoreDeleteDependentDictionaryTest subclass: #SSWReStoreDeleteDependentKeyDependentValueDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreDeleteDependentKeyDependentValueDictionaryTest guid: (GUID fromString: '{2ab4729b-a544-4299-b41c-8410895fdf7b}')!
SSWReStoreDeleteDependentKeyDependentValueDictionaryTest comment: ''!
!SSWReStoreDeleteDependentKeyDependentValueDictionaryTest categoriesForClass!Unclassified! !
!SSWReStoreDeleteDependentKeyDependentValueDictionaryTest methodsFor!

deleteQueriesCount

	"How many queries to delete a collection?"
	^reStore sqlDialect supportsDeleteWithJoin
		ifTrue: [1 "single query for entries, keys and values"]
		ifFalse: [3 "one query for entries, one for keys, one for values"]!

ordersCollectionDefinition

	^Dictionary of: (SimpleAddress dependent -> SimpleProductOrder dependent)!

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
!SSWReStoreDeleteDependentKeyDependentValueDictionaryTest categoriesFor: #deleteQueriesCount!constants!public! !
!SSWReStoreDeleteDependentKeyDependentValueDictionaryTest categoriesFor: #ordersCollectionDefinition!constants!public! !
!SSWReStoreDeleteDependentKeyDependentValueDictionaryTest categoriesFor: #testDeleteProxiedCollection!public!unit tests! !
!SSWReStoreDeleteDependentKeyDependentValueDictionaryTest categoriesFor: #testDeleteUnproxiedCollection!public!unit tests! !


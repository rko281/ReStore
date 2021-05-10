"Filed out from Dolphin Smalltalk 7"!

SSWReStoreDeleteRelatedDictionaryTest subclass: #SSWReStoreDeleteRelatedKeyRelatedValueDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreDeleteRelatedKeyRelatedValueDictionaryTest guid: (GUID fromString: '{1d5ce376-063c-4410-9b0d-1d8ba44df4e3}')!
SSWReStoreDeleteRelatedKeyRelatedValueDictionaryTest comment: ''!
!SSWReStoreDeleteRelatedKeyRelatedValueDictionaryTest categoriesForClass!Unclassified! !
!SSWReStoreDeleteRelatedKeyRelatedValueDictionaryTest methodsFor!

ordersCollectionDefinition

	^Dictionary of: (SimpleAddress related -> SimpleProductOrder related)!

testDeleteProxiedCollection

	| keyTable allKeysCount |

	keyTable := (reStore tableForClass: SimpleAddress) name.
	allKeysCount := (reStore executeSQL: 'select count(id_) from <1s>' << keyTable) results first contents first.

	super testDeleteProxiedCollection.

	"Verify the keys have not been deleted"
	self assert: (reStore executeSQL: 'select count(id_) from <1s>' << keyTable) results first contents first equals: allKeysCount!

testDeleteUnproxiedCollection

	| keyTable allKeysCount |

	keyTable := (reStore tableForClass: SimpleAddress) name.
	allKeysCount := (reStore executeSQL: 'select count(id_) from <1s>' << keyTable) results first contents first.

	super testDeleteUnproxiedCollection.

	"Verify the keys have not been deleted"
	self assert: (reStore executeSQL: 'select count(id_) from <1s>' << keyTable) results first contents first equals: allKeysCount! !
!SSWReStoreDeleteRelatedKeyRelatedValueDictionaryTest categoriesFor: #ordersCollectionDefinition!constants!public! !
!SSWReStoreDeleteRelatedKeyRelatedValueDictionaryTest categoriesFor: #testDeleteProxiedCollection!public!unit tests! !
!SSWReStoreDeleteRelatedKeyRelatedValueDictionaryTest categoriesFor: #testDeleteUnproxiedCollection!public!unit tests! !


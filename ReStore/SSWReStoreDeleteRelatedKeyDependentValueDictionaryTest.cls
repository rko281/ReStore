"Filed out from Dolphin Smalltalk 7"!

SSWReStoreDeleteDependentDictionaryTest subclass: #SSWReStoreDeleteRelatedKeyDependentValueDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreDeleteRelatedKeyDependentValueDictionaryTest guid: (GUID fromString: '{f4c4d2fd-149f-4ad4-996b-a7cb3e4367b1}')!
SSWReStoreDeleteRelatedKeyDependentValueDictionaryTest comment: ''!
!SSWReStoreDeleteRelatedKeyDependentValueDictionaryTest categoriesForClass!Unclassified! !
!SSWReStoreDeleteRelatedKeyDependentValueDictionaryTest methodsFor!

ordersCollectionDefinition

	^Dictionary of: (SimpleAddress related -> SimpleProductOrder dependent)!

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

	"Verify the keys have been not deleted"
	self assert: (reStore executeSQL: 'select count(id_) from <1s>' << keyTable) results first contents first equals: allKeysCount! !
!SSWReStoreDeleteRelatedKeyDependentValueDictionaryTest categoriesFor: #ordersCollectionDefinition!constants!public! !
!SSWReStoreDeleteRelatedKeyDependentValueDictionaryTest categoriesFor: #testDeleteProxiedCollection!public!unit tests! !
!SSWReStoreDeleteRelatedKeyDependentValueDictionaryTest categoriesFor: #testDeleteUnproxiedCollection!public!unit tests! !


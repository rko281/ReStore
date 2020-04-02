"Filed out from Dolphin Smalltalk 7"!

SSWReStoreGenericRelatedCollectionTest subclass: #SSWReStoreRelatedDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreRelatedDictionaryTest guid: (GUID fromString: '{ae275dac-fa24-402e-9385-4f817aef3ef6}')!
SSWReStoreRelatedDictionaryTest comment: 'ReStore
©2020 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreRelatedDictionaryTest categoriesForClass!Unclassified! !
!SSWReStoreRelatedDictionaryTest methodsFor!

addToCollection: aCollection

	^aCollection at: self templateComponent put: self templateComponent!

componentDefinition

	^(Dictionary of: GenericOwnedTest -> GenericOwnedTest related)!

remove: anObject fromCollection: aCollection

	^aCollection removeKey: (aCollection keyAtValue: anObject)!

replaceInCollection: aCollection

	| key old |

	key := aCollection keys anyOne.
	old := aCollection at: key.
	^old -> (aCollection at: key put: self templateComponent)!

templateCollection

	^Dictionary new
		at: self templateComponent put: self templateComponent;
		at: self templateComponent put: self templateComponent;
		at: self templateComponent put: self templateComponent;
		at: self templateComponent put: self templateComponent;
		at: self templateComponent put: self templateComponent;
		yourself! !
!SSWReStoreRelatedDictionaryTest categoriesFor: #addToCollection:!helpers!private! !
!SSWReStoreRelatedDictionaryTest categoriesFor: #componentDefinition!accessing!public! !
!SSWReStoreRelatedDictionaryTest categoriesFor: #remove:fromCollection:!helpers!private! !
!SSWReStoreRelatedDictionaryTest categoriesFor: #replaceInCollection:!public! !
!SSWReStoreRelatedDictionaryTest categoriesFor: #templateCollection!accessing!public! !


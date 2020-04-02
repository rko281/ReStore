"Filed out from Dolphin Smalltalk 7"!

SSWReStoreGenericNonRelatedCollectionTest subclass: #SSWReStoreNonRelatedDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreNonRelatedDictionaryTest guid: (GUID fromString: '{6b1484b3-f3b4-4662-8187-3564d40dd7d9}')!
SSWReStoreNonRelatedDictionaryTest comment: 'ReStore
©2020 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreNonRelatedDictionaryTest categoriesForClass!Unclassified! !
!SSWReStoreNonRelatedDictionaryTest methodsFor!

addToCollection: aCollection

	^aCollection at: self templateComponent put: self templateComponent!

componentDefinition

	^(Dictionary of: GenericOwnedTest -> GenericOwnedTest)!

remove: anObject fromCollection: aCollection

	^aCollection removeKey: (aCollection keyAtValue: anObject)!

removeFromCollection: aCollection

	^aCollection removeKey: collection keys anyOne!

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
!SSWReStoreNonRelatedDictionaryTest categoriesFor: #addToCollection:!helpers!private! !
!SSWReStoreNonRelatedDictionaryTest categoriesFor: #componentDefinition!accessing!public! !
!SSWReStoreNonRelatedDictionaryTest categoriesFor: #remove:fromCollection:!helpers!private! !
!SSWReStoreNonRelatedDictionaryTest categoriesFor: #removeFromCollection:!helpers!private! !
!SSWReStoreNonRelatedDictionaryTest categoriesFor: #replaceInCollection:!public! !
!SSWReStoreNonRelatedDictionaryTest categoriesFor: #templateCollection!accessing!public! !


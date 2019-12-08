"Filed out from Dolphin Smalltalk 7"!

SSWReStoreGenericNonRelatedCollectionTest subclass: #SSWReStoreNonRelatedOwnedOrderedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreNonRelatedOwnedOrderedCollectionTest guid: (GUID fromString: '{d9eba199-fc05-45a5-8311-dfb96804590e}')!
SSWReStoreNonRelatedOwnedOrderedCollectionTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreNonRelatedOwnedOrderedCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreNonRelatedOwnedOrderedCollectionTest methodsFor!

componentDefinition

	^OrderedCollection of: GenericOwnedTest owner: #owner!

replaceInCollection: aCollection

	^(aCollection at: aCollection size) -> (aCollection at: aCollection size put: self templateComponent)!

templateCollection

	^OrderedCollection 
		with: self templateComponent
		with: self templateComponent
		with: self templateComponent! !
!SSWReStoreNonRelatedOwnedOrderedCollectionTest categoriesFor: #componentDefinition!accessing!public! !
!SSWReStoreNonRelatedOwnedOrderedCollectionTest categoriesFor: #replaceInCollection:!public! !
!SSWReStoreNonRelatedOwnedOrderedCollectionTest categoriesFor: #templateCollection!accessing!public! !


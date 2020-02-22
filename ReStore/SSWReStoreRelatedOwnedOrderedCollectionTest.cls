"Filed out from Dolphin Smalltalk 7"!

SSWReStoreGenericRelatedCollectionTest subclass: #SSWReStoreRelatedOwnedOrderedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreRelatedOwnedOrderedCollectionTest guid: (GUID fromString: '{a700c641-c5c7-405c-9f59-32592d5c16b8}')!
SSWReStoreRelatedOwnedOrderedCollectionTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreRelatedOwnedOrderedCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreRelatedOwnedOrderedCollectionTest methodsFor!

componentDefinition

	^OrderedCollection of: GenericOwnedTest related owner: #owner!

replaceInCollection: aCollection

	^(aCollection at: aCollection size) -> (aCollection at: aCollection size put: self templateComponent)!

templateCollection

	^OrderedCollection 
		with: self templateComponent
		with: self templateComponent
		with: self templateComponent! !
!SSWReStoreRelatedOwnedOrderedCollectionTest categoriesFor: #componentDefinition!accessing!public! !
!SSWReStoreRelatedOwnedOrderedCollectionTest categoriesFor: #replaceInCollection:!public! !
!SSWReStoreRelatedOwnedOrderedCollectionTest categoriesFor: #templateCollection!accessing!public! !


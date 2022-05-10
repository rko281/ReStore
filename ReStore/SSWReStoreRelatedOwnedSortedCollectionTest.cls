"Filed out from Dolphin Smallalk"!

SSWReStoreRelatedOwnedOrderedCollectionTest subclass: #SSWReStoreRelatedOwnedSortedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreRelatedOwnedSortedCollectionTest guid: (GUID fromString: '{ca4ca9bb-b11b-4105-aba9-98a30c4f1d10}')!
SSWReStoreRelatedOwnedSortedCollectionTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreRelatedOwnedSortedCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreRelatedOwnedSortedCollectionTest methodsFor!

componentDefinition

	^SortedCollection of: GenericOwnedTest related owner: #owner!

replaceInCollection: aCollection

	^(aCollection remove: aCollection last) -> (aCollection add: self templateComponent)!

templateCollection

	^SortedCollection 
		with: self templateComponent
		with: self templateComponent
		with: self templateComponent! !
!SSWReStoreRelatedOwnedSortedCollectionTest categoriesForMethods!
componentDefinition!accessing!public! !
replaceInCollection:!public! !
templateCollection!accessing!public! !
!


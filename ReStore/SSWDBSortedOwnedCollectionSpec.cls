"Filed out from Dolphin Smallalk"!

SSWDBOwnedCollectionSpec subclass: #SSWDBSortedOwnedCollectionSpec
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBSortedOwnedCollectionSpec guid: (GUID fromString: '{d1cdd241-010b-49ec-b908-535d393924ae}')!
SSWDBSortedOwnedCollectionSpec comment: ''!
!SSWDBSortedOwnedCollectionSpec categoriesForClass!Unclassified! !
!SSWDBSortedOwnedCollectionSpec methodsFor!

hasCollection: updatedCollection anyAdditionsOrRemovalsFrom: originalCollection

	updatedCollection size = originalCollection size ifFalse: [^true].

	1 to: originalCollection size do: [ :index | (originalCollection at: index) == (updatedCollection at: index) ifFalse: [^true]].

	^false!

queryClass

	"Return the correct query class to use for the receiver"
	
	^SSWSQLOrderedSelectQuery!

setOrderingSpecs

	self orderingSpecs: (self templateCollection orderingSpecsFor: self targetClass in: self reStore)! !
!SSWDBSortedOwnedCollectionSpec categoriesForMethods!
hasCollection:anyAdditionsOrRemovalsFrom:!private!testing! !
queryClass!accessing!public! !
setOrderingSpecs!initializing!public! !
!


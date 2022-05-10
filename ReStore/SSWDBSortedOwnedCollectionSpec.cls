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
	updatedCollection with: originalCollection do: [ :a :b | a == b ifFalse: [^true]].
	^false! !
!SSWDBSortedOwnedCollectionSpec categoriesForMethods!
hasCollection:anyAdditionsOrRemovalsFrom:!private!testing! !
!


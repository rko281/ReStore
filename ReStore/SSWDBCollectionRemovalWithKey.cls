"Filed out from Dolphin Smalltalk 7"!

SSWDBCollectionRemoval subclass: #SSWDBCollectionRemovalWithKey
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBCollectionRemovalWithKey guid: (GUID fromString: '{68a2862d-68cc-4bd2-97cc-8518747dfaba}')!
SSWDBCollectionRemovalWithKey comment: ''!
!SSWDBCollectionRemovalWithKey categoriesForClass!Unclassified! !
!SSWDBCollectionRemovalWithKey methodsFor!

prepareToCommitFor: anSSWDBCollectionProxy

	(anSSWDBCollectionProxy _shouldUnstoreKey: self affectedEntry index) ifTrue: [self affectedEntry index unstore].

	^super prepareToCommitFor: anSSWDBCollectionProxy! !
!SSWDBCollectionRemovalWithKey categoriesFor: #prepareToCommitFor:!actions - api!public! !


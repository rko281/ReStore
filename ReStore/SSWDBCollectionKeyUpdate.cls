"Filed out from Dolphin Smalltalk 7"!

SSWDBCollectionIndexUpdate subclass: #SSWDBCollectionKeyUpdate
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBCollectionKeyUpdate guid: (GUID fromString: '{d86f43fa-1b8c-46a8-9bda-9e6ccc91bf66}')!
SSWDBCollectionKeyUpdate comment: ''!
!SSWDBCollectionKeyUpdate categoriesForClass!Unclassified! !
!SSWDBCollectionKeyUpdate methodsFor!

prepareToCommitFor: anSSWDBCollectionProxy

	(anSSWDBCollectionProxy _shouldUnstoreKey: self affectedEntry index) ifTrue: [self affectedEntry index unstore].

	^super prepareToCommitFor: anSSWDBCollectionProxy! !
!SSWDBCollectionKeyUpdate categoriesFor: #prepareToCommitFor:!actions - api!public! !


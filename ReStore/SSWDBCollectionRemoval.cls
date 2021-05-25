"Filed out from Dolphin Smalltalk 7"!

SSWDBCollectionChange subclass: #SSWDBCollectionRemoval
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBCollectionRemoval guid: (GUID fromString: '{5a3e3dc8-3990-11d5-b1df-444553540000}')!
SSWDBCollectionRemoval comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBCollectionRemoval categoriesForClass!Unclassified! !
!SSWDBCollectionRemoval methodsFor!

applyTo: aCollection

	self affectedEntry removeFrom: aCollection!

commitFor: aCollectionProxy

	self affectedEntry isPersistent ifTrue: [aCollectionProxy _collectionSpec deleteEntry: self affectedEntry]!

prepareToCommitFor: anSSWDBCollectionProxy

	(anSSWDBCollectionProxy _shouldUnstoreValue: self affectedEntry target) ifTrue: [self affectedEntry target unstore].

	^super prepareToCommitFor: anSSWDBCollectionProxy! !
!SSWDBCollectionRemoval categoriesFor: #applyTo:!actions!public! !
!SSWDBCollectionRemoval categoriesFor: #commitFor:!actions - api!public! !
!SSWDBCollectionRemoval categoriesFor: #prepareToCommitFor:!actions - api!public! !


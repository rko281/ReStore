"Filed out from Dolphin Smalltalk 7"!

SSWDBCollectionChange subclass: #SSWDBCollectionUpdate
	instanceVariableNames: 'newTarget'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBCollectionUpdate guid: (GUID fromString: '{62572521-5cd7-11d5-b1df-0010a70883e2}')!
SSWDBCollectionUpdate comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBCollectionUpdate categoriesForClass!Unclassified! !
!SSWDBCollectionUpdate methodsFor!

applyTo: aCollection

	self affectedEntry target: self newTarget!

canRemoveValue

	^true!

commitFor: aCollectionProxy

	self affectedEntry isPersistent ifTrue: 
		[aCollectionProxy _collectionSpec 
			updateEntry: self affectedEntry 
			withTarget: self newTarget
			in: aCollectionProxy _reStore]!

newTarget

	"newTarget stores the object which is now in the position of the collection
	associated with the receiver's entry"

	^newTarget!

newTarget: anObject

	"newTarget stores the object which is now in the position of the collection
	associated with the receiver's entry"

	newTarget := anObject! !
!SSWDBCollectionUpdate categoriesFor: #applyTo:!actions - api!public! !
!SSWDBCollectionUpdate categoriesFor: #canRemoveValue!public!testing! !
!SSWDBCollectionUpdate categoriesFor: #commitFor:!actions - api!public! !
!SSWDBCollectionUpdate categoriesFor: #newTarget!accessing!public! !
!SSWDBCollectionUpdate categoriesFor: #newTarget:!accessing!public! !

!SSWDBCollectionUpdate class methodsFor!

entry: aCollectionEntry newTarget: anObject

	^(self newWithEntry: aCollectionEntry)
		newTarget: anObject;
		yourself! !
!SSWDBCollectionUpdate class categoriesFor: #entry:newTarget:!instance creation!public! !


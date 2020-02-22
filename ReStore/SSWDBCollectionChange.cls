"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SSWDBCollectionChange
	instanceVariableNames: 'affectedEntry'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBCollectionChange guid: (GUID fromString: '{5a3e3dc6-3990-11d5-b1df-444553540000}')!
SSWDBCollectionChange comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBCollectionChange categoriesForClass!Unclassified! !
!SSWDBCollectionChange methodsFor!

affectedEntry

	"affectedEntry stores the Collection Entry affected (added/removed/altered) by the
	change represented by the receiver"
	
	^affectedEntry!

affectedEntry: anSSWDBCollectionEntry

	"affectedEntry stores the Collection Entry affected (added/removed/altered) by the
	change represented by the receiver"
	
	affectedEntry := anSSWDBCollectionEntry!

applyTo: aCollectionOfEntries

	"Apply the change represented by the receiver to the given collection
	of collectionEntries"
	
	self subclassResponsibility!

canRemoveKey

	"Return a Boolean indicating whether the receiver can potentially remove a key/index from a collection.
	Default - false"

	^false!

canRemoveValue

	"Return a Boolean indicating whether the receiver can potentially remove a value object from a collection.
	Default - false"

	^false!

commitFor: aCollectionProxy

	"Apply the change represented by the receiver onto the ReStore in which
	the given SSWDBCollectionProxy resides"
	
	self subclassResponsibility!

prepareToCommitFor: anSSWDBCachingCollectionProxy

	^self affectedEntry prepareToCommitFor: anSSWDBCachingCollectionProxy! !
!SSWDBCollectionChange categoriesFor: #affectedEntry!accessing!public! !
!SSWDBCollectionChange categoriesFor: #affectedEntry:!accessing!public! !
!SSWDBCollectionChange categoriesFor: #applyTo:!actions!public! !
!SSWDBCollectionChange categoriesFor: #canRemoveKey!public!testing! !
!SSWDBCollectionChange categoriesFor: #canRemoveValue!public!testing! !
!SSWDBCollectionChange categoriesFor: #commitFor:!actions!public! !
!SSWDBCollectionChange categoriesFor: #prepareToCommitFor:!actions!public! !

!SSWDBCollectionChange class methodsFor!

added: anObject

	^self newWithEntry:
		(SSWDBCollectionEntry new
			target: anObject;
			yourself)!

newWithEntry: anSSWDBCollectionEntry

	^self new
		affectedEntry: anSSWDBCollectionEntry;
		yourself! !
!SSWDBCollectionChange class categoriesFor: #added:!instance creation!public! !
!SSWDBCollectionChange class categoriesFor: #newWithEntry:!instance creation!public! !


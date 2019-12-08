"Filed out from Dolphin Smalltalk 7"!

SSWDBCollectionChange subclass: #SSWDBCollectionIndexUpdate
	instanceVariableNames: 'newIndex'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBCollectionIndexUpdate guid: (GUID fromString: '{7253b7a1-61bd-11d5-b1df-0010a70883e2}')!
SSWDBCollectionIndexUpdate comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBCollectionIndexUpdate categoriesForClass!Unclassified! !
!SSWDBCollectionIndexUpdate methodsFor!

applyTo: aCollection

	self affectedEntry index: self newIndex

"	| oldIndex |

	oldIndex := aCollection identityIndexOf: self affectedEntry.
	oldIndex = newIndex ifFalse: 
		[aCollection 
			removeAtIndex: oldIndex;
			add: self affectedEntry afterIndex: (self newIndex - 1)]"!

canRemoveKey

	^true!

commitFor: aCollectionProxy

	self affectedEntry isPersistent ifTrue: 
		[aCollectionProxy _collectionSpec 
			updateEntry: self affectedEntry 
			withIndex: self newIndex
			in: aCollectionProxy _reStore]!

indexChange

	^self newIndex - self oldIndex!

newIndex

	"newIndex stores the Integer index which the entry represented by the receiver
	should hold on commit"

	^newIndex!

newIndex: anInteger

	"newIndex stores the Integer index which the entry represented by the receiver
	should hold on commit"

	newIndex := anInteger!

oldIndex

	^self affectedEntry index!

prepareToCommitFor: anSSWDBCachingCollectionProxy

	self newIndex _ensureActiveIn: anSSWDBCachingCollectionProxy _reStore.

	^super prepareToCommitFor: anSSWDBCachingCollectionProxy! !
!SSWDBCollectionIndexUpdate categoriesFor: #applyTo:!actions - api!public! !
!SSWDBCollectionIndexUpdate categoriesFor: #canRemoveKey!public!testing! !
!SSWDBCollectionIndexUpdate categoriesFor: #commitFor:!actions - api!public! !
!SSWDBCollectionIndexUpdate categoriesFor: #indexChange!accessing!public! !
!SSWDBCollectionIndexUpdate categoriesFor: #newIndex!accessing!public! !
!SSWDBCollectionIndexUpdate categoriesFor: #newIndex:!accessing!public! !
!SSWDBCollectionIndexUpdate categoriesFor: #oldIndex!accessing!public! !
!SSWDBCollectionIndexUpdate categoriesFor: #prepareToCommitFor:!actions!public! !

!SSWDBCollectionIndexUpdate class methodsFor!

entry: aCollectionEntry newIndex: anInteger

	^(self newWithEntry: aCollectionEntry)
		newIndex: anInteger;
		yourself! !
!SSWDBCollectionIndexUpdate class categoriesFor: #entry:newIndex:!instance creation!public! !


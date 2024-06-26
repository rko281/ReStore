﻿"Filed out from Dolphin Smallalk"!

SSWDBCollectionChange subclass: #SSWDBCollectionAddition
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBCollectionAddition guid: (GUID fromString: '{5a3e3dc7-3990-11d5-b1df-444553540000}')!
SSWDBCollectionAddition comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBCollectionAddition categoriesForClass!Unclassified! !
!SSWDBCollectionAddition methodsFor!

applyTo: aCollection

	self affectedEntry addTo: aCollection!

commitFor: aCollectionProxy

	"	self affectedEntry target isNil
		ifTrue: [self affectedEntry targetID: nil]
		ifFalse: [self affectedEntry targetID: self affectedEntry target _id]."

	aCollectionProxy _collectionSpec insertEntry: self affectedEntry!

prepareToCommitFor: aCollectionProxy

	| table |

	super prepareToCommitFor: aCollectionProxy.

	self affectedEntry target _ensurePersistentIn: aCollectionProxy _reStore.

	table := aCollectionProxy _collectionSpec collectionTable.

	self affectedEntry 
		table: table;
		sourceID: aCollectionProxy _ownerID;
		entryID: (aCollectionProxy _reStore allocateIDFor: self affectedEntry in: table)! !
!SSWDBCollectionAddition categoriesForMethods!
applyTo:!actions!public! !
commitFor:!actions!public! !
prepareToCommitFor:!actions!public! !
!

!SSWDBCollectionAddition class methodsFor!

added: anObject at: keyObject

	^self newWithEntry:
		(SSWDBKeyedCollectionEntry new
			target: anObject;
			index: keyObject;
			yourself)! !
!SSWDBCollectionAddition class categoriesForMethods!
added:at:!instance creation!public! !
!


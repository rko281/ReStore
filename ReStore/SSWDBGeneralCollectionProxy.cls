﻿"Filed out from Dolphin Smalltalk 7"!

SSWDBCollectionProxy subclass: #SSWDBGeneralCollectionProxy
	instanceVariableNames: 'collectionEntries changes isDeleted'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBGeneralCollectionProxy guid: (GUID fromString: '{20954e42-6188-11d5-b1df-0010a70883e2}')!
SSWDBGeneralCollectionProxy comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBGeneralCollectionProxy categoriesForClass!Unclassified! !
!SSWDBGeneralCollectionProxy methodsFor!

_changes

	"During commit, changes temporatily stores a Collection of 	SSWDBCollectionChanges 
	representing changes made to the receiver's proxied collection"

	^changes!

_changes: anOrderedCollection

	"During commit, changes temporatily stores a Collection of 	SSWDBCollectionChanges 
	representing changes made to the receiver's proxied collection"

	changes := anOrderedCollection!

_checkHasChanged

	| changed |

	self _isDeleted ifTrue: [^true].

	self _setChanges.
	changed := changes isEmpty not.

	"Clear out the changes"
	self _resetChanges.

	^changed!

_collectionEntries

	"The receiver automatically detects changes to its proxiedObject collection
	by keeping a copy of the SSWDBCollectionEntry records that define the colleciton in the DB"
	
	^collectionEntries!

_collectionEntries: aCollection

	"The receiver automatically detects changes to its proxiedObject collection
	by keeping a copy of the SSWDBCollectionEntry records that define the colleciton in the DB"
	
	collectionEntries := aCollection!

_commitChanges

	changes do: [ :change | change commitFor: self].

	"Deletion of collection table entries, keys and values (as appropriate)"
	self _isDeleted ifTrue: 
		[collectionSpec isValueDependent ifTrue: 
			[collectionSpec deleteStatement
				values: (Array with: owner _id);
				exec].

		"Keys"
		collectionSpec isKeyDependent ifTrue: 
			[collectionSpec deleteKeysStatement ifNotNil: 
				[ :stmt |
				stmt
					values: (Array with: owner _id);
					exec]].

		"Entries, if not already done by the above"
		(collectionSpec sqlDialect supportsDeleteWithJoin and: [collectionSpec isKeyDependent or: [collectionSpec isValueDependent]]) ifFalse: 
			[collectionSpec deleteEntriesStatement
				values: (Array with: owner _id);
				exec]].

	^true!

_hasChanged

	"Unlike _checkHasChanged, do not clear out the changes
	 - prepareToCommit will use them"
	
	self _setChanges.

	^self _isDeleted or: [changes isEmpty not]!

_isDeleted

	"The receiver stores its deleted status as a Boolean"

	^isDeleted!

_isDeleted: aBoolean

	"The receiver stores its deleted status as a Boolean"

	isDeleted := aBoolean!

_isPersistent

	^collectionEntries ~~ nil or: [self _isRecovered not]!

_postCommitChanges

	self _isPersistent 
		ifTrue: [changes do: [ :change | change applyTo: collectionEntries]]
		ifFalse: [collectionEntries := changes collect: [ :change | change affectedEntry]].
	
	self _resetChanges!

_prepareToCommit

	"The receiver is guaranteed to be sent _hasChanged prior to this method,
	so no need to reassemble the changes"
	changes do: [ :change | change prepareToCommitFor: self]!

_resetChanges

	changes := nil!

_rollbackChanges

	"Rollback any changes made by reinstantiating from the collectionEntries.
	Also transfer any events associated with the collection"

	| rollbackCollection me |

	self _checkHasChanged
	ifTrue:
		[rollbackCollection := collectionSpec newCollection.
		collectionEntries do: [ :entry | entry addTargetTo: rollbackCollection].
		proxiedObject getEvents ifNotNil: [ :events | rollbackCollection setEvents: events]]
	ifFalse:
		[rollbackCollection := self	"Will be proxiedObject after the swap"].

	me := proxiedObject.
	self _swapReferences.

	me _proxiedObject: rollbackCollection!

_setChanges

	self _isPersistent
	ifTrue: 
		[self _isDeleted
		ifTrue: 
			[changes := #().
			(collectionSpec isValueDependent or: [collectionSpec isKeyDependent]) ifTrue: 
				[collectionEntries do: 
					[ :each |
					(collectionSpec isKeyDependent and: [each index isDBProxy]) ifTrue: 
						[reStore transaction addDeletedObject: each index _proxiedObject.
						each index unstore].
					(collectionSpec isValueDependent and: [each target isDBProxy]) ifTrue: 
						[reStore transaction addDeletedObject: each target _proxiedObject.
						each target unstore]]]]
		ifFalse: 
			[changes := proxiedObject _changesFrom: collectionEntries]]
	ifFalse: 
		[changes := proxiedObject _collectionAdditions]!

_shouldUnstoreKey: anObject

	^self _collectionSpec isKeyDependent and: [(self _proxiedObject includesKey: anObject) not]!

_shouldUnstoreValue: anObject

	^self _collectionSpec isValueDependent and: [(self _proxiedObject identityIncludes: anObject) not]!

_unstore

	self _isPersistent 
		ifTrue: [isDeleted := true]
		ifFalse: [reStore removeFromTransaction: self]! !
!SSWDBGeneralCollectionProxy categoriesFor: #_changes!accessing!public! !
!SSWDBGeneralCollectionProxy categoriesFor: #_changes:!accessing!public! !
!SSWDBGeneralCollectionProxy categoriesFor: #_checkHasChanged!public!testing! !
!SSWDBGeneralCollectionProxy categoriesFor: #_collectionEntries!accessing!public! !
!SSWDBGeneralCollectionProxy categoriesFor: #_collectionEntries:!accessing!public! !
!SSWDBGeneralCollectionProxy categoriesFor: #_commitChanges!actions!public! !
!SSWDBGeneralCollectionProxy categoriesFor: #_hasChanged!public!testing! !
!SSWDBGeneralCollectionProxy categoriesFor: #_isDeleted!accessing!public!testing! !
!SSWDBGeneralCollectionProxy categoriesFor: #_isDeleted:!accessing!public! !
!SSWDBGeneralCollectionProxy categoriesFor: #_isPersistent!public!testing! !
!SSWDBGeneralCollectionProxy categoriesFor: #_postCommitChanges!actions!public! !
!SSWDBGeneralCollectionProxy categoriesFor: #_prepareToCommit!actions!public! !
!SSWDBGeneralCollectionProxy categoriesFor: #_resetChanges!actions!public! !
!SSWDBGeneralCollectionProxy categoriesFor: #_rollbackChanges!actions!public! !
!SSWDBGeneralCollectionProxy categoriesFor: #_setChanges!actions!public! !
!SSWDBGeneralCollectionProxy categoriesFor: #_shouldUnstoreKey:!private!testing! !
!SSWDBGeneralCollectionProxy categoriesFor: #_shouldUnstoreValue:!private!testing! !
!SSWDBGeneralCollectionProxy categoriesFor: #_unstore!actions!public! !

!SSWDBGeneralCollectionProxy class methodsFor!

new

	^super new
		_isDeleted: false;
		yourself! !
!SSWDBGeneralCollectionProxy class categoriesFor: #new!instance creation!public! !


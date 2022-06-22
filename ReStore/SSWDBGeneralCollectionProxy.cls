"Filed out from Dolphin Smallalk"!

SSWDBCollectionProxy subclass: #SSWDBGeneralCollectionProxy
	instanceVariableNames: 'collectionEntries changes'
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

	(self _isDeleted or: [self _isPersistent not]) ifTrue: [^true].

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
	
	collectionEntries := aCollection.
	collectionSpec preserveCollectionEntries: aCollection!

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

_forgetProxiedObject

	collectionEntries := nil.
	super _forgetProxiedObject!

_hasChanged

	"Unlike _checkHasChanged, do not clear out the changes - prepareToCommit will use them"
	
	self _setChanges.

	^self _isDeleted or: [self _isPersistent not or: [changes isEmpty not]]!

_postCommitChanges

	self _isPersistent 
		ifTrue: [changes do: [ :change | change applyTo: collectionEntries]]
		ifFalse: [self _collectionEntries: (changes collect: [ :change | change affectedEntry])].

	self 
		_setPersistent;
		_resetChanges!

_prepareToCommit

	"The receiver is guaranteed to be sent _hasChanged prior to this method,
	so no need to reassemble the changes"
	changes do: [ :change | change prepareToCommitFor: self]!

_resetChanges

	changes := nil!

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
						[reStore transaction addDeletedObject: each index.
						each index unstore].
					(collectionSpec isValueDependent and: [each target isDBProxy]) ifTrue: 
						[reStore transaction addDeletedObject: each target.
						each target unstore]]]]
		ifFalse: 
			[changes := collectionSpec changesTo: proxiedObject from: collectionEntries]]
	ifFalse: 
		[changes := collectionSpec allAdditionsTo: proxiedObject]!

_shouldUnstoreKey: anObject

	^self _collectionSpec isKeyDependent and: [(self _proxiedObject includesKey: anObject) not]!

_shouldUnstoreValue: anObject

	^self _collectionSpec isValueDependent and: [(self _proxiedObject identityIncludes: anObject) not]!

_unchangedCollection

	"Answer the receiver's collection prior to any changes. This is used to roll the receiver back to its previous state"

	| unchangedCollection |

	self _checkHasChanged ifFalse: [^proxiedObject].

	unchangedCollection := collectionSpec newCollection.
	collectionEntries notNil ifTrue: [collectionEntries do: [ :entry | entry addTargetTo: unchangedCollection]].
	
	^unchangedCollection! !
!SSWDBGeneralCollectionProxy categoriesForMethods!
_changes!accessing!public! !
_changes:!accessing!public! !
_checkHasChanged!public!testing! !
_collectionEntries!accessing!public! !
_collectionEntries:!accessing!public! !
_commitChanges!actions-internal!public! !
_forgetProxiedObject!actions-internal!public! !
_hasChanged!public!testing! !
_postCommitChanges!actions-internal!public! !
_prepareToCommit!actions-internal!public! !
_resetChanges!actions-internal!public! !
_setChanges!actions-internal!public! !
_shouldUnstoreKey:!private!testing! !
_shouldUnstoreValue:!private!testing! !
_unchangedCollection!accessing!private! !
!


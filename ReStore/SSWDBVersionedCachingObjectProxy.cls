"Filed out from Dolphin Smalltalk 7"!

SSWDBCachingObjectProxy subclass: #SSWDBVersionedCachingObjectProxy
	instanceVariableNames: 'version'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBVersionedCachingObjectProxy guid: (GUID fromString: '{36898ee1-3d8f-11d5-b1df-444553540000}')!
SSWDBVersionedCachingObjectProxy comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBVersionedCachingObjectProxy categoriesForClass!Unclassified! !
!SSWDBVersionedCachingObjectProxy methodsFor!

_commitUpdates

	"Reimplemented to include version increment"

	| updates |

	updates := self _fieldUpdates.
	
	^updates isEmpty 
	ifTrue: 
		[true]
	ifFalse: 
		[updates add: self _incrementVersionUpdate.
		(reStore applyUpdates: updates toObject: self)]!

_incrementVersion

	version == nil
		ifTrue: [version := 1]
		ifFalse: [version := version + 1]!

_incrementVersionUpdate

	"Create and return an update that will increment the version number
	of the row corresponding to the receiver's proxiedObject"
	
	^version == nil
		ifTrue: [SSWSQLFieldAssignment field: (self _dbTable fieldAccessing: #_version) value: 1]
		ifFalse: [SSWSQLFieldAssignment field: (self _dbTable fieldAccessing: #_version) value: (version + 1)]!

_matchStateOf: aProxy

	"Match the internal proxy (non data) state of aProxy"

	version := aProxy _version!

_postCommitUpdates

	"Reimplemented to increment version"

	| updates |

	updates := self _fieldUpdates.
	
	updates isEmpty ifFalse: 
		[updates applyTo: copyObject. 
		self _incrementVersion]!

_refreshIfUpdated

	"Using the receiver's version it is possible to refresh the receiver only if it has actually been updated in the database"

	self _isRecovered ifTrue: 
		[(reStore refreshProxyIfUpdated: self) ifTrue:
			["Update the copyObject"
			self _aquireCopyObject]]!

_version

	"version stores an Integer representing the version or revision number
	of the object proxy'd by the receiver.
	
	This number is incremented each time the object is changed in the DB"
	
	^version!

_version: anInteger

	"version stores an Integer representing the version or revision number
	of the object proxy'd by the receiver.
	
	This number is incremented each time the object is changed in the DB"
	
	version := anInteger! !
!SSWDBVersionedCachingObjectProxy categoriesFor: #_commitUpdates!actions-internal!public! !
!SSWDBVersionedCachingObjectProxy categoriesFor: #_incrementVersion!actions-internal!public! !
!SSWDBVersionedCachingObjectProxy categoriesFor: #_incrementVersionUpdate!accessing:derived!public! !
!SSWDBVersionedCachingObjectProxy categoriesFor: #_matchStateOf:!actions-internal!public! !
!SSWDBVersionedCachingObjectProxy categoriesFor: #_postCommitUpdates!actions-internal!public! !
!SSWDBVersionedCachingObjectProxy categoriesFor: #_refreshIfUpdated!actions-refresh!public! !
!SSWDBVersionedCachingObjectProxy categoriesFor: #_version!accessing!public! !
!SSWDBVersionedCachingObjectProxy categoriesFor: #_version:!accessing!public! !

!SSWDBVersionedCachingObjectProxy class methodsFor!

_forNewObject: anObject withID: anInteger inReStore: aReStore

	"Overriden to set initial version number"
	
	^(super _forNewObject: anObject withID: anInteger inReStore: aReStore)
		_version: 1;
		yourself!

controlFields

	"Overriden to set version controlField"

	^super controlFields
		add: self versionControlField;
		yourself!

modifyUpdatesFor: anSSWDBTable

	^(super modifyUpdatesFor: anSSWDBTable)
		add: [ :obj | obj _version: obj _version + 1];
		yourself
	!

new

	"Overriden to set initial version number"
	
	^super new
		_version: 1;
		yourself!

versionControlField

	^SSWDBStaticField new
		accessor: SSWDBVersionAccessor new;
		targetClass: Integer;
		yourself
	! !
!SSWDBVersionedCachingObjectProxy class categoriesFor: #_forNewObject:withID:inReStore:!instance creation!public! !
!SSWDBVersionedCachingObjectProxy class categoriesFor: #controlFields!constants!public! !
!SSWDBVersionedCachingObjectProxy class categoriesFor: #modifyUpdatesFor:!constants!public! !
!SSWDBVersionedCachingObjectProxy class categoriesFor: #new!instance creation!public! !
!SSWDBVersionedCachingObjectProxy class categoriesFor: #versionControlField!constants!public! !


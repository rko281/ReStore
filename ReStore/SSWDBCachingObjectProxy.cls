"Filed out from Dolphin Smallalk"!

SSWDBObjectProxy subclass: #SSWDBCachingObjectProxy
	instanceVariableNames: 'copyObject'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBCachingObjectProxy guid: (GUID fromString: '{5a3e3ddc-3990-11d5-b1df-444553540000}')!
SSWDBCachingObjectProxy comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBCachingObjectProxy categoriesForClass!Unclassified! !
!SSWDBCachingObjectProxy methodsFor!

_aquireCopyObject

	copyObject := self _dbTable copyForProxy: proxiedObject!

_checkHasChanged

	"Use the copy object to determine these"
	
	^self _isDeleted or:
		[self _isNew or: 
			[self _dbTable dataFields anySatisfy:
				[ :field || accessor current |
				accessor := field accessor.
				current := accessor valueIn: proxiedObject.
				current _hasChangedFrom: (accessor valueIn: copyObject)]]]!

_commitChanges

	"Return a Boolean indicating whether the commit succeeds"

	^self _isPersistent
	ifTrue:
		[self _isDeleted
			ifTrue: [self _commitUnstore]
			ifFalse: [self _commitUpdates]]
	ifFalse:
		[self _commitStore]!

_commitStore

	"Private - Return a Boolean indicating whether the commit succeeds"

	reStore insertProxy: self.

	"Assumed to always succeed"
	^true!

_commitUnstore

	"Private - Return a Boolean indicating whether the commit succeeds"

	reStore deleteProxy: self. 

	"Assumed to always succeed"
	^true
!

_commitUpdates

	"Private - Return a Boolean indicating whether the commit succeeds"

	| updates |

	updates := self _fieldUpdates.
	
	^updates isEmpty 
		ifTrue: [true]
		ifFalse: [reStore applyUpdates: updates toObject: self]!

_copyObject

	"The receiver automatically detects changes to its proxiedObject by maintaining a shallow copy
	of the proxiedObject. This is held in copyObject"
	
	^copyObject!

_copyObject: anObject

	"The receiver automatically detects changes to its proxiedObject by maintaining a shallow copy
	of the proxiedObject. This is held in copyObject"
	
	copyObject := anObject!

_fieldUpdates

	"Use the copy object to determine these"
	
	^self _dbTable dataFields inject: SSWSQLFieldAssignmentCollection new into: 
		[ :updates :field || accessor current |
		accessor := field accessor.
		current := accessor valueIn: proxiedObject.
		(current _hasChangedFrom: (accessor valueIn: copyObject)) ifTrue: 
			[updates add: (SSWSQLFieldAssignment field: field value: current)].
		updates]!

_forgetProxiedObject

	"Override to reset the copyObject"
	
	copyObject := nil.
	^super _forgetProxiedObject!

_isDeleted

	"Return a Boolean indicating whether the receiver has been marked as deleted.
	Deleted proxies have a copy of themselves as their copy object - this is the only circumstances under which copyObject holds a proxy"
	
	^copyObject isDBProxy!

_isPersistent

	"Return a Boolean indicating whether the receiver is persistent.
	Persistent proxies always have a copyObject, if they are recovered.
	Unrecovered proxies are persistent by definition"
	
	^copyObject ~~ nil or: [self _isRecovered not]!

_matchStateOf: aProxy

	"Match the internal proxy (non data) state of aProxy"

	^self!

_postCommitChanges

	"The receiver's changes have successfully been committed.
	Complete follow-on work"

	^self _isPersistent
	ifTrue:
		[self _isDeleted
			ifTrue: [self _postCommitUnstore]
			ifFalse: [self _postCommitUpdates]]
	ifFalse:
		[self _postCommitStore]!

_postCommitStore

	"Private - The receiver has been inserted into the database.
	Complete follow-on work"

	self _dbTable idDataField ifNotNil: [ :idDataField | idDataField accessor value: id in: proxiedObject].
	self _aquireCopyObject.
	self _intern	"Re-register"!

_postCommitUnstore

	"Private - The receiver has been successfully deleted from the database.
	Complete follow-on work and notify interest parties"

	reStore uncacheObject: self. 

	self _proxiedObject onUnstored.

	copyObject := proxiedObject := SSWDBDeletedObject newForClass: class id: id!

_postCommitUpdates

	| updates |

	updates := self _fieldUpdates.
	
	updates isEmpty ifFalse: [updates applyTo: copyObject]!

_prepareToCommit

	"Intercept to check for overwriten dependent objects - unstore these (issue#0006)"

	(self _isPersistent and: [self _isDeleted not]) ifTrue:
		[| replacedDependentFields |
		replacedDependentFields := self _dbTable dependentDataFieldsSelect:
			[ :field | (field accessor valueIn: proxiedObject) ~~ (field accessor valueIn: copyObject)].
		replacedDependentFields isEmpty ifFalse:
			[| heldObjects |
			"Only delete replaced dependent objects if they are not held elsewhere in proxiedObject"
			heldObjects := self _dbTable dataFields collect: [ :field | field accessor valueIn: proxiedObject].
			replacedDependentFields do: 
				[ :field | 
				(heldObjects identityIncludes: (field accessor valueIn: copyObject)) ifFalse:
					[(field accessor valueIn: copyObject) unstore]]]].

	^super _prepareToCommit!

_proxiedObject

	"Inline self _isDeleted"
	copyObject isDBProxy ifTrue: [^copyObject _proxiedObject].

	^proxiedObject!

_proxiedObject: anObject

	"Overriden to set the copyObject"
	
	super _proxiedObject: anObject.
	self _aquireCopyObject!

_recoverProxiedObject

	"Override to check for deleted status"
	
	self _isDeleted ifTrue: [nil error: 'Attempt to reference deleted persistent object'].
	
	super _recoverProxiedObject!

_refreshAndRollforward

	"Apply the changes made to the receiver to the current representation in the DB.
	Return a Boolean indicating if the receiver should be re-commited"

	| currentProxy |

	currentProxy := self _currentVersion.

	^(self _refreshAndRollforwardFrom: currentProxy)
		ifTrue: [self _matchStateOf: currentProxy. true]
		ifFalse: [false]!

_refreshAndRollforwardFrom: currentProxyObject

	"Update the receiver such that it is based on the state of currentProxyObject
	with its own changes (compared to copyObject) applied on top.
	Return a Boolean indicating if the receiver should be re-commited"

	| currentObject |

	currentObject := currentProxyObject _proxiedObject.

	^self _isDeleted
	ifTrue:
		[currentObject isDBDeleted 
			ifTrue: [false]
			ifFalse: [true]]
	ifFalse:
		[currentObject isDBDeleted
		ifTrue:
			["Re-insert the receiver by marking it as new"
			copyObject := nil.
			currentProxyObject _matchStateOf: self]
		ifFalse:
			[| myUpdates |
			myUpdates := self _fieldUpdates.
			currentProxyObject _copyObject: copyObject.
			currentProxyObject _fieldUpdates applyTo: proxiedObject.
			myUpdates applyTo: proxiedObject].
		true]!

_refreshFromRow: aDatabaseRow table: aDBTable

	"Return whether the proxiedObject was refreshed at all.
	table is passed in as an optimisation"

	^(super _refreshFromRow: aDatabaseRow table: aDBTable)
	ifTrue: 
		["Update the copyObject"
		self _aquireCopyObject]
	ifFalse:
		[false]!

_resolveUpdateConflicts

	"Changes to the receiver have failed to commit in anSSWReStore due to another client's changes.
	Attempt to resolve the conflicts.

	For implementation details, see _resolveUpdateConflictsWith:"	

	| currentProxy |

	currentProxy := self _currentVersion.

	^(self _resolveUpdateConflictsWith: currentProxy)
		ifTrue: [self _matchStateOf: currentProxy. true]
		ifFalse: [false]!

_resolveUpdateConflictsWith: currentProxyObject

	"Changes to the receiver have failed to commit in anSSWReStore due to another client's changes.
	Analyse all changes made (between the receiver's copyObject, proxiedObject and currentProxyObject)
	and attempt to bring the receiver up to date with the state of currentProxyObject,
	whilst maintaining the receiver's changes from its copyObject.

	Return true if the receiver was able to resolve the conflict, false otherwise"

	| newVersion |

	newVersion := currentProxyObject _proxiedObject.
	newVersion isDBDeleted ifTrue: [^false].

	self _dbTable dataFields do:
		[ :field || accessor oldValue myValue newValue |
		accessor := field accessor.
		oldValue := accessor valueIn: copyObject.
		myValue := accessor valueIn: proxiedObject.
		newValue := accessor valueIn: newVersion.

		(myValue _hasChangedFrom: oldValue) 
		ifTrue: 
			["Receiver has changed this attribute.
			If newVersion has also changed it, then there is a clash.
			Ask the proxiedObject to resolve this"
			(newValue _hasChangedFrom: oldValue) ifTrue:
				[(proxiedObject 
					safeHandleUpdateClash: accessor name 
					from: copyObject
					to: newVersion) ifFalse: [^false]]]
		ifFalse:
			["Receiver has not changed this attribute (no clash). 
			Check for change in newVersion, and ask proxiedObject to handle it (usually by merging)"
			(newValue _hasChangedFrom: oldValue) ifTrue: 
				[(proxiedObject 
					safeMergeUpdateFrom: newVersion 
					newValue: newValue
					accessor: accessor) ifFalse:[^false]]]].

	^true!

_rollbackChanges

	self _isPersistent
	ifTrue:
		[self _isDeleted
			ifTrue: [self _rollbackUnstore]
			ifFalse: [self _rollbackUpdates]]
	ifFalse:
		[self _rollbackStore]!

_rollbackStore

	"Private - The receiver was a newly-persisted object - deregister from the reStore"

	reStore deregisterProxy: self.
	self _unswap!

_rollbackUnstore

	"self assert: copyObject isDBProxy"

	proxiedObject := copyObject _proxiedObject.
	copyObject := copyObject _copyObject.

	self _rollbackUpdates!

_rollbackUpdates

	"Private - Forget any updates by instantiating from the copyObject.
	Also transfer over any events registered against the current proxiedObject"

	| me him |

	me := proxiedObject.
	him := self.

	self _unswap.

	me _checkHasChanged ifTrue: 
		[me _proxiedObject: me _copyObject shallowCopy. 
		him getEvents ifNotNil: [ :events | me _proxiedObject setEvents: events]]!

_unstore

	"Intercept this message to cache a copy of the receiver to handle potential rollback"

	self _isDeleted ifTrue: [^self].
	self _isPersistent ifTrue: [copyObject := self _shallowCopy].	

	super _unstore!

_updateCollectionProxyUsing: aCollectionSpec

	| collectionProxy |

	collectionProxy := super _updateCollectionProxyUsing: aCollectionSpec.
	copyObject notNil ifTrue: [aCollectionSpec accessor value: collectionProxy in: copyObject].

	^collectionProxy!

_valuesForAccessor: anInstVarAccessor

	"Return the value(s) in the receiver's proxy object(s) which could be accessed by anInstVarAccessor.
	Also need to consider the copyObject"

	| proxyValue copyValue |

	proxyValue := proxiedObject ifNotNil: [anInstVarAccessor valueIn: proxiedObject].

	self _isDeleted
		ifTrue: [copyValue := copyObject _copyObject ifNotNil: [ :copy | anInstVarAccessor valueIn: copy]]
		ifFalse: [copyValue := copyObject ifNotNil: [anInstVarAccessor valueIn: copyObject]].

	^proxyValue == copyValue 
		ifTrue: [Array with: proxyValue]
		ifFalse: [Array with: proxyValue with: copyValue]!

inspect

	"Prevent inspecting of a deleted object"

	^self _isDeleted
		ifTrue: [nil inspect]
		ifFalse: [super inspect]! !
!SSWDBCachingObjectProxy categoriesForMethods!
_aquireCopyObject!actions-internal!public! !
_checkHasChanged!public!testing! !
_commitChanges!actions-internal!public! !
_commitStore!actions-internal!private! !
_commitUnstore!actions-internal!private! !
_commitUpdates!actions-internal!private! !
_copyObject!accessing!public! !
_copyObject:!accessing!public! !
_fieldUpdates!evaluating!public! !
_forgetProxiedObject!actions-internal!public! !
_isDeleted!public!testing! !
_isPersistent!public!testing! !
_matchStateOf:!actions-internal!public! !
_postCommitChanges!actions-internal!public! !
_postCommitStore!actions-internal!private! !
_postCommitUnstore!actions-internal!private! !
_postCommitUpdates!actions-internal!private! !
_prepareToCommit!actions-internal!public! !
_proxiedObject!accessing!public! !
_proxiedObject:!accessing!public! !
_recoverProxiedObject!actions-internal!public! !
_refreshAndRollforward!actions-internal!public! !
_refreshAndRollforwardFrom:!actions-internal!public! !
_refreshFromRow:table:!actions-internal!public! !
_resolveUpdateConflicts!actions-internal!public! !
_resolveUpdateConflictsWith:!actions-internal!public! !
_rollbackChanges!actions-internal!public! !
_rollbackStore!actions-internal!private! !
_rollbackUnstore!actions-internal!private! !
_rollbackUpdates!actions-internal!private! !
_unstore!actions-internal!public! !
_updateCollectionProxyUsing:!actions-internal!private! !
_valuesForAccessor:!accessing!private! !
inspect!forwarding!public! !
!


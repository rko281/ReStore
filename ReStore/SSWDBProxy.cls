"Filed out from Dolphin Smallalk"!

ProtoObject subclass: #SSWDBProxy
	instanceVariableNames: 'proxiedObject reStore flags'
	classVariableNames: 'IsDeletedMask IsPersistentMask IsSwappedMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBProxy guid: (GUID fromString: '{5a3e3dd8-3990-11d5-b1df-444553540000}')!
SSWDBProxy comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBProxy categoriesForClass!Unclassified! !
!SSWDBProxy methodsFor!

__ensureActive

	"Check if the receiver is in its reStore's current transaction. If not, add it to the transaction

	c.f. _ensureActiveIn:, which is a distinct method sent only by objects external to the proxy mechanism.
	__ensureActive is sent internally within the proxy mechanism, 
	hence the receipt of the message cannot be taken as a guarantee of non-activity"
	
	proxiedObject == nil ifTrue: [self _recoverProxiedObject].

	(reStore transaction includesProxy: self) ifFalse: [self _referenced]!

__referenced

	reStore proxy: self forwarded: ##(Message selector: #_referenced)!

_changedObjectsIn: aReStore

	^(self _checkHasChangedIn: aReStore)
		ifTrue: [Array with: self]
		ifFalse: [#()]!

_checkHasChanged

	"Return whether the receiver's proxiedObject has been changed 
	from its representation in the database.

	Compared to _hasChanged, the inferrence is that this is a 'quick test',
	not related to commiting those changes"
	
	^self subclassResponsibility!

_checkHasChangedIn: aReStore

	^self _isRecovered and: [self _hasChanged]!

_clearDeleted

	"Private - Clear deleted status"

	flags := flags maskClear: IsDeletedMask!

_commitChanges

	"Commit to the reStore changes to the receiver's proxiedObject.
	Return a Boolean indicating success"
	
	self subclassResponsibility!

_commitChangesPhase1

	"Commit to the reStore changes to the receiver's proxiedObject - phase 1 of 2.
	Return a Boolean indicating success"

	"Default behaviour for subclasses only requiring a single phase"
	^self _commitChanges!

_commitChangesPhase2

	"Commit to the reStore changes to the receiver's proxiedObject - phase 2 of 2.
	Return a Boolean indicating success"

	"Subclasses only requiring a single phase should override _commitChanges"
	^true!

_commitIn: anSSWReStore

	"Add the receiver to the referenced set (if it is recovered) for subsequent commit"

	self validateReStore: anSSWReStore.

	self _isRecovered ifTrue: [self _referenced]!

_dbProxyIn: aReStore
	
	^self _dbProxyIn: aReStore ifNone: [self error: 'proxy does not belong to aReStore']!

_dbProxyIn: aReStore ifNone: aBlock
	
	^aReStore == reStore
		ifTrue: [self]
		ifFalse: [aBlock value]!

_dbProxyReStore
	"Private - As #_reStore, but do not perform a reverse lookup if sent to a regular object.
	Used internally by #doesNotUnderstand: to safely retrieve the ReStore in order to enter a critical section.

	See implementation in Object for more details"

	^reStore!

_debugPrintString

	"Do not fault the receiver just for a debugger"

	^proxiedObject == nil
		ifTrue: [self _unrecoveredProxyString]
		ifFalse: ['<', proxiedObject debugPrintString, '>']!

_ensureActiveIn: anSSWReStore

	"Ensure that the receiver is 'active' in the given ReStore 
	'active' means persistent in anSSWReStore, and present in the current transaction.

	Since the message has been received by a proxy then we can sumise it is persistent, 
	but not active in the current transaction - reference it to arrange this"

	self validateReStore: anSSWReStore.

	proxiedObject == nil ifTrue: [self _recoverProxiedObject].

	self _referenced!

_ensurePersistentIn: anSSWReStore

	"Check if the receiver is persistent in the given SSWReStore"
	
	"Proxies are persistent by default - only need check anSSWReStore"
	self validateReStore: anSSWReStore!

_flags

	^flags!

_flags: aSmallInteger

	flags := aSmallInteger!

_forceRefresh

	"Simple - just forget then re-recover the proxied object"

	self 
		_lazyRefresh; 
		_recoverProxiedObject!

_forceRefreshIn: aReStore

	self validateReStore: aReStore.

	self _forceRefresh!

_forceRefreshWithContents

	"Refresh the receiver and its contents (if any). Return any refreshed contents (if any)"

	self _forceRefresh.

	^#()!

_forgetProxiedObject

	"Dispose of the reference to the receiver's proxiedObject"
	
	proxiedObject := nil!

_forwardDirectly: aMessage

	"Private - Forward aMessage to the proxiedObject; do not swap the receiver with the proxied object.
	Should only be invoked inside a transactionCritical: lock.
	Privileged use only"
	
	proxiedObject isNil ifTrue: [self _recoverProxiedObject].
	^aMessage value: proxiedObject!

_hasChanged

	"Return whether the receiver's proxiedObject has been changed
	from its representation in the database

	Compared to _checkHasChanged, the inferrence is that if the receiver has 
	actually changed, then the receiver will next be sent _prepareToCommit. 
	Subclasses may take advantage by caching some of the work done here"

	^self _checkHasChanged!

_hasChangedFrom: anObject

	^(self == anObject) not!

_isDeleted

	"Return a Boolean indicating whether the receiver is marked as deleted"
	
	^flags anyMask: IsDeletedMask!

_isPersistent

	"Return a Boolean indicating whether the receiver is persistent
	(has been written to the database yet)"
	
	^flags anyMask: IsPersistentMask!

_isRecovered

	^proxiedObject ~~ nil!

_isSwapped

	"Return a Boolean indicating whether the receiver has been swapped such that all references point to the proxiedObject.
	For speed this is usually inlined"

	^flags anyMask: IsSwappedMask!

_lazyRefresh

	"Simple - just forget the proxied object"

	self _forgetProxiedObject!

_lazyRefreshIn: aReStore

	self validateReStore: aReStore.

	self _lazyRefresh!

_newProxiedObject: anObject

	"Set proxiedObject, but the implication is anObject is new, i.e. not yet persistent.
	Defer to _setProxiedlObject: by default; subclasses may override as necessary"
	
	self _setProxiedObject: anObject!

_postCommitChanges

	"The receiver's changes have been successfully committed.
	Carry out any necessary internal updates"

	^self!

_postSwapReferences

	"Carry out any tidying up actions required after a _swapReferences"

	^self!

_prepareToCommit

	"Prepare to commit changes to the receiver's proxiedObject"
	
	self subclassResponsibility!

_prepareToCommitPhase1

	"Prepare to commit changes to the receiver's proxiedObject - pass 1 of 2.
	Answer true or false depending on whether the receiver needs phase 2 to complete its preparations"

	"Default action for subclasses only needing one pass"
	self _prepareToCommit.
	^false!

_prepareToCommitPhase2

	"Prepare to commit changes to the receiver's proxiedObject - pass 2 of 2."

	"Subclasses only requiring a single phase should override _prepareToCommit"
	^self!

_proxiedObject

	"proxiedObject stores the actual object which the receiver is a proxy for"
	
	^proxiedObject!

_proxiedObject: anObject

	"proxiedObject stores the actual object which the receiver is a proxy for"
	
	proxiedObject := anObject!

_proxiedObjectClass

	"Answer the class of the proxiedObject (or best guess) without needing to have the proxiedObject itself"

	^self subclassResponsibility!

_recoverProxiedObject

	"Recover the receiver's proxiedObject from the database"
	
	self subclassResponsibility!

_referenced

	"This message is sent by clients of the receiver which access the proxiedObject directly,
	but wish such accesses to be notified to interested parties in the same way as a DNU send.

	Carry out the same notifications as occur during the receiver's implementation of DNU"

	| me |

	"Unless the receiver is new, swap references to the receiver and proxiedObject.
	From hereon, must use me instead of self, and not reference inst vars directly"
	self _isPersistent
		ifTrue: [me := self _swap]
		ifFalse: [me := self].

	me __referenced.
	
	^me!

_refresh

	"Refresh the receiver with its current database version according to its own preferred strategy.
	Default behaviour is to refresh if updated; future releases may make this choice tuneable or heuristic-driven based on class/instance etc."

	self _refreshIfUpdated!

_refreshIfUpdated

	"Refresh the receiver if it has been updated in the database.

	Simplest implementation - just refresh regardless. More intelligent subclasses may do something better"

	self _forceRefresh!

_refreshIfUpdatedIn: aReStore

	self validateReStore: aReStore.

	self _refreshIfUpdated!

_refreshIn: aReStore

	self validateReStore: aReStore.

	self _refresh!

_refreshWithContents

	"Refresh the receiver and its contents (if any). Return any refreshed contents (if any)"

	"Default behaviour is to only refresh if updated. Future releases may make this choice tuneable or heuristic-driven based on class/instance"
	^self _refreshWithContentsIfUpdated!

_refreshWithContentsIfUpdated

	"Refresh the receiver and its contents (if any) if they are updated. Return the refreshed contents (if any)"

	self _refreshIfUpdated.
	^#()!

_reStore

	"reStore stores the SSWReStore which owns the object for which the receiver is a proxy"
	
	^reStore!

_reStore: anSSWReStore

	"reStore stores the SSWReStore which owns the object for which the receiver is a proxy"
	
	reStore := anSSWReStore!

_reStoreIfNone: aBlock

	^reStore!

_rollbackChanges

	"Forget changes to the receiver.
	By default, this is done by forgetting about the proxiedObject (forcing a re-read)"
	
	self _forgetProxiedObject!

_rollbackIn: aReStore

	"Add the receiver to the referenced set (if it is recovered) for subsequent rollback"

	self validateReStore: aReStore.

	self _isRecovered ifTrue: [self _referenced]!

_setDeleted

	"Private - Set the receiver's state to mark it as deleted from the database (assuming the commit completes)"

	flags := flags maskSet: IsDeletedMask!

_setNewNonPersistent

	"Initialize the receiver as a new non-persistent object"

	flags := (flags maskClear: IsPersistentMask) maskSet: IsSwappedMask!

_setNonPersistent

	flags := flags maskClear: IsPersistentMask!

_setPersistent

	flags := flags maskSet: IsPersistentMask!

_setProxiedObject: anObject

	"Set proxiedObject ONLY - no other actions.
	Subclasses should NEVER override"
	
	proxiedObject := anObject!

_setSwapped

	"Set the receiver to mark that all references are now pointing to the proxied object.
	For speed this is inlined in _swap"

	flags := flags maskSet: IsSwappedMask!

_setUnswapped

	"Set the receiver to mark that all references are pointing to the receiver rather than the proxied object.
	For speed this is inlined in _unswap"

	flags := flags maskClear: IsSwappedMask!

_swap

	| newFlags |

	newFlags := flags bitOr: IsSwappedMask.
	newFlags == flags ifTrue: [self error: 'attempt to swap already-swapped proxy'].
	flags := newFlags.

	^self _swapReferences!

_swapReferences

	"Private - this method should only be sent from _swap or _unswap.
	Swap references to the receiver with references to the proxiedObject, returning the receiver.
	Subclasses should not override this method, but instead use _postSwapReferences"

	| me him |

	"Cannot swap references if no proxy"
	proxiedObject == nil ifTrue: [^self].

	"Set up 'me' and 'him' so that they will be correct after the swap"
	me := proxiedObject.
	him := self.

	proxiedObject become: self.

	me _setProxiedObject: him.
	me _postSwapReferences.

	^me!

_unrecoveredProxyString

	^'%<an unrecovered <1p>%>' expandMacrosWith: self _proxiedObjectClass!

_unstore

	"Mark the receiver in such a way that it will be deleted from the database on commit"

	self subclassResponsibility!

_unswap

	| newFlags |

	newFlags := flags bitAnd: -2 "IsSwappedMask bitInvert".
	newFlags == flags ifTrue: [self error: 'attempt to unswap proxy which has not been swapped'].
	flags := newFlags.

	^self _swapReferences!

commit

	"Commit the receiver and its related objects.
	Return success"

	^reStore commit: self withRelatedComponents!

debugPrintString

	^self _dbProxyReStore 
	ifNil: 
		[self debugPrintString]
	ifNotNil: 
		[ :proxyReStore |
		proxyReStore transactionCritical: 
			[self isDBProxy 
				ifTrue: [self _debugPrintString]
				ifFalse: [self debugPrintString]]]!

doesNotUnderstand: aMessage

	"Patched for issue 120-011"

	"Forward aMessage to the proxiedObject, subject to the transactionMutex"
	
	self _dbProxyReStore ifNotNil: 
		[ :proxyReStore |
		proxyReStore transactionCritical: 
			["Make sure that some other process has not swapped my references while I was waiting for the mutex."
			self isDBProxy ifTrue: 
				[proxiedObject isNil ifTrue: [self _recoverProxiedObject].
				"Swap references to the receiver and proxiedObject. From hereon, must not reference inst vars directly."
				proxyReStore proxy: self _swap forwarded: aMessage]]].

	^aMessage value: self!

halt

	"Go via the reStore so we use debug mode"

	reStore isNil ifTrue: [super halt] ifFalse: [reStore halt]!

includedIn: aCollection

	"Reciprocal of Collection>>includes: 
	aCollection may use identity test for inclusion, so don't bother the proxiedObject at this stage"

	^aCollection includes: self!

instVarAt: anInteger

	"Avoid the ProtoObject implementation"	

	^self _dbProxyReStore 
	ifNil: 
		[self instVarAt: anInteger]
	ifNotNil: 
		[ :proxyReStore |
		proxyReStore transactionCritical: 
			[self isDBProxy 
			ifTrue: 
				[reStore isDebugging
					ifTrue: [super instVarAt: anInteger]
					ifFalse: [self _forwardDirectly: (Message selector: #instVarAt: argument: anInteger)]]
			ifFalse: 
				[self instVarAt: anInteger]]]!

isDBProxy

	^true!

isInteger

	"No need to bother the proxiedObject"
	
	^false
!

notNil

	"No need to bother the proxiedObject"

	^true!

onRollback

	"Sent immediately after rollback. Normally sent direct to the rolled-back object, not via the proxy. 
	If a proxy receives this message it has been flipped by a previous onRollback, so forward without notification"

	^proxiedObject onRollback!

printOn: aStream

	^aStream nextPutAll: self debugPrintString!

printString

	^self debugPrintString!

refresh

	"Refresh the receiver and its related objects to their stored state"

	reStore refresh: self withRelatedComponents!

rollback

	"Rollback the receiver and its related objects to their previous state"

	reStore rollback: self withRelatedComponents!

softRollback

	"Carry out a 'soft rollback' on the receiver. This does not rollback any changes but makes the receiver effectively an 'untouched' persistent object and thus eligible for automatic/transparent refresh if its database row is encountered.
	Since we are a proxy we are by definition not touched, so nothing to do here"

	!

store

	"Store the receiver and its related objects.
	Return success"

	^reStore commit: self withRelatedComponents!

storeIn: aReStore

	"Store the receiver and its related objects.
	Return success"

	self validateReStore: aReStore.

	^self store!

subclassResponsibility

	"Revector to a well-known object"
	
	^nil subclassResponsibility!

validateReStore: aReStore

	(reStore notNil and: [reStore ~~ reStore]) ifTrue: [self error: 'Attempt to move object between ReStores - Invalid']!

withComponents

	"Avoid faulting in the proxied object"

	^SSWDBObjectWithComponents on: self!

withRelatedComponents

	"Avoid faulting in the proxied object"

	^SSWDBObjectWithRelatedComponents on: self!

yourself

	"No need to bother the proxiedObject"
	
	^self! !
!SSWDBProxy categoriesForMethods!
__ensureActive!actions-internal!public! !
__referenced!actions-internal!private! !
_changedObjectsIn:!accessing!public! !
_checkHasChanged!public!testing! !
_checkHasChangedIn:!public!testing! !
_clearDeleted!actions-internal!flags!private! !
_commitChanges!actions-internal!public! !
_commitChangesPhase1!actions-internal!public! !
_commitChangesPhase2!actions-internal!public! !
_commitIn:!actions-internal!public! !
_dbProxyIn:!accessing:direct!public! !
_dbProxyIn:ifNone:!accessing:direct!public! !
_dbProxyReStore!accessing!private! !
_debugPrintString!non forwarding!private! !
_ensureActiveIn:!actions-internal!public! !
_ensurePersistentIn:!actions-internal!public! !
_flags!accessing!public! !
_flags:!accessing!public! !
_forceRefresh!actions-refresh!public! !
_forceRefreshIn:!actions-refresh!public! !
_forceRefreshWithContents!actions-refresh!public! !
_forgetProxiedObject!actions-internal!public! !
_forwardDirectly:!forwarding!private! !
_hasChanged!public!testing! !
_hasChangedFrom:!public!testing! !
_isDeleted!public!testing! !
_isPersistent!public!testing! !
_isRecovered!public!testing! !
_isSwapped!public!testing! !
_lazyRefresh!actions-refresh!public! !
_lazyRefreshIn:!actions-refresh!public! !
_newProxiedObject:!accessing!public! !
_postCommitChanges!actions-internal!public! !
_postSwapReferences!actions-internal!public! !
_prepareToCommit!actions-internal!public! !
_prepareToCommitPhase1!actions-internal!public! !
_prepareToCommitPhase2!actions-internal!public! !
_proxiedObject!accessing!public! !
_proxiedObject:!accessing!public! !
_proxiedObjectClass!accessing!public! !
_recoverProxiedObject!actions-internal!public! !
_referenced!actions-internal!public! !
_refresh!actions-refresh!public! !
_refreshIfUpdated!actions-refresh!public! !
_refreshIfUpdatedIn:!actions-refresh!public! !
_refreshIn:!actions-refresh!public! !
_refreshWithContents!actions-refresh!public! !
_refreshWithContentsIfUpdated!actions-refresh!public! !
_reStore!accessing!public! !
_reStore:!accessing!public! !
_reStoreIfNone:!accessing:direct!public! !
_rollbackChanges!actions-internal!public! !
_rollbackIn:!actions-internal!public! !
_setDeleted!actions-internal!flags!private! !
_setNewNonPersistent!actions-internal!flags!private! !
_setNonPersistent!actions-internal!flags!private! !
_setPersistent!actions-internal!flags!private! !
_setProxiedObject:!accessing!public! !
_setSwapped!actions-internal!flags!private! !
_setUnswapped!actions-internal!flags!private! !
_swap!actions-internal!public! !
_swapReferences!actions-internal!private! !
_unrecoveredProxyString!accessing!public! !
_unstore!actions-internal!public! !
_unswap!actions-internal!public! !
commit!actions-api!public! !
debugPrintString!non forwarding!public! !
doesNotUnderstand:!forwarding!public! !
halt!non forwarding!public! !
includedIn:!public!testing! !
instVarAt:!forwarding!public! !
isDBProxy!public!testing! !
isInteger!non forwarding!public! !
notNil!non forwarding!public! !
onRollback!actions-internal!public! !
printOn:!non forwarding!public! !
printString!non forwarding!public! !
refresh!actions-api!public! !
rollback!actions-api!public! !
softRollback!actions-api!public! !
store!actions-api!public! !
storeIn:!actions-api!public! !
subclassResponsibility!non forwarding!public! !
validateReStore:!actions-internal!private! !
withComponents!accessing!public! !
withRelatedComponents!accessing!public! !
yourself!non forwarding!public! !
!

!SSWDBProxy class methodsFor!

initialize

	super initialize.

	IsSwappedMask := 1.
	IsPersistentMask := 2.
	IsDeletedMask := 4!

new

	"Create and answer a new instance of the receiver.
	By default we assume the instance will be used for a persistent object; other users should send _setNewNonPersistent after creation"

	^super new
		_flags: IsPersistentMask;
		yourself! !
!SSWDBProxy class categoriesForMethods!
initialize!class initialization!public! !
new!instance creation!public! !
!


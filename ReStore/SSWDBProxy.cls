"Filed out from Dolphin Smalltalk 7"!

ProtoObject subclass: #SSWDBProxy
	instanceVariableNames: 'proxiedObject reStore'
	classVariableNames: ''
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

_doesNotUnderstand: aMessage

	"Forward to the proxiedObject"
	
	| me |

	proxiedObject == nil ifTrue: [self _recoverProxiedObject].

	"Swap references to the receiver and proxiedObject.
	From hereon, must use me instead of self, and not reference inst vars directly"
	me := self _swapReferences.

	^[me _proxiedObject perform: aMessage selector withArguments: aMessage arguments]
		ensure: [me _reStore proxy: me forwarded: aMessage]!

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
	
	^self subclassResponsibility!

_isPersistent

	"Return a Boolean indicating whether the receiver is persistent
	(has been written to the database yet)"
	
	^self subclassResponsibility!

_isRecovered

	^proxiedObject ~~ nil!

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

_orProxiedObject

	^proxiedObject!

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
		ifTrue: [me := self _swapReferences]
		ifFalse: [me := self].

	me _reStore proxy: me forwarded: ##(Message selector: #_referenced).
	
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

_rollbackChanges

	"Forget changes to the receiver.
	By default, this is done by forgetting about the proxiedObject (forcing a re-read)"
	
	self _forgetProxiedObject!

_rollbackIn: aReStore

	"Add the receiver to the referenced set (if it is recovered) for subsequent rollback"

	self validateReStore: aReStore.

	self _isRecovered ifTrue: [self _referenced]!

_setProxiedObject: anObject

	"Set proxiedObject ONLY - no other actions.
	Subclasses should NEVER override"
	
	proxiedObject := anObject!

_swapReferences

	"Swap references to the receiver with references to the proxiedObject, returning the receiver.
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

	^'<Unrecovered Proxy>'!

_unstore

	"Mark the receiver in such a way that it will be deleted from the database on commit"

	self subclassResponsibility!

commit

	"Commit the receiver and its related objects.
	Return success"

	^reStore commit: self withRelatedComponents!

debugPrintString

	"Do not fault the receiver just for a debugger"

	^proxiedObject == nil
		ifTrue: [self _unrecoveredProxyString]
		ifFalse: ['<', proxiedObject debugPrintString, '>']!

doesNotUnderstand: aMessage

	"Patched for issue 120-011"

	"Forward aMessage to the proxiedObject, subject to the transactionMutex"
	
	[(self _proxyInstVarAt: 2) transactionCritical: 
		["Make sure that some other process has not swapped my references while I was waiting for the mutex."
		| me |
		self isDBProxy ifTrue: 
			[proxiedObject == nil ifTrue: [self _recoverProxiedObject].
			"Swap references to the receiver and proxiedObject. 
			From hereon, must use me instead of self to refer to the proxy, and not reference inst vars directly."
			me := self _swapReferences.
			me _reStore proxy: me forwarded: aMessage]]] 
		on: MessageNotUnderstood
		do: [:ex | ex selector = #_proxyInstVarAt: ifTrue: [ex return] ifFalse: [ex pass]].

	^aMessage value: self!

includedIn: aCollection

	"Reciprocal of Collection>>includes: 
	aCollection may use identity test for inclusion, so don't bother the proxiedObject at this stage"

	^aCollection includes: self!

instVarAt: anInteger

	"This is a standard message which does not modify the proxiedObject.
	Hence forward without notification"	
	
	proxiedObject == nil ifTrue: [self _recoverProxiedObject].

	^proxiedObject instVarAt: anInteger
!

isDBProxy

	^true!

onRollback

	"Sent immediately after rollback. Normally sent direct to the rolled-back object, not via the proxy. 
	If a proxy receives this message it has been flipped by a previous onRollback, so forward without notification"

	^proxiedObject onRollback!

printOn: aStream

	"For efficiency, recognise this as a non-modifying method.
	ASSERT: the proxiedObject is not modified when sent this message"

	proxiedObject == nil ifTrue: [self _recoverProxiedObject].

	^proxiedObject printOn: aStream!

printString

	"For efficiency, recognise this as a non-modifying method.
	ASSERT: the proxiedObject is not modified when sent this message"

	proxiedObject == nil ifTrue: [self _recoverProxiedObject].

	^proxiedObject printString!

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
!SSWDBProxy categoriesFor: #__ensureActive!actions-internal!public! !
!SSWDBProxy categoriesFor: #_changedObjectsIn:!accessing!public! !
!SSWDBProxy categoriesFor: #_checkHasChanged!public!testing! !
!SSWDBProxy categoriesFor: #_checkHasChangedIn:!public!testing! !
!SSWDBProxy categoriesFor: #_commitChanges!actions-internal!public! !
!SSWDBProxy categoriesFor: #_commitChangesPhase1!actions-internal!public! !
!SSWDBProxy categoriesFor: #_commitChangesPhase2!actions-internal!public! !
!SSWDBProxy categoriesFor: #_commitIn:!actions-internal!public! !
!SSWDBProxy categoriesFor: #_dbProxyIn:!accessing:direct!public! !
!SSWDBProxy categoriesFor: #_dbProxyIn:ifNone:!accessing:direct!public! !
!SSWDBProxy categoriesFor: #_doesNotUnderstand:!forwarding!public! !
!SSWDBProxy categoriesFor: #_ensureActiveIn:!actions-internal!public! !
!SSWDBProxy categoriesFor: #_ensurePersistentIn:!actions-internal!public! !
!SSWDBProxy categoriesFor: #_forceRefresh!actions-refresh!public! !
!SSWDBProxy categoriesFor: #_forceRefreshIn:!actions-refresh!public! !
!SSWDBProxy categoriesFor: #_forceRefreshWithContents!actions-refresh!public! !
!SSWDBProxy categoriesFor: #_forgetProxiedObject!actions-internal!public! !
!SSWDBProxy categoriesFor: #_hasChanged!public!testing! !
!SSWDBProxy categoriesFor: #_hasChangedFrom:!public!testing! !
!SSWDBProxy categoriesFor: #_isDeleted!public!testing! !
!SSWDBProxy categoriesFor: #_isPersistent!public!testing! !
!SSWDBProxy categoriesFor: #_isRecovered!public!testing! !
!SSWDBProxy categoriesFor: #_lazyRefresh!actions-refresh!public! !
!SSWDBProxy categoriesFor: #_lazyRefreshIn:!actions-refresh!public! !
!SSWDBProxy categoriesFor: #_newProxiedObject:!accessing!public! !
!SSWDBProxy categoriesFor: #_orProxiedObject!accessing!public! !
!SSWDBProxy categoriesFor: #_postCommitChanges!actions-internal!public! !
!SSWDBProxy categoriesFor: #_postSwapReferences!actions-internal!public! !
!SSWDBProxy categoriesFor: #_prepareToCommit!actions-internal!public! !
!SSWDBProxy categoriesFor: #_prepareToCommitPhase1!actions-internal!public! !
!SSWDBProxy categoriesFor: #_prepareToCommitPhase2!actions-internal!public! !
!SSWDBProxy categoriesFor: #_proxiedObject!accessing!public! !
!SSWDBProxy categoriesFor: #_proxiedObject:!accessing!public! !
!SSWDBProxy categoriesFor: #_recoverProxiedObject!actions-internal!public! !
!SSWDBProxy categoriesFor: #_referenced!actions-internal!public! !
!SSWDBProxy categoriesFor: #_refresh!actions-refresh!public! !
!SSWDBProxy categoriesFor: #_refreshIfUpdated!actions-refresh!public! !
!SSWDBProxy categoriesFor: #_refreshIfUpdatedIn:!actions-refresh!public! !
!SSWDBProxy categoriesFor: #_refreshIn:!actions-refresh!public! !
!SSWDBProxy categoriesFor: #_refreshWithContents!actions-refresh!public! !
!SSWDBProxy categoriesFor: #_refreshWithContentsIfUpdated!actions-refresh!public! !
!SSWDBProxy categoriesFor: #_reStore!accessing!public! !
!SSWDBProxy categoriesFor: #_reStore:!accessing!public! !
!SSWDBProxy categoriesFor: #_rollbackChanges!actions-internal!public! !
!SSWDBProxy categoriesFor: #_rollbackIn:!actions-internal!public! !
!SSWDBProxy categoriesFor: #_setProxiedObject:!accessing!public! !
!SSWDBProxy categoriesFor: #_swapReferences!actions-internal!public! !
!SSWDBProxy categoriesFor: #_unrecoveredProxyString!accessing!public! !
!SSWDBProxy categoriesFor: #_unstore!actions-internal!public! !
!SSWDBProxy categoriesFor: #commit!actions-api!public! !
!SSWDBProxy categoriesFor: #debugPrintString!non forwarding!public! !
!SSWDBProxy categoriesFor: #doesNotUnderstand:!forwarding!public! !
!SSWDBProxy categoriesFor: #includedIn:!public!testing! !
!SSWDBProxy categoriesFor: #instVarAt:!forwarding!public! !
!SSWDBProxy categoriesFor: #isDBProxy!public!testing! !
!SSWDBProxy categoriesFor: #onRollback!actions-internal!public! !
!SSWDBProxy categoriesFor: #printOn:!forwarding!public! !
!SSWDBProxy categoriesFor: #printString!forwarding!public! !
!SSWDBProxy categoriesFor: #refresh!actions-api!public! !
!SSWDBProxy categoriesFor: #rollback!actions-api!public! !
!SSWDBProxy categoriesFor: #softRollback!actions-api!public! !
!SSWDBProxy categoriesFor: #store!actions-api!public! !
!SSWDBProxy categoriesFor: #storeIn:!actions-api!public! !
!SSWDBProxy categoriesFor: #subclassResponsibility!non forwarding!public! !
!SSWDBProxy categoriesFor: #validateReStore:!actions-internal!private! !
!SSWDBProxy categoriesFor: #withComponents!accessing!public! !
!SSWDBProxy categoriesFor: #withRelatedComponents!accessing!public! !
!SSWDBProxy categoriesFor: #yourself!non forwarding!public! !


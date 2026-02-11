"Filed out from Dolphin Smalltalk"!

SSWDBProxy subclass: #SSWDBCollectionProxy
	instanceVariableNames: 'collectionSpec owner'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWDBCollectionProxy guid: (GUID fromString: '{5a3e3dd9-3990-11d5-b1df-444553540000}')!

SSWDBCollectionProxy comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!

!SSWDBCollectionProxy categoriesForClass!Unclassified! !

!SSWDBCollectionProxy methodsFor!

_collectionSpec

	"collectionSpec stores the SSWDBCollectionSpec which, given the receiver's ownerID,
	can query for the members of the collection proxy'd by the receiver"
	
	^collectionSpec!

_collectionSpec: anSSWDBCollectionSpec

	"dbCollectionSpec stores the SSWDBCollectionSpec which, given the receiver's ownerID,
	can query for the members of the collection proxy'd by the receiver"
	
	collectionSpec := anSSWDBCollectionSpec!

_forceRefresh

	self _isRecovered ifTrue: [collectionSpec refreshCollectionForProxy: self]!

_forceRefreshWithContents

	"Return the refreshed elements"

	^self _isRecovered 
		ifTrue: [collectionSpec refreshCollectionWithContentsForProxy: self]
		ifFalse: [#()]!

_owner

	"owner stores the proxy of the object to which the collection proxy'd by the receiver belongs.
	Holding this ensures that the owner is not GC'd before the collection.

	NB owner ALWAYS holds the actual proxy, not the owning object itself"
	
	^owner!

_owner: anObject

	"owner stores the object to which the collection proxy'd by the receiver belongs.
	Holding this ensures that the owner is not GC'd before the collection.

	NB owner ALWAYS holds the actual proxy, not the owning object itself"
	
	owner := anObject!

_ownerID

	"Return the unique ID (Integer) of the object to which the collection proxy'd by the receiver belongs"
	
	^owner _id!

_postSwapReferences

	"Inform the owner"

	owner _collectionProxySwapped: self!

_prepareToCommit

	"Default: no action for collections"

	^self!

_printTypeAndIDStringOn: s
	self _owner _printTypeAndIDStringOn: s.
	s
		nextPut: $.;
		nextPutAll: self _collectionSpec accessor name.!

_proxiedObjectClass
	
	^collectionSpec collectionClass!

_recoverProxiedObject

	collectionSpec recoverCollectionForProxy: self!

_refreshIfUpdated

	self _isRecovered ifTrue: [collectionSpec refreshCollectionIfUpdatedForProxy: self]!

_refreshWithContentsIfUpdated

	"Return the refreshed elements"

	^self _isRecovered 
		ifTrue: [collectionSpec refreshCollectionWithContentsIfUpdatedForProxy: self]
		ifFalse: [#()]!

_rollbackChanges

	"Forget any changes by reinstantiating the unchanged collection.
	Also transfer over any events registered against the current proxiedObject"

	| unchangedCollection me changedCollection |

	self _clearDeleted.

	unchangedCollection := self _unchangedCollection.
	unchangedCollection == proxiedObject ifTrue: [^self _unswap].

	me := proxiedObject.
	changedCollection := self.
	self _unswap.

	me _setProxiedObject: unchangedCollection.
	changedCollection getEvents ifNotNil: [ :events | me _proxiedObject setEvents: events]!

_unchangedCollection

	"Answer the receiver's collection prior to any changes. This is used to roll the receiver back to its previous state"

	^self subclassResponsibility!

_unstore

	self _isDeleted ifTrue: [^self].

	self _isPersistent 
		ifTrue: [self _setDeleted]
		ifFalse: [reStore removeFromTransaction: self]!

orRemote

	"Use the proxied collection, if in memory, otherwise the remote collection"

	^proxiedObject == nil
		ifTrue: [self remote]
		ifFalse: [self]


	!

remote

	^collectionSpec dbInstancesFor: self!

size

	"Optimisation for collections - go direct.
	ASSERT: the proxiedObject's implementation of size is fast and non-modifying"

	^self _dbProxyReStore 
	ifNil: 
		[self size]
	ifNotNil: 
		[ :proxyReStore |
		proxyReStore transactionCritical: 
			[self isDBProxy 
				ifTrue: [self _recoveredProxiedObject size]
				ifFalse: [self size]]]!

withComponents

	"Avoid faulting in the proxied object"

	^SSWDBCollectionWithContents on: self!

withRelatedComponents

	"Avoid faulting in the proxied object"

	^SSWDBCollectionWithRelatedContents on: self! !

!SSWDBCollectionProxy categoriesForMethods!
_collectionSpec!accessing!public! !
_collectionSpec:!accessing!public! !
_forceRefresh!actions-refresh!public! !
_forceRefreshWithContents!actions-refresh!public! !
_owner!accessing!public! !
_owner:!accessing!public! !
_ownerID!accessing!public! !
_postSwapReferences!actions-internal!public! !
_prepareToCommit!actions-internal!public! !
_printTypeAndIDStringOn:!actions-internal!actions-printing!public! !
_proxiedObjectClass!accessing!public! !
_recoverProxiedObject!actions-internal!public! !
_refreshIfUpdated!actions-refresh!public! !
_refreshWithContentsIfUpdated!actions-refresh!public! !
_rollbackChanges!actions-internal!public! !
_unchangedCollection!accessing!private! !
_unstore!actions-internal!public! !
orRemote!forwarding!public! !
remote!accessing!public! !
size!public! !
withComponents!accessing!public! !
withRelatedComponents!accessing!public! !
!


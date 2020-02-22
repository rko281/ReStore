"Filed out from Dolphin Smalltalk 7"!

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

_checkHasChanged

	"Default - collection proxies do not keep track of their changes"

	^false!

_collectionSpec

	"collectionSpec stores the SSWDBCollectionSpec which, given the receiver's ownerID,
	can query for the members of the collection proxy'd by the receiver"
	
	^collectionSpec!

_collectionSpec: anSSWDBCollectionSpec

	"dbCollectionSpec stores the SSWDBCollectionSpec which, given the receiver's ownerID,
	can query for the members of the collection proxy'd by the receiver"
	
	collectionSpec := anSSWDBCollectionSpec!

_commitChanges

	"Default: no action for collections"
	
	^true!

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

_recoverProxiedObject

	collectionSpec recoverCollectionForProxy: self!

_refreshIfUpdated

	self _isRecovered ifTrue: [collectionSpec refreshCollectionIfUpdatedForProxy: self]!

_refreshWithContentsIfUpdated

	"Return the refreshed elements"

	^self _isRecovered 
		ifTrue: [collectionSpec refreshCollectionWithContentsIfUpdatedForProxy: self]
		ifFalse: [#()]!

_unrecoveredProxyString

	^'<an unrecovered ', collectionSpec templateCollection class name, '>'!

class

	^proxiedObject == nil
		ifTrue: [collectionSpec collectionClass]
		ifFalse: [proxiedObject class]!

orRemote

	"Use the proxied collection, if in memory, otherwise the remote collection"

	^proxiedObject == nil
		ifTrue: [self remote]
		ifFalse: [self]


	!

remote

	^collectionSpec dbInstancesFor: self!

withComponents

	"Avoid faulting in the proxied object"

	^SSWDBCollectionWithContents on: self!

withRelatedComponents

	"Avoid faulting in the proxied object"

	^SSWDBCollectionWithRelatedContents on: self! !
!SSWDBCollectionProxy categoriesFor: #_checkHasChanged!public!testing! !
!SSWDBCollectionProxy categoriesFor: #_collectionSpec!accessing!public! !
!SSWDBCollectionProxy categoriesFor: #_collectionSpec:!accessing!public! !
!SSWDBCollectionProxy categoriesFor: #_commitChanges!actions-internal!public! !
!SSWDBCollectionProxy categoriesFor: #_forceRefresh!actions-refresh!public! !
!SSWDBCollectionProxy categoriesFor: #_forceRefreshWithContents!actions-refresh!public! !
!SSWDBCollectionProxy categoriesFor: #_owner!accessing!public! !
!SSWDBCollectionProxy categoriesFor: #_owner:!accessing!public! !
!SSWDBCollectionProxy categoriesFor: #_ownerID!accessing!public! !
!SSWDBCollectionProxy categoriesFor: #_postSwapReferences!actions-internal!public! !
!SSWDBCollectionProxy categoriesFor: #_prepareToCommit!actions-internal!public! !
!SSWDBCollectionProxy categoriesFor: #_recoverProxiedObject!actions-internal!public! !
!SSWDBCollectionProxy categoriesFor: #_refreshIfUpdated!actions-refresh!public! !
!SSWDBCollectionProxy categoriesFor: #_refreshWithContentsIfUpdated!actions-refresh!public! !
!SSWDBCollectionProxy categoriesFor: #_unrecoveredProxyString!accessing!public! !
!SSWDBCollectionProxy categoriesFor: #class!forwarding!public! !
!SSWDBCollectionProxy categoriesFor: #orRemote!forwarding!public! !
!SSWDBCollectionProxy categoriesFor: #remote!accessing!public! !
!SSWDBCollectionProxy categoriesFor: #withComponents!accessing!public! !
!SSWDBCollectionProxy categoriesFor: #withRelatedComponents!accessing!public! !


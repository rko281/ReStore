"Filed out from Dolphin Smalltalk 7"!

SSWDBProxy subclass: #SSWDBObjectProxy
	instanceVariableNames: 'class id collectionProxies'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBObjectProxy guid: (GUID fromString: '{5a3e3ddb-3990-11d5-b1df-444553540000}')!
SSWDBObjectProxy comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBObjectProxy categoriesForClass!Unclassified! !
!SSWDBObjectProxy methodsFor!

_aquireCollectionProxiesUsing: collectionSpecs

	"Cache the proxiedObject's collection proxies, and set the backwards owner reference.
	The CollectionSpecs identifying the collections (equivalent to self _dbTable collectionSpecs) 
	are passed in as an optimisation"

	"If refreshing an existing object, we may already have the collections"
	collectionProxies isNil 
	ifTrue:
		[collectionProxies := IdentityDictionary new: collectionSpecs size.

		collectionSpecs do:
			[ :spec |
			(collectionProxies at: spec put: (spec accessor valueIn: proxiedObject))
				_owner: self]]
	ifFalse:
		[collectionSpecs do:
			[ :spec |
			spec accessor value: (collectionProxies at: spec) in: proxiedObject]]!

_class

	"class stores the Class of the object for which the receiver is a proxy"
	
	^class!

_class: aClass

	"class stores the Class of the object for which the receiver is a proxy"
	
	class := aClass!

_collectionProxies

	"collectionProxies stores an IdentityDictionary mapping each of 
	the receiver's table's collectionSpecs to the proxied collection in that spec.
	These are maintained by the receiver so actual collections in the proxiedObject
	can be related to their originating proxy"

	^collectionProxies!

_collectionProxies: anIdentityDictionary

	"collectionProxies stores an IdentityDictionary mapping each of 
	the receiver's table's collectionSpecs to the proxied collection in that spec.
	These are maintained by the receiver so actual collections in the proxiedObject
	can be related to their originating proxy"

	collectionProxies := anIdentityDictionary!

_collectionProxyFor: aCollectionSpec

	"Look up the collection proxy specified by the given spec.
	If none, create and cache it"

	^collectionProxies at: aCollectionSpec ifAbsentPut:
		[aCollectionSpec newProxydCollectionFor: self]!

_collectionProxySwapped: aCollectionProxy

	"The given collection proxy has swapped its references.
	Update the cache"

	^collectionProxies at: aCollectionProxy _collectionSpec put: aCollectionProxy!

_currentVersion

	"Re-read the receiver's proxiedObject from the database,
	returning it as a new proxied object.
	NB Intended for privileged clients only; other clients should use currentVersion (no _ prefix)"
	
	| newProxy |
	
	newProxy := self _proxyClass new.
	newProxy _id: id; _class: class; _reStore: reStore.	

	reStore recoverObjectOfClass: class withID: id into: newProxy.
	
	^newProxy!

_dbTable

	^reStore tableForClass: class!

_id

	"id stores the unique ID (Integer) of the object for which the receiver is a proxy"
	
	^id!

_id: anInteger

	"dbID stores the unique ID (Integer) of the object for which the receiver is a proxy"
	
	id := anInteger!

_idIn: aReStore

	"Polymorphic with Object"
	
	^reStore == aReStore 
		ifTrue: [id]
		ifFalse: [nil error: 'incorrect ReStore parameter']!

_instVarAt: anInteger put: anObject

	"Sent from internal code to access the proxiedObject directly.
	ASSERT: the receiver is a recovered proxy"
	
	^proxiedObject instVarAt: anInteger put: anObject!

_intern

	"Register the receiver in its reStore"
	
	reStore registerProxy: self!

_isNew

	"Return a Boolean indicating whether the receiver does not yet exist in the database"
	
	^self _isPersistent not!

_postSwapReferences

	"Inform the collectionProxies"

	collectionProxies do: [ :proxy | proxy _owner: self]!

_prepareToCommit

	self _isDeleted ifFalse: [self _storeNonPersistentComponents]!

_proxiedObjectMissing

	"The receiver's proxiedObject (as specified by class/id) is missing.
	Initialize the receiver to represent this"

	self 
		_proxiedObject: (SSWDBDeletedObject newForClass: class id: id);
		_collectionProxies: IdentityDictionary new!

_recoverProxiedObject

	"Recover the receiver's proxiedObject from the database"
	
	reStore recoverObjectOfClass: class withID: id into: self!

_refreshFromRow: aDatabaseRow table: aDBTable

	"Return whether the proxiedObject was refreshed at all.
	table is passed in as an optimisation"
	
	^(aDBTable refreshProxy: self whereChangedFromRow: aDatabaseRow)
		ifTrue: [proxiedObject onRefresh. true]
		ifFalse: [false]!

_storeNonPersistentComponents

	"Ensure that each non-persistent component of the proxiedObject exists in the receiver's reStore"

	| table |

	table := self _dbTable.

	table dataFields do: [ :field | (field accessor valueIn: proxiedObject) _ensurePersistentIn: reStore].
		
	table collectionSpecs do:
		[ :collectionSpec || collection |
		collection := collectionSpec accessor valueIn: self.
		collection isNil ifTrue: [collection := collectionSpec newCollection].
		collection isDBProxy ifFalse: 
			[| proxy |
			proxy := self _collectionProxyFor: collectionSpec.
			proxy _proxiedObject == collection ifFalse: 
				[proxy _setProxiedObject: collection; _referenced]]]!

_unrecoveredProxyString

	^'%<an unrecovered <1p> id=<2p>%>' expandMacrosWith: class with: id!

_unstore

	"Unstore the receiver's proxyObject - set the receiver's state so that the receiver is recognised as unstored and hence will be deleted at the next commit"

	"Notify interested parties"
	self _dbTable aboutToBeUnstored: proxiedObject.
	proxiedObject onAboutToUnstore.

	self _isPersistent ifFalse: [reStore deregisterProxy: self; removeFromTransaction: self].

	"Separate loops to cope with potential reference swap"
	collectionProxies do: [ :each | each __ensureActive].
	collectionProxies do: [ :each | each _unstore].

	proxiedObject := nil!

= anotherObject

	"No need to fetch the object if #= == #=="
	^(proxiedObject isNil and: [(class lookupMethod: #=) == (Object>>#=)])
		ifTrue: [self == anotherObject]
		ifFalse: [self doesNotUnderstand: (Message selector: #= arguments: (Array with: anotherObject))]!

basicClass

	^class!

class

	"No need to bother the proxiedObject, except for inherited objects which are needed to determine their class"

	^(self _dbTable class == SSWDBTable) 
	ifTrue: 
		[class]
	ifFalse: 
		[proxiedObject == nil ifTrue: [self _recoverProxiedObject].
		proxiedObject class]!

currentVersion

	"Re-read the receiver's proxiedObject from the database,
	returning it as a new unproxied object.
	c.f. _currentVersion which returns a proxied object"
	
	^self _currentVersion _proxiedObject!

debugPrintString

	"Override to test for deleted status"
	
	^self _isDeleted 
		ifTrue: [(SSWDBDeletedObject newForClass: class id: id) printString]
		ifFalse: [super debugPrintString]!

hash

	"No need to fetch the object if hash == identityHash"

	^(proxiedObject isNil and: [(class lookupMethod: #hash) == (Object>>#hash)])
		ifTrue: [self identityHash]
		ifFalse: [self doesNotUnderstand: (Message selector: #hash)]!

isInteger

	"No need to bother the proxiedObject"
	
	^false
!

isKindOf: aClass

	"No need to bother the proxiedObject (except for inherited objects)"

	^(self _dbTable class == SSWDBTable)
	ifTrue: 
		[(class == aClass) or: [class inheritsFrom: aClass]]
	ifFalse: 
		[proxiedObject == nil ifTrue: [self _recoverProxiedObject].
		proxiedObject isKindOf: aClass]!

isSQLNull

	"No need to bother the proxiedObject"
	
	^false!

isValidForPersistence

	^true!

printOn: aStream

	"Do not error on printString to a deleted object"

	^self _isDeleted
		ifTrue: [aStream nextPutAll: self debugPrintString]
		ifFalse: [super printOn: aStream]!

printString

	"Do not error on printString to a deleted object"

	^self _isDeleted
		ifTrue: [self debugPrintString]
		ifFalse: [super printString]!

reStoreValue

	^id!

sqlStringIn: anSSWSQLDialect

	| stream |
	
	stream := anSSWSQLDialect sqlWriteStream.
	
	self writeSQLOn: stream.
	
	^stream contents
!

unstore

	"Unstore the receiver's proxiedObject, returning the proxiedObject.
	This message (as opposed to the private _unstore) is only sent when the receive has not yet been referenced in the current transaction. Hence reference it here.

	NB: This is also a legacy selector whose meaning was 'unstore in the active transaction'.
	We have repurposed this to also be a direct 'unstore now' message, which begins and completes in its own transaction.
	Accomodate both new and legacy behavior by checking if there is currently a transaction in progress"
	
	| me him |

	reStore isTransactionInProgress ifFalse: [^self unstored store].

	proxiedObject == nil ifTrue: [self _recoverProxiedObject].
	proxiedObject isDBDeleted ifTrue: [^self].

	"Set me and him to be correct after the swap (done during _referenced)"
	me := proxiedObject.
	him := self.

	self _referenced.

	me _unstore.

	^him!

unstored

	"Return the receiver in an UnstoreWrapper"

	^SSWDBUnstoreWrapper on: self!

writeSQLOn: aStream

	"The SQL for a persistent object is its id"

	id writeSQLOn: aStream!

writeSQLOn: aStream forCondition: aSQLCondition

	^self writeSQLOn: aStream forField: aSQLCondition field!

writeSQLOn: aStream forField: aField

	"The SQL for a persistent object is its id"

	id writeSQLOn: aStream forField: aField! !
!SSWDBObjectProxy categoriesFor: #_aquireCollectionProxiesUsing:!actions-internal!public! !
!SSWDBObjectProxy categoriesFor: #_class!accessing!public! !
!SSWDBObjectProxy categoriesFor: #_class:!accessing!public! !
!SSWDBObjectProxy categoriesFor: #_collectionProxies!accessing!public! !
!SSWDBObjectProxy categoriesFor: #_collectionProxies:!accessing!public! !
!SSWDBObjectProxy categoriesFor: #_collectionProxyFor:!accessing:derived!public! !
!SSWDBObjectProxy categoriesFor: #_collectionProxySwapped:!actions-internal!public! !
!SSWDBObjectProxy categoriesFor: #_currentVersion!accessing:derived!public! !
!SSWDBObjectProxy categoriesFor: #_dbTable!accessing:derived!public! !
!SSWDBObjectProxy categoriesFor: #_id!accessing!public! !
!SSWDBObjectProxy categoriesFor: #_id:!accessing!public! !
!SSWDBObjectProxy categoriesFor: #_idIn:!forwarding!public! !
!SSWDBObjectProxy categoriesFor: #_instVarAt:put:!forwarding!public! !
!SSWDBObjectProxy categoriesFor: #_intern!actions-internal!public! !
!SSWDBObjectProxy categoriesFor: #_isNew!public!testing! !
!SSWDBObjectProxy categoriesFor: #_postSwapReferences!actions-internal!public! !
!SSWDBObjectProxy categoriesFor: #_prepareToCommit!actions-internal!public! !
!SSWDBObjectProxy categoriesFor: #_proxiedObjectMissing!actions-internal!public! !
!SSWDBObjectProxy categoriesFor: #_recoverProxiedObject!actions-internal!public! !
!SSWDBObjectProxy categoriesFor: #_refreshFromRow:table:!actions-internal!public! !
!SSWDBObjectProxy categoriesFor: #_storeNonPersistentComponents!actions-internal!private! !
!SSWDBObjectProxy categoriesFor: #_unrecoveredProxyString!accessing!public! !
!SSWDBObjectProxy categoriesFor: #_unstore!actions-internal!public! !
!SSWDBObjectProxy categoriesFor: #=!forwarding!public! !
!SSWDBObjectProxy categoriesFor: #basicClass!forwarding!public! !
!SSWDBObjectProxy categoriesFor: #class!forwarding!public! !
!SSWDBObjectProxy categoriesFor: #currentVersion!accessing:derived!public! !
!SSWDBObjectProxy categoriesFor: #debugPrintString!forwarding!public! !
!SSWDBObjectProxy categoriesFor: #hash!forwarding!public! !
!SSWDBObjectProxy categoriesFor: #isInteger!forwarding!public! !
!SSWDBObjectProxy categoriesFor: #isKindOf:!forwarding!public! !
!SSWDBObjectProxy categoriesFor: #isSQLNull!non forwarding!public! !
!SSWDBObjectProxy categoriesFor: #isValidForPersistence!forwarding!public! !
!SSWDBObjectProxy categoriesFor: #printOn:!forwarding!public! !
!SSWDBObjectProxy categoriesFor: #printString!forwarding!public! !
!SSWDBObjectProxy categoriesFor: #reStoreValue!accessing:derived!public! !
!SSWDBObjectProxy categoriesFor: #sqlStringIn:!forwarding!public! !
!SSWDBObjectProxy categoriesFor: #unstore!forwarding!public! !
!SSWDBObjectProxy categoriesFor: #unstored!forwarding!public! !
!SSWDBObjectProxy categoriesFor: #writeSQLOn:!actions-internal!public! !
!SSWDBObjectProxy categoriesFor: #writeSQLOn:forCondition:!non forwarding!public! !
!SSWDBObjectProxy categoriesFor: #writeSQLOn:forField:!actions-internal!public! !

!SSWDBObjectProxy class methodsFor!

_forNewObject: anObject withID: anInteger inReStore: aReStore

	^(self _forObjectOfClass: anObject class withID: anInteger  inReStore: aReStore)
		_newProxiedObject: anObject;
		_collectionProxies: IdentityDictionary new;
		yourself!

_forObjectOfClass: aClass withID: anInteger  inReStore: aReStore

	^self new
		_reStore: aReStore;
		_class: aClass;
		_id: anInteger;
		yourself!

controlFields

	"Return any fields required by instances of the receiver 
	to control their operation.

	None by default, subclasses should override as necessary"

	^SSWSQLFieldCollection new!

modifyUpdatesFor: anSSWDBTable

	"Return any updates that should be applied to rows in anSSWDBTable when carrying out a modify: update.

	None by default, subclasses should override as necessary"

	^OrderedCollection new! !
!SSWDBObjectProxy class categoriesFor: #_forNewObject:withID:inReStore:!instance creation!public! !
!SSWDBObjectProxy class categoriesFor: #_forObjectOfClass:withID:inReStore:!instance creation!public! !
!SSWDBObjectProxy class categoriesFor: #controlFields!constants!public! !
!SSWDBObjectProxy class categoriesFor: #modifyUpdatesFor:!constants!public! !


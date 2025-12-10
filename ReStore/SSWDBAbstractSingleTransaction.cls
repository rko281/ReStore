"Filed out from Dolphin Smalltalk"!

SSWDBTransaction subclass: #SSWDBAbstractSingleTransaction
	instanceVariableNames: 'allReferencedObjects currentReferencedObjects activeProxiesMap changedObjects allocatedIDs deletedObjects'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWDBAbstractSingleTransaction guid: (GUID fromString: '{5a3e3dd4-3990-11d5-b1df-444553540000}')!

SSWDBAbstractSingleTransaction comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!

!SSWDBAbstractSingleTransaction categoriesForClass!Unclassified! !

!SSWDBAbstractSingleTransaction methodsFor!

abandon

	"End this transaction, leaving objects in their current state (unlike rollback which returns them to their state prior to the transaction)"

	self proxySwapper abandon: self currentReferencedObjects.
	"self currentReferencedObjects do: [ :each | each _abandonChanges]."
	self endObjectCollection!

activeProxiesMap

	"activeProxiesMap stores an IdentityDictionary mapping objects active in this transaction to their proxy"

	^activeProxiesMap!

activeProxiesMap: anIdentityDictionary

	"activeProxiesMap stores an IdentityDictionary mapping objects active in this transaction to their proxy"

	activeProxiesMap := anIdentityDictionary!

addDeletedObject: aDBProxy

	^self deletedObjects add: aDBProxy!

addProxy: aDBProxy

	"Add aDBProxy to the collection of potentially-changed objects.
	ASSERT: aDBProxy is swapped, wearing the back-face identity of the pair."

	aDBProxy _proxiedObject ifNotNil: [ :object | self activeProxiesMap at: object put: aDBProxy].
	self currentReferencedObjects add: aDBProxy!

allocatedIDs

	"allocatedIDs stores SSWDBAllocatedIDs allocated to newly-persistent objects during a commit of the receiver.
	Structure is a Dictionary mapping tables to IDs allocated in each table"

	^allocatedIDs!

allocatedIDs: anIdentityDictionary

	"allocatedIDs stores SSWDBAllocatedIDs allocated to newly-persistent objects during a commit of the receiver.
	Structure is a Dictionary mapping tables to IDs allocated in each table"

	allocatedIDs := anIdentityDictionary!

allocateIDFor: anObject tableRecord: aDBTableRecord

	| allocated |

	allocated := self allocatedIDs at: aDBTableRecord ifAbsentPut: [OrderedCollection new: 32].

	^allocated add:
		(SSWDBAllocatedID new
			tableRecord: aDBTableRecord;
			offset: allocated size;
			object: anObject;
			yourself)!

allReferencedObjects

	"allReferencedObjects stores a collection of all objects referenced during this transaction. 
	It is created/added to following each phase	(see comment to currentReferencedObjects)"
	
	^allReferencedObjects!

allReferencedObjects: anIdentitySet

	"allReferencedObjects stores a collection of all objects referenced during this transaction. 
	It is created/added to following each phase	(see comment to currentReferencedObjects)"
	
	allReferencedObjects := anIdentitySet!

autoRecoverCommitIn: anSSWReStore

	"Attempt to fix up the receiver following an error during the commit stage"

	"Any objects referenced during the errored commit will erroneously be in currentReferencedObjects.
	Swap back and forget"
	SSWDBTransactionProxySwapper unswapAll: self currentReferencedObjects.

	"The receiver's changedObjects should now be the currentReferencedObjects"
	self currentReferencedObjects: (self newEmptyObjectsSet: self changedObjects size).
	(SSWDBTransactionProxySwapper swapAll: self changedObjects).
	self allReferencedObjects: self newEmptyObjectsSet!

autoRecoverPreCommitIn: anSSWReStore

	"Attempt to fix up the receiver following an error during the pre-commit stage"

	"Move allReferencedObjects back to currentReferencedObjects"
	self currentReferencedObjects addAll: self allReferencedObjects.
	self allReferencedObjects: self newEmptyObjectsSet!

begin

	"Initialize the receiver transaction"
	
	self
		allocatedIDs: (IdentityDictionary new: 64);
		activeProxiesMap: (IdentityDictionary new: 128);
		beginObjectCollection!

beginObjectCollection

	"Initialize the receiver transaction to begin accumulating referenced objects"
	
	self 
		currentReferencedObjects: self newEmptyObjectsSet;
		allReferencedObjects: self newEmptyObjectsSet;
		deletedObjects: self newEmptyObjectsSet!

beginWithin: anotherTransaction

	"For single (non-nested) transactions, anotherTransaction should always be nil.
	Defer to begin, or error if anotherTransaction is not nil"
	
	(anotherTransaction = nil or: [anotherTransaction isDumb and: [anotherTransaction isEmpty]])
		ifTrue: [self begin]
		ifFalse: [self error: 'Nesting of transaction not supported']!

changedObjects

	"changedObjects stores the collection of objects changed within this transaction.
	It is constructed from referencedObjects during pre-commit"
	
	^changedObjects!

changedObjects: anIdentitySet

	"changedObjects stores the collection of objects changed within this transaction.
	It is constructed from referencedObjects during pre-commit"
	
	changedObjects := anIdentitySet!

commitAllocatedIDs

	self allocatedIDs keysAndValuesDo: 
		[ :tableRecord :ids |
		[| directTableRecord nextID statement |
		"Avoid invoking change detection system by referencing proxied table record directly"
		directTableRecord := tableRecord _proxiedObject.
		nextID := directTableRecord nextID + ids size.
		statement := tableRecord _reStore nextIDStatement.
		statement values: (Array with: nextID with: tableRecord _id with: directTableRecord nextID); exec.
		statement rowsAffected = 1] whileFalse: 
			["Update clash; refresh and try again"
			tableRecord _recoverProxiedObject]]!

currentReferencedObjects

	"currentReferencedObjects stores a collection of all objects that are referenced 
	during the current 'phase' of the receiver. Phases are
	 - initial use (following begin)
	 - each pre-commital loop (see prepareToCommit)"
	
	^currentReferencedObjects!

currentReferencedObjects: anIdentitySet

	"currentReferencedObjects stores a collection of all objects that are referenced 
	during the current 'phase' of the receiver. Phases are
	 - initial use (following begin)
	 - each pre-commital loop (see prepareToCommit)"
	
	currentReferencedObjects := anIdentitySet!

deletedObjects

	"deletedObjects stores any persistent objects which have been deleted during this transaction.
	This is used to prevent redundant duplicate deletion attempts, e.g. where an object is a member of a deleted collection"
	
	^deletedObjects!

deletedObjects: anIdentitySet

	"deletedObjects stores any persistent objects which have been deleted during this transaction.
	This is used to prevent redundant duplicate deletion attempts, e.g. where an object is a member of a deleted collection"
	
	deletedObjects := anIdentitySet!

endObjectCollection

	"End the accumulation of referenced objects"

	self 
		allReferencedObjects: nil;
		currentReferencedObjects: self newEmptyObjectsSet.
	self activeProxiesMap removeAll!

ensureIsActive: anObject

	"Ensure anObject is currently active (i.e.is in the currentReferencedObjects set) if it is already present in this transaction.
	Return whether anObject exists in this transaction"

	^(self activeProxiesMap at: anObject ifPresent: [ :proxy | self currentReferencedObjects add: proxy]) notNil!

includesProxiedObject: anObject

	^self activeProxiesMap includesKey: anObject!

includesProxy: anSSWDBProxy

	^(self currentReferencedObjects includes: anSSWDBProxy)
		or: [self allReferencedObjects includes: anSSWDBProxy]!

isAlreadyDeleted: aDBProxy

	^self deletedObjects includes: aDBProxy!

isEmpty

	^self activeProxiesMap isEmpty!

newEmptyObjectsSet

	"Return an empty Set of a default size that can be used for holding proxies"

	^self newEmptyObjectsSet: 128!

newEmptyObjectsSet: anInteger

	"Return an empty Set that can be used for holding proxies"

	^IdentitySet new: anInteger!

nextCollectionPhase

	self allReferencedObjects isEmpty
		ifTrue: [self allReferencedObjects: self currentReferencedObjects]
		ifFalse: [self allReferencedObjects addAll: self currentReferencedObjects].

	self currentReferencedObjects: (self newEmptyObjectsSet: self currentReferencedObjects size)
!

ownerTransaction

	"For a single (non-nested transaction) the ownerTransaction is always nil"
	
	^nil!

postCommitAllocatedIDs

	self allocatedIDs keysAndValuesDo: 
		[ :tableRecord :ids |

		ids do: [ :id | id postCommit].
		"Avoid invoking change detection system by referencing proxied table record directly"
		tableRecord _proxiedObject incrementNextIDBy: ids size]!

prepareToCommit

	| changed currentObjects |
	changed := self newEmptyObjectsSet: self currentReferencedObjects size // 2.

	"Pre-write validate the changed objects. This may cause other objects to be added to the transaction,
	so repeat until no more changed objects are found"
	[ self currentReferencedObjects isEmpty ] whileFalse: [
		| needingPhase2 |
		currentObjects := self currentReferencedObjects.
		needingPhase2 := self newEmptyObjectsSet.
		self nextCollectionPhase.
		currentObjects do: [ :proxy |
			(changed includes: proxy) ifFalse: [
				proxy _hasChanged ifTrue: [
					changed add: proxy.
					proxy _prepareToCommitPhase1 ifTrue: [ needingPhase2 add: proxy ] ] ] ].
		needingPhase2 do: [ :each | each _prepareToCommitPhase2 ] ].

	self changedObjects: (changed collect: [ :each | each _proxiedObject ]).
	SSWDBTransactionProxySwapper unswapAll: self allReferencedObjects.

	self endObjectCollection!

proxyForObject: anObject ifNone: aBlock

	^self activeProxiesMap at: anObject ifAbsent: aBlock!

proxySwapper

	^SSWDBProxySwapper new!

removeProxy: aDBProxy

	"Remove aDBProxy from the collections of potentially-changed objects"

	aDBProxy _isSwapped
	ifTrue: 
		["The standard though unusual case of an object being stored and unstored in one transaction. In this case we also need to remove any allocated ID"
		self allocatedIDs at: aDBProxy _tableRecord ifPresent: [ :allocIDs | allocIDs removeAllSuchThat: [ :each | each object == aDBProxy _proxiedObject]].
		self currentReferencedObjects remove: aDBProxy.
		self allReferencedObjects remove: aDBProxy ifAbsent: []. "May be empty"
		self activeProxiesMap removeKey: aDBProxy _proxiedObject]
	ifFalse: 
		["aDBProxy has been unswapped after earlier being swapped into this transaction, hence the receiver now contains the proxied object in place of the proxy and vice versa"
		self currentReferencedObjects remove: aDBProxy _proxiedObject.
		self allReferencedObjects remove: aDBProxy _proxiedObject ifAbsent: []. "May be empty"
		self activeProxiesMap removeKey: aDBProxy]!

resetChangedObjects

	self changedObjects: nil! !

!SSWDBAbstractSingleTransaction categoriesForMethods!
abandon!actions!public! !
activeProxiesMap!accessing!private! !
activeProxiesMap:!accessing!private! !
addDeletedObject:!actions!public! !
addProxy:!proxy tracking!public! !
allocatedIDs!accessing!public! !
allocatedIDs:!accessing!public! !
allocateIDFor:tableRecord:!actions!public! !
allReferencedObjects!accessing!public! !
allReferencedObjects:!accessing!public! !
autoRecoverCommitIn:!actions!public! !
autoRecoverPreCommitIn:!actions!public! !
begin!actions!public! !
beginObjectCollection!initializing!public! !
beginWithin:!actions!public! !
changedObjects!accessing!public! !
changedObjects:!accessing!public! !
commitAllocatedIDs!actions!private! !
currentReferencedObjects!accessing!public! !
currentReferencedObjects:!accessing!public! !
deletedObjects!accessing!public! !
deletedObjects:!accessing!public! !
endObjectCollection!initializing!public! !
ensureIsActive:!actions!public! !
includesProxiedObject:!public!testing! !
includesProxy:!public!testing! !
isAlreadyDeleted:!public!testing! !
isEmpty!public!testing! !
newEmptyObjectsSet!evaluating!public! !
newEmptyObjectsSet:!evaluating!public! !
nextCollectionPhase!initializing!public! !
ownerTransaction!evaluating!public! !
postCommitAllocatedIDs!actions!private! !
prepareToCommit!actions!public! !
proxyForObject:ifNone:!proxy tracking!public! !
proxySwapper!accessing!public! !
removeProxy:!proxy tracking!public! !
resetChangedObjects!initializing!public! !
!


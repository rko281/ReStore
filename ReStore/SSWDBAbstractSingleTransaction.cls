"Filed out from Dolphin Smalltalk 7"!

SSWDBTransaction subclass: #SSWDBAbstractSingleTransaction
	instanceVariableNames: 'allReferencedObjects currentReferencedObjects changedObjects allocatedIDs'
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

	self currentReferencedObjects do: [ :each | each _swapReferences].
	self endObjectCollection!

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
	self currentReferencedObjects do: [ :obj | obj _swapReferences].

	"The receiver's changedObjects should now be the currentReferencedObjects"
	self currentReferencedObjects: (self changedObjects collect: [ :obj | obj _swapReferences]).
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
		beginObjectCollection!

beginObjectCollection

	"Initialize the receiver transaction to begin accumulating referenced objects"
	
	self 
		currentReferencedObjects: self newEmptyObjectsSet;
		allReferencedObjects: self newEmptyObjectsSet!

beginWithin: anotherTransaction

	"For single (non-nested) transactions, anotherTransaction should always be nil.
	Defer to begin, or error if anotherTransaction is not nil"
	
	anotherTransaction = nil
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
		statement values: (Array with: nextID with: directTableRecord _id with: directTableRecord nextID); exec.
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

endObjectCollection

	"End the accumulation of referenced objects"

	self 
		allReferencedObjects: nil;
		currentReferencedObjects: self newEmptyObjectsSet!

includesProxy: anSSWDBProxy

	^(self currentReferencedObjects includes: anSSWDBProxy)
		or: [self allReferencedObjects includes: anSSWDBProxy]!

newEmptyObjectsSet

	"Return an empty Set of a default size that can be used for holding proxies"

	^self newEmptyObjectsSet: 20!

newEmptyObjectsSet: anInteger

	"Return an empty Set that can be used for holding proxies"

	^IdentitySet new: anInteger!

nextCollectionPhase

	self allReferencedObjects isEmpty
		ifTrue: [self allReferencedObjects: self currentReferencedObjects]
		ifFalse: [self allReferencedObjects addAll: self currentReferencedObjects].

	self currentReferencedObjects: self newEmptyObjectsSet
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

	| changed noneChanged currentObjects |

	changed := self newEmptyObjectsSet: (self currentReferencedObjects size // 2).
	noneChanged := false.

	"Pre-write validate the changed objects. This may cause other objects to be added to the transaction,
	so repeat until no more changed objects are found"
	[noneChanged] whileFalse:
		[noneChanged := true.
		currentObjects := self currentReferencedObjects.
		self nextCollectionPhase.
		currentObjects do: 
			[ :proxy | 
			(changed includes: proxy) ifFalse:
				[proxy _hasChanged 
				ifTrue: 
					[noneChanged := false.
					changed add: proxy.
					proxy _prepareToCommit]
				ifFalse:
					[self currentReferencedObjects add: proxy]]]].

	self currentReferencedObjects do: [ :proxy | proxy _swapReferences].
	self changedObjects: (changed collect: [ :proxy | proxy _swapReferences]). 

	self endObjectCollection!

proxy: aProxydObject forwarded: aMessage

	"Add aProxydObject to the collection of potentially-changed objects
	(the receiver performs no checking on the message sent)"

	self currentReferencedObjects add: aProxydObject!

proxyForObject: anObject ifNone: aBlock

	^self currentReferencedObjects detect: [ :each | each _proxiedObject == anObject] ifNone:
		[self allReferencedObjects detect: [ :each | each _proxiedObject == anObject] ifNone: aBlock]!

removeProxy: aProxydObject

	"Remove aProxydObject from the collections of potentially-changed objects"

	self currentReferencedObjects remove: aProxydObject ifAbsent: [].
	self allReferencedObjects remove: aProxydObject ifAbsent: []!

resetChangedObjects

	self changedObjects: nil! !
!SSWDBAbstractSingleTransaction categoriesFor: #abandon!actions!public! !
!SSWDBAbstractSingleTransaction categoriesFor: #allocatedIDs!accessing!public! !
!SSWDBAbstractSingleTransaction categoriesFor: #allocatedIDs:!accessing!public! !
!SSWDBAbstractSingleTransaction categoriesFor: #allocateIDFor:tableRecord:!actions!public! !
!SSWDBAbstractSingleTransaction categoriesFor: #allReferencedObjects!accessing!public! !
!SSWDBAbstractSingleTransaction categoriesFor: #allReferencedObjects:!accessing!public! !
!SSWDBAbstractSingleTransaction categoriesFor: #autoRecoverCommitIn:!actions!public! !
!SSWDBAbstractSingleTransaction categoriesFor: #autoRecoverPreCommitIn:!actions!public! !
!SSWDBAbstractSingleTransaction categoriesFor: #begin!actions!public! !
!SSWDBAbstractSingleTransaction categoriesFor: #beginObjectCollection!initializing!public! !
!SSWDBAbstractSingleTransaction categoriesFor: #beginWithin:!actions!public! !
!SSWDBAbstractSingleTransaction categoriesFor: #changedObjects!accessing!public! !
!SSWDBAbstractSingleTransaction categoriesFor: #changedObjects:!accessing!public! !
!SSWDBAbstractSingleTransaction categoriesFor: #commitAllocatedIDs!actions!private! !
!SSWDBAbstractSingleTransaction categoriesFor: #currentReferencedObjects!accessing!public! !
!SSWDBAbstractSingleTransaction categoriesFor: #currentReferencedObjects:!accessing!public! !
!SSWDBAbstractSingleTransaction categoriesFor: #endObjectCollection!initializing!public! !
!SSWDBAbstractSingleTransaction categoriesFor: #includesProxy:!public!testing! !
!SSWDBAbstractSingleTransaction categoriesFor: #newEmptyObjectsSet!evaluating!public! !
!SSWDBAbstractSingleTransaction categoriesFor: #newEmptyObjectsSet:!evaluating!public! !
!SSWDBAbstractSingleTransaction categoriesFor: #nextCollectionPhase!initializing!public! !
!SSWDBAbstractSingleTransaction categoriesFor: #ownerTransaction!evaluating!public! !
!SSWDBAbstractSingleTransaction categoriesFor: #postCommitAllocatedIDs!actions!private! !
!SSWDBAbstractSingleTransaction categoriesFor: #prepareToCommit!actions!public! !
!SSWDBAbstractSingleTransaction categoriesFor: #proxy:forwarded:!proxy tracking!public! !
!SSWDBAbstractSingleTransaction categoriesFor: #proxyForObject:ifNone:!proxy tracking!public! !
!SSWDBAbstractSingleTransaction categoriesFor: #removeProxy:!proxy tracking!public! !
!SSWDBAbstractSingleTransaction categoriesFor: #resetChangedObjects!initializing!public! !


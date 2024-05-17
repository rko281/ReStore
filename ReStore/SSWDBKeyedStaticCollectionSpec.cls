"Filed out from Dolphin Smalltalk"!

SSWDBStaticCollectionSpec subclass: #SSWDBKeyedStaticCollectionSpec
	instanceVariableNames: 'indexField updateTargetStatement'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBKeyedStaticCollectionSpec guid: (GUID fromString: '{4648dc63-a6b1-11d5-b1e0-444553540000}')!
SSWDBKeyedStaticCollectionSpec comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBKeyedStaticCollectionSpec categoriesForClass!Unclassified! !
!SSWDBKeyedStaticCollectionSpec methodsFor!

allAdditionsTo: aCollection

	"Return an collection of SSWDBCollectionAdditions representing the addition of all aCollection's elements to itself, starting when empty"

	| additions |

	additions := OrderedCollection new: aCollection size.

	aCollection keysAndValuesDo: [ :key :each | additions add: (SSWDBCollectionAddition added: each at: key)].

	^additions!

changesTo: aCollection from: aCollectionOfEntries

	"Return the changes made to aCollection compared to aCollectionOf(Collection)Entries"

	| changes map |

	changes := OrderedCollection new: (aCollection size // 10).

	"Make a map of each index (as was) to its entry"
	self shouldCompareKeysByEquality
		ifTrue: [map := Dictionary new: aCollectionOfEntries size]
		ifFalse: [map := IdentityDictionary new: aCollectionOfEntries size].
	aCollectionOfEntries do: [ :each | map at: each index put: each].

	"Locate and remove entry for each member of the receiver and check for key change"
	aCollection keysAndValuesDo:
		[ :key :value || entry |
		entry := map removeKey: key ifAbsent: [NilCookie].
		entry == NilCookie
		ifTrue:
			["No entry found = element has been added to the receiver" 
			(changes add: (SSWDBCollectionAddition added: value at: key)) affectedEntry]
		ifFalse: 
			[(entry target == value or: [self shouldCompareChangesByEquality and: [entry target = value]]) ifFalse: [changes add: (SSWDBCollectionUpdate entry: entry newTarget: value)]]].

	"Any remaining entries indicate elements removed from the receiver"
	map do: [ :entry | changes add: (self elementRemovalClass newWithEntry: entry)].

	^changes!

elementRemovalClass

	"Return the class of change object representing the removal of an element for the type of collection modelled by the receiver"

	^SSWDBCollectionRemoval!

entryClass

	"Return the class of collection entry appropriate for the receiver"
	
	^SSWDBKeyedCollectionEntry!

freePreparedStatements

	updateTargetStatement notNil ifTrue: 
		[updateTargetStatement free.
		updateTargetStatement := nil].

	super freePreparedStatements!

indexField

	"indexField stores the SSWDBField in the receiver's collectionTable
	that holds the index of the elements"
	
	indexField == nil ifTrue: [indexField := self collectionTable fieldAccessing: #index].
	
	^indexField!

indexField: anSSWDBField

	"indexField stores the SSWDBField in the receiver's collectionTable
	that holds the index of the elements"
	
	indexField := anSSWDBField!

shouldCompareKeysByEquality

	^false!

updateEntry: anSSWDBCollectionEntry withTarget: aProxy in: anSSWReStore 

	| query |

	query := SSWSQLUpdateObjectQuery 
			forObject: anSSWDBCollectionEntry
			withUpdates: 
				(SSWSQLFieldAssignmentCollection with:
					(SSWSQLFieldAssignment 
						field: self targetField
						value: aProxy)).

	(updateTargetStatement ifNil: [updateTargetStatement := anSSWReStore prepareStatementForQuery: query])
		values: query values;
		exec! !
!SSWDBKeyedStaticCollectionSpec categoriesForMethods!
allAdditionsTo:!change detection!public! !
changesTo:from:!change detection!public! !
elementRemovalClass!change detection!constants!private! !
entryClass!constants!public! !
freePreparedStatements!initialize/release!public! !
indexField!accessing!public! !
indexField:!accessing!public! !
shouldCompareKeysByEquality!change detection!private!testing! !
updateEntry:withTarget:in:!actions - api!public! !
!


"Filed out from Dolphin Smallalk"!

SSWDBStaticCollectionSpec subclass: #SSWDBKeyedStaticCollectionSpec
	instanceVariableNames: 'indexField updateIndexStatement'
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

changesTo: aCollection from: aCollectionOfEntries comparisonMap: aDictionary

	"Private - Return the changes made to aCollection compared to aCollectionOf(Collection)Entries.
	For keyed changes, must consider additions, removals and changes of key"

	| changes |

	changes := OrderedCollection new: (aCollection size // 10).

	"Make a map of each element (as was) to its entry(s)"
	aCollectionOfEntries do: [ :each | (aDictionary at: (each target ifNil: [NilCookie]) ifAbsentPut: [OrderedCollection new: 1]) addLast: each].

	"Locate and remove entry for each member of the receiver and check for key change"
	aCollection keysAndValuesDo:
		[ :newKey :each || entry |
		entry := (aDictionary at: (each ifNil: [NilCookie]) ifAbsent: [##(OrderedCollection new)]) removeFirstIfAbsent:
			"No entry found = element has been added to the receiver" 
			[(changes add: (SSWDBCollectionAddition added: each at: newKey)) affectedEntry].
		entry index = newKey ifFalse: 
			[changes add: (self keyUpdateClass entry: entry newIndex: newKey)]].

	"Any remaining entries indicate elements removed from the receiver"
	aDictionary keysAndValuesDo:
		[ :each :entries | 
		entries isEmpty ifFalse:		"Minor optimisation"
			[entries do: [ :entry | changes add: (self elementRemovalClass newWithEntry: entry)]]].

	^changes!

elementRemovalClass

	"Return the class of change object representing the removal of an element for the type of collection modelled by the receiver"

	^SSWDBCollectionRemoval!

entryClass

	"Return the class of collection entry appropriate for the receiver"
	
	^SSWDBKeyedCollectionEntry!

equalityChangesTo: aCollection from: aCollectionOfEntries

	"Return the changes made to aCollection compared to aCollectionOf(Collection)Entries, comparing via equality (=)"

	^self changesTo: aCollection from: aCollectionOfEntries comparisonMap: (Dictionary new: aCollectionOfEntries size)!

freePreparedStatements

	updateIndexStatement notNil ifTrue: 
		[updateIndexStatement free.
		updateIndexStatement := nil].

	super freePreparedStatements!

identityChangesTo: aCollection from: aCollectionOfEntries

	"Return the changes made to aCollection compared to aCollectionOf(Collection)Entries, comparing via identity (==)"

	^self changesTo: aCollection from: aCollectionOfEntries comparisonMap: (IdentityDictionary new: aCollectionOfEntries size)!

indexField

	"indexField stores the SSWDBField in the receiver's collectionTable
	that holds the index of the elements"
	
	indexField == nil ifTrue: [indexField := self collectionTable fieldAccessing: #index].
	
	^indexField!

indexField: anSSWDBField

	"indexField stores the SSWDBField in the receiver's collectionTable
	that holds the index of the elements"
	
	indexField := anSSWDBField!

keyUpdateClass

	"Return the class of change object representing a key update for the type of collection modelled by the receiver"

	^SSWDBCollectionIndexUpdate!

updateEntry: anSSWDBCollectionEntry withIndex: anInteger in: anSSWReStore 

	| query |

	query := SSWSQLUpdateObjectQuery 
			forObject: anSSWDBCollectionEntry
			withUpdates: 
				(SSWSQLFieldAssignmentCollection with:
					(SSWSQLFieldAssignment 
						field: self indexField
						value: anInteger)).

	(updateIndexStatement ifNil: [updateIndexStatement := anSSWReStore prepareStatementForQuery: query])
		values: query values;
		exec! !
!SSWDBKeyedStaticCollectionSpec categoriesForMethods!
allAdditionsTo:!change detection!public! !
changesTo:from:comparisonMap:!change detection!private! !
elementRemovalClass!change detection!constants!private! !
entryClass!constants!public! !
equalityChangesTo:from:!change detection!private! !
freePreparedStatements!initialize/release!public! !
identityChangesTo:from:!change detection!private! !
indexField!accessing!public! !
indexField:!accessing!public! !
keyUpdateClass!change detection!constants!private! !
updateEntry:withIndex:in:!actions - api!public! !
!


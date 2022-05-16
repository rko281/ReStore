"Filed out from Dolphin Smallalk"!

SSWDBCollectionSpec subclass: #SSWDBGeneralCollectionSpec
	instanceVariableNames: 'sourceField targetField collectionTable'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBGeneralCollectionSpec guid: (GUID fromString: '{266e4dd2-398e-11d5-b1df-444553540000}')!
SSWDBGeneralCollectionSpec comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBGeneralCollectionSpec categoriesForClass!Unclassified! !
!SSWDBGeneralCollectionSpec methodsFor!

allAdditionsTo: aCollection

	"Return an OrderedCollection of SSWDBCollectionAdditions representing the addition of all aCollection's elements to itself, starting when empty"

	"Must return an OrderedCollection, so don't use collect:"
	^aCollection inject: (OrderedCollection new: aCollection size) into: [ :all :each | all add: (SSWDBCollectionAddition added: each); yourself]!

changesTo: aCollection from: aCollectionOfEntries

	"Return the changes made to aCollection compared to aCollectionOf(Collection)Entries"

	^self shouldCompareChangesByEquality
		ifTrue: [self equalityChangesTo: aCollection from: aCollectionOfEntries]
		ifFalse: [self identityChangesTo: aCollection from: aCollectionOfEntries]!

collectionTable

	"collectionTable stores an SSWDBTable that is used to store 'instances'
	of the collection modelled by the receiver"
	
	collectionTable == nil ifTrue: [self createCollectionTable].
	
	^collectionTable!

collectionTable: anSSWDBTable

	"collectionTable stores an SSWDBTable that is used to store 'instances'
	of the collection modelled by the receiver"
	
	collectionTable := anSSWDBTable!

containedTables

	^Array with: self collectionTable!

createCollectionTable

	| sourceName targetName |
	
	sourceName := self table containedTableNameRoot.
	targetName := self table sqlDialect transformInstVarName: self accessor name.
	
	self collectionTable: 
		(self entryClass dbTableNamed: (sourceName, targetName) in: self table reStore)!

deleteEntry: anSSWDBCollectionEntry

	| query |

	query := SSWSQLDeleteObjectQuery forObject: anSSWDBCollectionEntry.

	(self collectionTable deleteStatementGeneratedFrom: query)
		values: query values;
		exec; 
		close!

entryClass

	"Return the class of collection entry appropriate for the receiver"
	
	^SSWDBCollectionEntry!

equalityChangesTo: aCollection from: aCollectionOfEntries

	"Return the changes made to aCollection compared to aCollectionOf(Collection)Entries, comparing via equality (=)"

	^self subclassResponsibility!

identityChangesTo: aCollection from: aCollectionOfEntries

	"Return the changes made to aCollection compared to aCollectionOf(Collection)Entries, comparing via identity (==)"

	^self subclassResponsibility!

insertEntry: anSSWDBCollectionEntry

	| query statement |

	query := SSWSQLInsertQuery forObject: anSSWDBCollectionEntry.

	statement := self collectionTable insertStatementGeneratedFrom: query.
	statement values: query values.
	statement exec; close!

queryClass

	"Return the class of select query appropriate for the receiver"
	
	^SSWSQLSelectQuery!

shouldCompareChangesByEquality

	"Generally, directly-persisted objects are compared by equality, and persistent object stored in their own table are compared by identity.
	The former could be slightly optimised for e.g. collections of Symbols"

	^self targetClass isDirectlyPersisted!

sourceField

	"sourceField stores the SSWDBField in the receiver's collectionTable
	that points to the collection owner"
	
	sourceField == nil ifTrue: [sourceField := self collectionTable fieldAccessing: #sourceID].
	
	^sourceField!

sourceField: anSSWDBField

	"sourceField stores the SSWDBField in the receiver's collectionTable
	that points to the collection owner"
	
	sourceField := anSSWDBField!

targetField

	"targetField stores the SSWDBField in the receiver's collectionTable
	that points to the objects that belong in the collection"
	
	targetField == nil ifTrue: [targetField := self collectionTable fieldAccessing: #target].
	
	^targetField!

targetField: anSSWDBField

	"targetField stores the SSWDBField in the receiver's collectionTable
	that points to the objects that belong in the collection"
	
	targetField := anSSWDBField! !
!SSWDBGeneralCollectionSpec categoriesForMethods!
allAdditionsTo:!change detection!public! !
changesTo:from:!change detection!public! !
collectionTable!accessing!public! !
collectionTable:!accessing!public! !
containedTables!evaluating!public! !
createCollectionTable!initializing!public! !
deleteEntry:!actions - api!public! !
entryClass!constants!public! !
equalityChangesTo:from:!change detection!private! !
identityChangesTo:from:!change detection!private! !
insertEntry:!actions - api!public! !
queryClass!constants!public! !
shouldCompareChangesByEquality!change detection!private!testing! !
sourceField!accessing!public! !
sourceField:!accessing!public! !
targetField!accessing!public! !
targetField:!accessing!public! !
!


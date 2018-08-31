"Filed out from Dolphin Smalltalk 7"!

SSWDBCollectionSpec subclass: #SSWDBGeneralCollectionSpec
	instanceVariableNames: 'sourceField targetField collectionTable'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBGeneralCollectionSpec guid: (GUID fromString: '{266e4dd2-398e-11d5-b1df-444553540000}')!
SSWDBGeneralCollectionSpec comment: 'Copyright 2000/2001 Solutions Software Limited'!
!SSWDBGeneralCollectionSpec categoriesForClass!Unclassified! !
!SSWDBGeneralCollectionSpec methodsFor!

collectionTable

	"20/8/2000
	
	collectionTable stores an SSWDBTable that is used to store 'instances'
	of the collection modelled by the receiver"
	
	collectionTable == nil ifTrue: [self createCollectionTable].
	
	^collectionTable!

collectionTable: anSSWDBTable

	"20/8/2000
	
	collectionTable stores an SSWDBTable that is used to store 'instances'
	of the collection modelled by the receiver"
	
	collectionTable := anSSWDBTable!

containedTables

	"19/4/2001"

	^Array with: self collectionTable!

createCollectionTable

	"Created 20/8/2000
	Modified: 12/9/2001	Use dialect name transformation/apply dialect (issue#0007)"
		
	| sourceName targetName |
	
	sourceName := self table containedTableNameRoot.
	targetName := self table sqlDialect transformName: self accessor name.
	
	self collectionTable: 
		(self entryClass dbTableNamed: (sourceName, targetName) in: self table reStore)!

deleteEntry: anSSWDBCollectionEntry in: anSSWReStore 

	"15/9/2000"
	
	anSSWDBCollectionEntry table: self collectionTable.

	anSSWReStore executeQuery: (SSWSQLDeleteObjectQuery forObject: anSSWDBCollectionEntry)!

entryClass

	"18/9/2000
	
	Return the class of collection entry appropriate for the receiver"
	
	^SSWDBCollectionEntry!

insertEntry: anSSWDBCollectionEntry in: anSSWReStore 

	"15/9/2000"
		
	anSSWReStore executeQuery: (SSWSQLInsertQuery forObject: anSSWDBCollectionEntry)!

queryClass

	"18/9/2000
	
	Return the class of select query appropriate for the receiver"
	
	^SSWSQLSelectQuery!

sourceField

	"20/8/2000
	
	sourceField stores the SSWDBField in the receiver's collectionTable
	that points to the collection owner"
	
	sourceField == nil ifTrue: [sourceField := self collectionTable fieldAccessing: #sourceID].
	
	^sourceField!

sourceField: anSSWDBField

	"20/8/2000
	
	sourceField stores the SSWDBField in the receiver's collectionTable
	that points to the collection owner"
	
	sourceField := anSSWDBField!

targetField

	"20/8/2000
	
	targetField stores the SSWDBField in the receiver's collectionTable
	that points to the objects that belong in the collection"
	
	targetField == nil ifTrue: [targetField := self collectionTable fieldAccessing: #target].
	
	^targetField!

targetField: anSSWDBField

	"20/8/2000
	
	targetField stores the SSWDBField in the receiver's collectionTable
	that points to the objects that belong in the collection"
	
	targetField := anSSWDBField! !
!SSWDBGeneralCollectionSpec categoriesFor: #collectionTable!accessing!public! !
!SSWDBGeneralCollectionSpec categoriesFor: #collectionTable:!accessing!public! !
!SSWDBGeneralCollectionSpec categoriesFor: #containedTables!evaluating!public! !
!SSWDBGeneralCollectionSpec categoriesFor: #createCollectionTable!initializing!public! !
!SSWDBGeneralCollectionSpec categoriesFor: #deleteEntry:in:!actions - api!public! !
!SSWDBGeneralCollectionSpec categoriesFor: #entryClass!constants!public! !
!SSWDBGeneralCollectionSpec categoriesFor: #insertEntry:in:!actions - api!public! !
!SSWDBGeneralCollectionSpec categoriesFor: #queryClass!constants!public! !
!SSWDBGeneralCollectionSpec categoriesFor: #sourceField!accessing!public! !
!SSWDBGeneralCollectionSpec categoriesFor: #sourceField:!accessing!public! !
!SSWDBGeneralCollectionSpec categoriesFor: #targetField!accessing!public! !
!SSWDBGeneralCollectionSpec categoriesFor: #targetField:!accessing!public! !


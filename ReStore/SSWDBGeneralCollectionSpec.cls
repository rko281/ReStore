"Filed out from Dolphin Smalltalk 7"!

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

deleteEntry: anSSWDBCollectionEntry in: anSSWReStore 

	anSSWDBCollectionEntry table: self collectionTable.

	anSSWReStore executeQuery: (SSWSQLDeleteObjectQuery forObject: anSSWDBCollectionEntry)!

entryClass

	"Return the class of collection entry appropriate for the receiver"
	
	^SSWDBCollectionEntry!

insertEntry: anSSWDBCollectionEntry in: anSSWReStore 

	anSSWReStore executeQuery: (SSWSQLInsertQuery forObject: anSSWDBCollectionEntry)!

queryClass

	"Return the class of select query appropriate for the receiver"
	
	^SSWSQLSelectQuery!

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


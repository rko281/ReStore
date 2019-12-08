"Filed out from Dolphin Smalltalk 7"!

SSWSQLQuery subclass: #SSWSQLTableQuery
	instanceVariableNames: 'tables'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLTableQuery guid: (GUID fromString: '{6266c931-3983-11d5-b1df-444553540000}')!
SSWSQLTableQuery comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLTableQuery categoriesForClass!Unclassified! !
!SSWSQLTableQuery methodsFor!

addTable: anSSWDBTable joinedWithField: anSSWDBField

	"Return the table added"
	
	^self tables addAliasingDuplicates: anSSWDBTable joinedWithField: anSSWDBField!

table

	"Return the single table used by this query"
	
	^self tables soleTable!

table: anSSWDBTable

	"Set the single table used by this query. Also used to set the initial table in a series of tables 
	- subsequent tables should be added using addTable:joinWith:"
	
	self tables soleTable: anSSWDBTable!

tables

	"tables stores an SSWSQLJoinedTableCollection of SSWDBTable involved in the receiver query.
	If the receiver only needs/supports a single table, it should use table/table:"
	
	^tables!

tables: anSSWSQLJoinedTableCollection

	"tables stores an SSWSQLJoinedTableCollection of SSWDBTable involved in the receiver query.
	If the receiver only needs/supports a single table, it should use table/table:"
	
	tables := anSSWSQLJoinedTableCollection! !
!SSWSQLTableQuery categoriesFor: #addTable:joinedWithField:!adding/removing!public! !
!SSWSQLTableQuery categoriesFor: #table!accessing - derived!public! !
!SSWSQLTableQuery categoriesFor: #table:!accessing - derived!public! !
!SSWSQLTableQuery categoriesFor: #tables!accessing!public! !
!SSWSQLTableQuery categoriesFor: #tables:!accessing!public! !

!SSWSQLTableQuery class methodsFor!

new

	^super new
		tables: SSWSQLLeftJoinedTableCollection new;
		yourself! !
!SSWSQLTableQuery class categoriesFor: #new!instance creation!public! !


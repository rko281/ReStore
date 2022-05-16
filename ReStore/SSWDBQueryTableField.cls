"Filed out from Dolphin Smallalk"!

SSWDBQueryField subclass: #SSWDBQueryTableField
	instanceVariableNames: 'table accessorPath'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBQueryTableField guid: (GUID fromString: '{266e4dca-398e-11d5-b1df-444553540000}')!
SSWDBQueryTableField comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBQueryTableField categoriesForClass!Unclassified! !
!SSWDBQueryTableField methodsFor!

= anSSWDBField

	^self == anSSWDBField or: [anSSWDBField = self field and: [anSSWDBField table = self table]]!

accessorPath

	"The path of accessors from some originating table to this field"

	^accessorPath!

accessorPath: anObject

	"The path of accessors from some originating table to this field"

	accessorPath := anObject!

hash

	^self table hash bitXor: self name hash!

isInlined

	^self field isInlined!

printOn: aStream

	super printOn: aStream.
	aStream 
		nextPutAll: ' (';
		nextPutAll: self table name;
		nextPut: $.;
		nextPutAll: self name;
		nextPut: $)!

table

	"The receiver is created to stand in place of a regular SSWDBField when that field 
	is involved in a query where the same table is referenced more than once, via more than one field.

	Each reocurrence of the table is replaced (aliased) by an SSWDBQueryTable,
	and a reference to a field belonging to that table is replaced by an instance of the receiver's class.
	
	table stores the SSWDBQueryTable to which the receiver field belongs"
	
	^table!

table: anSSWDBQueryTable

	"The receiver is created to stand in place of a regular SSWDBField when that field 
	is involved in a query where the same table is referenced more than once, via more than one field.

	Each reocurrence of the table is replaced (aliased) by an SSWDBQueryTable,
	and a reference to a field belonging to that table is replaced by an instance of the receiver's class.
	
	table stores the SSWDBQueryTable to which the receiver field belongs"
	
	table := anSSWDBQueryTable!

writeAliasedSQLOn: aStream

	"For situations where duplicate field names are anticipated
	- write the SQL of the receiver on aStream, but use aliased names to force uniqueness"
	aStream nextPutAliasedField: self!

writeSQLOn: aStream

	"Use <table name>.<field name> notation to avoid ambiguity"
	
	self table writeSQLNameOn: aStream.
	
	aStream 
		nextPut: $.;
		nextPutIdentifier: self name! !
!SSWDBQueryTableField categoriesForMethods!
=!comparing!public! !
accessorPath!accessing!public! !
accessorPath:!accessing!public! !
hash!comparing!public! !
isInlined!public!testing! !
printOn:!output!public! !
table!accessing!public! !
table:!accessing!public! !
writeAliasedSQLOn:!output!public! !
writeSQLOn:!output!public! !
!

!SSWDBQueryTableField class methodsFor!

forField: anSSWDBField in: anSSWDBQueryTable

	^self forField: anSSWDBField in: anSSWDBQueryTable path: #()!

forField: anSSWDBField in: anSSWDBQueryTable path: anArray

	^self new
		field: anSSWDBField;
		table: anSSWDBQueryTable;
		accessorPath: anArray;
		yourself! !
!SSWDBQueryTableField class categoriesForMethods!
forField:in:!instance creation!public! !
forField:in:path:!instance creation!public! !
!


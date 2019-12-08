"Filed out from Dolphin Smalltalk 7"!

SSWSQLTableComponent subclass: #SSWSQLField
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLField guid: (GUID fromString: '{767240f8-a555-11d5-b1e0-444553540000}')!
SSWSQLField comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLField categoriesForClass!Unclassified! !
!SSWSQLField methodsFor!

= anSSWDBField

	^self == anSSWDBField 
		or: [self table = anSSWDBField table and: [self name = anSSWDBField name]]!

canBeParameterized

	^true!

fieldNamed: aString

	"Polymorphic with field collections"

	^self name = aString 
		ifTrue: [self]
		ifFalse: [nil]!

hash

	^self table hash bitXor: self name hash!

isFieldCollection

	"Just a single field"

	^false!

name

	"name stores the name of this field"
	
	^name!

name: aString

	"name stores the name of this field"
	
	name := aString!

requiresAliasing

	"Return whether this field always requires aliasing"
	^false!

sqlCanBeParameterized

	"When expressing this field as a value, can its SQL be parameterized?
	Different to canBeParameterized!!"

	^false!

withFunction: aString arguments: aCollection

	"Return an SSWSQLFunctionField base on the receiver with the given function String and arguments"
	
	^SSWSQLFunctionField new
		table: self table;
		name: self name;
		function: aString;
		arguments: aCollection;
		yourself!

writeAliasedSQLOn: aStream

	"For situations where duplicate field names are anticipated
	- write the SQL of the receiver on aStream, but use aliased names to force uniqueness"
	
	aStream nextPutAliasedField: self!

writeSQLForUpdateOn: aStream

	"Write the receiver field to aStream, specifically as part of an Update query.
	At present, ReStore only supports updates against one table (i.e. no joins).
	Hence the <table name>. prefix is unnecessary in update queries - in fact it is specifically disallowed in some DBs"

	^aStream nextPutIdentifier: self name!

writeSQLOn: aStream

	"Use <table name>.<field name> notation to avoid ambiguity"

	self table writeSQLNameOn: aStream.

	aStream 
		nextPut: $.;
		nextPutIdentifier: self name! !
!SSWSQLField categoriesFor: #=!comparing!public! !
!SSWSQLField categoriesFor: #canBeParameterized!public!testing! !
!SSWSQLField categoriesFor: #fieldNamed:!accessing!public! !
!SSWSQLField categoriesFor: #hash!comparing!public! !
!SSWSQLField categoriesFor: #isFieldCollection!public!testing! !
!SSWSQLField categoriesFor: #name!accessing!public! !
!SSWSQLField categoriesFor: #name:!accessing!public! !
!SSWSQLField categoriesFor: #requiresAliasing!public!testing! !
!SSWSQLField categoriesFor: #sqlCanBeParameterized!public!testing! !
!SSWSQLField categoriesFor: #withFunction:arguments:!evaluating!public! !
!SSWSQLField categoriesFor: #writeAliasedSQLOn:!output!public! !
!SSWSQLField categoriesFor: #writeSQLForUpdateOn:!output!public! !
!SSWSQLField categoriesFor: #writeSQLOn:!output!public! !

!SSWSQLField class methodsFor!

allFieldsInTable: anSSWSQLTable

	"Create and return a 'field' to represent the SQL concept of all fields (*) for the given table"
	
	^self new
		table: anSSWSQLTable;
		name: '*';
		yourself! !
!SSWSQLField class categoriesFor: #allFieldsInTable:!instance creation!public! !


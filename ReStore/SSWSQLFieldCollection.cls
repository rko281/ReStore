"Filed out from Dolphin Smallalk"!

SSWSQLCollection variableSubclass: #SSWSQLFieldCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLFieldCollection guid: (GUID fromString: '{6266c924-3983-11d5-b1df-444553540000}')!
SSWSQLFieldCollection comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLFieldCollection categoriesForClass!Unclassified! !
!SSWSQLFieldCollection methodsFor!

fieldNamed: aString

	"Return the individual field with the given name"

	1 to: self size do: [ :index | ((self at: index) fieldNamed: aString) ifNotNil: [ :match | ^match]].

	^nil!

isAll

	"Since an empty field collection makes no sense, we use this to mean 'all fields' "
	
	^self isEmpty!

isAllInTable

	"Return whether the receiver represents all fields in a specific table,
	as opposed to all fields in a query, which is the definition of isAll.

	Technically this cannot be decided from the field collection alone 
	however we have a specific class to represent this concept.
	Hence - return false"
	
	^false!

isFieldCollection

	^true!

requiresAliasing

	"Query individual fields"
	^self anySatisfy: [ :each | each requiresAliasing]!

sqlConcatenator

	"A comma is used to separate a list of tables in SQL"
	
	^', '!

writeAliasedSQLOn: aStream

	"For situations where duplicate field names are anticipated
	- write the SQL of the receiver on aStream, but use aliased names to force uniqueness"

	self first writeAliasedSQLOn: aStream.
	
	2 to: self size do:
		[ :index || sqlEntity |
		sqlEntity := self at: index.
		aStream nextPutAll: self sqlConcatenator.
		sqlEntity writeAliasedSQLOn: aStream]!

writeSQLOn: aStream

	^self isAll
		ifTrue: [aStream nextPut: $*]
		ifFalse: [super writeSQLOn: aStream]! !
!SSWSQLFieldCollection categoriesForMethods!
fieldNamed:!accessing!public! !
isAll!public!testing! !
isAllInTable!public!testing! !
isFieldCollection!public!testing! !
requiresAliasing!public!testing! !
sqlConcatenator!output!public! !
writeAliasedSQLOn:!output!public! !
writeSQLOn:!output!public! !
!


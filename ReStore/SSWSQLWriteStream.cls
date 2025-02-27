"Filed out from Dolphin Smalltalk"!

WriteStream subclass: #SSWSQLWriteStream
	instanceVariableNames: 'dialect fieldAliases tableAliases parameterizedFields parameterizedValues placeholderCount'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWSQLWriteStream guid: (GUID fromString: '{3d2e72e1-a7ae-11d5-b1e0-444553540000}')!

SSWSQLWriteStream comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!

!SSWSQLWriteStream categoriesForClass!Unclassified! !

!SSWSQLWriteStream methodsFor!

dialect

	"dialect stores the SSWSQLDialect of the database for which the receiver stream is writing SQL"

	^dialect!

dialect: anSSWSQLDialect

	"dialect stores the SSWSQLDialect of the database for which the receiver stream is writing SQL"

	dialect := anSSWSQLDialect!

fieldAliases

	"fieldAliases stores an IdentityDictionary mapping SSWSQLFields to an aliased name
	assigned to that field by the receiver"

	^fieldAliases!

fieldAliases: anIdentityDictionary

	"fieldAliases stores an IdentityDictionary mapping SSWSQLFields to an aliased name
	assigned to that field by the receiver"

	fieldAliases := anIdentityDictionary!

hasParameterizedFields

	^self parameterizedFields isEmpty not!

nextFieldAlias

	^self dialect transformInstVarName: ('field_', (self fieldAliases size + 1) printString) asSymbol

!

nextPut: anObject forField: aField

	"Always use a parameterized field if possible"

	(aField canBeParameterized and: [anObject sqlCanBeParameterized]) 
		ifTrue: [self nextPutParameterizedValue: anObject forField: aField]
		ifFalse: [anObject writeSQLOn: self]!

nextPutAliasedField: anSSWSQLField

	"Append to the receiver an aliased representation of anSSWSQLField"

	anSSWSQLField writeSQLOn: self.
	self
		nextPutAll: ' AS ';
		nextPutAll: (self fieldAliases at: anSSWSQLField ifAbsentPut: [self nextFieldAlias])!

nextPutAliasedTable: anSSWSQLTable

	"Append to the receiver an aliased representation of anSSWSQLTable"

	self nextPutAll: (self tableAliases at: anSSWSQLTable ifAbsentPut: [self nextTableAlias])!

nextPutIdentifier: aString

	self 
		nextPut: self dialect identifierQuoteOpen;
		nextPutAll: aString;
		nextPut: self dialect identifierQuoteClose!

nextPutParameterizedValue: anObject forField: aField

	self nextPutParameterPlaceholder.
	self parameterizedFields add: aField.
	self parameterizedValues add: anObject!

nextPutParameterPlaceholder

	self placeholderCount: self placeholderCount + 1.
	self dialect printParameterPlaceholder: self placeholderCount on: self!

nextPutPossiblyAliasedField: anSSWSQLField

	"Append to the receiver anSSWSQLField, using any already-defined alias"

	(self fieldAliases at: anSSWSQLField  ifAbsent: [nil])
		ifNil: [anSSWSQLField writeSQLOn: self]
		ifNotNil: [ :alias | self nextPutAll: alias]!

nextTableAlias

	^self dialect transformClassName: ('table', (self tableAliases size + 1) printString) asSymbol!

parameterizedFields
	^parameterizedFields!

parameterizedFields: anObject
	parameterizedFields := anObject!

parameterizedValues
	^parameterizedValues!

parameterizedValues: anObject
	parameterizedValues := anObject!

placeholderCount
	^placeholderCount!

placeholderCount: anObject
	placeholderCount := anObject!

tableAliases

	"tableAliases stores an IdentityDictionary mapping SSWSQLTables to an aliased name
	assigned to that field by the receiver"

	^tableAliases!

tableAliases: anIdentityDictionary

	"tableAliases stores an IdentityDictionary mapping SSWSQLTables to an aliased name
	assigned to that field by the receiver"

	tableAliases := anIdentityDictionary!

writeSQLFor: anObject

	anObject writeSQLOn: self! !

!SSWSQLWriteStream categoriesForMethods!
dialect!accessing!public! !
dialect:!accessing!public! !
fieldAliases!accessing!public! !
fieldAliases:!accessing!public! !
hasParameterizedFields!public!testing! !
nextFieldAlias!accessing!public! !
nextPut:forField:!printing!public! !
nextPutAliasedField:!printing!public! !
nextPutAliasedTable:!printing!public! !
nextPutIdentifier:!printing!public! !
nextPutParameterizedValue:forField:!printing!public! !
nextPutParameterPlaceholder!printing!public! !
nextPutPossiblyAliasedField:!printing!public! !
nextTableAlias!accessing!public! !
parameterizedFields!accessing!private! !
parameterizedFields:!accessing!private! !
parameterizedValues!accessing!private! !
parameterizedValues:!accessing!private! !
placeholderCount!accessing!public! !
placeholderCount:!accessing!public! !
tableAliases!accessing!public! !
tableAliases:!accessing!public! !
writeSQLFor:!printing!public! !
!

!SSWSQLWriteStream class methodsFor!

newIn: anSSWSQLDialect

	^(self on: (String new: 32))
		dialect: anSSWSQLDialect;
		fieldAliases: IdentityDictionary new;
		tableAliases: IdentityDictionary new;
		parameterizedFields: OrderedCollection new;
		parameterizedValues: OrderedCollection new;
		placeholderCount: 0;
		yourself! !

!SSWSQLWriteStream class categoriesForMethods!
newIn:!instance creation!public! !
!


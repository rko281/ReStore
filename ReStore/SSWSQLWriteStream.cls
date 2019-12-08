"Filed out from Dolphin Smalltalk 7"!

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

	tableAliases := anIdentityDictionary! !
!SSWSQLWriteStream categoriesFor: #dialect!accessing!public! !
!SSWSQLWriteStream categoriesFor: #dialect:!accessing!public! !
!SSWSQLWriteStream categoriesFor: #fieldAliases!accessing!public! !
!SSWSQLWriteStream categoriesFor: #fieldAliases:!accessing!public! !
!SSWSQLWriteStream categoriesFor: #hasParameterizedFields!public!testing! !
!SSWSQLWriteStream categoriesFor: #nextFieldAlias!accessing!public! !
!SSWSQLWriteStream categoriesFor: #nextPut:forField:!printing!public! !
!SSWSQLWriteStream categoriesFor: #nextPutAliasedField:!printing!public! !
!SSWSQLWriteStream categoriesFor: #nextPutAliasedTable:!printing!public! !
!SSWSQLWriteStream categoriesFor: #nextPutIdentifier:!printing!public! !
!SSWSQLWriteStream categoriesFor: #nextPutParameterizedValue:forField:!printing!public! !
!SSWSQLWriteStream categoriesFor: #nextPutParameterPlaceholder!printing!public! !
!SSWSQLWriteStream categoriesFor: #nextTableAlias!accessing!public! !
!SSWSQLWriteStream categoriesFor: #parameterizedFields!accessing!private! !
!SSWSQLWriteStream categoriesFor: #parameterizedFields:!accessing!private! !
!SSWSQLWriteStream categoriesFor: #parameterizedValues!accessing!private! !
!SSWSQLWriteStream categoriesFor: #parameterizedValues:!accessing!private! !
!SSWSQLWriteStream categoriesFor: #placeholderCount!accessing!public! !
!SSWSQLWriteStream categoriesFor: #placeholderCount:!accessing!public! !
!SSWSQLWriteStream categoriesFor: #tableAliases!accessing!public! !
!SSWSQLWriteStream categoriesFor: #tableAliases:!accessing!public! !

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
!SSWSQLWriteStream class categoriesFor: #newIn:!instance creation!public! !


"Filed out from Dolphin Smalltalk"!

DBVarCharBuffer subclass: #SSWODBCVarCharBuffer
	instanceVariableNames: 'sqlDialect'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWODBCVarCharBuffer guid: (GUID fromString: '{4c1ae635-9f50-46f8-868f-107f99267483}')!

SSWODBCVarCharBuffer comment: ''!

!SSWODBCVarCharBuffer categoriesForClass!Unclassified! !

!SSWODBCVarCharBuffer methodsFor!

dbConvert: anObject for: aDBField
	"Convert the argument to an <AnsiString> for marshalling to SQL_C_CHAR representation in the <DBField> 2nd argument. Throw an error if this is not possible."

	^anObject asSQLStringIn: sqlDialect!

initializeForColumn: anSSWODBCColAttr

	super initializeForColumn: anSSWODBCColAttr.
	anSSWODBCColAttr field ifNotNil: [ :field | sqlDialect := field sqlDialect]! !

!SSWODBCVarCharBuffer categoriesForMethods!
dbConvert:for:!operations!public! !
initializeForColumn:!initializing!public! !
!


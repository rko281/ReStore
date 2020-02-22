"Filed out from Dolphin Smalltalk 7"!

SSWSQLDialect subclass: #SSWPostgreSQLDialect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWPostgreSQLDialect guid: (GUID fromString: '{12d8994a-38c7-47ee-9760-30dd5a44471a}')!
SSWPostgreSQLDialect comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWPostgreSQLDialect categoriesForClass!Unclassified! !
!SSWPostgreSQLDialect methodsFor!

alterField: aField table: aTable in: aReStore

	aReStore executeSQLFrom: 
		[ :stream | 
		stream 
			nextPutAll: 'ALTER TABLE ';
			nextPutIdentifier: aTable name;
			nextPutAll: ' ALTER COLUMN ';
			nextPutIdentifier: aField name;
			nextPutAll: ' TYPE '.
		aField targetClass writeSQLTypeOn: stream using: self]!

datetime

	^'TIMESTAMP'!

datetimeWithResolution

	^'TIMESTAMP(<1p>)'!

defaultDateTimeResolution

	^6!

defaultMaxColumnNameLength

	^63!

defaultMaxTableNameLength

	^63!

dialectSpecificFunctions

	^Dictionary new

		"String functions"
		at: #size put: 'CHAR_LENGTH(%1)' asSQLFunctionIntegerResult;
		at: #asciiValue put: 'ASCII(%1)' asSQLFunctionIntegerResult;
		at: #indexOfSubCollection: put: 'POSITION(%2,%1)' asSQLFunctionIntegerResult;

		"Date functions"
		at: #dayOfMonth put: 'DATEPART(''day'',%1)' asSQLFunctionIntegerResult;
		at: #monthIndex put: 'DATEPART(''month'',%1)' asSQLFunctionIntegerResult;
		at: #year put: 'DATEPART(''yyyy'',%1)' asSQLFunctionIntegerResult;

		at: #ifNil: put: 'COALESCE(%1,%2)' asSQLFunction;
		at: #ifNull: put: 'COALESCE(%1,%2)' asSQLFunction;

		yourself!

double

	^'DOUBLE PRECISION'!

identifierQuoteClose

	^$"!

identifierQuoteOpen

	^$"!

maxCharacter

	"Technically 1GB, but limit it to something reasonable"

	^65535!

renameField: oldField to: newField in: aReStore

	aReStore executeSQLFrom: 
		[ :stream | 
		stream 
			nextPutAll: 'ALTER TABLE ';
			nextPutIdentifier: newField table name;
			nextPutAll: ' RENAME ';
			nextPutIdentifier: oldField name;
			nextPutAll: ' TO ';
			nextPutIdentifier: newField name]!

shouldCheckAutoCommit

	^true!

shouldMaskSuccessWithInfo

	^true! !
!SSWPostgreSQLDialect categoriesFor: #alterField:table:in:!maintenance!public! !
!SSWPostgreSQLDialect categoriesFor: #datetime!datatypes!public! !
!SSWPostgreSQLDialect categoriesFor: #datetimeWithResolution!datatypes!public! !
!SSWPostgreSQLDialect categoriesFor: #defaultDateTimeResolution!constants!public! !
!SSWPostgreSQLDialect categoriesFor: #defaultMaxColumnNameLength!constants!public! !
!SSWPostgreSQLDialect categoriesFor: #defaultMaxTableNameLength!constants!public! !
!SSWPostgreSQLDialect categoriesFor: #dialectSpecificFunctions!constants!public! !
!SSWPostgreSQLDialect categoriesFor: #double!datatypes!public! !
!SSWPostgreSQLDialect categoriesFor: #identifierQuoteClose!constants!public! !
!SSWPostgreSQLDialect categoriesFor: #identifierQuoteOpen!constants!public! !
!SSWPostgreSQLDialect categoriesFor: #maxCharacter!constants!public! !
!SSWPostgreSQLDialect categoriesFor: #renameField:to:in:!maintenance!public! !
!SSWPostgreSQLDialect categoriesFor: #shouldCheckAutoCommit!public!testing! !
!SSWPostgreSQLDialect categoriesFor: #shouldMaskSuccessWithInfo!public!testing! !

!SSWPostgreSQLDialect class methodsFor!

dbmsName

	^'PostgreSQL'! !
!SSWPostgreSQLDialect class categoriesFor: #dbmsName!constants!public! !


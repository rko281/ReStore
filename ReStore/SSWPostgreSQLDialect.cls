"Filed out from Dolphin Smalltalk"!

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
			writeSQLFor: aTable;
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

defaultStandardNamespace

	^'public'!

dialectSpecificFunctions

	^Dictionary new

		"String functions"
		at: #size put: 'CHAR_LENGTH(%1)' asSQLFunctionIntegerResult;
		at: #asciiValue put: 'ASCII(%1)' asSQLFunctionIntegerResult;
		at: #indexOfSubCollection: put: 'POSITION(%2,%1)' asSQLFunctionIntegerResult;

		"Date functions"
		at: #dayOfMonth put: 'EXTRACT(DAY FROM %1)' asSQLFunctionIntegerResult;
		at: #monthIndex put: 'EXTRACT(MONTH FROM %1)' asSQLFunctionIntegerResult;
		at: #year put: 'EXTRACT(YEAR FROM %1)' asSQLFunctionIntegerResult;

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

onConnected: aConnection

	"ReStore has removed support for non-numeric Booleans.
	Ensure the 'bools as chars' option isn't set"

	(aConnection query: 'select true') first contents first = '1' ifTrue: 
		[self error: 'Bools as Char connection option is set; this is no longer supported in ReStore. Please unset this option in the connection configuration'].

	super onConnected: aConnection!

renameField: oldField to: newField in: aReStore

	aReStore executeSQLFrom: 
		[ :stream | 
		stream 
			nextPutAll: 'ALTER TABLE ';
			writeSQLFor: newField table;
			nextPutAll: ' RENAME ';
			nextPutIdentifier: oldField name;
			nextPutAll: ' TO ';
			nextPutIdentifier: newField name]!

unsizedBlob

	^'bytea'!

uuid

	^'uuid'! !

!SSWPostgreSQLDialect categoriesForMethods!
alterField:table:in:!maintenance!public! !
datetime!datatypes!public! !
datetimeWithResolution!datatypes!public! !
defaultDateTimeResolution!constants!public! !
defaultMaxColumnNameLength!constants!public! !
defaultMaxTableNameLength!constants!public! !
defaultStandardNamespace!constants!public! !
dialectSpecificFunctions!constants!public! !
double!datatypes!public! !
identifierQuoteClose!constants!public! !
identifierQuoteOpen!constants!public! !
maxCharacter!constants!public! !
onConnected:!event handling!public! !
renameField:to:in:!maintenance!public! !
unsizedBlob!datatypes!public! !
uuid!datatypes!public! !
!

!SSWPostgreSQLDialect class methodsFor!

dbmsName

	^'PostgreSQL'! !

!SSWPostgreSQLDialect class categoriesForMethods!
dbmsName!constants!public! !
!


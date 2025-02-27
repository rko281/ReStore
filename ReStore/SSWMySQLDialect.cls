"Filed out from Dolphin Smalltalk"!

SSWSQLDialect subclass: #SSWMySQLDialect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWMySQLDialect guid: (GUID fromString: '{6645ca35-73aa-4a51-b909-d0cb2f7c228b}')!

SSWMySQLDialect comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!

!SSWMySQLDialect categoriesForClass!Unclassified! !

!SSWMySQLDialect methodsFor!

alterField: aField table: aTable in: aReStore

	aReStore executeSQLFrom: 
		[ :stream | 
		stream 
			nextPutAll: 'ALTER TABLE ';
			writeSQLFor: aTable;
			nextPutAll: ' MODIFY COLUMN '.
		aField writeSQLDefinitionOn: stream]!

blobTypes

	"Full use of MEDIUMBLOB and LONGBLOB will require increasing the default maxColumnBytes (unrealistically so for LONGBLOB)"

	^OrderedCollection new
		add: (self maxVarchar "same as max VARBINARY" -> 'VARBINARY(<1p>)');
		add: (65535 "((2 raisedTo: 16) - 1)" -> 'BLOB');
		add: (16777215 "((2 raisedTo: 24) - 1)" -> 'MEDIUMBLOB');
		add: (4294967295 "((2 raisedTo: 32) - 1)" -> 'LONGBLOB');
		yourself!

boolean

	^'TINYINT'!

defaultMaxColumnNameLength

	^64!

defaultMaxTableNameLength

	^64!

defaultTimeResolution

	^3!

dialectSpecificFunctions

	^Dictionary new

		"Conversion functions"
		at: #asInteger put: 'CAST(%1 AS UNSIGNED)' asSQLFunctionIntegerResult;

		"String functions"
		at: #, put: 'CONCAT(%1,%2)' asSQLFunction;
		at: #size put: 'CHAR_LENGTH(%1)' asSQLFunctionIntegerResult;
		at: #leftString: put: 'LEFT(%1,%2)' asSQLFunction;
		at: #rightString: put: 'RIGHT(%1,%2)' asSQLFunction;
		at: #asciiValue put: 'ASCII(%1)' asSQLFunctionIntegerResult;
		at: #indexOfSubCollection: put: 'LOCATE(%2,%1)' asSQLFunctionIntegerResult;
		at: #indexOfSubCollection:startingAt: put: 'LOCATE(%2,%1,%3)' asSQLFunctionIntegerResult;
		at: #replaceAllOccurencesOf:with: put: 'REPLACE(%1,%2,%3)' asSQLFunction;
		at: #reverse put: 'REVERSE(%1)' asSQLFunction;
		at: #replaceFrom:length:with: put: 'INSERT(%1,%2,%3,%4)' asSQLFunction;

		"Date functions"
		at: #addDays: put: 'DATE_ADD(%1, INTERVAL %2 DAY)' asSQLFunction;
		at: #addMonths: put: 'DATE_ADD(%1, INTERVAL %2 MONTH)' asSQLFunction;
		at: #addYears: put: 'DATE_ADD(%1, INTERVAL %2 YEAR)' asSQLFunction;
		at: #subtractDays: put: 'DATE_SUB(%1, INTERVAL %2 DAY)' asSQLFunction;
		at: #weekday put: 'DAYNAME(%1)' asSQLFunctionStringResult;
		at: #dayOfMonth put: 'DAYOFMONTH(%1)' asSQLFunctionIntegerResult;
		at: #day put: 'DAYOFYEAR(%1)' asSQLFunctionIntegerResult;
		at: #monthIndex put: 'MONTH(%1)' asSQLFunctionIntegerResult;
		at: #monthName put: 'MONTHNAME(%1)' asSQLFunctionStringResult ;
		at: #year put: 'YEAR(%1)' asSQLFunctionIntegerResult;

		yourself!

maxVarchar

	"MySQL's limit is technically 65535, but this is for an entire row.
	2KB should be safe enough that we don't exceed this, whilst being reasonably large"

	^2048!

renameField: oldField to: newField in: aReStore

	aReStore executeSQLFrom: 
		[ :stream | 
		stream 
			nextPutAll: 'ALTER TABLE ';
			writeSQLFor: newField table;
			nextPutAll: ' CHANGE ';
			nextPutIdentifier: oldField name;
			space.
		newField writeSQLDefinitionOn: stream]!

renameTable: oldTable to: newTable in: anSSWReStore

	anSSWReStore executeSQLFrom: 
		[ :stream | 
		stream 
			nextPutAll: 'ALTER TABLE ';
			writeSQLFor: oldTable;
			nextPutAll: ' RENAME TO ';
			writeSQLFor: newTable]  "<-subtle difference; MySQL needs the fully-qualified new name in case of namespace qualification, or the table will move to the standard namespace"!

supportsDeleteWithJoin

	"Answer whether this dialect supports DELETE queries featuring JOINs"

	^true!

supportsMultipleAddColumns

	^true!

unsizedStringTypes

	"Full use of MEDIUMTEXT and LONGTEXT will require increasing the default maxColumnBytes (unrealistically so for LONGTEXT)"

	^OrderedCollection new
		add: (65535 "((2 raisedTo: 16) - 1)" -> 'TEXT');
		add: (16777215 "((2 raisedTo: 24) - 1)" -> 'MEDIUMTEXT');
		add: (4294967295 "((2 raisedTo: 32) - 1)" -> 'LONGTEXT');
		yourself!

uuid

	^'BINARY(16)'! !

!SSWMySQLDialect categoriesForMethods!
alterField:table:in:!maintenance!public! !
blobTypes!datatypes!public! !
boolean!datatypes!public! !
defaultMaxColumnNameLength!constants!public! !
defaultMaxTableNameLength!constants!public! !
defaultTimeResolution!constants!public! !
dialectSpecificFunctions!constants!public! !
maxVarchar!constants!public! !
renameField:to:in:!maintenance!public! !
renameTable:to:in:!maintenance!public! !
supportsDeleteWithJoin!public!testing! !
supportsMultipleAddColumns!public!testing! !
unsizedStringTypes!datatypes!public! !
uuid!datatypes!public! !
!

!SSWMySQLDialect class methodsFor!

dbmsName

	^'MySQL'! !

!SSWMySQLDialect class categoriesForMethods!
dbmsName!constants!public! !
!


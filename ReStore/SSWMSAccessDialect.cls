"Filed out from Dolphin Smalltalk 7"!

SSWSQLDialect subclass: #SSWMSAccessDialect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWMSAccessDialect guid: (GUID fromString: '{afd771ea-5cc7-4d40-9dc1-eb018e9e13c7}')!
SSWMSAccessDialect comment: ''!
!SSWMSAccessDialect categoriesForClass!Unclassified! !
!SSWMSAccessDialect methodsFor!

boolean

	^'YESNO'!

canDescribeParameters

	^false!

connectionReservedWords

	"Access 2013 (and others?) appears to (sometimes?) truncate the result of SQL_KEYWORDS to 255 characters, omitting some important reserved words (e.g. NUMBER).
	Attempt to handle this by comparing the connectionReservedWords with a complete set returned from an earlier version of Access.
	Prefer the hardcoded set if this is larger than the connection set"

	| expectedReservedWords |

	expectedReservedWords := #('ALPHANUMERIC' 'AUTOINCREMENT' 'BINARY' 'BYTE' 'COUNTER' 'CURRENCY' 'DATABASE' 'DATABASENAME' 'DATETIME' 'DISALLOW' 'DISTINCTROW' 'DOUBLEFLOAT' 'FLOAT4' 'FLOAT8' 'GENERAL' 'IEEEDOUBLE' 'IEEESINGLE' 'IGNORE' 'INT' 'INTEGER1' 'INTEGER2' 'INTEGER4' 'LEVEL' 'LOGICAL' 'LOGICAL1' 'LONG' 'LONGBINARY' 'LONGCHAR' 'LONGTEXT' 'MEMO' 'MONEY' 'NOTE' 'NUMBER' 'OLEOBJECT' 'OPTION' 'OWNERACCESS' 'PARAMETERS' 'PERCENT' 'PIVOT' 'SHORT' 'SINGLE' 'SINGLEFLOAT' 'SMALLINT' 'STDEV' 'STDEVP' 'STRING' 'TABLEID' 'TEXT' 'TOP' 'TRANSFORM' 'UNSIGNEDBYTE' 'VALUES' 'VAR' 'VARBINARY' 'VARP' 'YESNO').

	^expectedReservedWords size >= connectionReservedWords size
		ifTrue: [expectedReservedWords]
		ifFalse: [connectionReservedWords]!

date

	"No explicit date type"

	^self datetime!

datetimeWithResolution

	"Not supported"

	^self datetime!

dialectSpecificFunctions

	^##(Dictionary new

		"Numeric functions"
		at: #\\ put: '(%1 MOD %2)';

		"String functions"
		at: #, put: '(%1 + %2)';
		at: #midString:from: put: 'MID(%1,%3,%2)';
		at: #asciiValue put: 'ASC(%1)';
		at: #leftString: put: 'LEFT(%1,%2)';
		at: #rightString: put: 'RIGHT(%1,%2)';
		
		"Date functions"
		at: #addDays: put: 'DATEADD(''d'',%2,%1)';
		at: #addMonths: put: 'DATEADD(''m'',%2,%1)';
		at: #addYears: put: 'DATEADD(''yyyy'',%2,%1)';
		at: #dayOfMonth put: 'DATEPART(''d'',%1)';
		at: #monthIndex put: 'DATEPART(''m'',%1)';
		at: #year put: 'DATEPART(''yyyy'',%1)';

		yourself)!

longText

	^'LONGTEXT'!

maxAllocatedStatements

	"Access 2000 (v9.0.2720, driver 4.00.4403.02) seems to slowdown around 120 allocated statements"

	"Leave some headroom"
	^100!

maxDateTimeResolution

	^0!

renameTableNamed: oldName to: newName in: anSSWReStore

	anSSWReStore 
		executeSQL: ('SELECT * INTO %2 FROM %1' formatWith: oldName with: newName);
		executeSQL: ('DROP TABLE %1' formatWith: oldName)!

shouldMapEmptyStringsToNil

	"Return whether empty Strings should be mapped to nil before storage in the database.
	This can be useful for databases in which String fields default to 'Do not allow zero size' (usually this attribute cannot be set via ODBC/SQL)"

	^true!

time

	"No explicit time type"

	^self datetime!

trueObject

	^-1!

updateDelaySeconds

	"Arrived at anecdotally... refresh SUnit tests fail with 4 seconds, pass with 5"

	^5!

writeSQLForDate: aDate on: aStream

	self writeSQLForDateAndTime: aDate asDateAndTime on: aStream!

writeSQLForTime: aTime on: aStream

	self writeSQLForDateAndTime: aTime asDateAndTime on: aStream! !
!SSWMSAccessDialect categoriesFor: #boolean!datatypes!public! !
!SSWMSAccessDialect categoriesFor: #canDescribeParameters!public!testing! !
!SSWMSAccessDialect categoriesFor: #connectionReservedWords!constants!public! !
!SSWMSAccessDialect categoriesFor: #date!datatypes!public! !
!SSWMSAccessDialect categoriesFor: #datetimeWithResolution!datatypes!public! !
!SSWMSAccessDialect categoriesFor: #dialectSpecificFunctions!constants!public! !
!SSWMSAccessDialect categoriesFor: #longText!datatypes!public! !
!SSWMSAccessDialect categoriesFor: #maxAllocatedStatements!constants!public! !
!SSWMSAccessDialect categoriesFor: #maxDateTimeResolution!constants!public! !
!SSWMSAccessDialect categoriesFor: #renameTableNamed:to:in:!maintenance!public! !
!SSWMSAccessDialect categoriesFor: #shouldMapEmptyStringsToNil!public!testing! !
!SSWMSAccessDialect categoriesFor: #time!datatypes!public! !
!SSWMSAccessDialect categoriesFor: #trueObject!constants!public! !
!SSWMSAccessDialect categoriesFor: #updateDelaySeconds!constants!public! !
!SSWMSAccessDialect categoriesFor: #writeSQLForDate:on:!public!writing sql! !
!SSWMSAccessDialect categoriesFor: #writeSQLForTime:on:!public!writing sql! !

!SSWMSAccessDialect class methodsFor!

dbmsName

	^'ACCESS'! !
!SSWMSAccessDialect class categoriesFor: #dbmsName!constants!public! !


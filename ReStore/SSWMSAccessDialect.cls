"Filed out from Dolphin Smalltalk 7"!

SSWSQLDialect subclass: #SSWMSAccessDialect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWMSAccessDialect guid: (GUID fromString: '{afd771ea-5cc7-4d40-9dc1-eb018e9e13c7}')!
SSWMSAccessDialect comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWMSAccessDialect categoriesForClass!Unclassified! !
!SSWMSAccessDialect methodsFor!

boolean

	^'YESNO'!

canDescribeParameters

	^false!

date

	"No explicit date type"

	^self datetime!

datetimeWithResolution

	"Not supported"

	^self datetime!

defaultMaxColumnNameLength

	^64!

defaultMaxTableNameLength

	^64!

dialectSpecificFunctions

	^Dictionary new

		"Conversion functions"
		at: #asInteger put: 'ROUND(%1,0)' asSQLFunctionIntegerResult;

		"Numeric functions"
		at: #\\ put: '(%1 MOD %2)' asSQLFunctionIntegerResult;

		"String functions"
		at: #, put: '(%1 + %2)' asSQLFunction;
		at: #midString:from: put: 'MID(%1,%3,%2)' asSQLFunction;
		at: #asciiValue put: 'ASC(%1)' asSQLFunctionIntegerResult;
		at: #leftString: put: 'LEFT(%1,%2)' asSQLFunction;
		at: #rightString: put: 'RIGHT(%1,%2)' asSQLFunction;
		
		"Date functions"
		at: #addDays: put: 'DATEADD(''d'',%2,%1)' asSQLFunction;
		at: #addMonths: put: 'DATEADD(''m'',%2,%1)' asSQLFunction;
		at: #addYears: put: 'DATEADD(''yyyy'',%2,%1)' asSQLFunction;
		at: #dayOfMonth put: 'DATEPART(''d'',%1)' asSQLFunctionIntegerResult;
		at: #monthIndex put: 'DATEPART(''m'',%1)' asSQLFunctionIntegerResult;
		at: #year put: 'DATEPART(''yyyy'',%1)' asSQLFunctionIntegerResult;

		"Logical functions"
		at: #ifNil: put: 'IIF(ISNULL(%1),%2,%1)' asSQLFunction;
		at: #ifNull: put: 'IIF(ISNULL(%1),%2,%1)' asSQLFunction;
		at: #ifNull:ifNotNull: put: ('IIF(ISNULL(%1),%2,%3)' asSQLFunction resultParamIndex: 2);
		at: #then:else: put: ('IIF(%1,%2,%3)' asSQLFunction resultParamIndex: 2);

		yourself!

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
		executeSQLFrom: [ :stream | stream nextPutAll: 'SELECT * INTO '; nextPutIdentifier: newName; nextPutAll: ' FROM '; nextPutIdentifier: oldName];
		executeSQLFrom: [ :stream | stream nextPutAll: 'DROP TABLE '; nextPutIdentifier: oldName]!

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

	^5! !
!SSWMSAccessDialect categoriesFor: #boolean!datatypes!public! !
!SSWMSAccessDialect categoriesFor: #canDescribeParameters!public!testing! !
!SSWMSAccessDialect categoriesFor: #date!datatypes!public! !
!SSWMSAccessDialect categoriesFor: #datetimeWithResolution!datatypes!public! !
!SSWMSAccessDialect categoriesFor: #defaultMaxColumnNameLength!constants!public! !
!SSWMSAccessDialect categoriesFor: #defaultMaxTableNameLength!constants!public! !
!SSWMSAccessDialect categoriesFor: #dialectSpecificFunctions!constants!public! !
!SSWMSAccessDialect categoriesFor: #longText!datatypes!public! !
!SSWMSAccessDialect categoriesFor: #maxAllocatedStatements!constants!public! !
!SSWMSAccessDialect categoriesFor: #maxDateTimeResolution!constants!public! !
!SSWMSAccessDialect categoriesFor: #renameTableNamed:to:in:!maintenance!public! !
!SSWMSAccessDialect categoriesFor: #shouldMapEmptyStringsToNil!public!testing! !
!SSWMSAccessDialect categoriesFor: #time!datatypes!public! !
!SSWMSAccessDialect categoriesFor: #trueObject!constants!public! !
!SSWMSAccessDialect categoriesFor: #updateDelaySeconds!constants!public! !

!SSWMSAccessDialect class methodsFor!

dbmsName

	^'ACCESS'! !
!SSWMSAccessDialect class categoriesFor: #dbmsName!constants!public! !


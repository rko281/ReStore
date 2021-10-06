"Filed out from Dolphin Smallalk"!

SSWSQLDialect subclass: #SSWSQLServerDialect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLServerDialect guid: (GUID fromString: '{520d9399-40a8-4481-bf93-615e8a4eb465}')!
SSWSQLServerDialect comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLServerDialect categoriesForClass!Unclassified! !
!SSWSQLServerDialect methodsFor!

boolean

	^'BIT'!

dateAndTimeFormat

	"The format for DateAndTImes when expressed as Strings"

	^'yyyy-MM-dd HH:mm:ssfff'!

datetime

	^'DATETIME2'!

datetimeWithResolution

	^'DATETIME2(<1p>)'!

defaultMaxColumnNameLength

	^128!

defaultMaxTableNameLength

	^128!

defaultStandardNamespace

	^'dbo'!

dialectSpecificFunctions

	^Dictionary new

		"Numeric functions"
		at: #rounded put: 'ROUND(%1,0)' asSQLFunctionIntegerResult;

		"String functions"
		at: #, put: '(%1 + %2)' asSQLFunction;
		at: #leftString: put: 'LEFT(%1,%2)' asSQLFunction;
		at: #rightString: put: 'RIGHT(%1,%2)' asSQLFunction;
		at: #asciiValue put: 'ASCII(%1)' asSQLFunctionIntegerResult;
		at: #indexOfSubCollection: put: 'CHARINDEX(%2,%1)' asSQLFunctionIntegerResult;
		at: #midString:from: put: 'SUBSTRING(%1,%3,%2)' asSQLFunction;
		
		"Date functions"
		at: #addDays: put: 'DATEADD(''d'',%2,%1)' asSQLFunction;
		at: #addMonths: put: 'DATEADD(''m'',%2,%1)' asSQLFunction;
		at: #addYears: put: 'DATEADD(''yyyy'',%2,%1)' asSQLFunction;
		at: #dayOfMonth put: 'DAY(%1)' asSQLFunctionIntegerResult;
		at: #monthIndex put: 'MONTH(%1)' asSQLFunctionIntegerResult;
		at: #year put: 'YEAR(%1)'asSQLFunctionIntegerResult;

		"Logical functions"
		at: #ifNil: put: 'ISNULL(%1,%2)' asSQLFunction;
		at: #ifNull: put: 'ISNULL(%1,%2)' asSQLFunction;

		yourself!

double

	^'DOUBLE PRECISION'!

identifierQuoteClose

	"Square brackers are the standard for SQLServer"

	^$]!

identifierQuoteOpen

	"Square brackers are the standard for SQLServer"

	^$[!

integer

	^'INT'!

maxCharacter

	^8000!

renameField: oldField to: newField in: aReStore

	aReStore executeSQL: ('EXEC sp_rename ''<1s>.<2s>'', <3p>, ''COLUMN''' expandMacrosWith: newField table qualifiedName with: oldField name with: newField name)!

renameTable: oldTable to: newTable in: anSSWReStore

	anSSWReStore executeSQL: ('EXEC sp_rename <1p>,<2p>' expandMacrosWith: oldTable qualifiedName with: newTable name)!

supportsImplicitTrueConditions

	^false!

unsizedBlob

	^'varbinary(max)'!

uuid

	^'UNIQUEIDENTIFIER'! !
!SSWSQLServerDialect categoriesForMethods!
boolean!datatypes!public! !
dateAndTimeFormat!constants!public! !
datetime!datatypes!public! !
datetimeWithResolution!datatypes!public! !
defaultMaxColumnNameLength!constants!public! !
defaultMaxTableNameLength!constants!public! !
defaultStandardNamespace!constants!public! !
dialectSpecificFunctions!constants!public! !
double!datatypes!public! !
identifierQuoteClose!constants!public! !
identifierQuoteOpen!constants!public! !
integer!datatypes!public! !
maxCharacter!constants!public! !
renameField:to:in:!maintenance!public! !
renameTable:to:in:!maintenance!public! !
supportsImplicitTrueConditions!public!testing! !
unsizedBlob!datatypes!public! !
uuid!datatypes!public! !
!

!SSWSQLServerDialect class methodsFor!

dbmsName

	^'MICROSOFT SQL SERVER' ! !
!SSWSQLServerDialect class categoriesForMethods!
dbmsName!constants!public! !
!


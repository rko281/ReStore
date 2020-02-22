"Filed out from Dolphin Smalltalk 7"!

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

canDescribeParameters

	"Appears to be supported by the native ODBC driver, but flaky (doesn't work with > 1 param?), so let's act as if it doesn't work"

	^false!

cursorType

	^#keysetDriven!

datetime

	^'DATETIME2'!

datetimeWithResolution

	^'DATETIME2(<1p>)'!

defaultMaxColumnNameLength

	^128!

defaultMaxTableNameLength

	^128!

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
		at: #dayOfMonth put: 'DATEPART(''d'',%1)' asSQLFunctionIntegerResult;
		at: #monthIndex put: 'DATEPART(''m'',%1)' asSQLFunctionIntegerResult;
		at: #year put: 'DATEPART(''yyyy'',%1)'asSQLFunctionIntegerResult;

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

	aReStore executeSQL: ('EXEC sp_rename ''<1s>.<2s>'', <3p>, ''COLUMN''' expandMacrosWith: (self asIdentifier: newField table name) with: (self asIdentifier: oldField name) with: (self asIdentifier: newField name))!

renameTableNamed: oldName to: newName in: anSSWReStore

	anSSWReStore executeSQL: ('EXEC sp_rename <1p>,<2p>' expandMacrosWith: (self asIdentifier: oldName) with: (self asIdentifier: newName))!

shouldMaskSuccessWithInfo

	^true!

supportsImplicitTrueConditions

	^false! !
!SSWSQLServerDialect categoriesFor: #boolean!datatypes!public! !
!SSWSQLServerDialect categoriesFor: #canDescribeParameters!public!testing! !
!SSWSQLServerDialect categoriesFor: #cursorType!constants!public! !
!SSWSQLServerDialect categoriesFor: #datetime!datatypes!public! !
!SSWSQLServerDialect categoriesFor: #datetimeWithResolution!datatypes!public! !
!SSWSQLServerDialect categoriesFor: #defaultMaxColumnNameLength!constants!public! !
!SSWSQLServerDialect categoriesFor: #defaultMaxTableNameLength!constants!public! !
!SSWSQLServerDialect categoriesFor: #dialectSpecificFunctions!constants!public! !
!SSWSQLServerDialect categoriesFor: #double!datatypes!public! !
!SSWSQLServerDialect categoriesFor: #identifierQuoteClose!constants!public! !
!SSWSQLServerDialect categoriesFor: #identifierQuoteOpen!constants!public! !
!SSWSQLServerDialect categoriesFor: #integer!datatypes!public! !
!SSWSQLServerDialect categoriesFor: #maxCharacter!constants!public! !
!SSWSQLServerDialect categoriesFor: #renameField:to:in:!maintenance!public! !
!SSWSQLServerDialect categoriesFor: #renameTableNamed:to:in:!maintenance!public! !
!SSWSQLServerDialect categoriesFor: #shouldMaskSuccessWithInfo!public!testing! !
!SSWSQLServerDialect categoriesFor: #supportsImplicitTrueConditions!public!testing! !

!SSWSQLServerDialect class methodsFor!

dbmsName

	^'MICROSOFT SQL SERVER' ! !
!SSWSQLServerDialect class categoriesFor: #dbmsName!constants!public! !


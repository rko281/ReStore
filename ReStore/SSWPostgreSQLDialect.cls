"Filed out from Dolphin Smalltalk 7"!

SSWSQLDialect subclass: #SSWPostgreSQLDialect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWPostgreSQLDialect guid: (GUID fromString: '{12d8994a-38c7-47ee-9760-30dd5a44471a}')!
SSWPostgreSQLDialect comment: ''!
!SSWPostgreSQLDialect categoriesForClass!Unclassified! !
!SSWPostgreSQLDialect methodsFor!

datetime

	^'TIMESTAMP'!

datetimeWithResolution

	^'TIMESTAMP(%1)'!

defaultDateTimeResolution

	^6!

dialectSpecificFunctions

	^##(Dictionary new

		"String functions"
		at: #size put: 'CHAR_LENGTH(%1)';
		at: #asciiValue put: 'ASCII(%1)';
		at: #indexOfSubCollection: put: 'POSITION(%2,%1)';

		"Date functions"
		at: #dayOfMonth put: 'DATEPART(''day'',%1)';
		at: #monthIndex put: 'DATEPART(''month'',%1)';
		at: #year put: 'DATEPART(''yyyy'',%1)';

		yourself)!

double

	^'DOUBLE PRECISION'!

falseObject

	"Booleans are bits (Integers)"

	^0!

maxCharacter

	"Technically 1GB, but limit it to something reasonable"

	^65535!

renameField: oldField to: newField in: aReStore

	| stream |

	stream := WriteStream on: (String new: 32).
	stream 
		nextPutAll: 'ALTER TABLE ';
		nextPutAll: newField table name;
		nextPutAll: ' RENAME ';
		nextPutAll: oldField name;
		nextPutAll: ' TO ';
		nextPutAll: newField name.

	aReStore executeSQL: stream contents!

shouldCheckAutoCommit

	^true!

shouldMaskSuccessWithInfo

	^true!

transformName: aSymbol

	"Postgres prefers lowercase"

	^(super transformName: aSymbol) asLowercase!

trueObject

	"Booleans are bits (Integers)"

	^1!

writeSQLForDate: aDate on: aStream

	"Postgres seems unhappy with the standard ODBC format"

	aStream nextPut: $'.

	aDate printOn: aStream format: 'yyyy-MM-dd'.

	aStream nextPut: $'!

writeSQLForDateAndTime: aDateAndTime on: aStream

	"Postgres seems unhappy with the standard ODBC format"

	aStream nextPut: $'.

	aDateAndTime printOn: aStream format: 'yyyy-MM-dd HH:mm:ssffffff'.

	aStream nextPut: $'!

writeSQLForTime: aTime on: aStream

	"Postgres seems unhappy with the standard ODBC format"

	aStream nextPut: $'.

	aTime printOn: aStream format: 'HH:mm:ss'.

	aStream nextPut: $'!

writeSQLForTimeStamp: aTimeStamp on: aStream

	"Postgres seems unhappy with the standard ODBC format"

	aStream nextPut: $'.

	aTimeStamp date printOn: aStream format: 'yyyy-MM-dd'.
	aStream space.
	aTimeStamp time printOn: aStream format: 'HH:mm:ss'.

	aStream nextPut: $'! !
!SSWPostgreSQLDialect categoriesFor: #datetime!datatypes!public! !
!SSWPostgreSQLDialect categoriesFor: #datetimeWithResolution!datatypes!public! !
!SSWPostgreSQLDialect categoriesFor: #defaultDateTimeResolution!constants!public! !
!SSWPostgreSQLDialect categoriesFor: #dialectSpecificFunctions!constants!public! !
!SSWPostgreSQLDialect categoriesFor: #double!datatypes!public! !
!SSWPostgreSQLDialect categoriesFor: #falseObject!constants!public! !
!SSWPostgreSQLDialect categoriesFor: #maxCharacter!constants!public! !
!SSWPostgreSQLDialect categoriesFor: #renameField:to:in:!maintenance!public! !
!SSWPostgreSQLDialect categoriesFor: #shouldCheckAutoCommit!public!testing! !
!SSWPostgreSQLDialect categoriesFor: #shouldMaskSuccessWithInfo!public!testing! !
!SSWPostgreSQLDialect categoriesFor: #transformName:!helpers!public! !
!SSWPostgreSQLDialect categoriesFor: #trueObject!constants!public! !
!SSWPostgreSQLDialect categoriesFor: #writeSQLForDate:on:!public!writing sql! !
!SSWPostgreSQLDialect categoriesFor: #writeSQLForDateAndTime:on:!public!writing sql! !
!SSWPostgreSQLDialect categoriesFor: #writeSQLForTime:on:!public!writing sql! !
!SSWPostgreSQLDialect categoriesFor: #writeSQLForTimeStamp:on:!public!writing sql! !

!SSWPostgreSQLDialect class methodsFor!

dbmsName

	^'PostgreSQL'! !
!SSWPostgreSQLDialect class categoriesFor: #dbmsName!constants!public! !


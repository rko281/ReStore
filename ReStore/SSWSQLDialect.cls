"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SSWSQLDialect
	instanceVariableNames: 'connection connectionReservedWords maxColumnNameLength maxTableNameLength customFunctions maxColumnBytes unsizedStringSize'
	classVariableNames: ''
	poolDictionaries: 'ODBCConstants'
	classInstanceVariableNames: ''!
SSWSQLDialect guid: (GUID fromString: '{24d06227-afdd-43ac-934f-2a8fcd601791}')!
SSWSQLDialect comment: ''!
!SSWSQLDialect categoriesForClass!Unclassified! !
!SSWSQLDialect methodsFor!

addFields: aCollection to: aTable in: anSSWReStore

	"Add the given collection of Fields to their table in anSSWReStore's database"

	| stream |

	self supportsMultipleAddColumns
	ifTrue:
		[stream := WriteStream on: (String new: 32).
		stream 
			nextPutAll: 'ALTER TABLE ';
			nextPutAll: aTable name.
		aCollection 
			do: 
				[ :field | 
				stream nextPutAll: ' ADD '.
				field writeSQLDefinitionOn: stream]
			separatedBy: [stream nextPut: $,].
		anSSWReStore executeSQL: stream contents]
	ifFalse:
		[aCollection do:
			[ :field || innerStream |
			innerStream := WriteStream on: (String new: 32).
			innerStream 
				nextPutAll: 'ALTER TABLE ';
				nextPutAll: aTable name;
				nextPutAll: ' ADD '.
			field writeSQLDefinitionOn: innerStream.
			anSSWReStore executeSQL: innerStream contents]]!

aggregateFunctions

	"Return a mapping from Smalltalk method names to an equivalent SQL aggregarte (COUNT etc.) function supported by this dialect.
	Subclasses should reimplement if they implement additional aggregate functions"

	^##(Dictionary new
		at: #count put: 'COUNT(%1)';
		at: #sum put: 'SUM(%1)';
		at: #minimum put: 'MIN(%1)';
		at: #maximum put: 'MAX(%1)';
		at: #average put: 'AVG(%1)';
		yourself)!

boolean

	^'BOOLEAN'!

canDescribeParameters

	"Does this dialect support the SQLDescribeParam function?"

	^true!

char

	^'CHAR(%1)'!

commonFunctions

	"Return a mapping from Smalltalk method names to an equivalent 'common' SQL function.
	Common function are as defined in SQL-99 standards and are assumed to be supported by all dialects.

	Subclasses should NOT override this method but instead implement dialectSpecificFunctions with any additional functions they support.
	If subclasses support a common function differently (or do not support it at all) they should add this to dialectSpecificFunctions, returning the alternative definition (or nil)"

	^##(Dictionary new

		"Conversion functions"
		at: #asInteger put: 'CAST(%1 AS INTEGER)';

		"Numeric functions"
		at: #+ put: '(%1 + %2)';
		at: #- put: '(%1 - %2)';
		at: #* put: '(%1 * %2)';
		at: #/ put: '(%1 / %2)';
		at: #\\ put: '(%1 %% %2)';
		at: #between:and: put: '%1 BETWEEN %2 AND %3';
		at: #abs put: 'ABS(%1)';
		at: #rounded put: 'ROUND(%1)';

		"String functions"
		at: #size put: 'LEN(%1)';
		at: #, put: '(%1 || %2)';
		at: #indexOfSubCollection: put: 'INSTR(%1,%2)';
		at: #midString:from: put: 'SUBSTRING(%1 FROM %3 FOR %2)';
		at: #trimBlanks put: 'TRIM(%1)';
		at: #asUppercase put: 'UPPER(%1)';
		at: #asLowercase put: 'LOWER(%1)';

		yourself)!

connection
	^connection!

connection: anObject
	connection := anObject!

connectionReservedWords

	"9/3/2001
	
	Reserved words are Strings which cannot be used for field or table names in this SQL Dialect. 
	connectionReservedWords are set by ReStore on logging in, from the ODBC SQLKeywords function.

	Clients should use isReservedWord: to check if a word is reserved;
	this additionally checks staticReservedWords"

	^connectionReservedWords!

connectionReservedWords: aCollection

	"9/3/2001
	
	Reserved words are Strings which cannot be used for field or table names in this SQL Dialect. 
	connectionReservedWords are set by ReStore on logging in, from the ODBC SQLKeywords function.

	Clients should use isReservedWord: to check if a word is reserved;
	this additionally checks staticReservedWords"

	connectionReservedWords := aCollection!

cursorType

	"Return the Symbol-ic name of the ODBC cursor type that will be used when creating statements. 
	See DBAbstractStatement>>cursorType for further details"

	^#forwardOnly!

customFunctions

	"customFunctions stores a mapping from Smalltalk method names (which may not actually be implemented!!) to an equivalent SQL function.
	See the other function methods in the constants category for how these are specified.
	Note that, unlike the constant functions, customFunctions is designed to be configured by client code.
	This may be to add dialect-specific functions without modifying core ReStore classes, or to add pseudo methods/functions for querying convenience, e.g.

		at: #plusPercent: put: '%1 * (1 + (%2 / 100))'

	Also note that, since the dialect is created following login, these must be set up after login"

	^customFunctions!

customFunctions: anObject
	customFunctions := anObject!

date

	^'DATE'!

dateAndTimeFormat

	"The format for DateAndTImes when expressed as Strings"

	^'yyyy-MM-dd HH:mm:ssffffff'!

dateAndTimeFrom: anObject

	| stream date time |

	(anObject isKindOf: String) ifTrue: 
		[stream := anObject readStream.
		date := Date readFrom: stream format: self dateFormat.
		stream next.
		time := Time readFrom: stream.
		^DateAndTime fromDate: date time: time].

	self error: ('cannot convert <1p> to a DateAndTime' expandMacrosWith: anObject)!

dateAndTimeStringFor: aDateAndTime

	"Return the String representation of aDateAndTime in this dialect"

	^aDateAndTime printStringFormat: self dateAndTimeFormat!

dateFormat

	"The format for Dates when expressed as Strings"

	^'yyyy-MM-dd'!

dateFrom: anObject

	anObject class = DateAndTime ifTrue: [^anObject asDate].

	(anObject isKindOf: String) ifTrue: [^Date readFrom: anObject readStream format: self dateFormat].

	self error: ('cannot convert <1p> to a Date' expandMacrosWith: anObject)!

dateStringFor: aDate

	"Return the String representation of aDate in this dialect"

	^aDate printStringFormat: self dateFormat!

datetime

	^'DATETIME'!

datetimeWithResolution

	"Parameter is resolution (0=seconds, 3=milliseconds etc.)"

	^'DATETIME(%1)'!

decimal

	^'DECIMAL(%1,%2)'!

defaultDateTimeResolution

	"0 = seconds, 3 = milliseconds etc."

	^0!

defaultMaxColumnBytes

	"default value for maxColumnBytes - see that method's comment"
	
	"Default to the same as Dolphin's DBConnect hard-coded value"
	^##(2 raisedTo: 16)!

defaultUnsizedStringSize

	"default value for unsizedStringSize - see that method's comment"
	
	"Default to the maximum column bytes - 1 (for null terminator)"
	^self defaultMaxColumnBytes - 1!

dialectSpecificFunctions

	"Return a mapping from Smalltalk method names to an equivalent SQL function supported by this dialect.
	Subclasses should reimplement as appropriate"

	^##(Dictionary new)!

double

	^'DOUBLE'!

dropColumnNamed: colString fromTable: anSSWDBTable in: anSSWReStore

	anSSWReStore executeSQL: ('ALTER TABLE %1 DROP COLUMN %2' formatWith: anSSWDBTable name with: colString)!

falseObject

	"The object which represents the false Boolean in this dialect"

	^##(false asParameter)!

float

	^'FLOAT'!

initialize

	self
		maxColumnBytes: self defaultMaxColumnBytes;
		unsizedStringSize: self defaultUnsizedStringSize!

initializeFor: aDBConnection

	self
		connection: aDBConnection;
		connectionReservedWords: ((aDBConnection getLongInfoString: SQL_KEYWORDS) subStrings: $,);
		maxColumnNameLength: aDBConnection maxColumnNameLength;
		maxTableNameLength: aDBConnection maxTableNameLength;
		customFunctions: Dictionary new!

integer

	^'INTEGER'!

isReservedWord: aString

	"30/4/2001"

	^(self staticReservedWords includes: aString asUppercase) or: 
		[self connectionReservedWords includes: aString asUppercase]!

longText

	^'TEXT'!

maxAllocatedStatements

	"Return an Integer specifying the maximum number of ODBC statements that should be allocated. 
	If this number is exceeded, statements are automatically freed when closed.

	Default - no particular limit"

	^SmallInteger maximum!

maxChar

	^self maxCharacter!

maxCharacter

	^255!

maxColumnBytes

	"maxColumnBytes stores the maximum size of a column in bytes - this is used to initialize a column's replication buffer where there is no size information (e.g. LongText).
	This is not really a dialect-specific attribute but its value affects the choice of String column type so we specify it here.

	The default is (2 raisedTo: 16), which is the standard maximum buffer size in Dolphin's database interface.
	If a larger size is needed you can set an appropriate value for your application following login.
	Bear in mind that wide character strings (if supported) can use > 1 byte per character.
	
	Also bear in mind that this value is used to create a ByteArray for each unsized column which is replicated.
	If you increase this value then consider specifying a maximum String size in your class spec methods to avoid unnecessarily large buffers.

	Also bear in mind that this value can be limited by the ODBC driver. 
	e.g. as of writing SQLite appears to be limited to 65536 bytes, whilst Postgres lets you specify the limit in the Datasource dialog (but the default is only 8190 bytes!!!!)

	Purely anecdotally, a maxColumnBytes of 1MB (2 raisedTo: 20) makes no discernable performance difference compared to the default size when run over the entire ReStore test suite.

	Very large values really need the use of unbound columns and incremental (paged) put/getData, however this is not yet implemented (and is potentially less performant than bound columns)"

	^maxColumnBytes!

maxColumnBytes: anObject
	maxColumnBytes := anObject!

maxColumnNameLength

	"Initialized from the DB on login but may be set to something else (lower!!) if necessary"

	^maxColumnNameLength!

maxColumnNameLength: anObject
	maxColumnNameLength := anObject!

maxDateTimeResolution

	"0 = seconds, 3 = milliseconds etc."

	^6!

maxTableNameLength

	"Initialized from the DB on login but may be set to something else (lower!!) if necessary"

	^maxTableNameLength!

maxTableNameLength: anObject
	maxTableNameLength := anObject!

maxVarchar

	^self maxCharacter!

postLoginScript

	"Return any SQL String which should be evaluated on each login for this dialect, or nil if none"

	^nil!

renameField: oldField to: newField in: aReStore

	"Simple implementation for dialects with no explicit rename column support"

	| table updator |

	table := newField table.

	"Add a new column with the new name"
	self addFields: (Array with: newField) to: table in: aReStore. 
		
	"Update all instances in DB so newInstVar column value = oldInstVar column value"
	updator := (newField accessor name, ':') asSymbol.
	(aReStore instancesOf: table instanceClass) modify: [ :each | each perform: updator with: (each perform: oldField accessor name)].

	"Drop the old column"
	self dropColumnNamed: oldField name fromTable: table in: aReStore!

renameTableNamed: oldName to: newName in: anSSWReStore

	anSSWReStore executeSQL: ('ALTER TABLE %1 RENAME TO %2' formatWith: oldName with: newName)!

shouldCheckAutoCommit

	"Return whether the DBConnection should check the status of autoCommit prior to attempting a change"

	^false!

shouldMapEmptyStringsToNil

	"Return whether empty Strings should be mapped to nil before storage in the database.
	This can be useful for databases in which default String fields to 'Do not allow zero size (usually this attribute cannot be set via ODBC/SQL)"

	^false!

shouldMaskSuccessWithInfo

	"Some databases/drivers send many SQLSuccessWithInfo results.
	shouldMaskSuccessWithInfo determines whether these go unreported (true) or are reported via a DBWarning exception (false, standard behaviour)"

	^false!

shouldRollbackOnQuery

	"Should the ODBC connection rollbackTxn following a query outside a Txn?"

	^false!

shouldUseColumnsStatement

	"Return whether this dialect should use DBColumnsStatement to interrogate the details of a table's columns (true, default) or a SELECT * query (false).
	
	Here primarily to satisfy a shortcoming in SQLite ODBC driver where DBColumnsStatement returns the character length for wide string columns, rather than the buffer length.
	Column details returned from a SELECT * query report the buffer length correctly"

	^true!

sqlFunctionFor: aMessageSelector

	^self dialectSpecificFunctions at: aMessageSelector ifAbsent: 
		[self commonFunctions at: aMessageSelector ifAbsent: 
			[self aggregateFunctions at: aMessageSelector ifAbsent: 
				[self customFunctions at: aMessageSelector ifAbsent: [nil]]]]!

staticReservedWords

	"Reserved words are Strings which cannot be used for field or table names in this SQL Dialect. 
	staticReservedWords are primarily the same as the class method odbcReservedWords, however subclasses can add to this if required.

	Clients should use isReservedWord: to check if a word is reserved; this additionally checks connectionReservedWords"

	^self class odbcReservedWords!

supportsImplicitTrueConditions

	"Does this dialect support implicit true conditions like IS_SOMETHING or does it require IS_SOMETHING = TRUE"

	^true!

supportsMultipleAddColumns

	"Return whether this dialect supports multiple 'ADD [COLUMN]' clauses per ALTER TABLE statement (true)
	or whether each column to be added must be done in a separate ALTER TABLE (false)"

	^false!

time

	^'TIME'!

timeFormat

	"The format for Times when expressed as Strings"

	^'HH:mm:ss'!

timeFrom: anObject

	anObject class = DateAndTime ifTrue: [^anObject asTime].

	(anObject isKindOf: String) ifTrue: [^Time readFrom: anObject readStream].

	self error: ('cannot convert <1p> to a Time' expandMacrosWith: anObject)!

timeStringFor: aTime

	"Return the String representation of aTime in this dialect"

	^aTime printStringFormat: self timeFormat!

transformClassName: aSymbol

	"Transform the given class name into a table-style String appropriate for this dialect"

	^self transformName: aSymbol into: #Table!

transformInstVarName: aSymbol

	"Transform the given instvar name into a field/column-style String appropriate for this dialect"

	^self transformName: aSymbol into: #Field!

transformName: aSymbol

	"Transform the given Symbol into a DB-style String appropriate/conventional for this dialect.
	'Basic' transformation with no checking (e.g. reserved word clashes)"

	^aSymbol sswInUnderscoreFormat!

transformName: aSymbol into: typeSymbol

	"Private - Transform the given Symbol into a DB-style String appropriate/conventional for this dialect.
	Also check for reserved word clashes, and handle appropriately - typeSymbol describes the type of name and is used in reserved-word conflict resolution"

	| transformedName |

	transformedName := self transformName: aSymbol.

	^(self isReservedWord: transformedName) 
		ifTrue: [transformedName, '_', (self transformName: typeSymbol)]
		ifFalse: [transformedName]!

trueObject

	"The object which represents the true Boolean in this dialect"

	^##(true asParameter)!

unsizedString

	"Unsized = only limited by the maximum column size.
	defaultStringSize is used to determine the most appropriate column type does not imply a limit unless <= maxVarchar (see defaultStringSize method comment)"

	^self unsizedStringSize <= self maxVarchar 
		ifTrue: [self varchar formatWith: self unsizedStringSize printString]
		ifFalse: [self unsizedStringTypeForSize: self unsizedStringSize]!

unsizedStringSize

	"unsizedStringSize stores the size assumed for Strings in persistent classes if no explicit size is given.
	Whilst not strictly an SQLDialect attribute it is specified here for its interplay with column type choice:

	If unsizedStringSize <= maxVarchar, an unsized string will use the varchar type with defaultStringSize.
	 - this is useful for DBs which have limitations on the use of their longtext type (e.g. Oracle7 only allows one LONG column per table)

	If unsizedStringSize > maxVarchar, an unsized string will use the smallest longText type which supports defaultStringSize characters.
	 - this is useful for databases which have more than one long text type, to ensure the most efficient type is used"

	^unsizedStringSize!

unsizedStringSize: anInteger

	unsizedStringSize := anInteger.

	"Ensure we can actually handle single-byte Strings of this size. +1 is to accomodate a null terminator"
	self maxColumnBytes: (self maxColumnBytes max: (self unsizedStringSize + 1))!

unsizedStringTypeForSize: anInteger

	anInteger <= self maxColumnBytes ifTrue: 
		[(self unsizedStringTypes asSortedCollection: [ :assoc1 :assoc2 | assoc1 key <= assoc2 key]) do: [ :assoc | assoc key >= anInteger ifTrue: [^assoc value]]].

	self error: 'No String type found for size <1p> - consider increasing maxColumnBytes'!

unsizedStringTypes

	"Return a collection of associations between the maximum size of an unsized String type (i.e. one whose type declaration does not include its size, c.f. varchar), and its name in this dialect.

	By default this just consists of the longText type - dialects with more String types can extend as necessary"

	^OrderedCollection new
		add: (self unsizedStringSize -> self longText);
		yourself!

updateDelaySeconds

	"In some DBs, an update may not be immediately visible in other sessions. 
	Return the number of seconds to wait before expecting the update to be visible.
	This is primarily for SUnit purposes but may be useful elsewhere"

	^0!

varchar

	^'VARCHAR(%1)'!

writeSQLForDate: aDate on: aStream

	"For multi-datasource compatability, use standard ODBC date escape sequence {d'yyyy-MM-dd'}.
	Subclasses may override to do their own thing (particularly if they do not support an actual DATE type) "

	aStream
		nextPut: ${;
		nextPut: $d;
		nextPut: $'.

	aDate printOn: aStream format: 'yyyy-MM-dd'.

	aStream
		nextPut: $';
		nextPut: $}!

writeSQLForDateAndTime: aDateAndTime on: aStream

	"For multi-datasource compatability, use standard ODBC date escape sequence {ts 'yyyy-MM-dd hh:mm:ss'}.
	Subclasses may override to do their own thing"

	aStream 
		nextPutAll: '{ts';
		nextPut: $'.
	aDateAndTime printOn: aStream format: 'yyyy-MM-dd HH:mm:ssffffff'.
	aStream
		nextPut: $';
		nextPut: $}!

writeSQLForFalseOn: aStream

	self falseObject writeSQLOn: aStream!

writeSQLForTime: aTime on: aStream

	"For multi-datasource compatability, use standard ODBC date escape sequence {t 'hh:mm:ss.mmmmmm'}.
	Subclasses may override to do their own thing (particularly if they do not support an actual TIME type)"

	aStream
		nextPutAll: '{t';
		nextPut: $'.

	aTime printOn: aStream format: 'HH:mm:ss'.

	aStream
		nextPut: $';
		nextPut: $}!

writeSQLForTrueOn: aStream

	self trueObject writeSQLOn: aStream! !
!SSWSQLDialect categoriesFor: #addFields:to:in:!maintenance!public! !
!SSWSQLDialect categoriesFor: #aggregateFunctions!constants!public! !
!SSWSQLDialect categoriesFor: #boolean!datatypes!public! !
!SSWSQLDialect categoriesFor: #canDescribeParameters!public!testing! !
!SSWSQLDialect categoriesFor: #char!datatypes!public! !
!SSWSQLDialect categoriesFor: #commonFunctions!constants!public! !
!SSWSQLDialect categoriesFor: #connection!accessing!private! !
!SSWSQLDialect categoriesFor: #connection:!accessing!private! !
!SSWSQLDialect categoriesFor: #connectionReservedWords!accessing!public! !
!SSWSQLDialect categoriesFor: #connectionReservedWords:!accessing!public! !
!SSWSQLDialect categoriesFor: #cursorType!constants!public! !
!SSWSQLDialect categoriesFor: #customFunctions!accessing!public! !
!SSWSQLDialect categoriesFor: #customFunctions:!accessing!public! !
!SSWSQLDialect categoriesFor: #date!datatypes!public! !
!SSWSQLDialect categoriesFor: #dateAndTimeFormat!constants!public! !
!SSWSQLDialect categoriesFor: #dateAndTimeFrom:!conversions!public! !
!SSWSQLDialect categoriesFor: #dateAndTimeStringFor:!conversions!public! !
!SSWSQLDialect categoriesFor: #dateFormat!constants!public! !
!SSWSQLDialect categoriesFor: #dateFrom:!conversions!public! !
!SSWSQLDialect categoriesFor: #dateStringFor:!conversions!public! !
!SSWSQLDialect categoriesFor: #datetime!datatypes!public! !
!SSWSQLDialect categoriesFor: #datetimeWithResolution!datatypes!public! !
!SSWSQLDialect categoriesFor: #decimal!datatypes!public! !
!SSWSQLDialect categoriesFor: #defaultDateTimeResolution!constants!public! !
!SSWSQLDialect categoriesFor: #defaultMaxColumnBytes!constants!public! !
!SSWSQLDialect categoriesFor: #defaultUnsizedStringSize!constants!public! !
!SSWSQLDialect categoriesFor: #dialectSpecificFunctions!constants!public! !
!SSWSQLDialect categoriesFor: #double!datatypes!public! !
!SSWSQLDialect categoriesFor: #dropColumnNamed:fromTable:in:!maintenance!public! !
!SSWSQLDialect categoriesFor: #falseObject!constants!public! !
!SSWSQLDialect categoriesFor: #float!datatypes!public! !
!SSWSQLDialect categoriesFor: #initialize!initializing!public! !
!SSWSQLDialect categoriesFor: #initializeFor:!initializing!public! !
!SSWSQLDialect categoriesFor: #integer!datatypes!public! !
!SSWSQLDialect categoriesFor: #isReservedWord:!public!testing! !
!SSWSQLDialect categoriesFor: #longText!datatypes!public! !
!SSWSQLDialect categoriesFor: #maxAllocatedStatements!constants!public! !
!SSWSQLDialect categoriesFor: #maxChar!constants!public! !
!SSWSQLDialect categoriesFor: #maxCharacter!constants!public! !
!SSWSQLDialect categoriesFor: #maxColumnBytes!accessing!public! !
!SSWSQLDialect categoriesFor: #maxColumnBytes:!accessing!public! !
!SSWSQLDialect categoriesFor: #maxColumnNameLength!accessing!public! !
!SSWSQLDialect categoriesFor: #maxColumnNameLength:!accessing!public! !
!SSWSQLDialect categoriesFor: #maxDateTimeResolution!constants!public! !
!SSWSQLDialect categoriesFor: #maxTableNameLength!accessing!public! !
!SSWSQLDialect categoriesFor: #maxTableNameLength:!accessing!public! !
!SSWSQLDialect categoriesFor: #maxVarchar!constants!public! !
!SSWSQLDialect categoriesFor: #postLoginScript!constants!public! !
!SSWSQLDialect categoriesFor: #renameField:to:in:!maintenance!public! !
!SSWSQLDialect categoriesFor: #renameTableNamed:to:in:!maintenance!public! !
!SSWSQLDialect categoriesFor: #shouldCheckAutoCommit!public!testing! !
!SSWSQLDialect categoriesFor: #shouldMapEmptyStringsToNil!public!testing! !
!SSWSQLDialect categoriesFor: #shouldMaskSuccessWithInfo!public!testing! !
!SSWSQLDialect categoriesFor: #shouldRollbackOnQuery!public!testing! !
!SSWSQLDialect categoriesFor: #shouldUseColumnsStatement!public!testing! !
!SSWSQLDialect categoriesFor: #sqlFunctionFor:!helpers!public! !
!SSWSQLDialect categoriesFor: #staticReservedWords!constants!public! !
!SSWSQLDialect categoriesFor: #supportsImplicitTrueConditions!public!testing! !
!SSWSQLDialect categoriesFor: #supportsMultipleAddColumns!public!testing! !
!SSWSQLDialect categoriesFor: #time!datatypes!public! !
!SSWSQLDialect categoriesFor: #timeFormat!constants!public! !
!SSWSQLDialect categoriesFor: #timeFrom:!conversions!public! !
!SSWSQLDialect categoriesFor: #timeStringFor:!conversions!public! !
!SSWSQLDialect categoriesFor: #transformClassName:!helpers!public! !
!SSWSQLDialect categoriesFor: #transformInstVarName:!helpers!public! !
!SSWSQLDialect categoriesFor: #transformName:!helpers!public! !
!SSWSQLDialect categoriesFor: #transformName:into:!helpers!private! !
!SSWSQLDialect categoriesFor: #trueObject!constants!public! !
!SSWSQLDialect categoriesFor: #unsizedString!datatypes!public! !
!SSWSQLDialect categoriesFor: #unsizedStringSize!accessing!public! !
!SSWSQLDialect categoriesFor: #unsizedStringSize:!accessing!public! !
!SSWSQLDialect categoriesFor: #unsizedStringTypeForSize:!datatypes!public! !
!SSWSQLDialect categoriesFor: #unsizedStringTypes!datatypes!public! !
!SSWSQLDialect categoriesFor: #updateDelaySeconds!constants!public! !
!SSWSQLDialect categoriesFor: #varchar!datatypes!public! !
!SSWSQLDialect categoriesFor: #writeSQLForDate:on:!public!writing sql! !
!SSWSQLDialect categoriesFor: #writeSQLForDateAndTime:on:!public!writing sql! !
!SSWSQLDialect categoriesFor: #writeSQLForFalseOn:!public!writing sql! !
!SSWSQLDialect categoriesFor: #writeSQLForTime:on:!public!writing sql! !
!SSWSQLDialect categoriesFor: #writeSQLForTrueOn:!public!writing sql! !

!SSWSQLDialect class methodsFor!

dbmsName

	"Return the name of the database whose dialect is represented by the receiver.
	Should correlate with the result of DBConnection>>dbmsName (ignoring case)"

	^self subclassResponsibility!

dbmsVersion

	"Return the version of the database whose dialect is represented by the receiver.
	Should correlate with the result of DBConnection>>dbmsVersion (ignoring case).

	From MS ODBC docs: '
		The version is of the form ##.##.####, where the first two digits are the major version, the next two digits are the minor version, and the last four digits are the release version. 
		The driver must render the DBMS product version in this form but can also append the DBMS product-specific version. For example, '04.01.0000 Rdb 4.1'.

	For convenience this value may be a pattern - dialects can handle subtle differences with conditionals (referring to their connection for the version)"

	^'*'!

isCompatibleWithConnection: aDBConnection

	"Default implementation uses name and version.
	Subclasses with more sophisticated requirements may override"

	^(self dbmsName sameAs: aDBConnection dbmsName) and: [self dbmsVersion match: aDBConnection dbmsVersion]!

new

	^super new initialize!

newFor: aDBConnection

	^(self subclassFor: aDBConnection) new
		initializeFor: aDBConnection;
		yourself!

odbcReservedWords

	"Return the set of default ODBC reserved words, as defined by Microsoft ODBC Programmer's Reference"

	^##('ABSOLUTE IS ACTION ISOLATION ADA JOIN ADD KEY ALL LANGUAGE ALLOCATE LAST ALTER LEADING AND LEFT ANY LEVEL ARE LIKE AS LOCAL ASC LOWER ASSERTION MATCH AT MAX AUTHORIZATION MIN AVG MINUTE BEGIN MODULE BETWEEN MONTH BIT NAMES BIT_LENGTH NATIONAL BOTH NATURAL BY NCHAR CASCADE NEXT CASCADED NO CASE NONE CAST NOT CATALOG NULL CHAR NULLIF CHAR_LENGTH NUMERIC CHARACTER OCTET_LENGTH CHARACTER_LENGTH OF CHECK ON CLOSE ONLY COALESCE OPEN COLLATE OPTION COLLATION OR COLUMN ORDER COMMIT OUTER CONNECT OUTPUT CONNECTION OVERLAPS CONSTRAINT PAD CONSTRAINTS PARTIAL CONTINUE PASCAL CONVERT POSITION CORRESPONDING PRECISION COUNT PREPARE CREATE PRESERVE CROSS PRIMARY CURRENT PRIOR CURRENT_DATE PRIVILEGES CURRENT_TIME PROCEDURE CURRENT_TIMESTAMP PUBLIC CURRENT_USER READ CURSOR REAL DATE REFERENCES DAY RELATIVE DEALLOCATE RESTRICT DEC REVOKE DECIMAL RIGHT DECLARE ROLLBACK DEFAULT ROWS DEFERRABLE SCHEMA DEFERRED SCROLL DELETE SECOND DESC SECTION DESCRIBE SELECT DESCRIPTOR SESSION DIAGNOSTICS SESSION_USER DISCONNECT SET DISTINCT SIZE DOMAIN SMALLINT DOUBLE SOME DROP SPACE ELSE SQL END SQLCA END-EXEC SQLCODE ESCAPE SQLERROR EXCEPT SQLSTATE EXCEPTION SQLWARNING EXEC SUBSTRING EXECUTE SUM EXISTS SYSTEM_USER EXTERNAL TABLE EXTRACT TEMPORARY FALSE THEN FETCH TIME FIRST TIMESTAMP FLOAT TIMEZONE_HOUR FOR TIMEZONE_MINUTE FOREIGN TO FORTRAN TRAILING FOUND TRANSACTION FROM TRANSLATE FULL TRANSLATION GET TRIM GLOBAL TRUE GO UNION GOTO UNIQUE GRANT UNKNOWN GROUP UPDATE HAVING UPPER HOUR USAGE IDENTITY USER IMMEDIATE USING IN VALUE INCLUDE VALUES INDEX VARCHAR INDICATOR VARYING INITIALLY VIEW INNER WHEN INPUT WHENEVER INSENSITIVE WHERE INSERT WITH INT WORK INTEGER WRITE INTERSECT YEAR INTERVAL ZONE INTO' subStrings)!

subclassFor: aDBConnection

	"Return the correct subclass of the receiver to use for the given DBConnection"

	"Sort to prefer subclasses with specific version number over non version-specific subclasses"
	^(self allSubclasses asSortedCollection: [ :c1 :c2 | c1 dbmsVersion size >= c2 dbmsVersion size]) detect: [ :each | each isCompatibleWithConnection: aDBConnection] ifNone: ["Fallback" self]! !
!SSWSQLDialect class categoriesFor: #dbmsName!constants!public! !
!SSWSQLDialect class categoriesFor: #dbmsVersion!constants!public! !
!SSWSQLDialect class categoriesFor: #isCompatibleWithConnection:!public!testing! !
!SSWSQLDialect class categoriesFor: #new!instance creation!public! !
!SSWSQLDialect class categoriesFor: #newFor:!instance creation!public! !
!SSWSQLDialect class categoriesFor: #odbcReservedWords!constants!public! !
!SSWSQLDialect class categoriesFor: #subclassFor:!accessing!public! !


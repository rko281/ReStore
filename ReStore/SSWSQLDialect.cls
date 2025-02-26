﻿"Filed out from Dolphin Smalltalk"!

Object subclass: #SSWSQLDialect
	instanceVariableNames: 'connection classNameTransformation instVarNameTransformation maxColumnNameLength maxTableNameLength sqlFunctions maxColumnBytes unsizedStringSize unsizedBlobSize standardNamespace nullBoolean'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWSQLDialect guid: (GUID fromString: '{24d06227-afdd-43ac-934f-2a8fcd601791}')!

SSWSQLDialect comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!

!SSWSQLDialect categoriesForClass!Unclassified! !

!SSWSQLDialect methodsFor!

addFields: aCollection to: aTable in: anSSWReStore

	"Add the given collection of Fields to their table in anSSWReStore's database"

	| stream |

	self supportsMultipleAddColumns
	ifTrue:
		[stream := self sqlWriteStream.
		stream 
			nextPutAll: 'ALTER TABLE ';
			writeSQLFor: aTable.
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
			innerStream := self sqlWriteStream.
			innerStream 
				nextPutAll: 'ALTER TABLE ';
				writeSQLFor: aTable;
				nextPutAll: ' ADD '.
			field writeSQLDefinitionOn: innerStream.
			anSSWReStore executeSQL: innerStream contents]]!

alterField: aField table: aTable in: aReStore

	aReStore executeSQLFrom: 
		[ :stream | 
		stream 
			nextPutAll: 'ALTER TABLE ';
			writeSQLFor: aTable;
			nextPutAll: ' ALTER COLUMN '.
		aField writeSQLDefinitionOn: stream]!

asIdentifier: aString

	| stream |
	
	stream := self sqlWriteStream.
	stream nextPutIdentifier: aString.
	^stream contents!

blob

	"unsizedBlobSize is used to determine the most appropriate column type (see unsizedBlobSize method comment)"

	^self blobTypeForSize: self unsizedBlobSize!

blobTypeForSize: anInteger

	anInteger <= self maxColumnBytes ifTrue: 
		[(self blobTypes asSortedCollection: [ :assoc1 :assoc2 | assoc1 key <= assoc2 key]) do: [ :assoc | assoc key >= anInteger ifTrue: [^assoc value]]].

	self error: 'No Blob type found for size <1p> - consider increasing maxColumnBytes'!

blobTypes

	"Return a collection of associations between the maximum size of an unsized ByteArray type (i.e. one whose type declaration does not include its size, c.f. varblob), and its name in this dialect.

	By default this just consists of the blob type - dialects with more blob types can extend as necessary"

	^OrderedCollection new
		add: (self unsizedBlobSize -> self unsizedBlob);
		yourself!

boolean

	^'BOOLEAN'!

char

	^'CHAR(<1p>)'!

classNameTransformation

	"classNmeTransformation stores a one-arg Block which is evaluated with a class name and should deliver an equivalent database name.
	Standard tranformation is (e.g.) CustomerOrder -> customer_order"

	^classNameTransformation!

classNameTransformation: aBlock

	"classNmeTransformation stores a one-arg Block which is evaluated with a class name and should deliver an equivalent database name.
	Standard tranformation is (e.g.) CustomerOrder -> customer_order"

	classNameTransformation := aBlock!

commonFunctions

	"Return a mapping from Smalltalk method names to an equivalent 'common' SQL function.
	Common function are as defined in SQL-99 standards and are assumed to be supported by all dialects.

	Subclasses should NOT override this method but instead implement dialectSpecificFunctions with any additional functions they support.
	If subclasses support a common function differently (or do not support it at all) they should add this to dialectSpecificFunctions, returning the alternative definition (or nil)"

	^Dictionary new

		"Conversion functions"
		at: #asString put: 'CAST(%1 AS CHAR)' asSQLFunction;
		at: #asInteger put: 'CAST(%1 AS INTEGER)' asSQLFunctionIntegerResult;

		"Numeric functions"
		at: #+ put: '(%1 + %2)' asSQLFunction;
		at: #- put: '(%1 - %2)' asSQLFunction;
		at: #* put: '(%1 * %2)' asSQLFunction;
		at: #/ put: '(%1 / %2)' asSQLFunction;
		at: #\\ put: '(%1 %% %2)' asSQLFunctionIntegerResult;
		at: #between:and: put: '%1 BETWEEN %2 AND %3' asSQLFunctionBooleanResult;
		at: #abs put: 'ABS(%1)' asSQLFunction;
		at: #rounded put: 'ROUND(%1)' asSQLFunctionIntegerResult;
		"Integer bit manipulation functions (the logical role of these is handled directly)"
		at: #& put: '(%1 & %2)' asSQLFunction;
		at: #| put: '(%1 | %2)' asSQLFunction;
		
		"String functions"
		at: #size put: 'LEN(%1)' asSQLFunctionIntegerResult;
		at: #, put: '(%1 || %2)' asSQLFunction;
		at: #indexOfSubCollection: put: 'INSTR(%1,%2)' asSQLFunctionIntegerResult;
		at: #midString:from: put: 'SUBSTRING(%1 FROM %3 FOR %2)' asSQLFunction;
		at: #trimBlanks put: 'TRIM(%1)' asSQLFunction;
		at: #asUppercase put: 'UPPER(%1)' asSQLFunction;
		at: #asLowercase put: 'LOWER(%1)' asSQLFunction;

		"Aggregate functions"
		at: #count put: 'COUNT(%1)' asSQLFunctionIntegerResult beAggregateFunction;
		at: #sum put: 'SUM(%1)' asSQLFunction beAggregateFunction;
		at: #minimum put: 'MIN(%1)' asSQLFunction beAggregateFunction;
		at: #maximum put: 'MAX(%1)' asSQLFunction beAggregateFunction;
		at: #average put: 'AVG(%1)' asSQLFunction beAggregateFunction;

		"Logical functions"
		at: #ifNil: put: 'IFNULL(%1,%2)' asSQLFunction;
		at: #ifNull: put: 'IFNULL(%1,%2)' asSQLFunction;
		at: #ifNull:ifNotNull: put: ('CASE WHEN %1 IS NULL THEN %2 ELSE %3 END' asSQLFunction resultParamIndex: 2);
		at: #then:else: put: ('CASE WHEN %1 THEN %2 ELSE %3 END' asSQLFunction resultParamIndex: 2);

		yourself!

connection
	^connection!

connection: anObject
	connection := anObject!

date

	^'DATE'!

datetime

	^'DATETIME'!

datetimeWithResolution

	"Parameter is resolution (0=seconds, 3=milliseconds etc.)"

	^'DATETIME(<1p>)'!

decimal

	^'DECIMAL(<1p>,<2p>)'!

defaultClassNameTransformation

	^[ :name | name sswInUnderscoreFormat]!

defaultCursorType

	"Return the Symbol-ic name of the cursor type that will be used when creating statements for cursored results in this dialect. 
	The names are adopted from the Dolphin ODBC package:
		CursorTypes
			at: #static put: SQL_CURSOR_STATIC;
			at: #forwardOnly put: SQL_CURSOR_FORWARD_ONLY;
			at: #keysetDriven put: SQL_CURSOR_KEYSET_DRIVEN;
			at: #dynamic put: SQL_CURSOR_DYNAMIC;

	This is mostly relevant for ODBC connections since native connections don't generally support different cursor types.
	It is included in the main class since specifying a nil cursorType when executing a query is used to indicate no cursor is required - this is relevant to the native MySQL implementation"

	^#forwardOnly!

defaultDateTimeResolution

	"0 = seconds, 3 = milliseconds etc."

	^0!

defaultInstVarNameTransformation

	^[ :name | name sswInUnderscoreFormat]!

defaultMaxColumnBytes

	"default value for maxColumnBytes - see that method's comment"
	
	^self connection defaultMaxColumnBytes!

defaultMaxColumnNameLength

	"Return an appropriate/known value for when the connection is unable to determine"
	^self subclassResponsibility!

defaultMaxTableNameLength

	"Return an appropriate/known value for when the connection is unable to determine"
	^self subclassResponsibility!

defaultNullBoolean

	^nil!

defaultSQLFunctions

	| allDefaults |

	allDefaults := Dictionary new.

	self commonFunctions keysAndValuesDo: [ :message :sql | allDefaults at: message put: sql].
	self dialectSpecificFunctions keysAndValuesDo: [ :message :sql | allDefaults at: message put: sql].
	self platformSpecificFunctions keysAndValuesDo: [ :message :sql | allDefaults at: message put: sql].

	^allDefaults!

defaultStandardNamespace

	^nil!

defaultTimeResolution

	"0 = seconds, 3 = milliseconds etc."

	^self defaultDateTimeResolution!

defaultUnsizedBlobSize

	"default value for unsizedBlobSize - see that method's comment"
	
	"Default to the maximum column bytes - 1 (for null terminator)"
	^self maxColumnBytes - 1!

defaultUnsizedStringSize

	"default value for unsizedStringSize - see that method's comment"
	
	"Default to the maximum column bytes - 1 (for null terminator)"
	^self maxColumnBytes - 1!

dialectSpecificFunctions

	"Return a mapping from Smalltalk method names to an equivalent SQL function supported by this dialect.
	Subclasses should reimplement as appropriate"

	^Dictionary new!

double

	^'DOUBLE'!

dropColumnNamed: colString fromTable: anSSWDBTable in: anSSWReStore

	anSSWReStore executeSQLFrom: 
		[ :stream | 
		stream 
			nextPutAll: 'ALTER TABLE ';
			writeSQLFor: anSSWDBTable;
			nextPutAll: ' DROP COLUMN ';
			nextPutIdentifier: colString]!

float

	^'FLOAT'!

identifierQuoteClose

	"Return the closing character used to wrap identifiers in quotes.
	SQL standard is actually double quote char but in some dialects this requires specific config changes.
	Instead we use the backtick character which is widely supported by default, and override where necessary"

	^$`!

identifierQuoteOpen

	"Return the opening character used to wrap identifiers in quotes.
	SQL standard is actually double quote char but in some dialects this requires specific config changes.
	Instead we use the backtick character which is widely supported by default, and override where necessary"

	^$`!

initialize

	self
		sqlFunctions: self defaultSQLFunctions;
		nullBoolean: self defaultNullBoolean;
		classNameTransformation: self defaultClassNameTransformation;
		instVarNameTransformation: self defaultInstVarNameTransformation!

initializeFor: aDBConnection

	self
		connection: aDBConnection;
		maxColumnBytes: self defaultMaxColumnBytes;
		unsizedStringSize: self defaultUnsizedStringSize;
		unsizedBlobSize: self defaultUnsizedBlobSize;
		maxColumnNameLength: (aDBConnection maxColumnNameLength ifNil: [self defaultMaxColumnNameLength]);
		maxTableNameLength: (aDBConnection maxTableNameLength ifNil: [self defaultMaxTableNameLength]);
		standardNamespace: self defaultStandardNamespace!

instVarNameTransformation

	"classNmeTransformation stores a one-arg Block which is evaluated with an instance variable name and should deliver an equivalent database name.
	Standard tranformation is (e.g.) customerOrder -> customer_order"

	^instVarNameTransformation!

instVarNameTransformation: aBlock

	"classNmeTransformation stores a one-arg Block which is evaluated with an instance variable name and should deliver an equivalent database name.
	Standard tranformation is (e.g.) customerOrder -> customer_order"

	instVarNameTransformation := aBlock!

integer

	^'INTEGER'!

integerMaximum

	"Typically 4 byte signed"

	^##((2 ** 31) - 1)!

integerMinimum

	"Typically 4 byte signed"

	^##((2 ** 31) negated)!

largeInteger

	^'BIGINT'!

largeIntegerMaximum

	"Typically 8 byte signed"

	^##((2 ** 63) - 1)!

largeIntegerMinimum

	"Typically 8 byte signed"

	^##((2 ** 63) negated)!

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

	"defaultMaxColumnBytes defines the default maximum size of a column in bytes; this is not really a dialect-specific attribute but its value affects the choice of String column type so we specify it here.

	The default is defined by the connection object; if a different size is needed you can set an appropriate value for your application following login.
	
	Also bear in mind that (depending on the driver) this value may be used when creating a buffer for each unsized column which is replicated.
	If you increase this value then consider specifying a maximum String size in your class spec methods to avoid unnecessarily large buffers"

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

maxTimeResolution

	"0 = seconds, 3 = milliseconds etc."

	^self maxDateTimeResolution!

maxVarchar

	^self maxCharacter!

nullBoolean

	"nullBoolean stores the object used when a NULL value is returned from a Boolean field.
	Historically, ReStore coerced any non-true value (including NULL) to false, however the current behaviour is to return nil instead.
	To use the legacy behaviour, set nullBoolean to false"

	^nullBoolean!

nullBoolean: anObject

	"nullBoolean stores the object used when a NULL value is returned from a Boolean field.
	Historically, ReStore coerced any non-true value (including NULL) to false, however the current behaviour is to return nil instead.
	To use the legacy behaviour, set nullBoolean to false"

	nullBoolean := anObject!

onConnected: aConnection

	"Sent to the dialect immediately after login"

	self postLoginScript ifNotNil: 
		[ :script | 
		aConnection evaluateAsTxn: [aConnection exec: script. true]]!

platformSpecificFunctions

	"Return a mapping from Smalltalk method names which are specific to this platform (Dolphin, Pharo...) to an equivalent SQL function in this dialect.
	Subclass implementations should be in the appropriate platform-specific package"

	^Dictionary new!

postLoginScript

	"Return any SQL String which should be evaluated on each login for this dialect, or nil if none"

	^nil!

printParameterPlaceholder: anInteger on: aStream

	"Defer to the connection"
	self connection printParameterPlaceholder: anInteger on: aStream!

renameField: oldField to: newField in: aReStore

	"Simple implementation for dialects with no explicit rename column support"

	| table definitionTable updator |

	table := newField table.
	definitionTable := table rootTable forCreation.

	"Add a new column with the new name"
	self addFields: (Array with: newField) to: definitionTable in: aReStore. 
		
	"Update all instances in DB so newInstVar column value = oldInstVar column value"
	updator := (newField accessor name, ':') asSymbol.
	(aReStore instancesOf: table instanceClass) modify: [ :each | each perform: updator with: (each perform: oldField accessor name)].

	"Drop the old column"
	self dropColumnNamed: oldField name fromTable: definitionTable in: aReStore!

renameTable: oldTable to: newTable in: anSSWReStore

	anSSWReStore executeSQLFrom: 
		[ :stream | 
		stream 
			nextPutAll: 'ALTER TABLE ';
			writeSQLFor: oldTable;
			nextPutAll: ' RENAME TO ';
			nextPutIdentifier: newTable name]!

shouldExpandNamespacedAllFields

	"Return true if the all fields * pseudo-field should be expanded into a list of fields where the table has a namspace, i.e. namespace.table.field1, namespace.table.field2 etc. instead of namespace.table.*
	Needed to accomodate SQLite which gives an error with namespace.table.* in SELECT query"

	^false!

shouldMapEmptyStringsToNil

	"Return whether empty Strings should be mapped to nil before storage in the database.
	This can be useful for databases in which default String fields to 'Do not allow zero size (usually this attribute cannot be set via ODBC/SQL)"

	^false!

sqlFunctionFor: aMessageSelector

	^self sqlFunctions at: aMessageSelector ifAbsent: [nil]!

sqlFunctions

	"sqlFunctions stores a mapping from Smalltalk method names (which may not actually be implemented!!) to an equivalent SQL function.
	It is initialized from the various function methods in the constants category, however client code may add initial functions after login, e.g.

		at: #plusPercent: put: '%1 * (1 + (%2 / 100))'

	Also note that, since the dialect is created following login, these must be (re)set up after login"

	^sqlFunctions!

sqlFunctions: aDictionary

	"sqlFunctions stores a mapping from Smalltalk method names (which may not actually be implemented!!) to an equivalent SQL function.
	It is initialized from the various function methods in the constants category, however client code may add initial functions after login, e.g.

		at: #plusPercent: put: '%1 * (1 + (%2 / 100))'

	Also note that, since the dialect is created following login, these must be (re)set up after login"

	sqlFunctions := aDictionary!

sqlWriteStream

	^SSWSQLWriteStream newIn: self!

standardNamespace

	"standardNamespace stores the namespace (schema/database) in which unqualified (without a namespace. prefix) table names exist.
	This is initialized to a default for this dialect - see defaultStandardNamespace - and may be nil where this is irrelevant/unnecessary"

	^standardNamespace!

standardNamespace: aString

	"standardNamespace stores the namespace (schema/database) in which unqualified (without a namespace. prefix) table names exist.
	This is initialized to a default for this dialect - see defaultStandardNamespace - and may be nil where this is irrelevant/unnecessary"

	standardNamespace := aString!

supportsDeleteWithJoin

	"Answer whether this dialect supports DELETE queries featuring JOINs"

	^false!

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

timeWithResolution

	"Parameter is resolution (0=seconds, 3=milliseconds etc.)"

	^'TIME(<1p>)'!

transformClassName: aSymbol

	"Transform the given class name into a DB-style String appropriate/conventional for this dialect"

	^self classNameTransformation value: aSymbol!

transformInstVarName: aSymbol

	"Transform the given inst var name into a DB-style String appropriate/conventional for this dialect"

	^self instVarNameTransformation value: aSymbol!

translateMessage: aSymbol toFunction: aSQLFunction

	self sqlFunctions at: aSymbol put: aSQLFunction!

unsizedBlob

	^'BLOB'!

unsizedBlobSize

	"unsizedBlobSize stores the size assumed for ByteArrays in persistent classes if no explicit size is given.
	Whilst not strictly an SQLDialect attribute it is specified here for its interplay with column type choice.

	An unsized ByteArray will use the smallest blob type which supports unsizedBlobSize bytes
	- this is useful for databases which have more than one unsized blob type, to ensure the most efficient type is used"

	^unsizedBlobSize!

unsizedBlobSize: anInteger

	unsizedBlobSize := anInteger.

	"Ensure we can actually handle ByteArrays of this size. +1 is to accomodate a null terminator"
	self maxColumnBytes: (self maxColumnBytes max: (self unsizedBlobSize + 1))!

unsizedString

	"Unsized = only limited by the maximum column size.
	defaultStringSize is used to determine the most appropriate column type does not imply a limit unless <= maxVarchar (see defaultStringSize method comment)"

	^self unsizedStringSize <= self maxVarchar 
		ifTrue: [self varchar expandMacrosWith: self unsizedStringSize]
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

uuid

	^(self blobTypeForSize: 16) expandMacrosWith: 16!

varchar

	^'VARCHAR(<1p>)'! !

!SSWSQLDialect categoriesForMethods!
addFields:to:in:!maintenance!public! !
alterField:table:in:!maintenance!public! !
asIdentifier:!helpers!public! !
blob!datatypes!public! !
blobTypeForSize:!datatypes!public! !
blobTypes!datatypes!public! !
boolean!datatypes!public! !
char!datatypes!public! !
classNameTransformation!accessing!public! !
classNameTransformation:!accessing!public! !
commonFunctions!constants!public! !
connection!accessing!private! !
connection:!accessing!private! !
date!datatypes!public! !
datetime!datatypes!public! !
datetimeWithResolution!datatypes!public! !
decimal!datatypes!public! !
defaultClassNameTransformation!constants!public! !
defaultCursorType!constants!public! !
defaultDateTimeResolution!constants!public! !
defaultInstVarNameTransformation!constants!public! !
defaultMaxColumnBytes!constants!public! !
defaultMaxColumnNameLength!constants!public! !
defaultMaxTableNameLength!constants!public! !
defaultNullBoolean!constants!public! !
defaultSQLFunctions!constants!public! !
defaultStandardNamespace!constants!public! !
defaultTimeResolution!public! !
defaultUnsizedBlobSize!constants!public! !
defaultUnsizedStringSize!constants!public! !
dialectSpecificFunctions!constants!public! !
double!datatypes!public! !
dropColumnNamed:fromTable:in:!maintenance!public! !
float!datatypes!public! !
identifierQuoteClose!constants!public! !
identifierQuoteOpen!constants!public! !
initialize!initializing!public! !
initializeFor:!initializing!public! !
instVarNameTransformation!accessing!public! !
instVarNameTransformation:!accessing!public! !
integer!datatypes!public! !
integerMaximum!constants!public! !
integerMinimum!constants!public! !
largeInteger!datatypes!public! !
largeIntegerMaximum!constants!public! !
largeIntegerMinimum!constants!public! !
longText!datatypes!public! !
maxAllocatedStatements!constants!public! !
maxChar!constants!public! !
maxCharacter!constants!public! !
maxColumnBytes!accessing!public! !
maxColumnBytes:!accessing!public! !
maxColumnNameLength!accessing!public! !
maxColumnNameLength:!accessing!public! !
maxDateTimeResolution!constants!public! !
maxTableNameLength!accessing!public! !
maxTableNameLength:!accessing!public! !
maxTimeResolution!public! !
maxVarchar!constants!public! !
nullBoolean!accessing!public! !
nullBoolean:!accessing!public! !
onConnected:!event handling!public! !
platformSpecificFunctions!constants!public! !
postLoginScript!constants!public! !
printParameterPlaceholder:on:!helpers!public! !
renameField:to:in:!maintenance!public! !
renameTable:to:in:!maintenance!public! !
shouldExpandNamespacedAllFields!public!testing! !
shouldMapEmptyStringsToNil!public!testing! !
sqlFunctionFor:!accessing!public! !
sqlFunctions!accessing!public! !
sqlFunctions:!accessing!public! !
sqlWriteStream!helpers!public! !
standardNamespace!accessing!public! !
standardNamespace:!accessing!public! !
supportsDeleteWithJoin!public!testing! !
supportsImplicitTrueConditions!public!testing! !
supportsMultipleAddColumns!public!testing! !
time!datatypes!public! !
timeFormat!constants!public! !
timeWithResolution!public! !
transformClassName:!helpers!public! !
transformInstVarName:!helpers!public! !
translateMessage:toFunction:!initializing!public! !
unsizedBlob!datatypes!public! !
unsizedBlobSize!accessing!public! !
unsizedBlobSize:!accessing!public! !
unsizedString!datatypes!public! !
unsizedStringSize!accessing!public! !
unsizedStringSize:!accessing!public! !
unsizedStringTypeForSize:!datatypes!public! !
unsizedStringTypes!datatypes!public! !
updateDelaySeconds!constants!public! !
uuid!datatypes!public! !
varchar!datatypes!public! !
!

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

subclassFor: aDBConnection

	"Return the correct subclass of the receiver to use for the given DBConnection"

	"Sort to prefer subclasses with specific version number over non version-specific subclasses"
	^(self allSubclasses asSortedCollection: [ :c1 :c2 | c1 dbmsVersion size >= c2 dbmsVersion size]) detect: [ :each | each isCompatibleWithConnection: aDBConnection] ifNone: ["Fallback" self]! !

!SSWSQLDialect class categoriesForMethods!
dbmsName!constants!public! !
dbmsVersion!constants!public! !
isCompatibleWithConnection:!public!testing! !
new!instance creation!public! !
newFor:!instance creation!public! !
subclassFor:!accessing!public! !
!


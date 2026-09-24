"Filed out from Dolphin Smalltalk"!

P3Client subclass: #SSWP3Connection
	instanceVariableNames: 'sqlDialect debugStream columnDescriptions hasTxn queryCount statementCache'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWP3Connection guid: (GUID fromString: '{ee5b7119-24cb-40fe-9e23-c90c9c32563f}')!

SSWP3Connection comment: ''!

!SSWP3Connection categoriesForClass!P3-Core! !

!SSWP3Connection methodsFor!

_columnsInTable: aDBTable

	| names columns |
	
	names := self columnNamesForTable: aDBTable.
	names isNil ifTrue: [ ^#() ].

	columns := OrderedCollection new: names size.
	names keysAndValuesDo:
		[ :index :name | 
		columns add:
			( SSWDBColAttr new 
					name: name;
					index: index;
					table: aDBTable;
					field: (aDBTable fieldNamed: name);
					connection: self; 
					yourself ) ].
				
	^columns!

basicClose

	super close!

basicConnect

	super connect!

beginRWTxn

	self beginTxn!

beginTransaction 

	self execute: 'begin transaction'!

beginTxn

	self beginTransaction.
	self hasTxn: true!

close 

	self 
		prepareToClose;
		basicClose;
		resetTrait!

columnDescriptions
	^ columnDescriptions!

columnDescriptions: anObject
	columnDescriptions := anObject!

columnNamesForTable: aDBTable

	^(self query: ('select column_name from information_schema.columns where table_name = <1p>;' expandMacrosWith: aDBTable name)) data collect: [ :each | each first ]!

columns: aTableName

	^(self columnNamesForTable: aTableName) collect: [ :each | SSWDBColAttr new name: each]!

columnsForFields: aCollectionOfDBFields

	^aCollectionOfDBFields collect: [ :field | field columnIn: self]!

columnsInTable: aDBTable

	^self columnDescriptions at: aDBTable ifAbsentPut: 
		[| columns fieldMap | 
		columns := self _columnsInTable: aDBTable.
		fieldMap := IdentityDictionary new.
		aDBTable allFieldsDo: [ :field | (columns detect: [ :col | col name = field name] ifNone: [nil]) ifNotNil: [ :column | fieldMap at: field put: column]].
		fieldMap]!

commitTransaction 

	self execute: 'commit'!

commitTxn

	self commitTransaction.
	self hasTxn: false!

connect 

	self basicConnect.
	
	self isConnected ifTrue: 
		[self sqlDialect: (self sqlDialectClass newFor: self).
		self resetTrait]!

createNamespace: aString

	self execute: 'CREATE SCHEMA ', (self sqlDialect asIdentifier: aString)!

dbErrorClass

	^P3Error!

dbmsName

	^SSWMySQLDialect dbmsName!

dbmsVersion

	^[(self query: 'select version()') rows first atIndex: 1] on: Error do: [ :exc | exc return: '']!

debugStream
	^ debugStream!

debugStream: anObject
	debugStream := anObject!

declaredColumnTypesForTable: aDBTable

	^(self query: ('SELECT data_type, character_maximum_length FROM information_schema.COLUMNS WHERE TABLE_NAME = <1p>;' expandMacrosWith: aDBTable name)) data collect: [ :each | each first asString, each second displayString]!

defaultMaxColumnBytes

	"Comment taken from Dolphin implementation; method is included here since it also impacts on the assumed size of unsized Strings:
	
	
	defaultMaxColumnBytes defines the default maximum size of a column in bytes - this is used to initialize/cap the size of a column's replication buffer.
	
	The default is 128KB (2 raisedTo: 17) which is increased compared to the limit defined in Dolphin's Database Connection (64KB, 2 raisedTo: 16 - see DBField>>initializeForColumn:).
	If a larger size is needed you can set an appropriate value for your application following login by sending maxColumnBytes: to your ReStore's sqlDialect object.
	Bear in mind that wide character strings (if supported) can use > 1 byte per character.
	
	Also bear in mind that this value is used when creating a ByteArray for each unsized column which is replicated.
	If you increase this value then consider specifying a maximum String size in your reStoreDefinition methods to avoid unnecessarily large buffers.

	Also bear in mind that this value can be limited by the ODBC driver. 
	e.g. as of writing SQLite appears to be limited to 65536 bytes, whilst Postgres lets you specify the limit in the Datasource dialog (but the default is only 8190 bytes!!!!)

	Purely anecdotally, a maxColumnBytes of 1MB (2 raisedTo: 20) makes no discernable performance difference compared to the Dolphin default size of 64KB when run over the entire ReStore test suite.

	Very large values really need the use of unbound columns and incremental (paged) put/getData, however this is not yet implemented (and is potentially less performant than bound columns)"

	^"(2**17)" 131072!

dropNamespace: aString

	self execute: 'DROP SCHEMA ', (self sqlDialect asIdentifier: aString)!

error: aString

	"Use the expected dbErrorClass"
	
	^self dbErrorClass signal: aString!

evaluateAsTxn: aBlock

	"Evaluate aBlock within a database transaction (Txn in Dolphin DBConnect parlance).
	aBlock should evaluate to aBoolean indicating the success of its operation.
	If true, the transaction is committed, if false it is rolled back"

	^
		[self beginRWTxn.
		aBlock value
			ifTrue: [self commitTxn. true]
			ifFalse: [self rollbackTxn. false]] on: Error do: [ :exc | self rollbackTxn. exc pass]!

exec: aString

	self logQueryExecution: aString.
	^self execute: aString!

execute: query

	"Override to return the raw results object.
	Convention says we should return a statement here, but they are compatible enough"

	^self query: query!

executeQuery: anSQLQuery cursorType: aSymbol

	"Entry point for ad-hoc querying"

	| stream values statement |
		
	anSQLQuery preExecIn: self.

	stream := SSWSQLWriteStream newIn: self sqlDialect.
	anSQLQuery writeSQLOn: stream.
	values := stream parameterizedValues collect: [ :each | each reStoreValue].
	statement := self prepare: stream contents.

	^statement 
		setQuery: anSQLQuery;
		values: values;
		cursorType: aSymbol;
		exec;
		yourself!

forgetTable: aDBTable

	self columnDescriptions removeKey: aDBTable ifAbsent: []!

free 
	self close!

hasTxn

	^hasTxn ifNil: [ hasTxn := false ]!

hasTxn: aBoolean

	hasTxn := aBoolean!

incrementQueryCount

	queryCount ifNotNil: [ queryCount := queryCount + 1 ]!

isConnected

	^super isConnected!

isDebug

	^self debugStream notNil!

logQueryExecution: aString

	self debugStream ifNotNil: [ :stream | stream cr; show: aString].
	self incrementQueryCount!

logStatementExecution: aStatement

	self debugStream ifNotNil: [ :stream | stream cr. aStatement writeDebugInfoOn: stream].
	self incrementQueryCount!

maxColumnNameLength
	^63!

maxTableNameLength
	^63!

onStartup 

	[self close] on: self dbErrorClass do: [ :exc | exc return].
	[self connect] on: self dbErrorClass do: [ :exc | exc return]!

postConnect

	self syncTimeZone.

	self sqlDialect onConnected: self!

prepare: aString

	^self statementCache add: (self prepare: aString named: self statementCache size displayString)!

prepare: query named: queryName

	^(super prepare: query named: queryName) asSSWP3Statement
		sqlString: query; 
		yourself!

prepareQuery: anSQLQuery

	"Entry point for system-generated querying (read, refresh, insert).
	Prepare and return a parameterized statement for the execution of anSQLQuery"

	| stream |

	stream := SSWSQLWriteStream newIn: self sqlDialect.
	anSQLQuery writeSQLOn: stream.

	^(self prepare: stream contents)
		setQuery: anSQLQuery;
		parametersCount: stream parameterizedValues size;
		yourself!

prepareToClose

	self statementCache isNil ifFalse: [self statementCache do: [ :each | each free ]]!

printParameterPlaceholder: anInteger on: aStream

	aStream nextPut: $$.
	anInteger printOn: aStream!

queryCount
	^ queryCount!

queryCount: anObject
	queryCount := anObject!

reservedWords

	^#('ADD' 'ALL' 'ALTER' 'ANALYZE' 'AND' 'AS' 'ASC' 'AUTO_INCREMENT' 'BDB' 'BERKELEYDB' 'BETWEEN' 'BIGINT' 'BINARY' 'BLOB' 'BOTH' 'BTREE' 'BY' 'CASCADE' 'CASE' 'CHANGE' 'CHAR' 'CHARACTER' 'CHECK' 'COLLATE' 'COLUMN' 'COLUMNS' 'CONSTRAINT' 'CREATE' 'CROSS' 'CURRENT_DATE' 'CURRENT_TIME' 'CURRENT_TIMESTAMP' 'DATABASE' 'DATABASES' 'DAY_HOUR' 'DAY_MINUTE' 'DAY_SECOND' 'DEC' 'DECIMAL' 'DEFAULT' 'DELAYED' 'DELETE' 'DESC' 'DESCRIBE' 'DISTINCT' 'DISTINCTROW' 'DIV' 'DOUBLE' 'DROP' 'ELSE' 'ENCLOSED' 'ERRORS' 'ESCAPED' 'EXISTS' 'EXPLAIN' 'FALSE' 'FIELDS' 'FLOAT' 'FOR' 'FORCE' 'FOREIGN' 'FROM' 'FULLTEXT' 'FUNCTION' 'GEOMETRY' 'GRANT' 'GROUP' 'HASH' 'HAVING' 'HELP' 'HIGH_PRIORITY' 'HOUR_MINUTE' 'HOUR_SECOND' 'IF' 'IGNORE' 'IN' 'INDEX' 'INFILE' 'INNER' 'INNODB' 'INSERT' 'INT' 'INTEGER' 'INTERVAL' 'INTO' 'IS' 'JOIN' 'KEY' 'KEYS' 'KILL' 'LEADING' 'LEFT' 'LIKE' 'LIMIT' 'LINES' 'LOAD' 'LOCALTIME' 'LOCALTIMESTAMP' 'LOCK' 'LONG' 'LONGBLOB' 'LONGTEXT' 'LOW_PRIORITY' 'MASTER_SERVER_ID' 'MATCH' 'MEDIUMBLOB' 'MEDIUMINT' 'MEDIUMTEXT' 'MIDDLEINT' 'MINUTE_SECOND' 'MOD' 'MRG_MYISAM' 'NATURAL' 'NOT' 'NULL' 'NUMERIC' 'ON' 'OPTIMIZE' 'OPTION' 'OPTIONALLY' 'OR' 'ORDER' 'OUTER' 'OUTFILE' 'PRECISION' 'PRIMARY' 'PRIVILEGES' 'PROCEDURE' 'PURGE' 'READ' 'REAL' 'REFERENCES' 'REGEXP' 'RENAME' 'REPLACE' 'REQUIRE' 'RESTRICT' 'RETURNS' 'REVOKE' 'RIGHT' 'RLIKE' 'RTREE' 'SELECT' 'SET' 'SHOW' 'SMALLINT' 'SOME' 'SONAME' 'SPATIAL' 'SQL_BIG_RESULT' 'SQL_CALC_FOUND_ROWS' 'SQL_SMALL_RESULT' 'SSL' 'STARTING' 'STRAIGHT_JOIN' 'STRIPED' 'TABLE' 'TABLES' 'TERMINATED' 'THEN' 'TINYBLOB' 'TINYINT' 'TINYTEXT' 'TO' 'TRAILING' 'TRUE' 'TYPES' 'UNION' 'UNIQUE' 'UNLOCK' 'UNSIGNED' 'UPDATE' 'USAGE' 'USE' 'USER_RESOURCES' 'USING' 'VALUES' 'VARBINARY' 'VARCHAR' 'VARCHARACTER' 'VARYING' 'WARNINGS' 'WHEN' 'WHERE' 'WITH' 'WRITE' 'XOR' 'YEAR_MONTH' 'ZEROFILL')!

reset

	self statementCache: (OrderedCollection new: 128)!

resetQueryCount

	self queryCount: 0!

resetTrait

	self 
		columnDescriptions: IdentityDictionary new;
		reset!

rollbackTransaction 

	self execute: 'rollback'!

rollbackTxn

	"begin a transaction if one is not active
	(for db refresh purposes it can be useful to arbitarily execut a rollback)"

	self hasTxn ifFalse: [ self beginTxn ].
	self rollbackTransaction.
	self hasTxn: false!

runExtendedQueryResult: descriptions
	^(super runExtendedQueryResult: descriptions) asSSWP3ResultSet!

runQueryResult
	^super runQueryResult asSSWP3ResultSet!

sqlDialect
	^ sqlDialect!

sqlDialect: anObject
	sqlDialect := anObject!

sqlDialectClass 

	^SSWPostgreSQLNativeDialect!

statementCache
	^statementCache!

statementCache: anObject
	statementCache := anObject!

stopQueryCounting

	self queryCount: nil!

supportsScrollableCursors

	^true!

supportsScrollableDynamicCursorType

	^true!

supportsScrollableStaticCursorType

	^true!

syncTimeZone

	| localeOffset |

	"Ensure the session timezone matches the Locale"
	localeOffset := Locale timeZoneInformation currentBias negated minutes.
	self utcOffset = localeOffset ifFalse: [self utcOffset: localeOffset]!

tables

	^self tablesInNamespace: self sqlDialect standardNamespace!

tablesInNamespace: aString

	^(self listTablesInSchema: (aString ifNil: [self sqlDialect standardNamespace])) asOrderedCollection collect: [ :each | each first ]!

utcOffset

	^((self query: 'select now() - (now() at time zone ''utc'');') first atIndex: 1) asDuration!

utcOffset: aDuration

	self exec: 'SET TIME ZONE <1p>' << (aDuration negated "POSIX-style offset, i.e. inverted" printStringFormat: '+hh:mm')!

willAutoCommit: aBoolean! !

!SSWP3Connection categoriesForMethods!
_columnsInTable:!enquiries!public! !
basicClose!connection open/close!public! !
basicConnect!connection open/close!public! !
beginRWTxn!public!transactions! !
beginTransaction!public!transactions! !
beginTxn!public!transactions! !
close!connection open/close!public! !
columnDescriptions!accessing!public! !
columnDescriptions:!accessing!public! !
columnNamesForTable:!private! !
columns:!enquiries!public! !
columnsForFields:!enquiries!public! !
columnsInTable:!enquiries!public! !
commitTransaction!public!transactions! !
commitTxn!public!transactions! !
connect!connection open/close!public! !
createNamespace:!db maintenance!public! !
dbErrorClass!public!public API / introspection! !
dbmsName!enquiries!public! !
dbmsVersion!enquiries!public! !
debugStream!accessing!public! !
debugStream:!accessing!public! !
declaredColumnTypesForTable:!enquiries!public! !
defaultMaxColumnBytes!constants!public! !
dropNamespace:!db maintenance!public! !
error:!error handling!public! !
evaluateAsTxn:!public!transactions! !
exec:!public!querying! !
execute:!public!running! !
executeQuery:cursorType:!public!querying! !
forgetTable:!accessing!public! !
free!connection open/close!public! !
hasTxn!public!transactions! !
hasTxn:!accessing!public! !
incrementQueryCount!public!querying! !
isConnected!public!testing! !
isDebug!public!testing! !
logQueryExecution:!public!querying! !
logStatementExecution:!public!querying! !
maxColumnNameLength!accessing!public! !
maxTableNameLength!accessing!public! !
onStartup!connection open/close!public! !
postConnect!connection open/close!public! !
prepare:!accessing!public! !
prepare:named:!accessing!public! !
prepareQuery:!public!querying! !
prepareToClose!connection open/close!public! !
printParameterPlaceholder:on:!printing!public! !
queryCount!accessing!public! !
queryCount:!accessing!public! !
reservedWords!accessing!public! !
reset!connection open/close!public! !
resetQueryCount!public!querying! !
resetTrait!connection open/close!public! !
rollbackTransaction!public!transactions! !
rollbackTxn!public!transactions! !
runExtendedQueryResult:!public!querying! !
runQueryResult!public!querying! !
sqlDialect!accessing!public! !
sqlDialect:!accessing!public! !
sqlDialectClass!constants!public! !
statementCache!accessing!private! !
statementCache:!accessing!private! !
stopQueryCounting!public!querying! !
supportsScrollableCursors!public!testing! !
supportsScrollableDynamicCursorType!public!testing! !
supportsScrollableStaticCursorType!public!testing! !
syncTimeZone!connection open/close!private! !
tables!enquiries!public! !
tablesInNamespace:!accessing!public! !
utcOffset!accessing!public!public API / introspection! !
utcOffset:!accessing!public!public API / introspection! !
willAutoCommit:!accessing!public! !
!


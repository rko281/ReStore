"Filed out from Dolphin Smalltalk"!

MySQLDriver subclass: #SSWMySQLConnection
	instanceVariableNames: 'sqlDialect debugStream columnDescriptions hasTxn queryCount connectionSpec'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWMySQLConnection guid: (GUID fromString: '{61c6a1a5-b66a-47fd-9a14-1e10fed675ea}')!

SSWMySQLConnection comment: ''!

!SSWMySQLConnection categoriesForClass!SSW ReStore MySQL! !

!SSWMySQLConnection methodsFor!

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

	self connected ifTrue: [self disconnect]!

basicConnect

	| result |

	result := self connect: self connectionSpec.
	result isError ifTrue: [ result signalError ]!

beginRWTxn

	self beginTxn!

beginTransaction
	
	self query: 'BEGIN'!

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

	| stream |
	
	stream := self sqlDialect sqlWriteStream.
	stream nextPutAll: 'SHOW COLUMNS FROM '; writeSQLFor: aDBTable.

	^(self execute: stream contents) collect: [ :row | row first ]!

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

commandQueryClass

	^SSWMySQLCommandQuery!

commitTransaction
	
	self query: 'COMMIT'!

commitTxn

	self commitTransaction.
	self hasTxn: false!

connect 

	self basicConnect.
	
	self isConnected ifTrue: 
		[self sqlDialect: (self sqlDialectClass newFor: self).
		self resetTrait]!

connectionSpec
	^ connectionSpec!

connectionSpec: anObject
	connectionSpec := anObject!

createNamespace: aString

	self execute: 'CREATE SCHEMA ', (self sqlDialect asIdentifier: aString)!

dbErrorClass

	^MySQLDriverError!

dbmsVersion

	^[(self query: 'select version()') rows first atIndex: 1] on: Error do: [ :exc | exc return: '']!

debugStream
	^ debugStream!

debugStream: anObject
	debugStream := anObject!

declaredColumnTypesForTable: aDBTable

	| stream |
	
	stream := self sqlDialect sqlWriteStream.
	stream nextPutAll: 'SHOW COLUMNS FROM '; writeSQLFor: aDBTable.

	^(self execute: stream contents) collect: [ :row | Utf8String fromByteArray: (row atIndex: 2)]!

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

execute: aString

	| result |

	result := self query: aString.
	result isError ifTrue: [result signalError].
	^result!

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

	^self connected!

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

prepare: queryString

	^(SSWMySQLStatement onConnection: self)
		stmtId: (super prepare: queryString) prepareOkay stmtHandlerId; 
		sqlString: queryString;
		cursoredFetch: false;
		typeMapResults: false;
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

	"Allow resources to be finalized"!

printParameterPlaceholder: anInteger on: aStream

	aStream nextPut: $?!

queryCount
	^ queryCount!

queryCount: anObject
	queryCount := anObject!

reservedWords

	^#('ADD' 'ALL' 'ALTER' 'ANALYZE' 'AND' 'AS' 'ASC' 'AUTO_INCREMENT' 'BDB' 'BERKELEYDB' 'BETWEEN' 'BIGINT' 'BINARY' 'BLOB' 'BOTH' 'BTREE' 'BY' 'CASCADE' 'CASE' 'CHANGE' 'CHAR' 'CHARACTER' 'CHECK' 'COLLATE' 'COLUMN' 'COLUMNS' 'CONSTRAINT' 'CREATE' 'CROSS' 'CURRENT_DATE' 'CURRENT_TIME' 'CURRENT_TIMESTAMP' 'DATABASE' 'DATABASES' 'DAY_HOUR' 'DAY_MINUTE' 'DAY_SECOND' 'DEC' 'DECIMAL' 'DEFAULT' 'DELAYED' 'DELETE' 'DESC' 'DESCRIBE' 'DISTINCT' 'DISTINCTROW' 'DIV' 'DOUBLE' 'DROP' 'ELSE' 'ENCLOSED' 'ERRORS' 'ESCAPED' 'EXISTS' 'EXPLAIN' 'FALSE' 'FIELDS' 'FLOAT' 'FOR' 'FORCE' 'FOREIGN' 'FROM' 'FULLTEXT' 'FUNCTION' 'GEOMETRY' 'GRANT' 'GROUP' 'HASH' 'HAVING' 'HELP' 'HIGH_PRIORITY' 'HOUR_MINUTE' 'HOUR_SECOND' 'IF' 'IGNORE' 'IN' 'INDEX' 'INFILE' 'INNER' 'INNODB' 'INSERT' 'INT' 'INTEGER' 'INTERVAL' 'INTO' 'IS' 'JOIN' 'KEY' 'KEYS' 'KILL' 'LEADING' 'LEFT' 'LIKE' 'LIMIT' 'LINES' 'LOAD' 'LOCALTIME' 'LOCALTIMESTAMP' 'LOCK' 'LONG' 'LONGBLOB' 'LONGTEXT' 'LOW_PRIORITY' 'MASTER_SERVER_ID' 'MATCH' 'MEDIUMBLOB' 'MEDIUMINT' 'MEDIUMTEXT' 'MIDDLEINT' 'MINUTE_SECOND' 'MOD' 'MRG_MYISAM' 'NATURAL' 'NOT' 'NULL' 'NUMERIC' 'ON' 'OPTIMIZE' 'OPTION' 'OPTIONALLY' 'OR' 'ORDER' 'OUTER' 'OUTFILE' 'PRECISION' 'PRIMARY' 'PRIVILEGES' 'PROCEDURE' 'PURGE' 'READ' 'REAL' 'REFERENCES' 'REGEXP' 'RENAME' 'REPLACE' 'REQUIRE' 'RESTRICT' 'RETURNS' 'REVOKE' 'RIGHT' 'RLIKE' 'RTREE' 'SELECT' 'SET' 'SHOW' 'SMALLINT' 'SOME' 'SONAME' 'SPATIAL' 'SQL_BIG_RESULT' 'SQL_CALC_FOUND_ROWS' 'SQL_SMALL_RESULT' 'SSL' 'STARTING' 'STRAIGHT_JOIN' 'STRIPED' 'TABLE' 'TABLES' 'TERMINATED' 'THEN' 'TINYBLOB' 'TINYINT' 'TINYTEXT' 'TO' 'TRAILING' 'TRUE' 'TYPES' 'UNION' 'UNIQUE' 'UNLOCK' 'UNSIGNED' 'UPDATE' 'USAGE' 'USE' 'USER_RESOURCES' 'USING' 'VALUES' 'VARBINARY' 'VARCHAR' 'VARCHARACTER' 'VARYING' 'WARNINGS' 'WHEN' 'WHERE' 'WITH' 'WRITE' 'XOR' 'YEAR_MONTH' 'ZEROFILL')!

reset

	"Carry out any reset actions necessary after connect or disconnect"!

resetQueryCount

	self queryCount: 0!

resetTrait

	self 
		columnDescriptions: IdentityDictionary new;
		reset!

rollbackTransaction
	
	self query: 'ROLLBACK'!

rollbackTxn

	"begin a transaction if one is not active
	(for db refresh purposes it can be useful to arbitarily execut a rollback)"

	self hasTxn ifFalse: [ self beginTxn ].
	self rollbackTransaction.
	self hasTxn: false!

sqlDialect
	^ sqlDialect!

sqlDialect: anObject
	sqlDialect := anObject!

sqlDialectClass

	^self isMariaDB
		ifTrue: [SSWMariaDBNativeDialect]
		ifFalse: [SSWMySQLNativeDialect]!

stopQueryCounting

	self queryCount: nil!

supportsScrollableCursors

	^false!

syncTimeZone

	| localeOffset |

	"Ensure the session timezone matches the Locale"
	localeOffset := Locale timeZoneInformation offset.
	self utcOffset = localeOffset 
		ifTrue: [MySQLBinaryReader default utcOffset: nil]
		ifFalse: [self utcOffset: localeOffset]!

tables

	^self tablesInNamespace: self sqlDialect standardNamespace!

tablesInNamespace: aString

	^(((aString isNil or: [aString = self sqlDialect standardNamespace])
		ifTrue: [ self execute: 'SHOW TABLES' ]
		ifFalse: [ self execute: 'SHOW TABLES IN ', (self sqlDialect asIdentifier: aString) ]) collect: [ :row | row first ]) asOrderedCollection!

utcOffset

	"Query result will be a Time if positive or Duration if negative"
	^Duration seconds: ((self exec: 'SELECT TIMEDIFF(NOW(), UTC_TIMESTAMP);') first at: 1) asSeconds!

utcOffset: aDuration

	self exec: 'set @@session.time_zone = <1p>' << (aDuration printStringFormat: '+hh:mm').

	"Also update the reader"
	MySQLBinaryReader default utcOffset: aDuration!

versionString

	^(self query: 'select version()') rows first at: 1!

willAutoCommit: aBoolean! !

!SSWMySQLConnection categoriesForMethods!
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
commandQueryClass!accessing!public! !
commitTransaction!public!transactions! !
commitTxn!public!transactions! !
connect!connection open/close!public! !
connectionSpec!accessing!public! !
connectionSpec:!accessing!public! !
createNamespace:!db maintenance!public! !
dbErrorClass!public!public API / introspection! !
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
sqlDialect!accessing!public! !
sqlDialect:!accessing!public! !
sqlDialectClass!constants!public! !
stopQueryCounting!public!querying! !
supportsScrollableCursors!public!testing! !
syncTimeZone!connection open/close!private! !
tables!enquiries!public! !
tablesInNamespace:!accessing!public! !
utcOffset!accessing!public!public API / introspection! !
utcOffset:!accessing!public!public API / introspection! !
versionString!accessing!public! !
willAutoCommit:!accessing!public! !
!

!SSWMySQLConnection class methodsFor!

on: aMySQLDriverSpec

	^self new 
		connectionSpec: aMySQLDriverSpec;
		yourself! !

!SSWMySQLConnection class categoriesForMethods!
on:!instance creation!public! !
!


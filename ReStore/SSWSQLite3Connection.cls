"Filed out from Dolphin Smallalk"!

SQLite3Connection subclass: #SSWSQLite3Connection
	instanceVariableNames: 'sqlDialect debugStream columnDescriptions hasTxn queryCount'
	classVariableNames: ''
	poolDictionaries: 'SQLite3Constants'
	classInstanceVariableNames: ''!
SSWSQLite3Connection guid: (GUID fromString: '{9a6695ab-0c71-44c0-8c25-4b5d7f385335}')!
SSWSQLite3Connection comment: ''!
!SSWSQLite3Connection categoriesForClass!SQLite3-Core-Connections! !
!SSWSQLite3Connection methodsFor!

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

	dbHandle isNil ifTrue: [ dbHandle := SQLite3DatabaseExternalObject new ].

	^self open!

beginRWTxn

	self beginTxn!

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
	
	| s columns |

	self isOpen ifFalse: [ SQLite3NotOpen signal ].

	columns := OrderedCollection new.
	s := self prepare: 'pragma table_info(', (self sqlDialect asIdentifier: aDBTable name), ')'.
	s basicExecute: [ :row | columns add: (row stringAt: 1) ].
	s finalize.
	^ columns!

columns: aTableName

	^(self columnNamesFor: aTableName) collect: [ :each | SSWDBColAttr new name: each]!

columnsForFields: aCollectionOfDBFields

	^aCollectionOfDBFields collect: [ :field | field columnIn: self]!

columnsInTable: aDBTable

	^self columnDescriptions at: aDBTable ifAbsentPut: 
		[| columns fieldMap | 
		columns := self _columnsInTable: aDBTable.
		fieldMap := IdentityDictionary new.
		aDBTable allFieldsDo: [ :field | (columns detect: [ :col | col name = field name] ifNone: [nil]) ifNotNil: [ :column | fieldMap at: field put: column]].
		fieldMap]!

commitTxn

	self commitTransaction.
	self hasTxn: false!

connect 

	self basicConnect.
	
	self isConnected ifTrue: 
		[self sqlDialect: (self sqlDialectClass newFor: self).
		self resetTrait]!

createNamespace: aString

	"Since there is no filename given, map this to creating a temporary attached database"

	^self execute: 'ATTACH DATABASE '''' AS ', (self sqlDialect asIdentifier: aString)!

dbErrorClass

	^SQLite3AbstractError!

debugStream
	^ debugStream!

debugStream: anObject
	debugStream := anObject!

declaredColumnTypesForTable: aDBTable
	
	| s columns |

	self isOpen ifFalse: [ SQLite3NotOpen signal ].

	columns := OrderedCollection new.
	s := self prepare: 'pragma table_info(', (self sqlDialect asIdentifier: aDBTable name), ')'.
	s basicExecute: [ :row | columns add: (row stringAt: 2) ].
	s finalize.
	^ columns!

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

	^self execute: 'DETACH DATABASE ', (self sqlDialect asIdentifier: aString)!

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

	^(self prepare: aString) execute!

executeQuery: anSQLQuery cursoredFetch: aBoolean

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
		cursoredFetch: aBoolean;
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

initialize
	
	super initialize.
	statementClass := SSWSQLite3Statement!

isConnected

	^self isOpen!

isDebug

	^self debugStream notNil!

logQueryExecution: aString

	self debugStream ifNotNil: [ :stream | stream cr; show: aString].
	self incrementQueryCount!

masterTableForNamespace: aString

	^(aString isNil or: [aString = self sqlDialect standardNamespace])
		ifTrue: [ 'sqlite_master' ]
		ifFalse: [ aString, '.sqlite_master' ]!

maxColumnNameLength
	^63!

maxTableNameLength
	^63!

onStartup 

	[self close] on: self dbErrorClass do: [ :exc | exc return].
	[self connect] on: self dbErrorClass do: [ :exc | exc return]!

open

	"Override to enable URI naming if specified by the dbFilename"
	
	(dbFilename beginsWith: 'file:') ifFalse: [ ^super open ].

	library 
		open: dbFilename 
		withFlags: (SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_URI) 
		via: dbHandle.
		
	isOpen := true!

postConnect

	self sqlDialect postLoginScript ifNotNil: 
		[ :script | 
		self evaluateAsTxn: [self exec: script. true]]!

prepareQuery: anSQLQuery

	"Entry point for system-generated querying (read, refresh, insert).
	Prepare and return a parameterized statement for the execution of anSQLQuery"

	| stream |
		
	anSQLQuery preExecIn: self.

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

	^##(Set withAll: 'ABSOLUTE IS ACTION ISOLATION ADA JOIN ADD KEY ALL LANGUAGE ALLOCATE LAST ALTER LEADING AND LEFT ANY LEVEL ARE LIKE AS LOCAL ASC LOWER ASSERTION MATCH AT MAX AUTHORIZATION MIN AVG MINUTE BEGIN MODULE BETWEEN MONTH BIT NAMES BIT_LENGTH NATIONAL BOTH NATURAL BY NCHAR CASCADE NEXT CASCADED NO CASE NONE CAST NOT CATALOG NULL CHAR NULLIF CHAR_LENGTH NUMERIC CHARACTER OCTET_LENGTH CHARACTER_LENGTH OF CHECK ON CLOSE ONLY COALESCE OPEN COLLATE OPTION COLLATION OR COLUMN ORDER COMMIT OUTER CONNECT OUTPUT CONNECTION OVERLAPS CONSTRAINT PAD CONSTRAINTS PARTIAL CONTINUE PASCAL CONVERT POSITION CORRESPONDING PRECISION COUNT PREPARE CREATE PRESERVE CROSS PRIMARY CURRENT PRIOR CURRENT_DATE PRIVILEGES CURRENT_TIME PROCEDURE CURRENT_TIMESTAMP PUBLIC CURRENT_USER READ CURSOR REAL DATE REFERENCES DAY RELATIVE DEALLOCATE RESTRICT DEC REVOKE DECIMAL RIGHT DECLARE ROLLBACK DEFAULT ROWS DEFERRABLE SCHEMA DEFERRED SCROLL DELETE SECOND DESC SECTION DESCRIBE SELECT DESCRIPTOR SESSION DIAGNOSTICS SESSION_USER DISCONNECT SET DISTINCT SIZE DOMAIN SMALLINT DOUBLE SOME DROP SPACE ELSE SQL END SQLCA END-EXEC SQLCODE ESCAPE SQLERROR EXCEPT SQLSTATE EXCEPTION SQLWARNING EXEC SUBSTRING EXECUTE SUM EXISTS SYSTEM_USER EXTERNAL TABLE EXTRACT TEMPORARY FALSE THEN FETCH TIME FIRST TIMESTAMP FLOAT TIMEZONE_HOUR FOR TIMEZONE_MINUTE FOREIGN TO FORTRAN TRAILING FOUND TRANSACTION FROM TRANSLATE FULL TRANSLATION GET TRIM GLOBAL TRUE GO UNION GOTO UNIQUE GRANT UNKNOWN GROUP UPDATE HAVING UPPER HOUR USAGE IDENTITY USER IMMEDIATE USING IN VALUE INCLUDE VALUES INDEX VARCHAR INDICATOR VARYING INITIALLY VIEW INNER WHEN INPUT WHENEVER INSENSITIVE WHERE INSERT WITH INT WORK INTEGER WRITE INTERSECT YEAR INTERVAL ZONE INTO' subStrings)!

reset

	"Carry out any reset actions necessary after connect or disconnect"!

resetQueryCount

	self queryCount: 0!

resetTrait

	self 
		columnDescriptions: IdentityDictionary new;
		reset!

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

	^SSWSQLiteNativeDialect!

stopQueryCounting

	self queryCount: nil!

tables

	^self tablesInNamespace: self sqlDialect standardNamespace!

tablesInNamespace: aString

	| tables s |
	
	self isOpen
		ifFalse: [ SQLite3NotOpen signal ]
		ifTrue: [ 
			tables := OrderedCollection new.
			s := self prepare: 'select tbl_name from ', (self masterTableForNamespace: aString), ' where type = "table"'.
	  		s basicExecute: [ :row |
				(row dataValuesAvailable > 0) ifTrue: [ tables add: (row stringAt: 0) ]].
	  		s finalize.
			^ tables ]!

willAutoCommit: aBoolean! !
!SSWSQLite3Connection categoriesForMethods!
_columnsInTable:!enquiries!public! !
basicClose!connection open/close!public! !
basicConnect!initialization!public! !
beginRWTxn!public!transactions! !
beginTxn!public!transactions! !
close!connection open/close!public! !
columnDescriptions!accessing!public! !
columnDescriptions:!accessing!public! !
columnNamesForTable:!private! !
columns:!enquiries!public! !
columnsForFields:!enquiries!public! !
columnsInTable:!enquiries!public! !
commitTxn!public!transactions! !
connect!connection open/close!public! !
createNamespace:!db maintenance!public! !
dbErrorClass!constants!public! !
debugStream!accessing!public! !
debugStream:!accessing!public! !
declaredColumnTypesForTable:!enquiries!public! !
defaultMaxColumnBytes!constants!public! !
dropNamespace:!db maintenance!public! !
evaluateAsTxn:!public!transactions! !
exec:!public!querying! !
execute:!public!querying! !
executeQuery:cursoredFetch:!public!querying! !
forgetTable:!accessing!public! !
free!connection open/close!public! !
hasTxn!public!transactions! !
hasTxn:!accessing!public! !
incrementQueryCount!public!querying! !
initialize!initialization!public! !
isConnected!public!testing! !
isDebug!public!testing! !
logQueryExecution:!public!querying! !
masterTableForNamespace:!enquiries!public! !
maxColumnNameLength!accessing!public! !
maxTableNameLength!accessing!public! !
onStartup!connection open/close!public! !
open!connection open/close!public! !
postConnect!connection open/close!public! !
prepareQuery:!public!querying! !
prepareToClose!connection open/close!public! !
printParameterPlaceholder:on:!printing!public! !
queryCount!accessing!public! !
queryCount:!accessing!public! !
reservedWords!constants!public! !
reset!connection open/close!public! !
resetQueryCount!public!querying! !
resetTrait!connection open/close!public! !
rollbackTxn!public!transactions! !
sqlDialect!accessing!public! !
sqlDialect:!accessing!public! !
sqlDialectClass!constants!public! !
stopQueryCounting!public!querying! !
tables!enquiries!public! !
tablesInNamespace:!enquiries!public! !
willAutoCommit:!accessing!public! !
!


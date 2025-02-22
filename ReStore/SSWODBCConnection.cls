"Filed out from Dolphin Smalltalk"!

DBConnection subclass: #SSWODBCConnection
	instanceVariableNames: 'sqlDialect debugStream allocatedStatementCount columnDescriptions queryCount'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWODBCConnection guid: (GUID fromString: '{a1aded01-a947-11d5-b1e0-444553540000}')!

SSWODBCConnection comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!

!SSWODBCConnection categoriesForClass!Unclassified! !

!SSWODBCConnection methodsFor!

_columnsInTable: aDBTable 

	"Private - Answer the list of columns in the table matching the specified search criteria"

	| i stmt colAttrs maxBoundBufferSize shouldRequeryLongColumns toRequery |

	self sqlDialect shouldUseColumnsStatement ifFalse: [^self _columnsInTableViaQuery: aDBTable].

	stmt := DBColumnsStatement parent: self.
	stmt
		catalogName: (self sqlDialect catalogNameForTable: aDBTable);
		schemaName: (self sqlDialect schemaNameForTable: aDBTable);
		tableName: aDBTable name;
		columnName: nil.
	i := 0.
	maxBoundBufferSize := self sqlDialect maxColumnBytes.

	(shouldRequeryLongColumns := self sqlDialect shouldRequeryLongColumnDefinitions) ifTrue: [toRequery := OrderedCollection new].

	colAttrs := stmt results collect: 
					[:each || name coll |
					i := i + 1.
					name := each atIndex: 4.
					"at: 'column_name'"	"at: 'DATA_TYPE'"	"at: 'LENGTH'"	"at: 'PRECISION'"	"at: 'SCALE'"
					coll := 
						(SSWODBCColAttr new)
							columnNumber: i;
							name: name;
							type: (each atIndex: 5);
							length: (each atIndex: 8);
							precision: (each atIndex: 7);
							scale: (each atIndex: 9);
							field: (aDBTable fieldNamed: name);
							maxBoundBufferSize: maxBoundBufferSize;
							yourself.
					(shouldRequeryLongColumns and: [(#(-4 -1 -10) includes: coll type) and: [(DBVarFieldBuffer isLongColumn: coll) not]]) ifTrue: [toRequery add: coll].
					coll].
	stmt free.

	shouldRequeryLongColumns  ifTrue: 
		[toRequery do: 
			[ :each || updated |
			updated := (self columns: each name qualifier: nil owner: nil table: aDBTable name) first.
			(DBVarFieldBuffer isLongColumn: updated) ifTrue: [each length: updated length]]].

	^colAttrs!

_columnsInTableViaQuery: aDBTable

	"Use a SELECT query to interrogate the column definitions for aDBTable.
	Necessary where information returned via DBColumnsStatement can be inaccurate (sole case seen so far - SQLite3 ODBC driver returns char size rather than buffer size for widestring columns)"

	| query statement |

	query := 
		SSWSQLSelectQuery new 
			table: (SSWDBTable new name: aDBTable name; namespace: aDBTable namespace; yourself); 
			conditions: #(); 
			yourself.

	statement := self exec: (query sqlStringIn: self sqlDialect).

	^statement describeCols: (1 to: statement numColumns)!

allocatedStatementCount
	^allocatedStatementCount!

allocatedStatementCount: anObject
	allocatedStatementCount := anObject!

allocStmtHandle: aDBStatement

	"Keep track of the number of allocated statements"

	| hStmt |

	hStmt := super allocStmtHandle: aDBStatement.

	self allocatedStatementCount: (self allocatedStatementCount + 1).

	^hStmt!

autoCommitDuring: aBlock

	| oldValue |

	oldValue := self willAutoCommit.
	self willAutoCommit: true.
	[aBlock value] ensure: [self willAutoCommit: oldValue]!

basicConnect

	self dsn isNil 
		ifTrue: [self open "uses connectString"]
		ifFalse: [super basicConnect "uses dsn"].

	self isConnected ifTrue: 
		[self sqlDialect: (SSWSQLDialect newFor: self).
		self willAutoCommit: false.
		self reset]!

canDescribeParameters

	^(self getStringInfo: 10002 "SQL_DESCRIBE_PARAMETER") = 'Y'!

columnDescriptions
	^columnDescriptions!

columnDescriptions: anObject
	columnDescriptions := anObject!

columnsForFields: aCollectionOfDBFields

	^aCollectionOfDBFields collect: [ :field | field columnIn: self]!

columnsInTable: aDBTable

	^self columnDescriptions at: aDBTable ifAbsentPut: 
		[| columns fieldMap | 
		columns := self _columnsInTable: aDBTable.
		fieldMap := IdentityDictionary new.
		aDBTable allFieldsDo: [ :field | (columns detect: [ :col | col name = field name] ifNone: [nil]) ifNotNil: [ :column | fieldMap at: field put: column]].
		fieldMap]!

createNamespace: aString

	"Private - Create the given namespace (schema/database) - implementation depends on dialect"

	self autoCommitDuring: [self exec: (self sqlDialect createNamespaceSQLFor: aString)]!

dbCheckException: anIntegerRetCode function: aString

	"Overriden to revector to new dbCheckException:from: method, which may mask certain 'errors' "
	
	^self dbCheckException: anIntegerRetCode function: aString from: self!

dbCheckException: anIntegerRetCode function: aString from: anODBCObject

	"Check anIntegerRetCode as returned to anODBCObject.
	Report an error/notification if appropriate"

	^anIntegerRetCode = SQL_SUCCESS ifFalse: 
		["Signal an error or warning - decide which"
		(anIntegerRetCode = SQL_SUCCESS_WITH_INFO or: [anIntegerRetCode = SQL_NO_DATA])
		ifTrue: 
			[(self sqlDialect ifNil: ["During login - keep quiet" true] ifNotNil: [ :dialect | dialect shouldMaskSuccessWithInfo]) ifFalse:
				[DBWarning signal: aString with: (anODBCObject newExceptionDetails: anIntegerRetCode)]]
		ifFalse: 
			[DBError signal: aString with: (anODBCObject newExceptionDetails: anIntegerRetCode)]]!

dbErrorClass

	^DBError!

debugStream
	^debugStream!

debugStream: anObject
	debugStream := anObject!

defaultCursorType

	"Overriden to defer to the dialect"

	^self sqlDialect cursorType!

defaultMaxColumnBytes

	"defaultMaxColumnBytes defines the default maximum size of a column in bytes.
	As of Dolphin 7.2 very large columns are supported in ODBC - see DBLongVarField - so we now return a very large value here.

	Bear in mind that the maximum size can be limited by the ODBC driver, e.g. Postgres lets you specify the limit in the Datasource dialog (but the default is only 8190 bytes!!!!)"

	^SmallInteger maximum!

disconnect

	"Going through a Txn cycle seems to help when disconnecting"
	self rollbackTxn.

	"Occasional error in invalidateAllStmts seen in SQLite - works on retry after a short wait"
	[super disconnect] on: DBError do: 
		[ :exc | 
		exc isInvalidTransactionState ifTrue: 
			[(Delay forMilliseconds: 100) wait.
			super disconnect]].

	self reset!

dropNamespace: aString

	"Private - Drop the given namespace (schema/database) - implementation depends on dialect"

	self autoCommitDuring: [self exec: (self sqlDialect dropNamespaceSQLFor: aString)]!

evaluateAsTxn: aBlock

	"Evaluate aBlock within a database transaction (Txn in Dolphin DBConnect parlance).
	aBlock should evaluate to aBoolean indicating the success of its operation.
	If true, the transaction is committed, if false it is rolled back"

	^
		[self beginRWTxn.
		aBlock value
			ifTrue: [self commitTxn. true]
			ifFalse: [self rollbackTxn. false]] on: Error do: [ :exc | self rollbackTxn. exc pass]!

executeQuery: anSQLQuery cursoredFetch: aBoolean

	"Entry point for ad-hoc querying"

	anSQLQuery preExecIn: self.

	^self newStatement
		cursoredFetch: aBoolean;
		execQuery: anSQLQuery;
		yourself!

forgetTable: aDBTable

	^self columnDescriptions removeKey: aDBTable ifAbsent: []!

freeStmtHandle: aDBStatement

	"Keep track of the number of allocated statements"

	super freeStmtHandle: aDBStatement.

	self allocatedStatementCount: (self allocatedStatementCount - 1)!

getLongInfoString: infoCode

	"gnore the SQL_MAX_MESSAGE_LENGTH constant 
	 - SQLKeywords seems to violate this for some ODBC drivers/databases.
	Answer a String containing the value of the receiver's info attribute described by infoCode."

	| buffer len |

	buffer := Utf16String new: 2048	"not SQL_MAX_MESSAGE_LENGTH".
	len := SWORD new.

	self dbCheckException: 
		(ODBCLibrary default  
			sqlGetInfo: self asParameter
			infoType: infoCode
			infoValuePtr: buffer
			bufferLength: buffer size
			stringLengthPtr: len) function: 'SQLGetInfo'.

	^buffer copyFrom: 1 to: (len value / 2)!

hasTxn

	^transaction notNil!

incrementQueryCount

	queryCount ifNotNil: [ queryCount := queryCount + 1 ]!

isConnected

	^handle ~= nil!

isDebug

	^self debugStream notNil!

logStatementExec: aStatement

	debugStream ifNotNil: [aStatement  writeDebugInfoOn: debugStream].
	queryCount ifNotNil: [ queryCount := queryCount + 1 ]!

newParameterizedStatement: aSymbol

	"We don't make a distinction between parameterized and immediate statements.
	This method isn't used by ReStore but override for completeness"

	^self newStatement: aSymbol!

newStatement

	"Defer to newStatement"

	^self newStatement: self defaultCursorType
!

newStatement: aSymbol

	"Overriden to use an the appropriate statement class"

	^SSWODBCStatement parent: self cursorType: aSymbol!

onStartup

	"Private - Nothing to do here"!

postConnect

	self sqlDialect postLoginScript ifNotNil: 
		[ :script | 
		self evaluateAsTxn: [self exec: script. true]]!

postExec

	"Private - Sent immediately following the execution of a statement - carry out the rollback-on-query behavior required by some dialects"

	(transaction isNil and: [self sqlDialect shouldRollbackOnQuery]) ifTrue: [DBConnection transact: self action: SQL_ROLLBACK]!

prepareQuery: anSQLQuery

	"Entry point for system-generated querying (read, refresh, insert).
	Prepare and return a parameterized statement for the execution of anSQLQuery"

	^(self prepare: (anSQLQuery sqlStringIn: self sqlDialect))
		query: anSQLQuery;
		paramCols: (self columnsForFields: anSQLQuery parameterisedFields);
		yourself!

printParameterPlaceholder: anInteger on: aStream

	aStream nextPut: $?!

queryCount
	^queryCount!

queryCount: anObject
	queryCount := anObject!

reservedWords

	| defaults |

	"The set of default ODBC reserved words, as defined by Microsoft ODBC Programmer's Reference"
	defaults := ##(Set withAll: 'ABSOLUTE IS ACTION ISOLATION ADA JOIN ADD KEY ALL LANGUAGE ALLOCATE LAST ALTER LEADING AND LEFT ANY LEVEL ARE LIKE AS LOCAL ASC LOWER ASSERTION MATCH AT MAX AUTHORIZATION MIN AVG MINUTE BEGIN MODULE BETWEEN MONTH BIT NAMES BIT_LENGTH NATIONAL BOTH NATURAL BY NCHAR CASCADE NEXT CASCADED NO CASE NONE CAST NOT CATALOG NULL CHAR NULLIF CHAR_LENGTH NUMERIC CHARACTER OCTET_LENGTH CHARACTER_LENGTH OF CHECK ON CLOSE ONLY COALESCE OPEN COLLATE OPTION COLLATION OR COLUMN ORDER COMMIT OUTER CONNECT OUTPUT CONNECTION OVERLAPS CONSTRAINT PAD CONSTRAINTS PARTIAL CONTINUE PASCAL CONVERT POSITION CORRESPONDING PRECISION COUNT PREPARE CREATE PRESERVE CROSS PRIMARY CURRENT PRIOR CURRENT_DATE PRIVILEGES CURRENT_TIME PROCEDURE CURRENT_TIMESTAMP PUBLIC CURRENT_USER READ CURSOR REAL DATE REFERENCES DAY RELATIVE DEALLOCATE RESTRICT DEC REVOKE DECIMAL RIGHT DECLARE ROLLBACK DEFAULT ROWS DEFERRABLE SCHEMA DEFERRED SCROLL DELETE SECOND DESC SECTION DESCRIBE SELECT DESCRIPTOR SESSION DIAGNOSTICS SESSION_USER DISCONNECT SET DISTINCT SIZE DOMAIN SMALLINT DOUBLE SOME DROP SPACE ELSE SQL END SQLCA END-EXEC SQLCODE ESCAPE SQLERROR EXCEPT SQLSTATE EXCEPTION SQLWARNING EXEC SUBSTRING EXECUTE SUM EXISTS SYSTEM_USER EXTERNAL TABLE EXTRACT TEMPORARY FALSE THEN FETCH TIME FIRST TIMESTAMP FLOAT TIMEZONE_HOUR FOR TIMEZONE_MINUTE FOREIGN TO FORTRAN TRAILING FOUND TRANSACTION FROM TRANSLATE FULL TRANSLATION GET TRIM GLOBAL TRUE GO UNION GOTO UNIQUE GRANT UNKNOWN GROUP UPDATE HAVING UPPER HOUR USAGE IDENTITY USER IMMEDIATE USING IN VALUE INCLUDE VALUES INDEX VARCHAR INDICATOR VARYING INITIALLY VIEW INNER WHEN INPUT WHENEVER INSENSITIVE WHERE INSERT WITH INT WORK INTEGER WRITE INTERSECT YEAR INTERVAL ZONE INTO' subStrings).

	^defaults
		"Add the words defined by the current connection"
		addAll: (((self getLongInfoString: SQL_KEYWORDS) asUppercase subStrings: $,) collect: [ :each | each trimNulls asUtf8String]);
		yourself!

reset

	self 
		columnDescriptions: IdentityDictionary new;
		allocatedStatementCount: 0!

resetQueryCount

	self queryCount: 0!

rollbackTxn

	"Overriden to begin a transaction if one is not active
	(for db refresh purposes it can be useful to arbitarily execut an ODBC rollback)"

	self hasTxn ifFalse: [self beginTxn].
	super rollbackTxn!

shouldFreeStatementsOnClose

	"Some dialects slowdown or have a hard limit on the number of allocated statements.
	Attempt to handle this by requiring statements to be freed when closed if the limit has been surpassed"

	^self allocatedStatementCount > self sqlDialect maxAllocatedStatements!

sqlDialect

	"sqlDialect stores the SSWSQLDialect of the database to which the receiver connects"

	^sqlDialect!

sqlDialect: anSSWSQLDialect

	"sqlDialect stores the SSWSQLDialect of the database to which the receiver connects"

	sqlDialect := anSSWSQLDialect!

stopQueryCounting

	self queryCount: nil!

tables

	^self tablesInNamespace: nil!

tablesInNamespace: aStringOrNil

	"Answer a collection of all user tables in the namespace named aStringOrNil (nil = default namespace).
	Varies by dialect"

	^self sqlDialect tableNamesInNamespace: aStringOrNil for: self!

transaction: aDBTxn 
	"Overridden to avoid resetting the willAutoCommit status - ReStore never auto-commits (other than during autoCommitDuring: )"

	transaction notNil 
		ifTrue: [self error: self printString , ' already has an active transaction'].
	transaction := aDBTxn.!

upToParameterPlaceholderOn: aStream

	^aStream upTo: $?!

willAutoCommit: aBoolean

	"Overriden to check status prior to changing (dependent on dialect setting)"

	(self sqlDialect shouldCheckAutoCommit and: [self willAutoCommit = aBoolean]) ifFalse: 
		[super willAutoCommit: aBoolean]! !

!SSWODBCConnection categoriesForMethods!
_columnsInTable:!enquiries!private! !
_columnsInTableViaQuery:!enquiries!private! !
allocatedStatementCount!accessing!private! !
allocatedStatementCount:!accessing!private! !
allocStmtHandle:!helpers!private! !
autoCommitDuring:!private!transactions! !
basicConnect!operations!private! !
canDescribeParameters!public!testing! !
columnDescriptions!accessing!private! !
columnDescriptions:!accessing!private! !
columnsForFields:!enquiries!public! !
columnsInTable:!enquiries!public! !
createNamespace:!operations!private! !
dbCheckException:function:!exceptions!private! !
dbCheckException:function:from:!exceptions!private! !
dbErrorClass!accessing!public! !
debugStream!accessing!private! !
debugStream:!accessing!private! !
defaultCursorType!operations!public! !
defaultMaxColumnBytes!constants!public! !
disconnect!operations!private! !
dropNamespace:!operations!private! !
evaluateAsTxn:!public!transactions! !
executeQuery:cursoredFetch:!executing!public! !
forgetTable:!helpers!private! !
freeStmtHandle:!helpers!private! !
getLongInfoString:!helpers!private! !
hasTxn!public!transactions! !
incrementQueryCount!operations!private! !
isConnected!public!testing! !
isDebug!public!testing! !
logStatementExec:!operations!private! !
newParameterizedStatement:!operations!private! !
newStatement!operations!private! !
newStatement:!operations!private! !
onStartup!helpers!private! !
postConnect!operations!private! !
postExec!executing!private! !
prepareQuery:!executing!public! !
printParameterPlaceholder:on:!helpers!private! !
queryCount!accessing!public! !
queryCount:!accessing!private! !
reservedWords!accessing!public! !
reset!helpers!private! !
resetQueryCount!operations!private! !
rollbackTxn!public!transactions! !
shouldFreeStatementsOnClose!public!testing! !
sqlDialect!accessing!public! !
sqlDialect:!accessing!public! !
stopQueryCounting!operations!private! !
tables!enquiries!public! !
tablesInNamespace:!enquiries!public! !
transaction:!public!transactions! !
upToParameterPlaceholderOn:!helpers!private! !
willAutoCommit:!accessing!public! !
!


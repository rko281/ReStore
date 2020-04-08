"Filed out from Dolphin Smalltalk 7"!

DBConnection subclass: #SSWODBCConnection
	instanceVariableNames: 'sqlDialect debugStream allocatedStatementCount columnDescriptions'
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

	| i stmt colAttrs maxBoundBufferSize |

	self sqlDialect shouldUseColumnsStatement ifFalse: [^self _columnsInTableViaQuery: aDBTable].

	stmt := DBColumnsStatement parent: self.
	stmt
		catalogName: nil;
		schemaName: nil;
		tableName: aDBTable name;
		columnName: nil.
	i := 0.
	maxBoundBufferSize := self sqlDialect maxColumnBytes.
	colAttrs := stmt results collect: 
					[:each || name |
					i := i + 1.
					name := each atIndex: 4.
					"at: 'column_name'"	"at: 'DATA_TYPE'"	"at: 'LENGTH'"	"at: 'PRECISION'"	"at: 'SCALE'"
					(SSWODBCColAttr new)
						columnNumber: i;
						name: name;
						type: (each atIndex: 5);
						length: (each atIndex: 8);
						precision: (each atIndex: 7);
						scale: (each atIndex: 9);
						field: (aDBTable fieldNamed: name);
						maxBoundBufferSize: maxBoundBufferSize;
						yourself].
	stmt free.
	^colAttrs!

_columnsInTableViaQuery: aDBTable

	"Use a SELECT query to interrogate the column definitions for aDBTable.
	Necessary where information returned via DBColumnsStatement can be inaccurate (sole case seen so far - SQLite3 ODBC driver returns char size rather than buffer size for widestring columns)"

	| query statement |

	query := 
		SSWSQLSelectQuery new 
			table: (SSWSQLTable new name: aDBTable name); 
			conditions: #(); 
			yourself.

	statement := self exec: (query sqlStringIn: self sqlDialect).

	^statement describeCols: (1 to: statement numColumns)!

_dbCheckException: anIntegerRetCode from: anODBCObject

	"Check anIntegerRetCode as returned to anODBCObject.
	Report an error/notification if appropriate"

	^anIntegerRetCode = SQL_SUCCESS ifFalse: 
		["Signal an error or warning - decide which"
		(anIntegerRetCode = SQL_SUCCESS_WITH_INFO or: [anIntegerRetCode = SQL_NO_DATA])
		ifTrue: 
			[(self sqlDialect ifNil: ["During login - keep quiet" true] ifNotNil: [ :dialect | dialect shouldMaskSuccessWithInfo]) ifFalse:
				[DBWarning signalWith: (anODBCObject exceptionDetails: anIntegerRetCode)]]
		ifFalse: 
			[DBError signalWith: (anODBCObject exceptionDetails: anIntegerRetCode)]]!

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

basicConnect

	self dsn isNil 
		ifTrue: [self open "uses connectString"]
		ifFalse: [super basicConnect "uses dsn"].

	self isConnected ifTrue: 
		[self sqlDialect: (SSWSQLDialect newFor: self).
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

dbCheckException: anIntegerRetCode

	"Overriden to revector to new dbCheckException:from: method, which may mask certain 'errors' "
	
	^self _dbCheckException: anIntegerRetCode from: self!

dbCheckException: anIntegerRetCode from: anODBCObject

	"Since we end up here following all queries (browse my senders), hook the rollback-on-query behavior required by some dialects here"

	(self sqlDialect shouldRollbackOnQuery and: [self hasTxn not]) ifTrue: [self rollbackTxn].

	^self _dbCheckException: anIntegerRetCode from: anODBCObject!

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

	"defaultMaxColumnBytes defines the default maximum size of a column in bytes - this is used to initialize/cap the size of a column's replication buffer.
	
	The default is 128KB (2 raisedTo: 17) which is increased compared to the limit defined in Dolphin's Database Connection (64KB, 2 raisedTo: 16 - see DBField>>initializeForColumn:).
	If a larger size is needed you can set an appropriate value for your application following login by sending maxColumnBytes: to your ReStore's sqlDialect object.
	Bear in mind that wide character strings (if supported) can use > 1 byte per character.
	
	Also bear in mind that this value is used when creating a ByteArray for each unsized column which is replicated.
	If you increase this value then consider specifying a maximum String size in your reStoreDefinition methods to avoid unnecessarily large buffers.

	Also bear in mind that this value can be limited by the ODBC driver. 
	e.g. as of writing SQLite appears to be limited to 65536 bytes, whilst Postgres lets you specify the limit in the Datasource dialog (but the default is only 8190 bytes!!!!)

	Purely anecdotally, a maxColumnBytes of 1MB (2 raisedTo: 20) makes no discernable performance difference compared to the Dolphin default size of 64KB when run over the entire ReStore test suite.

	Very large values really need the use of unbound columns and incremental (paged) put/getData, however this is not yet implemented (and is potentially less performant than bound columns)"

	^##(2**17)!

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
			stringLengthPtr: len).

	^buffer copyFrom: 1 to: (len value / 2)!

hasTxn

	^transaction notNil!

isConnected

	^handle ~= nil!

isDebug

	^self debugStream notNil!

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

prepareQuery: anSQLQuery

	"Entry point for system-generated querying (read, refresh, insert).
	Prepare and return a parameterized statement for the execution of anSQLQuery"

	^(self prepare: (anSQLQuery sqlStringIn: self sqlDialect))
		query: anSQLQuery;
		paramCols: (self columnsForFields: anSQLQuery parameterisedFields);
		yourself!

printParameterPlaceholder: anInteger on: aStream

	aStream nextPut: $?!

reservedWords

	| defaults |

	"The set of default ODBC reserved words, as defined by Microsoft ODBC Programmer's Reference"
	defaults := ##(Set withAll: 'ABSOLUTE IS ACTION ISOLATION ADA JOIN ADD KEY ALL LANGUAGE ALLOCATE LAST ALTER LEADING AND LEFT ANY LEVEL ARE LIKE AS LOCAL ASC LOWER ASSERTION MATCH AT MAX AUTHORIZATION MIN AVG MINUTE BEGIN MODULE BETWEEN MONTH BIT NAMES BIT_LENGTH NATIONAL BOTH NATURAL BY NCHAR CASCADE NEXT CASCADED NO CASE NONE CAST NOT CATALOG NULL CHAR NULLIF CHAR_LENGTH NUMERIC CHARACTER OCTET_LENGTH CHARACTER_LENGTH OF CHECK ON CLOSE ONLY COALESCE OPEN COLLATE OPTION COLLATION OR COLUMN ORDER COMMIT OUTER CONNECT OUTPUT CONNECTION OVERLAPS CONSTRAINT PAD CONSTRAINTS PARTIAL CONTINUE PASCAL CONVERT POSITION CORRESPONDING PRECISION COUNT PREPARE CREATE PRESERVE CROSS PRIMARY CURRENT PRIOR CURRENT_DATE PRIVILEGES CURRENT_TIME PROCEDURE CURRENT_TIMESTAMP PUBLIC CURRENT_USER READ CURSOR REAL DATE REFERENCES DAY RELATIVE DEALLOCATE RESTRICT DEC REVOKE DECIMAL RIGHT DECLARE ROLLBACK DEFAULT ROWS DEFERRABLE SCHEMA DEFERRED SCROLL DELETE SECOND DESC SECTION DESCRIBE SELECT DESCRIPTOR SESSION DIAGNOSTICS SESSION_USER DISCONNECT SET DISTINCT SIZE DOMAIN SMALLINT DOUBLE SOME DROP SPACE ELSE SQL END SQLCA END-EXEC SQLCODE ESCAPE SQLERROR EXCEPT SQLSTATE EXCEPTION SQLWARNING EXEC SUBSTRING EXECUTE SUM EXISTS SYSTEM_USER EXTERNAL TABLE EXTRACT TEMPORARY FALSE THEN FETCH TIME FIRST TIMESTAMP FLOAT TIMEZONE_HOUR FOR TIMEZONE_MINUTE FOREIGN TO FORTRAN TRAILING FOUND TRANSACTION FROM TRANSLATE FULL TRANSLATION GET TRIM GLOBAL TRUE GO UNION GOTO UNIQUE GRANT UNKNOWN GROUP UPDATE HAVING UPPER HOUR USAGE IDENTITY USER IMMEDIATE USING IN VALUE INCLUDE VALUES INDEX VARCHAR INDICATOR VARYING INITIALLY VIEW INNER WHEN INPUT WHENEVER INSENSITIVE WHERE INSERT WITH INT WORK INTEGER WRITE INTERSECT YEAR INTERVAL ZONE INTO' subStrings).

	^defaults
		"Add the words defined by the current connection"
		addAll: ((self getLongInfoString: SQL_KEYWORDS) asUppercase subStrings: $,);
		yourself!

reset

	self 
		columnDescriptions: IdentityDictionary new;
		allocatedStatementCount: 0!

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

upToParameterPlaceholderOn: aStream

	^aStream upTo: $?!

willAutoCommit: aBoolean

	"Overriden to check status prior to changing (dependent on dialect setting)"

	(self sqlDialect shouldCheckAutoCommit and: [self willAutoCommit = aBoolean]) ifFalse: 
		[super willAutoCommit: aBoolean]! !
!SSWODBCConnection categoriesFor: #_columnsInTable:!enquiries!private! !
!SSWODBCConnection categoriesFor: #_columnsInTableViaQuery:!enquiries!private! !
!SSWODBCConnection categoriesFor: #_dbCheckException:from:!exceptions!private! !
!SSWODBCConnection categoriesFor: #allocatedStatementCount!accessing!private! !
!SSWODBCConnection categoriesFor: #allocatedStatementCount:!accessing!private! !
!SSWODBCConnection categoriesFor: #allocStmtHandle:!helpers!private! !
!SSWODBCConnection categoriesFor: #basicConnect!operations!private! !
!SSWODBCConnection categoriesFor: #canDescribeParameters!public!testing! !
!SSWODBCConnection categoriesFor: #columnDescriptions!accessing!private! !
!SSWODBCConnection categoriesFor: #columnDescriptions:!accessing!private! !
!SSWODBCConnection categoriesFor: #columnsForFields:!enquiries!public! !
!SSWODBCConnection categoriesFor: #columnsInTable:!enquiries!public! !
!SSWODBCConnection categoriesFor: #dbCheckException:!exceptions!public! !
!SSWODBCConnection categoriesFor: #dbCheckException:from:!exceptions!public! !
!SSWODBCConnection categoriesFor: #dbErrorClass!accessing!public! !
!SSWODBCConnection categoriesFor: #debugStream!accessing!private! !
!SSWODBCConnection categoriesFor: #debugStream:!accessing!private! !
!SSWODBCConnection categoriesFor: #defaultCursorType!operations!public! !
!SSWODBCConnection categoriesFor: #defaultMaxColumnBytes!constants!public! !
!SSWODBCConnection categoriesFor: #disconnect!operations!private! !
!SSWODBCConnection categoriesFor: #evaluateAsTxn:!public!transactions! !
!SSWODBCConnection categoriesFor: #executeQuery:cursoredFetch:!executing!public! !
!SSWODBCConnection categoriesFor: #forgetTable:!helpers!private! !
!SSWODBCConnection categoriesFor: #freeStmtHandle:!helpers!private! !
!SSWODBCConnection categoriesFor: #getLongInfoString:!helpers!private! !
!SSWODBCConnection categoriesFor: #hasTxn!public!transactions! !
!SSWODBCConnection categoriesFor: #isConnected!public!testing! !
!SSWODBCConnection categoriesFor: #isDebug!public!testing! !
!SSWODBCConnection categoriesFor: #newParameterizedStatement:!operations!private! !
!SSWODBCConnection categoriesFor: #newStatement!operations!private! !
!SSWODBCConnection categoriesFor: #newStatement:!operations!private! !
!SSWODBCConnection categoriesFor: #onStartup!helpers!private! !
!SSWODBCConnection categoriesFor: #postConnect!operations!private! !
!SSWODBCConnection categoriesFor: #prepareQuery:!executing!public! !
!SSWODBCConnection categoriesFor: #printParameterPlaceholder:on:!helpers!private! !
!SSWODBCConnection categoriesFor: #reservedWords!accessing!public! !
!SSWODBCConnection categoriesFor: #reset!helpers!private! !
!SSWODBCConnection categoriesFor: #rollbackTxn!public!transactions! !
!SSWODBCConnection categoriesFor: #shouldFreeStatementsOnClose!public!testing! !
!SSWODBCConnection categoriesFor: #sqlDialect!accessing!public! !
!SSWODBCConnection categoriesFor: #sqlDialect:!accessing!public! !
!SSWODBCConnection categoriesFor: #upToParameterPlaceholderOn:!helpers!private! !
!SSWODBCConnection categoriesFor: #willAutoCommit:!accessing!public! !


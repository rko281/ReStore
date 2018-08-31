"Filed out from Dolphin Smalltalk 7"!

DBConnection subclass: #SSWODBCConnection
	instanceVariableNames: 'sqlDialect debugStream allocatedStatementCount columnDescriptions'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWODBCConnection guid: (GUID fromString: '{a1aded01-a947-11d5-b1e0-444553540000}')!
SSWODBCConnection comment: ''!
!SSWODBCConnection categoriesForClass!Unclassified! !
!SSWODBCConnection methodsFor!

_dbCheckException: anIntegerRetCode from: anODBCObject

	"19/8/2001

	Check anIntegerRetCode as returned to anODBCObject.
	Report an error/notification if appropriate"

	^anIntegerRetCode = SQL_SUCCESS ifFalse: 
		["Signal an error or warning - decide which"
		anIntegerRetCode = SQL_SUCCESS_WITH_INFO
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
	
	super basicConnect.

	self isConnected ifTrue: 
		[self sqlDialect: (SSWSQLDialect newFor: self).
		self reset]!

canDescribeParameters

	^(self getStringInfo: 10002 "SQL_DESCRIBE_PARAMETER") = 'Y'!

columnDescriptions
	^columnDescriptions!

columnDescriptions: anObject
	columnDescriptions := anObject!

columns: aStringColumn qualifier: aStringQualifier owner: aStringOwner dbTable: aDBTable 
	"Private - Answer the list of columns in the table matching the specified search criteria"

	| i stmt colAttrs maxBoundBufferSize |
	stmt := DBColumnsStatement parent: self.
	stmt
		catalogName: aStringQualifier;
		schemaName: aStringOwner;
		tableName: aDBTable name;
		columnName: aStringColumn.
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

columnsForFields: aCollectionOfDBFields

	^aCollectionOfDBFields collect: [ :field | field columnIn: self]!

columnsInTable: aDBTable

	^self columnDescriptions at: aDBTable ifAbsentPut: 
		[| columns fieldMap | 
		columns := self columns: nil qualifier: nil owner: nil dbTable: aDBTable.
		fieldMap := IdentityDictionary new.
		aDBTable allFieldsDo: [ :field | (columns detect: [ :col | col name = field name] ifNone: [nil]) ifNotNil: [ :column | fieldMap at: field put: column]].
		fieldMap]!

dbCheckException: anIntegerRetCode

	"19/8/2001

	Overriden to revector to new dbCheckException:from: method, which may mask certain 'errors' "
	
	^self _dbCheckException: anIntegerRetCode from: self!

dbCheckException: anIntegerRetCode from: anODBCObject

	"Since we end up here following all queries (browse my senders), hook the rollback-on-query behavior required by some dialects here"

	(self sqlDialect shouldRollbackOnQuery and: [self hasTxn not]) ifTrue: [self rollbackTxn].

	^self _dbCheckException: anIntegerRetCode from: anODBCObject!

debugStream
	^debugStream!

debugStream: anObject
	debugStream := anObject!

defaultCursorType

	"25/4/2002

	Overriden to defer to the dialect"

	^self sqlDialect cursorType!

disconnect

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

executeQuery: anSQLQuery cursorType: aSymbol

	"Entry point for ad-hoc querying"

	anSQLQuery preExecIn: self.

	^(self newStatement: aSymbol) 
		execQuery: anSQLQuery;
		yourself!

forgetTable: aDBTable

	self columnDescriptions removeKey: aDBTable ifAbsent: []!

freeStmtHandle: aDBStatement

	"Keep track of the number of allocated statements"

	super freeStmtHandle: aDBStatement.

	self allocatedStatementCount: (self allocatedStatementCount - 1)!

getLongInfoString: infoCode

	"12/5/2001

	Ignore the SQL_MAX_MESSAGE_LENGTH constant 
	 - SQLKeywords seems to violate this for some ODBC drivers/databases.
	Answer a String containing the value of the receiver's info attribute described by infoCode."

	| value len |
	value := String new: 2048	"not SQL_MAX_MESSAGE_LENGTH".
	len := ODBCLibrary default getInfo: infoCode for: self into: value.
	^value copyFrom: 1 to: len!

hasTxn

	"12/5/2001"

	^transaction notNil!

isConnected

	"12/5/2001"

	^handle ~= nil!

isDebug

	"1/5/2002"

	^self debugStream notNil!

newParameterizedStatement: aSymbol

	"We don't make a distinction between parameterized and immediate statements.
	This method isn't used by ReStore but override for completeness"

	^self newStatement: aSymbol!

newStatement

	"18/9/2001
	Modified: 25/4/2002	Now only implemented/used by ReStore 

	Defer to newStatement"

	^self newStatement: self defaultCursorType
!

newStatement: aSymbol

	"Overriden to use an the appropriate statement class"

	^SSWODBCStatement parent: self cursorType: aSymbol!

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

	"16/8/2001 

	sqlDialect stores the SSWSQLDialect of the database to which the receiver connects"

	^sqlDialect!

sqlDialect: anSSWSQLDialect

	"16/8/2001 

	sqlDialect stores the SSWSQLDialect of the database to which the receiver connects"

	sqlDialect := anSSWSQLDialect!

willAutoCommit: aBoolean

	"25/4/2002 		(was autoCommit:, now deprecated)

	Overriden to check status prior to changing (dependent on dialect setting)"

	(self sqlDialect shouldCheckAutoCommit and: [self willAutoCommit = aBoolean]) ifFalse: 
		[super willAutoCommit: aBoolean]! !
!SSWODBCConnection categoriesFor: #_dbCheckException:from:!exceptions!private! !
!SSWODBCConnection categoriesFor: #allocatedStatementCount!accessing!private! !
!SSWODBCConnection categoriesFor: #allocatedStatementCount:!accessing!private! !
!SSWODBCConnection categoriesFor: #allocStmtHandle:!helpers!private! !
!SSWODBCConnection categoriesFor: #basicConnect!operations!private! !
!SSWODBCConnection categoriesFor: #canDescribeParameters!public!testing! !
!SSWODBCConnection categoriesFor: #columnDescriptions!accessing!private! !
!SSWODBCConnection categoriesFor: #columnDescriptions:!accessing!private! !
!SSWODBCConnection categoriesFor: #columns:qualifier:owner:dbTable:!enquiries!private! !
!SSWODBCConnection categoriesFor: #columnsForFields:!enquiries!public! !
!SSWODBCConnection categoriesFor: #columnsInTable:!enquiries!public! !
!SSWODBCConnection categoriesFor: #dbCheckException:!exceptions!public! !
!SSWODBCConnection categoriesFor: #dbCheckException:from:!exceptions!public! !
!SSWODBCConnection categoriesFor: #debugStream!accessing!private! !
!SSWODBCConnection categoriesFor: #debugStream:!accessing!private! !
!SSWODBCConnection categoriesFor: #defaultCursorType!operations!public! !
!SSWODBCConnection categoriesFor: #disconnect!operations!private! !
!SSWODBCConnection categoriesFor: #evaluateAsTxn:!public!transactions! !
!SSWODBCConnection categoriesFor: #executeQuery:cursorType:!executing!public! !
!SSWODBCConnection categoriesFor: #forgetTable:!public! !
!SSWODBCConnection categoriesFor: #freeStmtHandle:!helpers!private! !
!SSWODBCConnection categoriesFor: #getLongInfoString:!helpers!private! !
!SSWODBCConnection categoriesFor: #hasTxn!public!transactions! !
!SSWODBCConnection categoriesFor: #isConnected!public!testing! !
!SSWODBCConnection categoriesFor: #isDebug!public!testing! !
!SSWODBCConnection categoriesFor: #newParameterizedStatement:!operations!private! !
!SSWODBCConnection categoriesFor: #newStatement!operations!private! !
!SSWODBCConnection categoriesFor: #newStatement:!operations!private! !
!SSWODBCConnection categoriesFor: #postConnect!operations!private! !
!SSWODBCConnection categoriesFor: #prepareQuery:!executing!public! !
!SSWODBCConnection categoriesFor: #reset!helpers!private! !
!SSWODBCConnection categoriesFor: #rollbackTxn!public!transactions! !
!SSWODBCConnection categoriesFor: #shouldFreeStatementsOnClose!public!testing! !
!SSWODBCConnection categoriesFor: #sqlDialect!accessing!public! !
!SSWODBCConnection categoriesFor: #sqlDialect:!accessing!public! !
!SSWODBCConnection categoriesFor: #willAutoCommit:!accessing!public! !


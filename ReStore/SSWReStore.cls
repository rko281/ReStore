"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SSWReStore
	instanceVariableNames: 'connection tableCache nextIDCache executeStatement proxyCache transactionClass transaction objectProxyClass dbTableNames transactionMutex supportsFullTableRecords readAllBatchSize'
	classVariableNames: ''
	poolDictionaries: 'ODBCConstants'
	classInstanceVariableNames: 'default activeReStores'!
SSWReStore guid: (GUID fromString: '{5a3e3dd2-3990-11d5-b1df-444553540000}')!
SSWReStore comment: 'Copyright 2000/2001 Solutions Software Limited'!
!SSWReStore categoriesForClass!Unclassified! !
!SSWReStore methodsFor!

_rollbackObjects: aCollection

	[self beginTransaction.
	aCollection do: [ :each | each _rollbackIn: self]] ensure: [self rollbackTransaction]!

abandonTransaction

	self hasTransaction ifFalse: [self error: 'No transaction to abandon'].

	self transactionCritical:
		[self transaction abandon.
		self transaction: self transaction ownerTransaction.
		self connection rollbackTxn]!

actualProxyForObject: anObject ifNone: aBlock

	"20/8/2000
	
	Locate within the receiver's proxyCache the proxy object wrapping anObject.
	Ensure that we return a proxy (not a reference-swapped real object)"

	"Base types (String, Number etc.) - these are never proxified"
	anObject class isPersistentBaseClass ifTrue: [^aBlock value].

	(self tableForClass: anObject class) notNil ifTrue:
		[(self locateProxyForObject: anObject ifNone: [nil])
			ifNil: [^aBlock value]
			ifNotNil: [ :proxy | proxy isDBProxy ifTrue: [^proxy]]].

	"Check in the active transaction"
	^self transaction
		ifNil: [aBlock value]
		ifNotNil: [ :trans | trans proxyForObject: anObject ifNone: aBlock]!

addClass: aClass

	"6/8/2000
	
	Add aClass as a persistent class known to the receiver.
	If the class is already known, this will refresh its SSWDBTable.
	
	Return the table created by the addition"
	
	| table |
	
	table := self createTableForClass: aClass.
	table isNil ifTrue: [^nil].

	"Remove any pre-existing table"
	self forgetClass: aClass.

	"Must add the root class of a persistent hierarchy before adding a subclass"
	(table isRootTable or: [self tableCache includesKey: table rootClass]) ifFalse:
		[self addClass: table rootClass].

	"Validate"
	self validateTable: table.

	"Add it"
	self tableCache at: aClass put: table.

	"Added - now validate containedTables"
	table containedTables do: [ :each | self validateTable: each].

	^table!

addClasses: aCollection

	aCollection do: [ :each | self addClass: each]!

addClassWithSubclasses: aClass

	"6/8/2000
	
	Add aClass and all its subclasses as persistent classes known to the receiver"
	
	aClass withAllSubclasses do: [ :class | self addClass: class]!

applyUpdates: anSSWSQLCollection toObject: anSSWDBObjectProxy

	"6/8/2000
	
	Return a Boolean indicating whether the update succeeds"
	
	"If the update query succeeds, exactly 1 row should be affected"
	^(self executeQuery: 
		(SSWSQLUpdateObjectQuery 
			forObject: anSSWDBObjectProxy 
			withUpdates: anSSWSQLCollection)) = 1!

beginDumbTransaction

	"Private - 22/4/2001
	
	Begin a dumb transaction to absorb object traversals"
	
	self transaction: (SSWDBDumbTransaction new begin; yourself)!

beginTransaction

	"21/1/2001"
	
	| newTransaction |

	"An explicit beginTransaction is implicitly also a rollback for a dumb transaction"
	(self hasTransaction and: [self transaction isDumb]) ifTrue: [self rollbackTransaction].

	newTransaction := self transactionClass new.
	newTransaction beginWithin: self transaction.

	self transaction: newTransaction!

binaryStoreOn: aStream 

	"Override so the ReStore global is stored as a singleton proxy when saving the package (rather than a binary global)"

	self == ##(self) default ifFalse: [^super binaryStoreOn: aStream].

	(STBOutFiler on: aStream) 
		override: self with: (STBSingletonProxy forClass: ##(self) using: #default);
		nextPut: self!

cachedInstancesOf: aClass

	"Careful with this - despite the naming similarity to instancesOf: it is only intended for use with refreshObjects: and related methods"

	^(self classCacheFor: aClass) values!

cachedObjectOfClass: aClass withID: anID ifAbsent: aBlock

	"6/8/2000
	
	Return the cached object (actually a proxy) of the given class with the given unique ID.
	If none is found, evaluate aBlock"
	
	^(self classCacheFor: aClass) at: anID ifAbsent: aBlock!

cachedObjectOfClass: aClass withID: anID 
	ifAbsent: absentBlock ifUnrecovered: unrecoveredBlock ifUntouched: untouchedBlock

	"Return the cached object (which may actually a proxy) of the given class with the given unique ID.
	If none is found, evaluate absentBlock.
	If an unrecovered proxy, evaluate unrecoveredBlock with it.
	If a recovered but not 'touched' proxy, evaluate untouchedBlock with it.
	A proxy is considered 'touched' if it has been sent a message since the last abort"
	
	^(self cachedObjectOfClass: aClass withID: anID ifAbsent: [nil])
	ifNil:
		[absentBlock value]
	ifNotNil:
		[ :proxy |
		proxy isDBProxy ifTrue:
			[proxy _isRecovered 
				ifTrue: [untouchedBlock value: proxy]
				ifFalse: [unrecoveredBlock value: proxy]].
		proxy]
!

cacheObject: aPersistentObjectProxy

	"Created 6/8/2000
	Modified 5/9/2001		Use _class to avoid fetching inherited objects (issue#0015)
	
	Add the given persistent object proxy to the receiver's cache"
	
	(self classCacheFor: aPersistentObjectProxy _class) at: aPersistentObjectProxy _id put: aPersistentObjectProxy!

changedClassOfInstVar: aSymbol in: aClass modifyUsing: aBlock

	"The definition of the inst var named aSymbol in aClass has changed.
	Modify the column definition corresponding to aSymbol, using aBlock to modify existing records"

	| table origField columns |

	"Ensure the receiver is up-to-date with the definition of aClass"
	table := self addClass: aClass.

	"Check field exists"
	origField := table fieldAccessing: aSymbol.
	columns := self columnsInTable: table.
	(columns anySatisfy: [ :col | col name asUppercase = origField name asUppercase]) ifFalse:
		[(self error: 'No column corresponding to inst var ', aSymbol)].

	self evaluateAsTxn: 
		[| tempField updator |
		"Add a new column to hold the modified data"
		tempField := table addDataField: 
						(SSWDBStaticField new
							name: 'TEMP__';
							targetClass: origField targetClass;
							accessor: ((self sqlDialect instVarAccessorFor: aClass) access: aSymbol in: aClass);
							yourself).
		tempField accessor name: #temp__.
		self sqlDialect addFields: (Array with: tempField) to: table in: self. 
		
		"Modify the data"
		(self instancesOf: aClass) modify: [ :each | each temp__: (aBlock value: each)].

		"Drop the original column with the original definition"
		self sqlDialect dropColumnNamed: origField name fromTable: table in: self.

		"Re-add the column with its new definition"
		self sqlDialect addFields: (Array with: origField) to: table in: self. 
		
		"Copy the data back from the temp column"
		updator := (aSymbol, ':') asSymbol.
		(self instancesOf: aClass) modify: [ :each | each perform: updator with: each temp__].

		"Re-add class to remove temp field, and drop it"
		self addClass: aClass.
		self sqlDialect dropColumnNamed: tempField name fromTable: table in: self.
		true]!

classCacheFor: aClass

	"6/8/2000
	
	Return the subcache of the receiver's proxyCache responsible for caching
	proxied instances of aClass"
	
	"Proxies are cached under the registerClass of their associated table"
	^self proxyCache 
		at: (self tableForClass: aClass) registerClass 
		ifAbsentPut: [WeakIdentityDictionary new: 32]!

clearDBTableNames

	"12/5/2001"
	
	self dbTableNames: nil!

clearNextIDCache

	"14/8/2000"
	
	self nextIDCache: IdentityDictionary new!

clearProxyCache

	"14/8/2000"
	
	self proxyCache: IdentityDictionary new!

clearStatementCache

	executeStatement isNil ifFalse: 
		[executeStatement free.
		executeStatement := nil].

	self tableCache do: [ :each | each freePreparedStatements]!

clearTableCache

	"14/8/2000"
	
	self 
		tableCache: IdentityDictionary new;
		clearNextIDCache!

clearTransaction

	"Private - 1/5/2001"

	self transaction: nil!

columnsForFields: aCollectionOfDBFields

	^self connection columnsForFields: aCollectionOfDBFields!

columnsInTable: anSSWDBTable

	^self connection columnsInTable: anSSWDBTable!

commitObject: anObject

	"Commit changes to anObject"

	^self commitObjects: (Array with: anObject)!

commitObjects: aCollection

	"Alternative transaction model - commit any changes made to the members of aCollection.

	Note if a transaction is in progress (e.g. manually started with beginTransaction) the changes are added to this active transaction and *not* committed at this stage.
	This allows transaction and transactionaless APIs to be mixed.

	Return success"

	^self transactionCritical:
		[self evaluateInTransaction: [aCollection do: [ :each | each _commitIn: self]]]!

commitTransaction

	"Created 21/1/2001
	Modified: 3/10/2001	Trap and recover from errors during commit (Issue#0023)"

	self isTransactionInProgress ifFalse: [self error: 'No transaction in progress'].

	^self transactionCritical:
		[| success errorDescription |

		errorDescription := nil.

		[self transaction prepareToCommit] on: Error do: 
			[ :exc |
			self transaction autoRecoverPreCommitIn: self.
			errorDescription := exc description.
			exc return].

		errorDescription isNil ifFalse: [self error: ('An error occured during pre-commit: ', errorDescription)].

		success := 
			[self transaction commitTo: self connection.
			self transaction hasFailedCommit not] 
				on: Error do: 
					[ :exc |
					[self connection rollbackTxn] on: Error do: [ :txnExc | txnExc return].
					self transaction autoRecoverCommitIn: self.
					errorDescription := exc.
					exc return: false].
		success 
		ifTrue: 
			[self transaction: self transaction ownerTransaction]
		ifFalse:
			[errorDescription isNil ifFalse: [self error: ('An error occured during commit: ', errorDescription description)]].
	
		success]!

connect

	"Connect to the database, initializing the receiver"

	self isConnected ifTrue: [self error: 'already connected'].

	self objectProxyClass isNil ifTrue: [self setDefaultTransactionMode].

	"Reinitializate the mutex"
	self transactionMutex: Mutex new.

	[self connection connect] on: DBError do:
		[ :exc |
		self connection free.
		exc signal].

	self class activated: self.
	self connection willAutoCommit: false.
	self connection postConnect.

	"Must reset system classes after login to use current dialect's name transformation strategy"
	self persistentSystemClasses do: [ :each | self addClass: each]!

connection

	"6/8/2000
	
	connection stores the DBConnection with which the receiver communicates with the database"
	
	^connection!

connection: aDBConnection

	"6/8/2000
	
	connection stores the DBConnection with which the receiver communicates with the database"
	
	connection := aDBConnection!

createConnection

	self connection: SSWODBCConnection new!

createProxyForNewObject: anObject

	"Created 6/8/2000
	Modified 22/9/2001	Error if no active transaction (issue#0022)
	
	Create and return a proxy for the given non-persistent object"

	| id |

	(self hasTransaction and: [self transaction canCommit]) ifFalse:
		[self error: 'Cannot store an object outside of a transaction'].

	id := (self tableForClass: anObject class) idDataField 
		ifNil: [nil]
		ifNotNil: [ :idDataField | idDataField accessor valueIn: anObject].

	id isNil ifTrue: [id := self nextIDFor: anObject].

	^((self objectProxyClassFor: anObject class)
		_forNewObject: anObject withID: id inReStore: self)
			_intern;
			yourself!

createProxyForObjectOfClass: aClass withID: anInteger

	"6/8/2000
	
	Return an unrecovered proxy for the given class/ID"
	
	^((self objectProxyClassFor: aClass)
		 _forObjectOfClass: aClass withID: anInteger inReStore: self)
			_intern;
			yourself!

createProxyForRow: aDBRow fromTable: aDBTable withID: anInteger

	"Patched for issue 120-xxx	_intern the proxy before recovery (in case it directly references itself)
	
	Return a recovered proxy for the object persisted in the given row"
	
	| proxy |
	
	proxy := (self objectProxyClassFor: aDBTable instanceClass) 
			_forObjectOfClass: aDBTable instanceClass withID: anInteger inReStore: self.
	
	proxy _intern.

	aDBTable recoverInstanceFromRow: aDBRow into: proxy.
	
	^proxy yourself		!

createTableForClass: aClass

	"Private - Create and return the DB Table for aClass..
	NB the table is not added to the receiver's tableCache"
	
	| table |
	
	table := aClass tableIn: self.
	table isDefined ifFalse: [^nil].

	"Append meaningful postfixes in the case of a reserved word clash"
	(self sqlDialect isReservedWord: table name) ifTrue: [table name: (table name, '_TABLE')].
	table dataFields do: 
		[ :field | (self sqlDialect isReservedWord: field name) ifTrue: [field name: (field name, '_FIELD')]].

	^table!

createTableRecordFor: anSSWDBTable

	"Private - Create in the database the DBTableRecord for aClass."

	| record |
	
	record := SSWDBCachingObjectProxy new 
			_reStore: self;
			_class: SSWDBTableRecord;
			_proxiedObject: anSSWDBTable tableRecord; 
			yourself.

	anSSWDBTable instanceClass = SSWDBTableRecord
		ifTrue: [record _id: 0]
		ifFalse: [record _id: (self nextIDForTable: (self tableForClass: SSWDBTableRecord))].

	self evaluateInTxn: [self insertProxy: record. true]!

dbIncludesTableForClass: aClass

	^(self tableForClass: aClass ifAbsent: [nil])
		ifNil: [false]
		ifNotNil: [ :table | self dbIncludesTableNamed: table name]!

dbIncludesTableNamed: aString

	"12/5/2001"

	^self dbTableNames includes: aString asUppercase!

dbTableNames

	"12/5/2001
	
	dbTableNames stores the Collection of table name Strings returned from 'self connection tables'.
	This is cached for use by client methods as it can be an expensive operation.

	Lazy initialized; methods which may change the DB's table definitions should reset this to nil"
	
	dbTableNames == nil ifTrue: 
		[self dbTableNames: (self connection tables collect: [ :each | each asUppercase])].

	^dbTableNames!

dbTableNames: aCollectionOrNil

	"12/5/2001
	
	dbTableNames stores the Collection of table name Strings returned from 'self connection tables'.
	This is cached for use by client methods as it can be an expensive operation.

	Lazy initialized; methods which may change the DB's table definitions should reset this to nil"
	
	dbTableNames := aCollectionOrNil!

debugTo: aStreamOrNil

	"Set the debug (logging) mode of the receiver:
	 - if the parameter is aStream, all executed SQL is logged to that Stream.
	- if nil, debugging is deactivated"

	self connection debugStream: aStreamOrNil!

defaultReadAllBatchSize

	^100!

deferredObjectOfClass: aClass withID: anInteger

	"6/8/2000
	
	Return the object with the given class/ID from the receiver's proxyCache.
	If not present, create, cache and return an unrecovered (deferred) proxy for that object"
	
	^self cachedObjectOfClass: aClass withID: anInteger ifAbsent:
		[self createProxyForObjectOfClass: aClass withID: anInteger]!

deferredObjectOfClass: aClass withID: anInteger version: versionInteger

	"Return the object with the given class/ID from the receiver's proxyCache.
	If not present, create, cache and return an unrecovered (deferred) proxy for that object.
	If present and untouched, but with an earlier version than versionInteger, forget the current object"
	
	^self 
		cachedObjectOfClass: aClass
		withID: anInteger 
		ifAbsent: [self createProxyForObjectOfClass: aClass withID: anInteger]
		ifUnrecovered: [ :proxy | proxy]
		ifUntouched: [ :proxy | proxy _version < versionInteger ifTrue: [proxy _forgetProxiedObject]. proxy]!

deregisterProxy: anSSWDBObjectProxy

	"6/8/2000"
	
	self uncacheObject: anSSWDBObjectProxy!

destroyAllClasses

	"USE WITH EXTREME CAUTION.
	Also understand the difference between this method and destroyAllTables"

	| droppedTables |

	droppedTables := OrderedCollection new.

	[self evaluateAsTxn:
		[self tableCache keysAndValuesDo: 
			[ :class :table | 
			(self isSystemClass: class) ifFalse: 
				[droppedTables addAll: table removeDefinition]].
		true].
	self evaluateAsTransaction: [self unstoreNextIDsForTables: droppedTables]] ensure: [self clearDBTableNames]!

destroyAllTables

	"USE WITH EXTREME CAUTION - DEPENDING ON YOUR DATABASE - THIS MAY DELETE REQUIRED SYSTEM TABLES.
	Unlike destroyAllClasses (which only removes the tables of classes known to the receiver)
	this method will remove ABSOLUTELY ALL TABLES from the database"

	[self evaluateAsTxn:
		[self dbTableNames do: [ :tableName | self executeSQL: ('DROP TABLE ', tableName)].
		true]] 
			ensure: [self clearDBTableNames]!

destroyClass: aClass

	"12/5/2001

	Remove from the database the definition(s) of the table(s) associated with the given class"

	| table |

	table := self tableForClass: aClass.

	table isRootTable 
		ifTrue: [self destroyTable: table]
		ifFalse: [(self instancesOf: aClass) unstoreAll]!

destroyTable: aTable

	"Remove from the database the definition of the given table (and any associated tables)"

	[self evaluateAsTxn: 
		[| droppedTables |
		droppedTables := aTable removeDefinition. 
		self unstoreNextIDsForTables: droppedTables.
		true]] ensure: [self clearDBTableNames]!

disconnect

	"14/8/2000
	
	'Hard' disconnect - caches are cleared"
	
	self isConnected ifFalse: [self error: 'Not connected'].

	self
		clearProxyCache;
		clearNextIDCache;
		clearTransaction;
		clearDBTableNames;
		softDisconnect.

	self class deactivated: self!

dsn: aString

	"14/8/2000
	
	Forward to the connection itself"
	
	self connection dsn: aString!

enableFullTableRecords

	"Enable the use of full table records - intended for existing databases without this enabled"

	self supportsFullTableRecords ifTrue: [self error: 'Full table records already enabled'].

	self supportsFullTableRecords: true.
	self addClass: SSWDBTableRecord.
	self evaluateAsTxn:
		[(self tableForClass: SSWDBTableRecord) synchronizeDefinition.
		(self instancesOf: SSWDBTableRecord satisfying: [ :each | each fullTableName = nil]) 
			modify: [ :each | each fullTableName: each tableName].
		true]
!

ensureCanChangeTransactionMode

	"Private - 12/5/2001

	Cannot change mode if connected to DB"

	self isConnected ifTrue: [self error: 'Cannot change transaction mode whilst connected']!

ensureNoActiveTransaction

	self hasTransaction ifTrue:
		[self transaction isDumb
			ifTrue: [self rollbackTransaction]
			ifFalse: [self error: 'Active transaction - cannot proceed']]!

evaluateAsTransaction: aBlock

	"Return whether the commit succeeded"
	
	^[self beginTransaction.
	aBlock value.
	self commitTransaction] ifCurtailed: [self rollbackTransaction]!

evaluateAsTransactionUntilSuccess: aBlock

	"21/1/2001

	Evaluate aBlock within a transaction then commit.
	If the commit fails, rollback and refresh the transaction 
	and re-evaluate aBlock until the commit succeeds"

	self transactionCritical:	
		[[[self beginTransaction.
		aBlock value.
		self commitTransaction] whileFalse:
			[self rollbackAndRefreshTransaction]] ifCurtailed: [self rollbackTransaction]]!

evaluateAsTxn: aBlock

	"Evaluate aBlock within a database transaction (Txn in Dolphin DBConnect parlance).
	aBlock should evaluate to aBoolean indicating the success of its operation.
	If true, the transaction is committed, if false it is rolled back"

	^self connection evaluateAsTxn: aBlock!

evaluateInTransaction: aBlock

	"Evaluate aBlock within a transaction:
	 - if there is currently a transaction in progress just evaluate aBlock
	 - if there is no transaction in progress, begin and commit one around aBlock
	Return success (presumed in the case of the former).

	Note the subtle difference from evaluateAsTransaction: which always begins and commits a new transaction (erroring if there is already one in progress)"
	
	^self isTransactionInProgress
		ifTrue: [aBlock value. true]
		ifFalse: [self evaluateAsTransaction: aBlock]!

evaluateInTxn: aBlock

	"Private - If the receiver's connection is currently within a txn (database transaction),
	evaluate aBlock within that transaction, otherwise begin and commit a txn around aBlock"

	^self connection hasTxn
		ifTrue: [aBlock value]
		ifFalse: [self evaluateAsTxn: aBlock]!

executeQuery: anSSWSQLQuery

	"Execute the given query with the default cursorType.
	If it is a read query, return the DBResultSet (client code should close this when done)
	If it is a write query, return the number of rows affected"

	^self executeQuery: anSSWSQLQuery cursorType: self sqlDialect cursorType!

executeQuery: anSSWSQLQuery cursorType: aSymbol

	"Execute the given query with the given cursorType.
	If it is a read query, return the DBResultSet (client code should close this when done)
	If it is a write query, return the number of rows affected"

	| statement |

	statement := self connection executeQuery: anSSWSQLQuery cursorType: aSymbol.

	^anSSWSQLQuery isReadQuery
		ifTrue: [statement results]
		ifFalse: [statement closeAfter: [ :stmt | stmt numRows]]!

executeSQL: aString

	"12/5/01

	Raw SQL execution - for privileged clients only"

	^self executeStatement exec: aString!

executeSQLAsTxn: aCollectionOfStrings

	"12/5/01

	Raw SQL execution - for privileged clients only"

	self evaluateAsTxn:
		[aCollectionOfStrings do: [ :aString | self executeSQL: aString].
		true]!

executeStatement

	"Return a prepared statement for executing general non-read queries.
	This is faster than allocating a new statement each time"

	^executeStatement ifNil: [executeStatement := self connection newStatement]!

executeStatement: aStatement

	executeStatement := aStatement!

fetchObjectOfClass: aClass withQuery: anSSWSQLQuery ifNone: aBlock

	"6/8/2000"
	
	| row |
	
	row := self rowFromQuery: anSSWSQLQuery.
	
	^row isNil
		ifTrue: [aBlock value]
		ifFalse: [self objectFromRow: row table: (self tableForClass: aClass)]!

fetchObjectsOfClass: aClass withQuery: anSSWSQLQuery into: aCollection

	"6/8/2000"
	
	| table |
		
	table := self tableForClass: aClass.

	self rowsFromQuery: anSSWSQLQuery do: [ :row | aCollection directAdd: (self objectFromRow: row table: table)]!

fetchObjectsOfClass: aClass withStatement: aDBPreparedStatement into: aCollection

	"6/8/2000"
	
	| table index |
		
	table := self tableForClass: aClass.
	index := 1.

	self 
		rowsFromStatement: aDBPreparedStatement 
		do: 
			[ :row |
			aCollection directAdd: (self objectFromRow: row table: table) suggestedIndex: index.
			index := index + 1]!

finalize

	"4/9/2001

	Ensure the receiver is disconnected prior to GC  (issue#0016)"

	[self disconnect] on: Error do: [ :sig | "Ignore possible 'not connected' error; refactor to avoid this" sig return: nil]	!

forceRefreshObject: anObject

	self forceRefreshObjects: (Array with: anObject)!

forceRefreshObjects: aCollection

	self transactionCritical:
		[self ensureNoActiveTransaction.
		self connection rollbackTxn.

		aCollection do: [ :each | each _forceRefreshIn: self]]!

forgetClass: aClass

	(self tableCache removeKey: aClass ifAbsent: []) ifNotNil: [ :table | self connection forgetTable: table]!

fullTableRecordFor: anSSWDBTable

	"Private - Return the TableRecord (ID manager) for the given table, using full name lookup.
	Return nil if none found"

	^self nextIDCache at: anSSWDBTable ifAbsent:
		[| record |
		anSSWDBTable isRootTable
			ifTrue: [record := (self instancesOf: SSWDBTableRecord) detect: [ :seq | seq fullTableName = anSSWDBTable fullName] ifNone: [nil]]
			ifFalse: [record := self fullTableRecordFor: anSSWDBTable rootTable].
		record isNil
			ifTrue: [nil]
			ifFalse: [self nextIDCache at: anSSWDBTable put: record]]!

hasCommittedObject: anObject

	^(self transaction proxyForObject: anObject ifNone: [nil]) notNil!

hasObjectChanged: anObject

	"Return true if anObject has changes that would be persisted by commitObjects:"

	^anObject _checkHasChangedIn: self!

hasTransaction

	"Private - 21/1/2001"
	
	^self transaction notNil!

hasTransactionChanges

	"12/3/2001"
	
	"Critical due to hasChanges interrogating the internals of the transaction"
	^self transactionCritical: [self isTransactionInProgress and: [self transaction hasChanges]]!

haveObjectsChanged: aCollection

	"Return true if any of the objects in aCollection have changes that would be persisted by commitObjects:"

	^aCollection anySatisfy: [ :each | self hasObjectChanged: each]!

insertProxy: aProxydObject

	"21/1/2001
	
	aProxydObject is a proxy which is not yet persistent. Insert it into the database"

	| query statement |

	query := SSWSQLParameterisedInsertQuery forObject: aProxydObject.

	statement := (self tableForClass: aProxydObject class) insertStatementGeneratedFrom: [query].
	statement values: (query objectValues collect: [ :each | each odbcObject]).
	statement exec; close!

instancesOf: aClass

	"23/3/2001"
	
	^SSWDBInstancesCollection forClass: aClass in: self!

instancesOf: aClass satisfying: qualifierBlock

	"27/3/2001
	
	Convenience method"
	
	^(self instancesOf: aClass) satisfying: qualifierBlock!

isClassPersistent: aClass

	"6/8/2000
	
	Return a Boolean indicating whether the given class is a persistent class
	known to this reStore"
	
	^(self tableCache includesKey: aClass) or:
		"aClass is persistent if it defines a table"
		[(self addClass: aClass) notNil]!

isConnected

	"12/5/2001

	Pass-thru to the connection"

	^self connection isConnected!

isSystemClass: aClass

	^self persistentSystemClasses includes: aClass!

isTransactionInProgress

	"21/1/2001"
	
	^self hasTransaction and: [self transaction isDumb not]!

locateProxyForObject: anObject ifNone: aBlock

	"20/8/2000
	
	Locate within the receiver's proxyCache the proxy object wrapping anObject.
	If none found, return the result of evaluating aBlock"
	
	^(self classCacheFor: anObject class) detect: 
		[ :proxyOrObject | 
		proxyOrObject isDBProxy
			ifTrue: [proxyOrObject _proxiedObject == anObject]
			ifFalse: [proxyOrObject == anObject]] ifNone: aBlock!

nextIDCache

	"6/8/2000
	
	nextIDCache stores a Dictionary mapping SSWDBTables 
	to the persistent SSWDBTableNextID instance governing allocation of table IDs"
	
	^nextIDCache!

nextIDCache: anIdentityDictionary

	"6/8/2000
	
	nextIDCache stores a Dictionary mapping SSWDBTables 
	to the persistent SSWDBTableNextID instance governing allocation of table IDs"
	
	nextIDCache := anIdentityDictionary!

nextIDFor: anObject

	"19/8/2000"

	^self nextIDForTable: (self tableForClass: anObject class)!

nextIDForTable: anSSWDBTable

	"19/8/2000"
	
	| nextTableID directNextTableID nextID instances |

	"Note that SSWDBTableRecord creation is done manually, 
	since we need to keep it outside of general transaction management"
	nextTableID := self nextIDCache at: anSSWDBTable ifAbsentPut:
		[(self instancesOf: SSWDBTableRecord) detect: [ :seq | seq tableName = anSSWDBTable name] ifNone:
			[self createTableRecordFor: anSSWDBTable.
			(self instancesOf: SSWDBTableRecord) detect: [ :seq | seq tableName = anSSWDBTable name]]].
	
	"Avoid invoking change detection system by referencing nextTableID directly"
	directNextTableID := nextTableID _proxiedObject.
	nextID := directNextTableID nextCachedID.

	^nextID notNil 
	ifTrue: 
		[nextID]
	ifFalse:
		["Need to update nextTableID, ensuring we don't update if it has been changed (by another ReStore)"					
		nextID := directNextTableID nextID + anSSWDBTable idCacheSize.
		instances := self instancesOf: SSWDBTableRecord satisfying: 
			[ :each | 
			(each tableName = anSSWDBTable name) & (each nextID = directNextTableID nextID)].	

		(instances modify: [ :each | each nextID: nextID]) = 1
			ifTrue: [directNextTableID cacheUpToID: nextID]
			ifFalse: [nextTableID  _recoverProxiedObject].

		self nextIDForTable: anSSWDBTable]!

nextShortTableNameFor: anSSWDBTable

	"Private - Return a unique name for anSSWDBTable, within the size limits of the database"

	| subtable root counter shortName tableIDs |

	"First check - anSSWDBTable may have an already-defined subtable. Use its name"
	subtable := self tableCache detect: [ :each | each fullName = anSSWDBTable fullName] ifNone: [nil].
	subtable isNil ifFalse: [^subtable name].

	root := (anSSWDBTable name copyFrom: 1 to: (self sqlDialect maxTableNameLength - 4)), '_'.
	counter := 0.

	(self dbIncludesTableForClass: SSWDBTableRecord)
		ifTrue: [tableIDs := self instancesOf: SSWDBTableRecord]
		ifFalse: [tableIDs := #()].

	"Loop until name unique to both receiver and DB is found"
	[shortName := root, counter displayString.
	(self tableCache anySatisfy: [ :each | each definesName: shortName]) or: 
		[tableIDs anySatisfy: [ :each | each tableName = shortName]]] whileTrue: [counter := counter + 1].

	^shortName!

objectFromRow: aDatabaseRow table: anSSWDBTable

	"Return the proxyd object represented by the given row from the given table.
	If the required proxy object is not in the cache, create it.
	If the object is already recovered, refresh it from the row if it's not been changed in the image"
	
	| id |

	id := aDatabaseRow atField: anSSWDBTable idField.

	^id isNil
	ifTrue:
		[nil	"Should never happen"]
	ifFalse:
		[self 
			cachedObjectOfClass: (anSSWDBTable instanceClassFromRow: aDatabaseRow)
			withID: id 
			ifAbsent: [self createProxyForRow: aDatabaseRow fromTable: anSSWDBTable withID: id]
			ifUnrecovered: [ :proxy | anSSWDBTable recoverInstanceFromRow: aDatabaseRow into: proxy]
			ifUntouched: [ :proxy | proxy _refreshFromRow: aDatabaseRow table: anSSWDBTable]]!

objectProxyClass

	"1/10/2000

	objectProxyClass stores the class of Proxy to use for Objects (as opposed to collections).
	This will usually be SSWDBObjectProxy or one of its subclasses"
	
	^objectProxyClass!

objectProxyClass: aClass

	"1/10/2000

	objectProxyClass stores the class of Proxy to use for Objects (as opposed to collections).
	This will usually be SSWDBObjectProxy or one of its subclasses"
	
	objectProxyClass := aClass!

objectProxyClassFor: aClass

	^aClass preferredObjectProxyClass ifNil: [self objectProxyClass]!

openODBC

	"Convenience - open the 32bit ODBC control panel"

	ShellLibrary default shellOpen: 'odbcad32'!

persistentSystemClasses

	"Private - Return all ReStore system classes that exist in the database"

	^##(Array with: SSWDBTableRecord)!

prepareStatementForQuery: anSSWSQLQuery

	"Prepare (including column defs) and return a DBPreparedStatement for the given query"
	
	anSSWSQLQuery preExecIn: self.

	^self connection prepareQuery: anSSWSQLQuery!

preWriteValidate: anObject

	"20/8/2000"
	
	(self tableForClass: anObject class) storeNonPersistentComponentsOf: anObject!

proxy: anSSWDBProxy forwarded: aMessage

	"22/10/2000
	
	anSSWDBProxy has just forwarded aMessage to its proxiedObject.
	Take any necessary actions here and forward to other interested parties"

	transaction == nil ifTrue: [self beginDumbTransaction].

	self transaction proxy: anSSWDBProxy forwarded: aMessage!

proxyCache

	"6/8/2000
	
	proxyCache stores a Dictionary mapping classes of persistent objects 
	to a further dictionary mapping the unique IDs of persistent database objects
	to the proxy (SSWDBObjectProxy) which represents that object in the image.
	The sub-dictionary is weak-valued by default"
	
	^proxyCache!

proxyCache: aDictionary

	"6/8/2000
	
	proxyCache stores a Dictionary mapping classes of persistent objects 
	to a further dictionary mapping the unique IDs of persistent database objects
	to the proxy (SSWDBObjectProxy) which represents that object in the image.
	The sub-dictionary is weak-valued by default"
	
	proxyCache := aDictionary!

pwd: aString

	"14/8/2000
	
	Forward to the connection itself"
	
	self connection pwd: aString!

readAllBatchSize

	"When using the readAll function to mass-read components for all of a collection's elements, a parameteised statement is used with a fixed number of query parameters.
	This number should be a balance between the minimum and maximum likely collection size.
	 - query sets smaller than this are padded with nulls
	 - query sets larger than this are batched into sets of this size resulting in multiple queries (which readAll is designed to avoid) albeit (N/batchSize) ceiling queries rather than N.

	This value can be overridden in individual tables if required"

	^readAllBatchSize ifNil: [self defaultReadAllBatchSize]!

readAllBatchSize: anInteger

	"When using the readAll function to mass-read components for all of a collection's elements, a parameteised statement is used with a fixed number of query parameters.
	This number should be a balance between the minimum and maximum likely collection size.
	 - query sets smaller than this are padded with nulls
	 - query sets larger than this are batched into sets of this size resulting in multiple queries (which readAll is designed to avoid) albeit (N/batchSize) ceiling queries rather than N.

	This value can be overridden in individual tables if required"

	readAllBatchSize := anInteger!

reconnect

	self isConnected ifTrue: [self disconnect].
	self connect!

recoverObjectOfClass: aClass withID: anID into: anSSWDBObjectProxy

	"Optimised query for recovering objects into an unrecovered proxy.
	Uses cached prepared statement"
	
	| table statement row |

	table := self tableForClass: aClass.

	statement := table readStatement.
	statement values: (Array with: anID).
	statement exec.
	row := statement results first.
	statement close.

	row isNil 
		ifTrue: [anSSWDBObjectProxy _proxiedObjectMissing]
		ifFalse: [table recoverInstanceFromRow: row into: anSSWDBObjectProxy]!

refreshAllObjects

	"Patched for issue 120-010 (revised)"

	self transactionCritical:
		[self ensureNoActiveTransaction.
		self connection rollbackTxn.

		self proxyCache keysAndValuesDo: 
			[ :class :proxies | 
			(self isSystemClass: class) ifFalse:
				[proxies do: 
					[ :each | 
					each _forgetProxiedObject.
					each _collectionProxies notNil ifTrue: 
						[each _collectionProxies do: [ :coll | coll _forgetProxiedObject]]]]]]!

refreshAndRollforwardTransaction

	"24/4/2001"
	
	self isTransactionInProgress ifFalse: [self error: 'No transaction in progress'].

	self transactionCritical: 
		[self connection rollbackTxn.
		self transaction refreshAndRollforward]!

refreshClasses

	"6/8/2000

	Regenerate each table in the tableCache from its class"

	self tableCache copy keysDo: [ :class | self addClass: class]!

refreshObject: anObject

	self refreshObjects: (Array with: anObject)!

refreshObjectIfUpdated: anObject

	self refreshObjectsIfUpdated: (Array with: anObject)!

refreshObjects: aCollection

	self transactionCritical:
		[self ensureNoActiveTransaction.
		self connection rollbackTxn.

		"To give consistent behaviour we first rollback the objects. 
		This ensures that any current changes are undone regardless of whether the object is able to detect if it has been updated, or it has to refresh itself regardless"
		self _rollbackObjects: aCollection.

		aCollection do: [ :each | each _refreshIn: self]]!

refreshObjectsIfUpdated: aCollection

	"Refresh those members of aCollection which have been updated in the database"
	
	self transactionCritical:
		[self ensureNoActiveTransaction.
		self connection rollbackTxn.

		"To give consistent behaviour we first rollback the objects. 
		This ensures that any current changes are undone regardless of whether the object is able to detect if it has been updated, or it has to refresh itself regardless"
		self _rollbackObjects: aCollection.

		aCollection do: [ :each | each _refreshIfUpdatedIn: self]]!

refreshProxyIfUpdated: anSSWDBObjectProxy

	"Refresh the contents of anSSWDBObjectProxy if the version in the database has been updated
	since that held by anSSWDBObjectProxy was read.

	Return whether any change was detected & refreshed"
	
	| table statement row |

	table := self tableForClass: anSSWDBObjectProxy _class.

	statement := table refreshStatement.
	statement values: (Array with: anSSWDBObjectProxy _id).
	statement exec.
	row := statement results first.
	statement close.

	"A row will not be returned if the object has been deleted"
	row isNil ifTrue: 
		[anSSWDBObjectProxy _proxiedObjectMissing. 
		^true].

	^(row atField: table versionControlField ifAbsent: [nil]) ~= anSSWDBObjectProxy _version 
		ifTrue: [anSSWDBObjectProxy _forceRefresh. true] 
		ifFalse: [false]!

registerProxy: anSSWDBObjectProxy

	"6/8/2000"
	
	self cacheObject: anSSWDBObjectProxy!

removeFromTransaction: aProxy

	"22/5/2001"

	self transaction removeProxy: aProxy!

removeProxy: aProxydObject

	"21/1/2001
	
	Remove aProxydObject from the database and the receiver ReStore"

	^self 
		uncacheObject: aProxydObject;
		executeQuery: (SSWSQLDeleteObjectQuery forObject: aProxydObject)!

renamedClass: aClass from: aSymbol

	"Rename the table related to aClass to match its new name.
	Assumes standard table naming was used on the class"

	| newTable newDefinitionTable oldTable oldDefinitionTable instances |

	newTable := self addClass: aClass.
	newTable isRootTable ifFalse: 
		["Create and modify an instancesOf: collection for rows specifying the old class name"
		instances := self instancesOf: newTable rootClass satisfying: [ :e | e class = aSymbol asString].
		^instances modify: [ :each | each class: aClass]].

	newDefinitionTable := newTable forCreation.
	newDefinitionTable isNil ifTrue: [^self].

	oldTable := self createTableForClass: aClass.
	oldTable name: (self sqlDialect transformClassName: aSymbol).
	oldTable fullName: oldTable name.
	self validateTable: oldTable.
	oldTable containedTables do: [ :each | self validateTable: each].
	oldDefinitionTable := oldTable forCreation.

	[self evaluateAsTxn:
		[self renameTable: oldDefinitionTable to: newDefinitionTable.
		true]] 
			ensure: [self clearDBTableNames]!

renamedInstVar: newInstVar from: oldInstVar in: aClass

	"Rename the column corresponding to oldInstVar (a Symbol) in aClass to match newInstVar.
	Assumes standard field naming was used on the class"

	| table newField oldField columns |

	"Ensure the receiver is up-to-date with the definition of aClass"
	table := self addClass: aClass.

	"Check old iv field already exists and new iv field does not exist"
	newField := table fieldAccessing: newInstVar.
	oldField := table define: oldInstVar as: newField targetClass.
	columns := self columnsInTable: table.
	(columns anySatisfy: [ :col | col name asUppercase = oldField name asUppercase]) ifFalse:
		[(self error: 'No column corresponding to old inst var ', oldInstVar)].
	(columns anySatisfy: [ :col | col name asUppercase = newField name asUppercase]) ifTrue:
		[(self error: 'Already has column corresponding to new inst var ', newInstVar)].

	self evaluateInTxn: 
		[self sqlDialect renameField: oldField to: newField in: self.
		true].

	"Re-add the class to drop the oldField"
	self addClass: aClass!

renameTable: oldTable to: newTable

	"Private - Rename the old-named table to the new name, updating relevant objects"

	| instances oldRecord |

	self sqlDialect renameTableNamed: oldTable name to: newTable name in: self.

	"Also update the TableRecord in the DB"
	instances := self instancesOf: SSWDBTableRecord satisfying: [ :each | each tableName = oldTable name].
	self supportsFullTableRecords ifTrue: [instances modify: [ :each | each fullTableName: newTable fullName]].
	instances modify: [ :each | each tableName: newTable name].

	"Clear any cached TableRecord for the old table"
	oldRecord := self nextIDCache detect: [ :each | each tableName = oldTable name] ifNone: [nil].
	oldRecord notNil ifTrue:
		[| cachedOldTable |
		cachedOldTable := self nextIDCache keyAtValue: oldRecord.
		cachedOldTable isNil ifFalse: [self nextIDCache removeKey: cachedOldTable]].

	"Also rename containedTables"
	oldTable containedTables with: newTable containedTables do:
		[ :oldContainedTable :newContainedTable |
		self renameTable: oldContainedTable to: newContainedTable]!

resetClasses

	self clearTableCache.

	"tableCache should always contain the required system classes"
	self persistentSystemClasses do: [ :each | self addClass: each]!

rollbackAndRefreshTransaction

	"21/1/2001"
	
	self isTransactionInProgress ifFalse: [self error: 'No transaction in progress'].

	self transactionCritical:
		[self connection rollbackTxn.
		self transaction rollbackAndRefresh.
		self transaction: self transaction ownerTransaction]!

rollbackObject: anObject

	self rollbackObjects: (Array with: anObject)!

rollbackObjects: aCollection

	"Rollback any changes made to the members of aCollection"

	self transactionCritical:
		[self ensureNoActiveTransaction.
		self _rollbackObjects: aCollection]!

rollbackTransaction

	| rolledBack |

	self hasTransaction ifFalse: [self error: 'No transaction to rollback'].

	self transactionCritical:
		[rolledBack := self transaction rollback.
		self transaction: self transaction ownerTransaction.
		self connection rollbackTxn].

	rolledBack do: [ :each | each isDBProxy ifFalse: [each onRollback]]!

rowFromQuery: anSSWSQLQuery

	"6/8/2000
	
	Return the sole/first row obtained by execuing anSSWSQLQuery"
	
	| results row |
		
	results := self executeQuery: anSSWSQLQuery.

	row := results first.
		
	results close.
	
	^row!

rowsFromQuery: anSSWSQLQuery do: aBlock

	"6/8/2000"
	
	| results |
		
	results := self executeQuery: anSSWSQLQuery.

	 results 
		do: [ :row | aBlock value: row];
		close!

rowsFromStatement: aDBPreparedStatement do: aBlock

	"6/8/2000"
	
	aDBPreparedStatement exec.

	aDBPreparedStatement results do: [ :row | aBlock value: row].

	aDBPreparedStatement close!

selectChangedObjects: aCollection

	"Return those elements of aCollection which have changed"

	^aCollection inject: IdentitySet new into: [ :all :each | all addAll: (each _changedObjectsIn: self)]!

setDefaultTransactionMode

	self useTransactionsWithVersioning!

softDisconnect

	"14/8/2000
	
	Disconnect from the DB but do not clear the proxy cache"

	self clearStatementCache.

	"Going through a Txn cycle seems to help when disconnecting"
	self connection rollbackTxn.

	self connection close!

sqlDialect

	^self connection sqlDialect!

supportsFullTableRecords

	"supportsFullTableRecords stores a Boolean indicating whether the receiver
	is using the full definition of SSWDBTableRecord including description and fullTableName.
	This is necessary to automatically support long (> db limit) table names.

	Note this is false (off) by default in ReStore 1.20 to ensure compatibility with earlier releases.
	The default may become true (on) in a future release"

	supportsFullTableRecords isNil ifTrue: [supportsFullTableRecords := false].

	^supportsFullTableRecords!

supportsFullTableRecords: aBoolean

	"supportsFullTableRecords stores a Boolean indicating whether the receiver
	is using the full definition of SSWDBTableRecord including description and fullTableName.
	This is necessary to automatically support long (> db limit) table names.

	Note this is false (off) by default in ReStore 1.20 to ensure compatibility with earlier releases.
	The default may become true (on) in a future release"

	supportsFullTableRecords := aBoolean!

supportsVersioning

	^self objectProxyClass = SSWDBVersionedCachingObjectProxy!

synchronizeAllClasses

	"12/5/2001

	Synchronize the definitions of all the tables associated with the receiver's classes"

	[self evaluateAsTxn:
		[self persistentSystemClasses do: 
			[ :each |
			(self tableForClass: each) synchronizeDefinition].

		self tableCache keysAndValuesDo: 
			[ :class :table | 
			(self isSystemClass: class) ifFalse: [table synchronizeDefinition]].

		true]] 
			ensure: [self clearDBTableNames]!

synchronizeClass: aClass

	"12/5/2001

	Synchronize the definition(s) of the table(s) associated with the given class"

	[self evaluateAsTxn:
		[self persistentSystemClasses do: 
			[ :each |
			(self tableForClass: each) synchronizeDefinition].

		(self tableForClass: aClass) synchronizeDefinition.

		true]] 
			ensure: [self clearDBTableNames]!

tableCache

	"6/8/2000
	
	tableCache stores a Dictionary mapping classes (known as persistent to the receiver)
	to their equivalent SSWDBTable"
	
	^tableCache!

tableCache: anIdentityDictionary

	"6/8/2000
	
	tableCache stores a Dictionary mapping classes (known as persistent to the receiver)
	to their equivalent SSWDBTable"
	
	tableCache := anIdentityDictionary!

tableForClass: aClass

	^self tableForClass: aClass ifAbsent: [self addClass: aClass]!

tableForClass: aClass ifAbsent: aBlock
	
	^self tableCache at: aClass ifAbsent: aBlock!

transaction

	"20/10/2000
	
	transaction stores an SSWDBTransaction which manages 
	the writing/rollback of object changes within this ReStore"
	
	^transaction!

transaction: anSSWDBTransaction

	"20/10/2000
	
	transaction stores an SSWDBTransaction which manages 
	the writing/rollback of object changes within this ReStore"
	
	transaction := anSSWDBTransaction!

transactionClass

	"21/1/2001
	
	transactionClass stores the class of transaction (SSWDBTransaction subclass) 
	which the receiver uses"
	
	^transactionClass!

transactionClass: aSSWDBTransactionSubclass

	"21/1/2001
	
	transactionClass stores the class of transaction (SSWDBTransaction subclass) 
	which the receiver uses"
	
	self isTransactionInProgress ifTrue: [self error: 'Cannot change transactionClass whilst transaction in progress'].
	
	transactionClass := aSSWDBTransactionSubclass!

transactionCommitFailures

	"23/4/2001"
	
	self isTransactionInProgress ifFalse: [self error: 'No transaction in progress'].
	
	^self transaction hasFailedCommit
		ifTrue: [self transaction commitFailures]
		ifFalse: [self error: 'Transaction has not failed commit']!

transactionCritical: aBlock

	"25/4/2002

	Evaluate aBlock under the guard of the transactionMutex"

	^self transactionMutex critical: aBlock!

transactionCritical: aBlock ifLocked: lockedBlock

	"25/4/2002

	Evaluate aBlock under the guard of the transactionMutex"

	^self transactionMutex critical: aBlock ifLocked: lockedBlock!

transactionMutex

	"25/4/2002

	transactionMutex holds a Mutex which guards access to critical areas of transaction functionality.
	This prevents transactions being corrupted by access to objects during commit/rollback"

	^transactionMutex!

transactionMutex: aMutex

	"25/4/2002

	transactionMutex holds a Mutex which guards access to critical areas of transaction functionality.
	This prevents transactions being corrupted by access to objects during commit/rollback"

	transactionMutex := aMutex!

uid: aString

	"14/8/2000
	
	Forward to the connection itself"
	
	self connection uid: aString!

uncacheObject: aPersistentObjectProxy

	"Created 6/8/2000
	Modified 5/9/2001		Use _class to avoid fetching inherited objects (issue#0015)
	
	Remove the given persistent object proxy to the receiver's cache"
	
	(self classCacheFor: aPersistentObjectProxy _class) removeKey: aPersistentObjectProxy _id!

unstoreNextIDsForTables: aCollection

	"Private - 3/10/2001

	Forget and unstore the NEXT_ID entries for aCollection of (dropped) SSWDBTables"

	| droppedNames |

	aCollection do: [ :table | self nextIDCache removeKey: table ifAbsent: []].
	(self dbIncludesTableForClass: SSWDBTableRecord) ifFalse: [^self].

	droppedNames := (aCollection collect: [ :e | e name]) asArray.

	((self instancesOf: SSWDBTableRecord) satisfying: [ :nextID | droppedNames includes: nextID tableName]) unstoreAll!

useTransactionsWithoutVersioning

	"29/4/2001

	Set the receiver to use (single) transactions *without* version counting
	 - for single-user, transaction controlled DB updating"

	self 	
		ensureCanChangeTransactionMode;
		transactionClass: SSWDBSingleTransaction;
		objectProxyClass: SSWDBCachingObjectProxy;
		refreshClasses
!

useTransactionsWithVersioning

	"29/4/2001

	Set the receiver to use (single) transactions with version counting
	 - for optimistic-locking, multi-user, transaction controlled DB updating"

	self
		ensureCanChangeTransactionMode;
		transactionClass: SSWDBSingleTransactionWithVersioning;
		objectProxyClass: SSWDBVersionedCachingObjectProxy;
		refreshClasses
!

validateTable: anSSWDBTable

	"Private - At present, validation just checks that the table name is within the permitted size,
	and substitutes a unique abbreviated name if not"

	anSSWDBTable name size > self sqlDialect maxTableNameLength ifTrue:
		[self supportsFullTableRecords
		ifTrue:
			[| abbrevName |
			anSSWDBTable isRootTable 
			ifTrue:
				[| record |
				record := self fullTableRecordFor: anSSWDBTable.
				record isNil
					ifTrue: [abbrevName := self nextShortTableNameFor: anSSWDBTable]
					ifFalse: [abbrevName := record tableName]]
			ifFalse:
				[abbrevName := anSSWDBTable rootTable name].

			anSSWDBTable name: abbrevName]
		ifFalse:
			[self error: 'Oversize table name. Enable full table records (see supportsFullTableRecords)']]! !
!SSWReStore categoriesFor: #_rollbackObjects:!private!transactionless api! !
!SSWReStore categoriesFor: #abandonTransaction!public!transaction api! !
!SSWReStore categoriesFor: #actualProxyForObject:ifNone:!proxy manipulation!public! !
!SSWReStore categoriesFor: #addClass:!class maintenance!public! !
!SSWReStore categoriesFor: #addClasses:!class maintenance!public! !
!SSWReStore categoriesFor: #addClassWithSubclasses:!class maintenance!public! !
!SSWReStore categoriesFor: #applyUpdates:toObject:!public!read/write objects! !
!SSWReStore categoriesFor: #beginDumbTransaction!private!transaction management! !
!SSWReStore categoriesFor: #beginTransaction!public!transaction api! !
!SSWReStore categoriesFor: #binaryStoreOn:!binary filing!public! !
!SSWReStore categoriesFor: #cachedInstancesOf:!public!querying! !
!SSWReStore categoriesFor: #cachedObjectOfClass:withID:ifAbsent:!cache management!public! !
!SSWReStore categoriesFor: #cachedObjectOfClass:withID:ifAbsent:ifUnrecovered:ifUntouched:!cache management!public! !
!SSWReStore categoriesFor: #cacheObject:!cache management!public! !
!SSWReStore categoriesFor: #changedClassOfInstVar:in:modifyUsing:!class maintenance!public! !
!SSWReStore categoriesFor: #classCacheFor:!cache management!public! !
!SSWReStore categoriesFor: #clearDBTableNames!cache management!public! !
!SSWReStore categoriesFor: #clearNextIDCache!cache management!public! !
!SSWReStore categoriesFor: #clearProxyCache!cache management!public! !
!SSWReStore categoriesFor: #clearStatementCache!cache management!public! !
!SSWReStore categoriesFor: #clearTableCache!cache management!public! !
!SSWReStore categoriesFor: #clearTransaction!private!transaction management! !
!SSWReStore categoriesFor: #columnsForFields:!connection!public! !
!SSWReStore categoriesFor: #columnsInTable:!connection!public! !
!SSWReStore categoriesFor: #commitObject:!public!transactionless api! !
!SSWReStore categoriesFor: #commitObjects:!public!transactionless api! !
!SSWReStore categoriesFor: #commitTransaction!public!transaction api! !
!SSWReStore categoriesFor: #connect!connection!public! !
!SSWReStore categoriesFor: #connection!accessing!public! !
!SSWReStore categoriesFor: #connection:!accessing!public! !
!SSWReStore categoriesFor: #createConnection!initialize/release!public! !
!SSWReStore categoriesFor: #createProxyForNewObject:!proxy manipulation!public! !
!SSWReStore categoriesFor: #createProxyForObjectOfClass:withID:!proxy manipulation!public! !
!SSWReStore categoriesFor: #createProxyForRow:fromTable:withID:!proxy manipulation!public! !
!SSWReStore categoriesFor: #createTableForClass:!class maintenance!private! !
!SSWReStore categoriesFor: #createTableRecordFor:!class maintenance!private! !
!SSWReStore categoriesFor: #dbIncludesTableForClass:!class maintenance!public! !
!SSWReStore categoriesFor: #dbIncludesTableNamed:!public!testing! !
!SSWReStore categoriesFor: #dbTableNames!accessing!public! !
!SSWReStore categoriesFor: #dbTableNames:!accessing!public! !
!SSWReStore categoriesFor: #debugTo:!connection!public! !
!SSWReStore categoriesFor: #defaultReadAllBatchSize!constants!private! !
!SSWReStore categoriesFor: #deferredObjectOfClass:withID:!proxy manipulation!public! !
!SSWReStore categoriesFor: #deferredObjectOfClass:withID:version:!proxy manipulation!public! !
!SSWReStore categoriesFor: #deregisterProxy:!proxy manipulation!public! !
!SSWReStore categoriesFor: #destroyAllClasses!class maintenance!public! !
!SSWReStore categoriesFor: #destroyAllTables!class maintenance!public! !
!SSWReStore categoriesFor: #destroyClass:!class maintenance!public! !
!SSWReStore categoriesFor: #destroyTable:!class maintenance!private! !
!SSWReStore categoriesFor: #disconnect!connection!public! !
!SSWReStore categoriesFor: #dsn:!connection!public! !
!SSWReStore categoriesFor: #enableFullTableRecords!class maintenance!public! !
!SSWReStore categoriesFor: #ensureCanChangeTransactionMode!initialize/release!private! !
!SSWReStore categoriesFor: #ensureNoActiveTransaction!private!transaction management! !
!SSWReStore categoriesFor: #evaluateAsTransaction:!public!transaction api! !
!SSWReStore categoriesFor: #evaluateAsTransactionUntilSuccess:!public!transaction api! !
!SSWReStore categoriesFor: #evaluateAsTxn:!connection!private! !
!SSWReStore categoriesFor: #evaluateInTransaction:!public!transaction api! !
!SSWReStore categoriesFor: #evaluateInTxn:!connection!private! !
!SSWReStore categoriesFor: #executeQuery:!connection!public! !
!SSWReStore categoriesFor: #executeQuery:cursorType:!connection!public! !
!SSWReStore categoriesFor: #executeSQL:!connection!public! !
!SSWReStore categoriesFor: #executeSQLAsTxn:!connection!public! !
!SSWReStore categoriesFor: #executeStatement!accessing!public! !
!SSWReStore categoriesFor: #executeStatement:!accessing!public! !
!SSWReStore categoriesFor: #fetchObjectOfClass:withQuery:ifNone:!public!querying! !
!SSWReStore categoriesFor: #fetchObjectsOfClass:withQuery:into:!public!querying! !
!SSWReStore categoriesFor: #fetchObjectsOfClass:withStatement:into:!public!querying! !
!SSWReStore categoriesFor: #finalize!connection!initialize/release!public! !
!SSWReStore categoriesFor: #forceRefreshObject:!public!transactionless api! !
!SSWReStore categoriesFor: #forceRefreshObjects:!public!transactionless api! !
!SSWReStore categoriesFor: #forgetClass:!class maintenance!public! !
!SSWReStore categoriesFor: #fullTableRecordFor:!class maintenance!private! !
!SSWReStore categoriesFor: #hasCommittedObject:!private!transactionless api! !
!SSWReStore categoriesFor: #hasObjectChanged:!public!transactionless api! !
!SSWReStore categoriesFor: #hasTransaction!private!transaction management! !
!SSWReStore categoriesFor: #hasTransactionChanges!public!transaction api! !
!SSWReStore categoriesFor: #haveObjectsChanged:!public!transactionless api! !
!SSWReStore categoriesFor: #insertProxy:!public!read/write objects! !
!SSWReStore categoriesFor: #instancesOf:!public!querying! !
!SSWReStore categoriesFor: #instancesOf:satisfying:!public!querying! !
!SSWReStore categoriesFor: #isClassPersistent:!public!testing! !
!SSWReStore categoriesFor: #isConnected!public!testing! !
!SSWReStore categoriesFor: #isSystemClass:!public!testing! !
!SSWReStore categoriesFor: #isTransactionInProgress!public!transaction api! !
!SSWReStore categoriesFor: #locateProxyForObject:ifNone:!proxy manipulation!public! !
!SSWReStore categoriesFor: #nextIDCache!accessing!public! !
!SSWReStore categoriesFor: #nextIDCache:!accessing!public! !
!SSWReStore categoriesFor: #nextIDFor:!proxy manipulation!public! !
!SSWReStore categoriesFor: #nextIDForTable:!cache management!public! !
!SSWReStore categoriesFor: #nextShortTableNameFor:!class maintenance!private! !
!SSWReStore categoriesFor: #objectFromRow:table:!public!querying! !
!SSWReStore categoriesFor: #objectProxyClass!accessing!public! !
!SSWReStore categoriesFor: #objectProxyClass:!accessing!public! !
!SSWReStore categoriesFor: #objectProxyClassFor:!proxy manipulation!public! !
!SSWReStore categoriesFor: #openODBC!connection!public! !
!SSWReStore categoriesFor: #persistentSystemClasses!class maintenance!private! !
!SSWReStore categoriesFor: #prepareStatementForQuery:!connection!public! !
!SSWReStore categoriesFor: #preWriteValidate:!public!read/write objects! !
!SSWReStore categoriesFor: #proxy:forwarded:!proxy manipulation!public! !
!SSWReStore categoriesFor: #proxyCache!accessing!public! !
!SSWReStore categoriesFor: #proxyCache:!accessing!public! !
!SSWReStore categoriesFor: #pwd:!connection!public! !
!SSWReStore categoriesFor: #readAllBatchSize!accessing!public! !
!SSWReStore categoriesFor: #readAllBatchSize:!accessing!public! !
!SSWReStore categoriesFor: #reconnect!connection!public! !
!SSWReStore categoriesFor: #recoverObjectOfClass:withID:into:!public!read/write objects! !
!SSWReStore categoriesFor: #refreshAllObjects!public!transaction api! !
!SSWReStore categoriesFor: #refreshAndRollforwardTransaction!public!transaction api! !
!SSWReStore categoriesFor: #refreshClasses!class maintenance!public! !
!SSWReStore categoriesFor: #refreshObject:!public!transactionless api! !
!SSWReStore categoriesFor: #refreshObjectIfUpdated:!public!transactionless api! !
!SSWReStore categoriesFor: #refreshObjects:!public!transactionless api! !
!SSWReStore categoriesFor: #refreshObjectsIfUpdated:!public!transactionless api! !
!SSWReStore categoriesFor: #refreshProxyIfUpdated:!public!read/write objects! !
!SSWReStore categoriesFor: #registerProxy:!proxy manipulation!public! !
!SSWReStore categoriesFor: #removeFromTransaction:!proxy manipulation!public! !
!SSWReStore categoriesFor: #removeProxy:!public!read/write objects! !
!SSWReStore categoriesFor: #renamedClass:from:!class maintenance!public! !
!SSWReStore categoriesFor: #renamedInstVar:from:in:!class maintenance!public! !
!SSWReStore categoriesFor: #renameTable:to:!class maintenance!private! !
!SSWReStore categoriesFor: #resetClasses!class maintenance!public! !
!SSWReStore categoriesFor: #rollbackAndRefreshTransaction!public!transaction api! !
!SSWReStore categoriesFor: #rollbackObject:!public!transactionless api! !
!SSWReStore categoriesFor: #rollbackObjects:!public!transactionless api! !
!SSWReStore categoriesFor: #rollbackTransaction!public!transaction api! !
!SSWReStore categoriesFor: #rowFromQuery:!public!querying! !
!SSWReStore categoriesFor: #rowsFromQuery:do:!public!querying! !
!SSWReStore categoriesFor: #rowsFromStatement:do:!public!querying! !
!SSWReStore categoriesFor: #selectChangedObjects:!public!transactionless api! !
!SSWReStore categoriesFor: #setDefaultTransactionMode!initialize/release!private! !
!SSWReStore categoriesFor: #softDisconnect!connection!public! !
!SSWReStore categoriesFor: #sqlDialect!accessing!public! !
!SSWReStore categoriesFor: #supportsFullTableRecords!accessing!public! !
!SSWReStore categoriesFor: #supportsFullTableRecords:!accessing!public! !
!SSWReStore categoriesFor: #supportsVersioning!public!testing! !
!SSWReStore categoriesFor: #synchronizeAllClasses!class maintenance!public! !
!SSWReStore categoriesFor: #synchronizeClass:!class maintenance!public! !
!SSWReStore categoriesFor: #tableCache!accessing!public! !
!SSWReStore categoriesFor: #tableCache:!accessing!public! !
!SSWReStore categoriesFor: #tableForClass:!cache management!public! !
!SSWReStore categoriesFor: #tableForClass:ifAbsent:!cache management!public! !
!SSWReStore categoriesFor: #transaction!accessing!public! !
!SSWReStore categoriesFor: #transaction:!accessing!public! !
!SSWReStore categoriesFor: #transactionClass!accessing!public! !
!SSWReStore categoriesFor: #transactionClass:!accessing!public! !
!SSWReStore categoriesFor: #transactionCommitFailures!public!transaction api! !
!SSWReStore categoriesFor: #transactionCritical:!private!transaction management! !
!SSWReStore categoriesFor: #transactionCritical:ifLocked:!private!transaction management! !
!SSWReStore categoriesFor: #transactionMutex!accessing!public! !
!SSWReStore categoriesFor: #transactionMutex:!accessing!public! !
!SSWReStore categoriesFor: #uid:!connection!public! !
!SSWReStore categoriesFor: #uncacheObject:!cache management!public! !
!SSWReStore categoriesFor: #unstoreNextIDsForTables:!class maintenance!private! !
!SSWReStore categoriesFor: #useTransactionsWithoutVersioning!initialize/release!public! !
!SSWReStore categoriesFor: #useTransactionsWithVersioning!initialize/release!public! !
!SSWReStore categoriesFor: #validateTable:!class maintenance!private! !

!SSWReStore class methodsFor!

activated: anSSWReStore

	"Created 16/4/2001
	Modified 4/9/2001		Make anSSWReStore finalizable (issue#0016)"

	self activeReStores add: anSSWReStore.
	anSSWReStore beFinalizable!

activeReStores

	"Created 16/4/2001
	Modified 4/9/2001		Use a WeakIdentitySet (issue#0016)

	activeReStores stores a WeakIdentitySet of all instances of the receiver
	that are active (have allocated proxies)"

	activeReStores == nil ifTrue: [activeReStores := WeakIdentitySet new].

	^activeReStores!

deactivated: anSSWReStore

	"Created 16/4/2001
	Modified 4/9/2001		Make anSSWReStore unfinalizable (issue#0016)"

	self activeReStores remove: anSSWReStore ifAbsent: [nil].
	anSSWReStore beUnfinalizable!

default

	"Return the default ReStore instance, creating it if necessary. 
	Many (most?) applications will only use a single ReStore; having a default instance means it no longer needs to passed around as a parameter"

	^default ifNil: [default := self new]!

initialize

	SessionManager current when: #sessionStarted send: #onStartup to: self.
	self reset!

initializeReStoreGlobal

	Smalltalk at: #ReStore put: self default!

new

	"14/8/2000"
	
	^super new
		clearProxyCache;
		clearDBTableNames;
		clearTableCache;
		createConnection;
		yourself!

onStartup

	"Clear the statement cache of any active ReStores, 
	since these will reference the connection active in the previous session"

	self activeReStores do: [ :each | each clearStatementCache]!

proxyForObject: anObject ifNone: aBlock

	"16/4/2001

	Locate and return the proxy wrapping anObject in the receiver's activeReStores.
	If none found, return the result of evaluating aBlock"
	
	self activeReStores do:
		[ :aReStore | 
		"Only interrogate aReStore if it stores instances of the class of anObject"
		((aReStore tableCache includesKey: anObject class) or: [anObject isKindOf: Collection]) ifTrue:
			[(aReStore actualProxyForObject: anObject ifNone: [nil]) ifNotNil: [ :proxy | ^proxy]]].

	^aBlock value!

reset

	"Reset the default instance"

	default isNil ifFalse: 
		[default isConnected ifTrue: [default disconnect].
		default := nil].

	self initializeReStoreGlobal!

resetActive

	"Private - 22/9/2001	(renamed from resetActivate)"

	activeReStores := nil!

reStoreForObject: anObject ifNone: aBlock

	"Locate and return the instance of the receiver's activeReStores in which anObject is persistent.
	If none found, return the result of evaluating aBlock"
	
	^(self proxyForObject: anObject ifNone: [nil]) 
		ifNil: [aBlock value]
		ifNotNil: [ :proxy | proxy _reStore]
! !
!SSWReStore class categoriesFor: #activated:!events!public! !
!SSWReStore class categoriesFor: #activeReStores!accessing!public! !
!SSWReStore class categoriesFor: #deactivated:!events!public! !
!SSWReStore class categoriesFor: #default!accessing!public! !
!SSWReStore class categoriesFor: #initialize!initialize/release!public! !
!SSWReStore class categoriesFor: #initializeReStoreGlobal!initialize/release!private! !
!SSWReStore class categoriesFor: #new!instance creation!public! !
!SSWReStore class categoriesFor: #onStartup!events!public! !
!SSWReStore class categoriesFor: #proxyForObject:ifNone:!accessing!public! !
!SSWReStore class categoriesFor: #reset!accessing!initialize/release!public! !
!SSWReStore class categoriesFor: #resetActive!initialize/release!private! !
!SSWReStore class categoriesFor: #reStoreForObject:ifNone:!accessing!public! !


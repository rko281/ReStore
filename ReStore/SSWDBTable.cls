"Filed out from Dolphin Smalltalk 7"!

SSWSQLTable subclass: #SSWDBTable
	instanceVariableNames: 'instanceClass fullName idField idDataField dataFields controlFields collectionSpecs abbreviations reStore insertStatement readStatement refreshStatement deleteStatement readAllBatchSize namespace'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBTable guid: (GUID fromString: '{266e4dcc-398e-11d5-b1df-444553540000}')!
SSWDBTable comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBTable categoriesForClass!Unclassified! !
!SSWDBTable methodsFor!

abbreviate: aSymbol to: abbrevSymbol

	"Define abbrevSymbol as an abbreviated name for the inst var named aSymbol"

	self abbreviations at: aSymbol put: abbrevSymbol!

abbreviations

	"abbreviations stores a Dictionary mapping instance variables (Symbols)
	to abbreviated names (Symbols) to use to define their database name.

	This is required where names exceed the DB size limit"

	^abbreviations!

abbreviations: aDictionary

	"abbreviations stores a Dictionary mapping instance variables (Symbols)
	to abbreviated names (Symbols) to use to define their database name.

	This is required where names exceed the DB size limit"

	abbreviations := aDictionary!

aboutToBeUnstored: anObject

	"anObject (which originated in the receiver table) is about to be removed from the DB.
	Notify the receiver's components so they can take any necessary action"

	self componentsDo: [ :field | field aboutToBeUnstored: anObject]!

addDataField: anSSWDBField

	anSSWDBField table: self.
	^self dataFields add: anSSWDBField!

allDataFieldsDo: aBlock

	"Include the ID field if it is a data field"
	
	self idDataField ifNotNil: [ :field | aBlock value: field].

	self dataFields do: aBlock
!

allFields

	"Return an SSWSQLFieldCollection of all the receiver's fields"
	
	^self dataAndControlFields
		addFirst: self idField;
		yourself!

allFieldsDetect: aBlock ifNone: noneBlock

	(aBlock value: self idField) ifTrue: [^self idField].

	^self dataFields detect: aBlock ifNone: [self controlFields detect: aBlock ifNone: noneBlock]!

allFieldsDo: aBlock

	"Faster than allFields do:"
	
	aBlock value: self idField.
	self dataFields do: aBlock.
	self controlFields do: aBlock
!

collectionAccessing: aSymbol

	"Determine and return the collectionSpec of the receiver which accesses the inst var named aSymbol
	of the receiver's instanceClass"
	
	^self collectionSpecs detect: [ :spec | spec accessor accesses: aSymbol] ifNone: [nil]!

collectionSpecs

	"collectionSpecs stores a Collection of SSWDBCollectionSpecs which define the persistent
	collections held by instances of the receiver's instanceClass"
	
	^collectionSpecs!

collectionSpecs: anOrderedCollection

	"collectionSpecs stores a Collection of SSWDBCollectionSpecs which define the persistent
	collections held by instances of the receiver's instanceClass"
	
	collectionSpecs := anOrderedCollection!

componentAccessing: aSymbol

	^(self fieldAccessing: aSymbol) ifNil: [self collectionAccessing: aSymbol]!

componentsDo: aBlock

	"Evaluate aBlock with each component (field or collection spec) of the receiver"
	
	self dataFields do: aBlock.
	self collectionSpecs do: aBlock!

componentsSelect: aBlock

	| selected |

	selected := OrderedCollection new.
	self componentsDo: [ :each | (aBlock value: each) ifTrue: [selected add: each]].

	^selected!

containedTableNameRoot

	"Return the String to use as the root of all containedTables owned by the receiver"
	
	"Use a double-underscore to avoid name clashes with any class tables.
	ASSERT: class names NEVER contain an underscore"
	^self fullName, '__'!

containedTables

	"At present, only collection specs can contain other tables"

	| containedTables |

	containedTables := OrderedCollection new.

	self collectionSpecs do: [ :spec | containedTables addAll: spec containedTables].

	^containedTables!

controlFields

	"controlFields stores a Collection of SSWDBFields that do not hold data,
	but provide assistance to the ReStore persistency mechanism.

	Exact content and behaviour is dependent on the receiver's clients,
	but e.g. could refer to 'isActive', 'shouldIgnore' flags"	

	^controlFields!

controlFields: aCollection

	"controlFields stores a Collection of SSWDBFields that do not hold data,
	but provide assistance to the ReStore persistency mechanism.

	Exact content and behaviour is dependent on the receiver's clients,
	but e.g. could refer to 'isActive', 'shouldIgnore' flags"

	controlFields := aCollection!

copyForProxy: anObject

	| copy |

	copy := anObject shallowCopy.

	self dataFields do: [ :each | each accessor copyValueIn: anObject to: copy].

	^copy!

createDefinition

	"Create a table based on the receiver in the database accessed by the receiver's reStore.
	ASSERT: the receiver does not exist as a table in the database"
	
	self reStore
		executeSQL: self sqlDefinition;
		createTableRecordFor: self
	!

createIDField

	"Define the receiver table's unique ID field - it is not named at this point"
	
	| field |
	
	field := SSWDBStaticField new.
	
	field
		table: self;
		accessor: SSWDBIDAccessor new;
		targetClass: Integer.
	
	self idField: field!

createInstanceFromRow: aDBRow

	| object id |
	
	object := self instanceClass basicNew.

	self allDataFieldsDo:
		[ :field |
		field applyValueFromRow: aDBRow to: object].

	self collectionSpecs isEmpty ifTrue: [^object].

	id := aDBRow lookupField: self idField.
	self collectionSpecs do:
		[ :collection |
		collection applyTo: object withID: id in: self reStore].
		
	^object!

createNonProxiedInstanceFromRow: aDBRow
	
	"For internal/special non-proxied persistent objects"

	| instance |
	
	instance := self createInstanceFromRow: aDBRow.

	self controlFields do:
		[ :field |
		field applyValueFromRow: aDBRow to: instance].

	^instance!

dataAndControlFields

	^(SSWSQLFieldCollection new: 24)
		addAll: self dataFields;
		addAll: self controlFields;
		yourself
!

dataFields

	"dataFields stores an SSWSQLFieldCollection of SSWDBFields that define the data held by this table. 
	This specifically excludes the unique ID field and any control fields, which are held separately"
	
	^dataFields!

dataFields: anSSWSQLFieldCollection

	"dataFields stores an SSWSQLFieldCollection of SSWDBFields that define the data held by this table. 
	This specifically excludes the unique ID field and any control fields, which are held separately"
	
	dataFields := anSSWSQLFieldCollection!

dbNameFor: aSymbol

	"Return the name (String) to use within the database for the inst var named aSymbol"

	^self sqlDialect transformInstVarName: (self symbolicNameFor: aSymbol)!

defaultName

	"The default (table)name is the name of the receiver's instanceClass,
	transformed according to the sqlDialect"
	
	^self sqlDialect transformClassName: self instanceClass name
!

define: aSymbol abbreviation: abbrevSymbol as: anObject

	"Definition method for abbreviations. 
	As such, only suitable for definitions of instance variables"

	^self 
		abbreviate: aSymbol to: abbrevSymbol;
		define: aSymbol as: anObject!

define: aSymbol as: anObject

	"General user method for table specification.	 
	anObject could be a Class or ClassWithInfo (defining a field) or a CollectionSpec (defining a Collection).
	Example usage of each type:
		define: #name as: String;	
		define: #children as: (Collection of: Person owner: #parent)
	Return the table component added to the receiver"

	"Double-despatch; the object knows how to define itself"
	^anObject defineAs: aSymbol in: self!

define: aSymbol asCollectionSpec: aCollectionSpec

	^self collectionSpecs add:
		(aCollectionSpec
			accessor: (SSWInstVarAccessor toAccess: aSymbol in: self instanceClass);
			table: self;
			yourself)!

define: aSymbol asFieldNamed: aString holding: aClass

	"Return the field created"

	aString size > self sqlDialect maxColumnNameLength ifTrue: 
		[self error: ('Column <1s> for <2s> is larger than max length of <3d>. Define a suitable abbreviation'
					expandMacrosWith: aString with: aSymbol with: self sqlDialect maxColumnNameLength)].
	
	^self addDataField:
		(SSWDBStaticField new
			name: aString;
			targetClass: aClass;
			accessor: ((self sqlDialect instVarAccessorFor: aClass) access: aSymbol in: self instanceClass);
			yourself)!

define: aSymbol asInstVarHolding: aClass

	"Return the field created"
	
	^aClass shouldInlinePersistency
		ifTrue: [self define: aSymbol asInstVarHoldingInlined: aClass]
		ifFalse: [self define: aSymbol asFieldNamed: (self dbNameFor: aSymbol) holding: aClass]!

define: aSymbol asInstVarHoldingInlined: aClass

	| inliner |

	inliner := SSWFieldInliner new.
	inliner 
		table: self;
		instanceClass: self instanceClass;
		inlinedName: aSymbol;
		inlinedSlot: (self instanceClass allInstVarNames indexOf: aSymbol asString);
		inlinedClass: aClass.

	inliner inlinedSlot < 1 ifTrue: [self error: ('Undefined instance variable ', aSymbol)].

	aClass reStoreDefinition addDefinitionToTable: inliner.

	"To satisfy protocol of returning field created"
	^inliner fields first!

defineAsID: aSymbol

	"Define the receiver's idField to access inst var aSymbol.
	Use of this method enables persistent objects to store their unique ID within themselves.
	This can be useful in some cases, although the unique ID is really internal information.
	Return the idField"
	
	^self defineAsID: aSymbol fieldName: (self dbNameFor: aSymbol)!

defineAsID: aSymbol fieldName: aString

	"Define the receiver's idField to be named aString and to access inst var aSymbol.
	Use of this method enables persistent objects to store their unique ID within themselves.
	This can be useful in some cases, although the unique ID is really internal information.
	Return the idField"

	| field instanceAccessor |

	field := self defineIDFieldName: aString.
	instanceAccessor := SSWInstVarAccessor toAccess: aSymbol in: self instanceClass.

	field accessor instanceAccessor: instanceAccessor.

	self idDataField:
		(field copy
			accessor: instanceAccessor;
			yourself).

	^field!

defineDefaultIDField

	"Define the default-named ID field.
	Return the field defined"
	
	self createIDField.

	^self idField 
		name: (self sqlDialect transformInstVarName: self idField accessor nameInDB);
		yourself!

defineIDFieldName: aString

	"Define the receiver table's unique ID field to be named aString.
	Clients do not need to call this method if they are happy with the default name (based on #id_).
	Return the field created"

	self createIDField.

	^self idField 
		name: aString;
		yourself
!

definesName: aString

	^self name = aString or: [self containedTables anySatisfy: [ :each | each definesName: aString]]!

deleteStatementGeneratedFrom: aDeleteQuery

	^deleteStatement ifNil: [deleteStatement := self reStore prepareStatementForQuery: aDeleteQuery]!

dependentComponents

	^self componentsSelect: [ :each | each isDependent]!

dependentDataFields
	
	^self dataFields select: [ :field | field isDependent]!

dependentDataFieldsSelect: aBlock

	"Evaluate aBlock with each dependent component which is a data field, collecting those which answer true.
	Faster than dependentDataFields select:"
	
	^self dataFields select: [ :field | field isDependent and: [aBlock value: field]]!

fieldAccessing: aSymbol

	"Determine and return the field of the receiver which accesses the inst var named aSymbol of the receiver's instanceClass"
	
	^self allFieldsDetect: [ :field | field accessor accesses: aSymbol] ifNone: [nil]!

fieldNamed: aString

	^self allFieldsDetect: [ :field | field name = aString] ifNone: [nil]!

fieldsAccessing: aSymbol

	| matching |

	matching := OrderedCollection new.

	self allFieldsDo: [ :field | (field accessor accesses: aSymbol) ifTrue: [matching add: field]].

	^matching!

forCreation

	"Return an appropriate SSWDBxxxTable with which to 
	CREATE the receiver table in the database.
	
	Default - return the receiver"
	
	^self!

freePreparedStatements

	insertStatement notNil ifTrue: [insertStatement free].
	readStatement notNil ifTrue: [readStatement free].
	refreshStatement notNil ifTrue: [refreshStatement free].
	deleteStatement notNil ifTrue: [deleteStatement free].

	insertStatement := nil.
	readStatement := nil.
	refreshStatement := nil.
	deleteStatement := nil.

	self collectionSpecs do: [ :each | each freePreparedStatements].!

fullName

	"fullName stores the 'full' name of the receiver. 
	This is usually the same as the name, except where it exceeds the DB size limit,
	in which case name holds a suitably-abbreviated name, whilst fullName maintains the original"

	fullName isNil ifTrue: [fullName := self name].

	^fullName!

fullName: aString

	"fullName stores the 'full' name of the receiver. 
	This is usually the same as the name, except where it exceeds the DB size limit,
	in which case name holds a suitably-abbreviated name, whilst fullName maintains the original"

	fullName := aString!

hasCollectionAccessing: aSymbol

	"Return a Boolean indicating whether the receiver has a collectionSpec
	accessing the instance variable name aSymbol"

	^(self collectionAccessing: aSymbol) ~= nil !

hasFieldAccessing: aSymbol

	"Return a Boolean indicating whether the receiver has a Field
	accessing the instance variable name aSymbol"

	^(self fieldAccessing: aSymbol) notNil !

hasNamespace

	^self namespace notNil!

idDataField

	"idDataField stores a field which accesses the ID of instances when held as data in an actual object.
	This differs from the idField which accesses the ID solely in the proxy.
	Can be (and usually is) nil"

	^idDataField!

idDataField: anObject

	"idDataField stores a field which accesses the ID of instances when held as data in an actual object.
	This differs from the idField which accesses the ID solely in the proxy.
	Can be (and usually is) nil"

	idDataField := anObject!

idField

	"idField stores the SSWDBField which holds the unique ID of records in this table.	
	Lazy-defaulted if not set explicity"
	
	idField isNil ifTrue: [self defineDefaultIDField].
	
	^idField!

idField: anSSWDBField

	"idField stores the SSWDBField which holds the unique ID of records in this table"
	
	idField := anSSWDBField!

initializeIn: anSSWReStore

	self reStore: anSSWReStore.

	self controlFields: (anSSWReStore objectProxyClassFor: self instanceClass) controlFields.
	self controlFields do: 
		[ :field | 
		field table: self.
		field name: (self sqlDialect transformInstVarName: field accessor nameInDB)]!

insertStatementGeneratedFrom: anInsertQuery

	^insertStatement ifNil: [insertStatement := self reStore prepareStatementForQuery: anInsertQuery]!

instanceClass

	"instanceClass stores the Class which is equivalent to this table"
	
	^instanceClass!

instanceClass: aClass

	"instanceClass stores the Class which is equivalent to this table"
	
	"CHECK HERE: never allow aClass whose name includes an _
	as this can cause problems for the contained table mechanism"
	(aClass name includes: $_) ifTrue: [self error: 'Cannot use a Class name containing an underscore ( _ )'].

	instanceClass := aClass!

instanceClassFromRow: aDBRow

	"Private - for the receiver this is always its static instance class"

	^self instanceClass!

isDefined

	"Return a Boolean indicating if the receiver table is 'defined'
	i.e. if it has some meaningful fields/collections"
	
	^self dataFields size > 0 or: [self collectionSpecs size > 0]!

isRootTable

	^true!

isValidForPersistence

	"Tables are not persisted directly (e.g. via storeIn:), therefore consider them already persistent"

	^true!

name

	"Overriden to lazy initialize to default name"
	
	name isNil ifTrue: [name := fullName := self defaultName].
	
	^name!

namespace

	"namespace optionally stores the namespace (String, meaning schema or database depending on dialect) with which to qualify the table, i.e. the table is expressed as <namespace>.<table name>
	This is useful where some data is held in another namespace on the same server (e.g. a read-only namespace holding sensitive information). 
	Note that a class/table can only exist in one namespace"

	^namespace!

namespace: aString

	"namespace optionally stores the namespace (String, meaning schema or database depending on dialect) with which to qualify the table, i.e. the table is expressed as <namespace>.<table name>
	This is useful where some data is held in another namespace on the same server (e.g. a read-only namespace holding sensitive information). 
	Note that a class/table can only exist in one namespace"

	namespace := aString!

nonPersistentCopyOf: anObject

	"Return a non-persistent copy of the given object (which is of the receiver's instanceClass).
	Note that persistent collections are also copied"

	| copyObject |

	copyObject := anObject shallowCopy.

	self collectionSpecs do: 
		[ :spec |
		spec value: (spec value: anObject) copy in: copyObject].

	^copyObject!

parameterisedRecoveryQuery

	"Return a parameterised SQLSelectQuery which can fetch a single row of this table by its ID"

	^SSWSQLSelectQuery new
		table: self withAllFields;
		conditions: (SSWSQLCondition field: self idField equalTo: SSWSQLQueryParameter);
		yourself!

parameterisedRefreshQuery

	"Return a parameterised SQLSelectQuery which can be used to detect a change to a single row of this table based on its ID and version"

	^self parameterisedRecoveryQuery
		fields: (SSWSQLFieldCollection with: self versionControlField);
		yourself!

qualifiedName

	^self hasNamespace
		ifTrue: [self namespace, '.', self name]
		ifFalse: [self name]!

readAllBatchSize

	"When using the readAll function to mass-read components of the receiver, a parameteised statement is used with a fixed number of query parameters.
	This number should be a balance between the minimum and maximum likely query set size for this table:
	 - query sets smaller than this are padded with nulls
	 - query sets larger than this are batched into sets of this size resulting in multiple queries (which readAll is designed to avoid) albeit (N/batchSize) ceiling queries rather than N"

	^readAllBatchSize ifNil: [self reStore readAllBatchSize]!

readAllBatchSize: anInteger

	"When using the readAll function to mass-read components of the receiver, a parameteised statement is used with a fixed number of query parameters.
	This number should be a balance between the minimum and maximum likely query set size for this table:
	 - query sets smaller than this are padded with nulls
	 - query sets larger than this are batched into sets of this size resulting in multiple queries (which readAll is designed to avoid) albeit (N/batchSize) ceiling queries rather than N"

	readAllBatchSize := anInteger!

readStatement

	^readStatement ifNil: [readStatement := self reStore prepareStatementForQuery: self parameterisedRecoveryQuery]!

recoverInstanceFromRow: aDBRow into: anSSWDBObjectProxy
	
	anSSWDBObjectProxy 
		_proxiedObject: (self createInstanceFromRow: aDBRow);
		_aquireCollectionProxiesUsing: self collectionSpecs.

	self controlFields do:
		[ :field |
		field applyValueFromRow: aDBRow to: anSSWDBObjectProxy]!

refreshProxy: aProxy fromRow: aDBRow

	| instance |

	instance := aProxy _proxiedObject.

	self dataFields do:
		[ :field |
		field applyValueFromRow: aDBRow to: instance].
	
	self controlFields do:
		[ :field |
		field applyValueFromRow: aDBRow to: aProxy]!

refreshProxy: aProxy whereChangedFromRow: aDBRow

	"Return whether the proxy was refreshed at all"

	| instance changes |

	instance := aProxy _proxiedObject.

	changes := self dataFields select:
		[ :field |
		field applyValueIfChangedFromRow: aDBRow to: instance].
	
	changes addAll: (self controlFields select:
		[ :field |
		field applyValueIfChangedFromRow: aDBRow to: aProxy]).

	^changes isEmpty not!

refreshStatement

	^refreshStatement ifNil: [refreshStatement := self reStore prepareStatementForQuery: self parameterisedRefreshQuery]!

registerClass

	"Return the class under which objects created from this table 
	should be registered in an SSWReStore's proxy cache.
	Normally this is their own class. Subclassed may change this"

	^self instanceClass!

relatedComponents

	^self componentsSelect: [ :each | each isRelated]!

removeDefinition

	"Remove the receiver's definition from the database accessed by the receiver's reStore.
	Return a collection of the dropped tables"

	| creationTable containedTables |

	creationTable := self forCreation.
	creationTable isNil ifTrue: [^#()].

	(self reStore dbIncludesTable: creationTable) ifTrue: 
		[self reStore executeSQLFrom: [ :stream | stream nextPutAll: 'DROP TABLE '; writeSQLFor: creationTable]].

	containedTables := creationTable containedTables.
	containedTables do: [ :containedTable | containedTable removeDefinition].

	^(OrderedCollection with: creationTable)
		addAll: containedTables;
		yourself!

removeRedundantContainedTables

	"Remove from the database accessed by the receiver's reStore any contained tables that are no longer contained in the receiver"

	| root containedTableNames |

	root := self containedTableNameRoot.
	containedTableNames := (self reStore dbTableNamesFor: self namespace) select: [ :each | each beginsWith: root].

	"Don't delete any used containedTables"
	self containedTables do: [ :table | containedTableNames remove: table name ifAbsent: []].

	containedTableNames do:
		[ :tableName |
		self reStore executeSQL: ('DROP TABLE ', tableName)]!

reStore

	"the SSWReStore to which this table belongs"

	^reStore!

reStore: anSSWReStore

	"the SSWReStore to which this table belongs"

	reStore := anSSWReStore!

rootClass

	"Return the class which is the root of the receiver's persistent hierarchy.
	Standard definition - the receiver's instanceClass"

	^self instanceClass!

rootTable

	"Return the table which is the root of the receiver's persistent hierarchy.
	Standard definition - the receiver"

	^self!

sqlDefinition

	| stream |
	
	stream := self sqlDialect sqlWriteStream.
	
	self writeSQLDefinitionOn: stream.
	
	^stream contents!

sqlDialect

	^self reStore sqlDialect
!

staticConditions

	"Return an SSWSQLConditionCollection which is always applied
	when SELECTing from the receiver table.
	Unlike conditions that may be derived from controlFields, these conditions
	do not vary from object to object - they are static for all reads from this table.
	
	Subclasses should override if they implement hasStaticConditions to return true"
	
	^SSWSQLConditionCollection new!

storeNonPersistentComponentsOf: aProxyObject

	"Ensure that each non-persistency-valid component of the proxiedObject of aProxyObject 
	accessed by the receiver's components exists in the aProxyObject's ReStore 
	- store those that do not exist."
	
	| proxiedObject |
	
	proxiedObject := aProxyObject _proxiedObject.

	self dataFields do:
		[ :field | (field accessor valueIn: proxiedObject) _ensurePersistentIn: self reStore].
		
	self collectionSpecs do:
		[ :collectionSpec || collection |
		collection := collectionSpec accessor valueIn: aProxyObject.
		collection isNil ifTrue: [collection := collectionSpec newCollection].
		collection isDBProxy ifFalse: 
			[| proxy |
			proxy := aProxyObject _collectionProxyFor: collectionSpec.
			proxy _proxiedObject == collection ifFalse: 
				[proxy _setProxiedObject: collection; _referenced]]]!

symbolicNameFor: aSymbol

	"Return the correct symbolic name to use for the inst var named aSymbol.
	This is usually aSymbol itself, unless an abbreviation is specified"

	^self abbreviations at: aSymbol ifAbsent: [aSymbol]!

synchronizeDefinition

	"Update the receiver's definition in the database accessed by its reStore"
	
	| creationTable |

	creationTable := self forCreation.
	creationTable isNil ifTrue: [^self].

	(self reStore dbIncludesTable: creationTable)
	ifTrue: 
		[creationTable 
			synchronizeFields;
			removeRedundantContainedTables]
	ifFalse: 
		[creationTable createDefinition].

	creationTable containedTables do: [ :containedTable | containedTable synchronizeDefinition].

	self reStore connection columnDescriptions removeKey: self ifAbsent: []!

synchronizeFields

	"Update the definition of the receiver's fields in the database accessed by reStore.
	ASSERT: the receiver exists as a table in the database"
	
	| allFields allColumns addedFields droppedColumns |

	allFields := self allFields.
	allColumns := self reStore columnsInTable: self.
	addedFields := allFields reject: [ :field | allColumns anySatisfy: [ :column | column name = field name]].
	droppedColumns := allColumns reject: [ :column | allFields anySatisfy: [ :field | field name = column name]].

	addedFields isEmpty ifFalse: [self reStore sqlDialect addFields: addedFields to: self in: self reStore].

	"Not all DBs can directly DROP COLUMN. Use the dialect's maintenance action for this"
	droppedColumns do: 
		[ :column | 
		self reStore sqlDialect 
			dropColumnNamed: column name 
			fromTable: self
			in: self reStore]!

withAllFields

	"Return a table equivalent to the receiver but containing all possible fields.	
	For non-inherited tables, this is just the receiver"
	
	^self!

withControlFields

	"Return a table equivalent to the receiver but containing only control fields"
	
	| withControlFields |

	withControlFields := SSWDBTable new.

	^withControlFields
		reStore: self reStore;
		name: self name;
		fullName: self fullName;
		idField: (self idField copy table: withControlFields; yourself);
		controlFields: (self controlFields collect: [ :each | each copy table: withControlFields; yourself]);
		yourself!

writeSQLDefinitionOn: aStream
	
	self isDefined ifFalse: [self error: 'Cannot create a table with no fields'].
	
	aStream nextPutAll: 'CREATE TABLE '.

	self writeSQLNameOn: aStream.
	aStream nextPutAll: ' ('.
	
	self idField writeSQLDefinitionOn: aStream.
	aStream nextPutAll: ' PRIMARY KEY'.
		
	self dataAndControlFields do:
		[ :field |
		aStream nextPutAll: ', '.
		field writeSQLDefinitionOn: aStream].
		
	aStream nextPut: $)!

writeSQLNameOn: aStream

	self hasNamespace ifTrue: [aStream nextPutIdentifier: self namespace; nextPut: $.].

	super writeSQLNameOn: aStream
! !
!SSWDBTable categoriesFor: #abbreviate:to:!defining!private! !
!SSWDBTable categoriesFor: #abbreviations!accessing!public! !
!SSWDBTable categoriesFor: #abbreviations:!accessing!public! !
!SSWDBTable categoriesFor: #aboutToBeUnstored:!evaluating!public! !
!SSWDBTable categoriesFor: #addDataField:!defining!private! !
!SSWDBTable categoriesFor: #allDataFieldsDo:!enumerating!public! !
!SSWDBTable categoriesFor: #allFields!evaluating!public! !
!SSWDBTable categoriesFor: #allFieldsDetect:ifNone:!enumerating!public! !
!SSWDBTable categoriesFor: #allFieldsDo:!enumerating!public! !
!SSWDBTable categoriesFor: #collectionAccessing:!evaluating!public! !
!SSWDBTable categoriesFor: #collectionSpecs!accessing!public! !
!SSWDBTable categoriesFor: #collectionSpecs:!accessing!public! !
!SSWDBTable categoriesFor: #componentAccessing:!evaluating!public! !
!SSWDBTable categoriesFor: #componentsDo:!enumerating!public! !
!SSWDBTable categoriesFor: #componentsSelect:!enumerating!public! !
!SSWDBTable categoriesFor: #containedTableNameRoot!evaluating!private! !
!SSWDBTable categoriesFor: #containedTables!evaluating!public! !
!SSWDBTable categoriesFor: #controlFields!accessing!public! !
!SSWDBTable categoriesFor: #controlFields:!accessing!public! !
!SSWDBTable categoriesFor: #copyForProxy:!defining!evaluating!public! !
!SSWDBTable categoriesFor: #createDefinition!db maintenance!public! !
!SSWDBTable categoriesFor: #createIDField!initialize/release!private! !
!SSWDBTable categoriesFor: #createInstanceFromRow:!instance creation!public! !
!SSWDBTable categoriesFor: #createNonProxiedInstanceFromRow:!instance creation!private! !
!SSWDBTable categoriesFor: #dataAndControlFields!evaluating!public! !
!SSWDBTable categoriesFor: #dataFields!accessing!public! !
!SSWDBTable categoriesFor: #dataFields:!accessing!public! !
!SSWDBTable categoriesFor: #dbNameFor:!evaluating!private! !
!SSWDBTable categoriesFor: #defaultName!evaluating!public! !
!SSWDBTable categoriesFor: #define:abbreviation:as:!defining!public! !
!SSWDBTable categoriesFor: #define:as:!defining!public! !
!SSWDBTable categoriesFor: #define:asCollectionSpec:!defining!private! !
!SSWDBTable categoriesFor: #define:asFieldNamed:holding:!defining!private! !
!SSWDBTable categoriesFor: #define:asInstVarHolding:!defining!private! !
!SSWDBTable categoriesFor: #define:asInstVarHoldingInlined:!defining!private! !
!SSWDBTable categoriesFor: #defineAsID:!defining!public! !
!SSWDBTable categoriesFor: #defineAsID:fieldName:!defining!public! !
!SSWDBTable categoriesFor: #defineDefaultIDField!defining!private! !
!SSWDBTable categoriesFor: #defineIDFieldName:!defining!public! !
!SSWDBTable categoriesFor: #definesName:!public!testing! !
!SSWDBTable categoriesFor: #deleteStatementGeneratedFrom:!accessing!public! !
!SSWDBTable categoriesFor: #dependentComponents!accessing!public! !
!SSWDBTable categoriesFor: #dependentDataFields!evaluating!public! !
!SSWDBTable categoriesFor: #dependentDataFieldsSelect:!evaluating!public! !
!SSWDBTable categoriesFor: #fieldAccessing:!evaluating!public! !
!SSWDBTable categoriesFor: #fieldNamed:!evaluating!public! !
!SSWDBTable categoriesFor: #fieldsAccessing:!evaluating!public! !
!SSWDBTable categoriesFor: #forCreation!evaluating!public! !
!SSWDBTable categoriesFor: #freePreparedStatements!initialize/release!public! !
!SSWDBTable categoriesFor: #fullName!accessing!public! !
!SSWDBTable categoriesFor: #fullName:!accessing!public! !
!SSWDBTable categoriesFor: #hasCollectionAccessing:!public!testing! !
!SSWDBTable categoriesFor: #hasFieldAccessing:!public!testing! !
!SSWDBTable categoriesFor: #hasNamespace!public!testing! !
!SSWDBTable categoriesFor: #idDataField!accessing!public! !
!SSWDBTable categoriesFor: #idDataField:!accessing!public! !
!SSWDBTable categoriesFor: #idField!accessing!public! !
!SSWDBTable categoriesFor: #idField:!accessing!public! !
!SSWDBTable categoriesFor: #initializeIn:!initialize/release!public! !
!SSWDBTable categoriesFor: #insertStatementGeneratedFrom:!accessing!public! !
!SSWDBTable categoriesFor: #instanceClass!accessing!public! !
!SSWDBTable categoriesFor: #instanceClass:!accessing!public! !
!SSWDBTable categoriesFor: #instanceClassFromRow:!instance creation!private! !
!SSWDBTable categoriesFor: #isDefined!public!testing! !
!SSWDBTable categoriesFor: #isRootTable!public!testing! !
!SSWDBTable categoriesFor: #isValidForPersistence!public!testing! !
!SSWDBTable categoriesFor: #name!accessing!public! !
!SSWDBTable categoriesFor: #namespace!accessing!public! !
!SSWDBTable categoriesFor: #namespace:!accessing!public! !
!SSWDBTable categoriesFor: #nonPersistentCopyOf:!instance creation!public! !
!SSWDBTable categoriesFor: #parameterisedRecoveryQuery!evaluating!public! !
!SSWDBTable categoriesFor: #parameterisedRefreshQuery!evaluating!public! !
!SSWDBTable categoriesFor: #qualifiedName!accessing!public! !
!SSWDBTable categoriesFor: #readAllBatchSize!accessing!public! !
!SSWDBTable categoriesFor: #readAllBatchSize:!accessing!public! !
!SSWDBTable categoriesFor: #readStatement!accessing!public! !
!SSWDBTable categoriesFor: #recoverInstanceFromRow:into:!instance creation!public! !
!SSWDBTable categoriesFor: #refreshProxy:fromRow:!instance creation!public! !
!SSWDBTable categoriesFor: #refreshProxy:whereChangedFromRow:!instance creation!public! !
!SSWDBTable categoriesFor: #refreshStatement!accessing!public! !
!SSWDBTable categoriesFor: #registerClass!evaluating!public! !
!SSWDBTable categoriesFor: #relatedComponents!accessing!public! !
!SSWDBTable categoriesFor: #removeDefinition!db maintenance!public! !
!SSWDBTable categoriesFor: #removeRedundantContainedTables!db maintenance!public! !
!SSWDBTable categoriesFor: #reStore!accessing!public! !
!SSWDBTable categoriesFor: #reStore:!accessing!public! !
!SSWDBTable categoriesFor: #rootClass!evaluating!public! !
!SSWDBTable categoriesFor: #rootTable!evaluating!public! !
!SSWDBTable categoriesFor: #sqlDefinition!output!public! !
!SSWDBTable categoriesFor: #sqlDialect!evaluating!public! !
!SSWDBTable categoriesFor: #staticConditions!evaluating!public! !
!SSWDBTable categoriesFor: #storeNonPersistentComponentsOf:!public!validating! !
!SSWDBTable categoriesFor: #symbolicNameFor:!evaluating!private! !
!SSWDBTable categoriesFor: #synchronizeDefinition!db maintenance!public! !
!SSWDBTable categoriesFor: #synchronizeFields!db maintenance!public! !
!SSWDBTable categoriesFor: #withAllFields!evaluating!public! !
!SSWDBTable categoriesFor: #withControlFields!evaluating!public! !
!SSWDBTable categoriesFor: #writeSQLDefinitionOn:!output!public! !
!SSWDBTable categoriesFor: #writeSQLNameOn:!output!public! !

!SSWDBTable class methodsFor!

forClass: aClass

	^self new
		instanceClass: aClass;
		yourself!

forClass: aClass in: anSSWReStore

	^(self forClass: aClass)
		initializeIn: anSSWReStore;
		yourself!

new

	^super new
		dataFields: SSWSQLFieldCollection new;
		controlFields: SSWSQLFieldCollection new;
		collectionSpecs: OrderedCollection new;
		abbreviations: Dictionary new;
		yourself! !
!SSWDBTable class categoriesFor: #forClass:!instance creation!public! !
!SSWDBTable class categoriesFor: #forClass:in:!instance creation!public! !
!SSWDBTable class categoriesFor: #new!instance creation!public! !


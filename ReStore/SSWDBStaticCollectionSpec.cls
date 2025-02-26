﻿"Filed out from Dolphin Smalltalk"!

SSWDBGeneralCollectionSpec subclass: #SSWDBStaticCollectionSpec
	instanceVariableNames: 'targetClass deleteEntriesStatement'
	classVariableNames: 'NilCookie'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBStaticCollectionSpec guid: (GUID fromString: '{266e4dd3-398e-11d5-b1df-444553540000}')!
SSWDBStaticCollectionSpec comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBStaticCollectionSpec categoriesForClass!Unclassified! !
!SSWDBStaticCollectionSpec methodsFor!

createCollectionTable

	"Intercept to set the Class of the source and target fields in the collection table"
		
	super createCollectionTable.

	self sourceField targetClass: self table instanceClass reStoreIDClass.
	self targetField targetClass: self targetClass!

createNonProxiedInstanceFromRow: aDBRow

	^(self collectionTable createInstanceFromRow: aDBRow)
		table: self collectionTable;
		yourself!

dbInstancesFor: aCollectionProxy

	"Return a DBInstancesCollection representing the instances owned by aCollectionProxy
	and specified by the receiver"

	| instances targetTable |

	instances := aCollectionProxy _reStore instancesOf: self targetClass.
	targetTable := aCollectionProxy _reStore tableForClass: self targetClass.

	instances parser qualifyingTables 
		add: targetTable;
		add: self collectionTable joinedWith: (SSWSQLCondition field: self targetField equalTo: targetTable idField).

	instances parser qualifyingConditions: 
		(instances parser qualifyingConditions sqlAnd:
			(SSWSQLCondition field: self sourceField equalTo: aCollectionProxy _ownerID)).

	^instances!

deleteEntriesQuery

	^SSWSQLDeleteQuery new
		table: self collectionTable;
		conditions: (SSWSQLCondition field: self sourceField equalTo: SSWSQLQueryParameter);
		yourself!

deleteEntriesStatement

	"Return a prepared statement for deleting the entry table entries for this collection"

	^deleteEntriesStatement ifNil: [deleteEntriesStatement := self reStore prepareStatementForQuery: self deleteEntriesQuery]!

deleteQuery

	^self sqlDialect supportsDeleteWithJoin
		ifTrue: [self deleteQueryWithJoin]
		ifFalse: [self deleteQueryWithSubQuery]!

deleteQueryWithJoin

	| query |

	query := SSWSQLDeleteQuery new.
	query 
		table: self collectionTable;
		conditions: (SSWSQLCondition field: self sourceField equalTo: SSWSQLQueryParameter).

	self isValueDependent ifTrue: 
		[query 
			isMultiTableDelete: true;
			addTable: self targetTable withAllFields joinedWithField: self targetField].

	^query!

deleteQueryWithSubQuery

	| subquery |

	subquery := SSWSQLSelectQuery new.
	subquery
		field: self targetField;
		table: self collectionTable;
		conditions: (SSWSQLCondition field: self sourceField equalTo: SSWSQLQueryParameter).

	^SSWSQLDeleteQuery new
		table: self targetTable;
		conditions: (SSWSQLCondition field: self targetTable idField is: (SSWSQLOperator messageSelector: #includedIn:) to: subquery asSubQuery);
		yourself!

preserveCollectionEntries: aCollection

	"Private - If the collection stored mutatable directly-persisted objects then we must use a shallowCopy of these for change detection"

	self targetClass isMutableDirectlyPersistedNonBaseClass ifTrue: [aCollection do: [ :each | each target: each target shallowCopy]]!

readAllEntriesFor: ids

	| stream targetTable allEntries |

	stream := ReadStream on: ids.
	targetTable := self targetTable.
	allEntries := OrderedCollection new: ids size.

	[stream atEnd] whileFalse: 
		[self readAllStatement readValuesFrom: stream.
		self reStore rowsFromStatement: self readAllStatement do: 
			[ :row || entry |
			entry := allEntries add: (self createNonProxiedInstanceFromRow: row).
			entry target isDBProxy ifTrue: 
				["Untouched and possibly unrecovered proxy - use the row data appropriately"
				entry target _isRecovered
					ifTrue: [entry target _refreshFromRow: row table: targetTable]
					ifFalse: [targetTable recoverInstanceFromRow: row into: entry target]]]].

	^allEntries!

readAllFor: aCollection

	"Using a single query (ideally, multiple batched queries if aCollection is too large), read all unrecovered collections specified by the receiver for members of aCollection"

	| untouched ids collections |

	untouched := aCollection select: [ :each | (self accessor valueIn: each) isDBProxy].
	untouched isEmpty ifTrue: [^self].

	ids := untouched collect: [ :each | each _idIn: self reStore].
	collections := Dictionary new: untouched size.

	(self readAllEntriesFor: ids) do: [ :each | (collections at: each sourceID ifAbsentPut: [self newCollection]) _dbAdd: each].

	(aCollection reject: [ :each | (self accessor valueIn: each) _isRecovered]) do: 
		[ :proxy || entries |
		entries := collections at: proxy _id ifAbsent: [self newCollection].
		(self accessor valueIn: proxy) 
			_proxiedObject: (entries collect: [ :each | each target]);
			_collectionEntries: entries]!

readAllQuery

	| params |

	params := self newReadAllParameters.
	params atAllPut: SSWSQLQueryParameter.

	^self readQuery
		conditions: (SSWSQLCondition field: self sourceField is: (SSWSQLOperator messageSelector: #includedIn:) to: params);
		yourself!

readQuery

	| query |

	query := self refreshQuery.
	self targetClass isDirectlyPersisted ifFalse: [query addTable: self targetTable withAllFields joinedWithField: self targetField].

	^query!

recoverBaseClassCollectionForProxy: aCollectionProxy

	"Private - Recover a collection of base class (String, Date, Number...) objects.
	Return the recovered non-base class objects, i.e. none"

	| statement collection entries |

	statement := self readStatement.
	collection := self newCollection.
	entries := OrderedCollection new.

	statement values: (Array with: aCollectionProxy _ownerID).
	self reStore rowsFromStatement: statement do:
		[ :row |
		(self createNonProxiedInstanceFromRow: row)
			addTo: entries;
			addTargetTo: collection].
	
	aCollectionProxy
		_proxiedObject: collection;
		_collectionEntries: entries.

	^#()!

recoverCollectionForProxy: aCollectionProxy

	"Return the recovered member objects"

	^self targetClass isDirectlyPersisted
		ifTrue: [self recoverBaseClassCollectionForProxy: aCollectionProxy]
		ifFalse: [self recoverModelClassCollectionForProxy: aCollectionProxy]!

recoverModelClassCollectionForProxy: aCollectionProxy

	"Recover a collection of model class (non-base, specifying a table) instances.
	Return the recovered collection"

	| targetTable statement collection entries |

	targetTable := self targetTable.
	statement := self readStatement.
	collection := self newCollection.
	entries := OrderedCollection new.

	statement values: (Array with: aCollectionProxy _ownerID).
	self reStore rowsFromStatement: statement do:
		[ :row || entry |
		entry := self createNonProxiedInstanceFromRow: row.
		entry target isDBProxy ifTrue: 
			["Untouched and possibly unrecovered proxy - use the row data appropriately"
			entry target _isRecovered 
				ifTrue: [entry target _refreshFromRow: row table: targetTable]
				ifFalse: [targetTable recoverInstanceFromRow: row into: entry target]].
		entry
			addTo: entries;
			addTargetTo: collection].
	
	aCollectionProxy
		_proxiedObject: collection;
		_collectionEntries: entries.

	^collection!

refreshCollectionForProxy: aCollectionProxy

	"Refresh as opposed to read - just fetch the IDs.
	Return the refreshed contents (always none)"

	^self targetClass isDirectlyPersisted
		ifTrue: [self recoverBaseClassCollectionForProxy: aCollectionProxy]
		ifFalse: [self refreshModelClassCollectionForProxy: aCollectionProxy]!

refreshCollectionWithContentsIfUpdatedForProxy: aCollectionProxy

	"Refresh the receiver collection and its contents if they have been updated
	Return the refreshed contents, i.e. the collection itself"

	^self targetClass isDirectlyPersisted
		ifTrue: [self recoverBaseClassCollectionForProxy: aCollectionProxy]
		ifFalse: [self refreshModelClassCollectionWithContentsIfUpdatedForProxy: aCollectionProxy]!

refreshModelClassCollectionForProxy: aCollectionProxy

	"Refresh as opposed to read - just fetch the IDs.
	Return the refreshed objects, i.e. none"

	| statement collection entries |

	statement := self refreshStatement.
	collection := self newCollection.
	entries := OrderedCollection new.

	statement values: (Array with: aCollectionProxy _ownerID).
	self reStore rowsFromStatement: statement do:
		[ :row | 
		(self createNonProxiedInstanceFromRow: row)
			addTo: entries;
			addTargetTo: collection].
	
	aCollectionProxy
		_proxiedObject: collection;
		_collectionEntries: entries.

	^#()!

refreshModelClassCollectionWithContentsIfUpdatedForProxy: aCollectionProxy

	"Private - Refresh as opposed to read - just fetch the IDs"

	| collection entries versionField statement |

	"Without versioning we revert to a standard withContents refresh"
	self reStore supportsVersioning ifFalse: [^self refreshCollectionWithContentsForProxy: aCollectionProxy].

	collection := self newCollection.
	entries := OrderedCollection new.
	versionField := self targetTable versionControlField.

	statement := self refreshWithContentsIfUpdatedStatement.
	statement values: (Array with: aCollectionProxy _ownerID).

	self reStore rowsFromStatement: statement do:
		[ :row || entry |
		entry := self createNonProxiedInstanceFromRow: row.
		(entry target isDBProxy and: [entry target _isRecovered and: [entry target _version < (versionField lookupIn: row)]]) ifTrue:
			["Out-of-date target object - forget it"
			entry target _forgetProxiedObject].
		entry
			addTo: entries;
			addTargetTo: collection].
	
	aCollectionProxy
		_proxiedObject: collection;
		_collectionEntries: entries.

	^collection!

refreshQuery

	^(self selectQueryIn: self reStore)
		conditions: (SSWSQLCondition field: self sourceField equalTo: SSWSQLQueryParameter);
		yourself!

refreshWithContentsIfUpdatedQuery

	| query |

	query := self refreshQuery.
	query addTable: self targetTable withIDAndVersionFields joinedWithField: self targetField.

	^query!

selectQueryIn: anSSWReStore

	"Return a Query for recovering a collection represented by the receiver from anSSWReStore"
	
	^self queryClass new
		table: self collectionTable;	
		yourself!

setTargetClass: aClass

	"Double-despatch to the argument"
	
	aClass beTargetClassOf: self!

targetClass

	"targetClass stores the single Class of the objects stored in the collection modelled by the receiver.
	This must  be a persistent class"
	
	^targetClass!

targetClass: aClass

	"targetClass stores the single Class of the objects stored in the collection modelled by the receiver.
	This must  be a persistent class"
	
	targetClass := aClass!

targetTable 

	^self reStore tableForClass: self targetClass! !
!SSWDBStaticCollectionSpec categoriesForMethods!
createCollectionTable!initializing!public! !
createNonProxiedInstanceFromRow:!actions-internal!private! !
dbInstancesFor:!accessing!public! !
deleteEntriesQuery!accessing-queries!public! !
deleteEntriesStatement!accessing!public! !
deleteQuery!accessing-queries!public! !
deleteQueryWithJoin!accessing-queries!private! !
deleteQueryWithSubQuery!accessing-queries!private! !
preserveCollectionEntries:!actions-internal!private! !
readAllEntriesFor:!actions!private! !
readAllFor:!actions!public! !
readAllQuery!accessing-queries!public! !
readQuery!accessing-queries!public! !
recoverBaseClassCollectionForProxy:!actions-internal!private! !
recoverCollectionForProxy:!accessing!actions!public! !
recoverModelClassCollectionForProxy:!actions-internal!private! !
refreshCollectionForProxy:!accessing!actions!public! !
refreshCollectionWithContentsIfUpdatedForProxy:!accessing!actions!public! !
refreshModelClassCollectionForProxy:!actions-internal!private! !
refreshModelClassCollectionWithContentsIfUpdatedForProxy:!actions-internal!private! !
refreshQuery!accessing-queries!public! !
refreshWithContentsIfUpdatedQuery!accessing-queries!public! !
selectQueryIn:!accessing-queries!public! !
setTargetClass:!initializing!public! !
targetClass!accessing!public! !
targetClass:!accessing!public! !
targetTable!accessing!public! !
!

!SSWDBStaticCollectionSpec class methodsFor!

initialize

	NilCookie := Object new! !
!SSWDBStaticCollectionSpec class categoriesForMethods!
initialize!initializing!public! !
!


﻿"Filed out from Dolphin Smalltalk 7"!

SSWDBKeyedStaticCollectionSpec subclass: #SSWDBStaticDictionarySpec
	instanceVariableNames: 'keyClass isKeyDependent isKeyRelated keyTableForRead keyTableForRefresh deleteKeysStatement'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBStaticDictionarySpec guid: (GUID fromString: '{51e5267a-93ea-11d5-b1e0-444553540000}')!
SSWDBStaticDictionarySpec comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBStaticDictionarySpec categoriesForClass!Unclassified! !
!SSWDBStaticDictionarySpec methodsFor!

beKeyDependent

	isKeyDependent := true!

beKeyRelated

	isKeyRelated := true!

beKeyUnrelated

	isKeyRelated := false!

createCollectionTable

	"Intercept to set the Class of the key field in the collection table"
		
	super createCollectionTable.

	(self collectionTable fieldAccessing: #index) targetClass: self keyClass!

deleteKeysQuery

	^self sqlDialect supportsDeleteWithJoin
	ifTrue: 
		[self isValueDependent 
			ifTrue: [nil] "Will be handled by deleteStatement"
			ifFalse: [self deleteQueryWithJoin]]
	ifFalse: 
		[self deleteKeysQueryWithSubQuery]!

deleteKeysQueryWithSubQuery

	| subquery |

	subquery := SSWSQLSelectQuery new.
	subquery
		field: self indexField;
		table: self collectionTable;
		conditions: (SSWSQLCondition field: self sourceField equalTo: SSWSQLQueryParameter).

	^SSWSQLDeleteQuery new
		table: self keyTable;
		conditions: (SSWSQLCondition field: self keyTable idField is: (SSWSQLOperator messageSelector: #includedIn:) to: subquery asSubQuery);
		yourself!

deleteKeysStatement

	"Return a prepared statement for deleting the keys of this collection"

	^deleteKeysStatement ifNil: [self deleteKeysQuery ifNotNil: [ :query | deleteKeysStatement := self reStore prepareStatementForQuery: query]]!

deleteQueryWithJoin

	| query |

	query := super deleteQueryWithJoin.

	self isKeyDependent ifTrue: [query addTable: self keyTable withAllFields joinedWithField: self indexField].

	^query!

initialize

	super initialize.

	isKeyDependent := false.
	isKeyRelated := false!

isKeyDependent

	"Dictionary keys can optionally be dependent (see isValueDependent)"

	^isKeyDependent!

isKeyRelated

	"Dictionary keys can optionally be related (see isValueRelated)"

	^isKeyRelated!

keyClass

	"keyClass stores the Class of the objects that are the keys to this Dictionary.
	This should be a valid base class (String, Date etc.) or a persistent class"

	^keyClass!

keyClass: aBasicClass

	"keyClass stores the Class of the objects that are the keys to this Dictionary.
	This should be a valid base class (String, Date etc.) or a persistent class"

	keyClass := aBasicClass!

keyTable 

	^self reStore tableForClass: self keyClass!

keyTableForRead

	^keyTableForRead!

keyTableForRefresh

	^keyTableForRefresh!

readAllEntriesFor: ids

	| stream allEntries statement targetTable keyTable |

	stream := ReadStream on: ids.
	allEntries := OrderedCollection new: ids size.

	"Lazy initialization of readAllStatement may be needed before tables are valid"
	statement := self readAllStatement.
	self targetClass isPersistentBaseClass ifFalse: [targetTable := self targetTable].
	self keyClass isPersistentBaseClass ifFalse: [keyTable := self keyTableForRead].
		
	[stream atEnd] whileFalse: 
		[statement readValuesFrom: stream.
		self targetClass isPersistentBaseClass ifFalse: [targetTable := self targetTable].
		self keyClass isPersistentBaseClass ifFalse: [keyTable := self keyTableForRead].
		self reStore rowsFromStatement: self readAllStatement do: 
			[ :row || entry |
			entry := allEntries add: (self createNonProxiedInstanceFromRow: row).
			entry index isDBProxy ifTrue: 
				["Untouched and possibly unrecovered proxy - use the row data appropriately"
				entry index _isRecovered 
					ifTrue: [entry index _refreshFromRow: row table: keyTable]
					ifFalse: [keyTable recoverInstanceFromRow: row into: entry index]].
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

	(self readAllEntriesFor: ids) do: [ :each | (collections at: each sourceID ifAbsentPut: [OrderedCollection new]) add: each].

	(aCollection reject: [ :each | (self accessor valueIn: each) _isRecovered]) do: 
		[ :proxy || entries dict |
		entries := collections at: proxy _id ifAbsent: [OrderedCollection new].
		dict := self newCollection.
		entries do: [ :each | dict at: each index put: each target].
		(self accessor valueIn: proxy) 
			_proxiedObject: dict;
			_collectionEntries: entries]!

readQuery

	| query |

	query := super readQuery.
	self keyClass isPersistentBaseClass ifFalse: [keyTableForRead := (query addTable: self keyTable withAllFields joinedWithField: self indexField) last].

	^query!

recoverCollectionForProxy: aCollectionProxy

	"Recover a collection of instances; return the recovered collection.
	This implementation handles both base class and persistent class keys and values"

	| keyTable targetTable statement collection entries |

	statement := self readStatement.
	collection := self newCollection.
	entries := OrderedCollection new.
	self keyClass isPersistentBaseClass ifFalse: [keyTable := self keyTableForRead].
	self targetClass isPersistentBaseClass ifFalse: [targetTable := self targetTable].

	statement values: (Array with: aCollectionProxy _ownerID).
	self reStore rowsFromStatement: statement do:
		[ :row || entry |
		entry := self createNonProxiedInstanceFromRow: row.
		entry index isDBProxy ifTrue: 
			["Untouched and possibly unrecovered proxy - use the row data appropriately"
			entry index _isRecovered 
				ifTrue: [entry index _refreshFromRow: row table: keyTable]
				ifFalse: [keyTable recoverInstanceFromRow: row into: entry index]].
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

refreshCollectionWithContentsIfUpdatedForProxy: aCollectionProxy

	"Refresh the receiver collection and its contents if they have been updated
	Return the refreshed contents, i.e. the collection itself.
	This implementation handles both base class and persistent class keys and values"

	| collection entries keyVersionField valueVersionField statement |

	"Without versioning we revert to a standard withContents refresh"
	self reStore supportsVersioning ifFalse: [^self refreshCollectionWithContentsForProxy: aCollectionProxy].

	"No persistent class - just read"
	(self targetClass isPersistentBaseClass and: [self keyClass isPersistentBaseClass]) ifTrue: [^self recoverBaseClassCollectionForProxy: aCollectionProxy].

	"Key or Value is persistent class - refresh as opposed to read - just fetch the IDs"
	collection := self newCollection.
	entries := OrderedCollection new.

	statement := self refreshWithContentsIfUpdatedStatement.
	statement values: (Array with: aCollectionProxy _ownerID).

	self keyClass isPersistentBaseClass ifFalse: [keyVersionField := self keyTableForRefresh versionControlField].
	self targetClass isPersistentBaseClass ifFalse: [valueVersionField := self targetTable versionControlField].

	self reStore rowsFromStatement: statement do:
		[ :row || entry |
		entry := self createNonProxiedInstanceFromRow: row.
		(entry index isDBProxy and: [entry index _isRecovered and: [entry index _version < (row lookupField: keyVersionField)]]) ifTrue:
			["Out-of-date key object - forget it"
			entry index _forgetProxiedObject].
		(entry target isDBProxy and: [entry target _isRecovered and: [entry target _version < (row lookupField: valueVersionField)]]) ifTrue:
			["Out-of-date value object - forget it"
			entry target _forgetProxiedObject].
		entry
			addTo: entries;
			addTargetTo: collection].
	
	aCollectionProxy
		_proxiedObject: collection;
		_collectionEntries: entries.

	^collection!

refreshWithContentsIfUpdatedQuery

	| query |

	query := super refreshWithContentsIfUpdatedQuery.
	self keyClass isPersistentBaseClass ifFalse: [keyTableForRefresh := (query addTable: self keyTable withIDAndVersionFields joinedWithField: self indexField) last].

	^query!

setKeyClass: aClass

	"Double-despatch to the argument"
	
	aClass beKeyClassOf: self
! !
!SSWDBStaticDictionarySpec categoriesFor: #beKeyDependent!initializing!public! !
!SSWDBStaticDictionarySpec categoriesFor: #beKeyRelated!initializing!public! !
!SSWDBStaticDictionarySpec categoriesFor: #beKeyUnrelated!initializing!public! !
!SSWDBStaticDictionarySpec categoriesFor: #createCollectionTable!initializing!public! !
!SSWDBStaticDictionarySpec categoriesFor: #deleteKeysQuery!accessing-queries!private! !
!SSWDBStaticDictionarySpec categoriesFor: #deleteKeysQueryWithSubQuery!accessing-queries!private! !
!SSWDBStaticDictionarySpec categoriesFor: #deleteKeysStatement!accessing!public! !
!SSWDBStaticDictionarySpec categoriesFor: #deleteQueryWithJoin!accessing-queries!private! !
!SSWDBStaticDictionarySpec categoriesFor: #initialize!initialize/release!public! !
!SSWDBStaticDictionarySpec categoriesFor: #isKeyDependent!public!testing! !
!SSWDBStaticDictionarySpec categoriesFor: #isKeyRelated!public!testing! !
!SSWDBStaticDictionarySpec categoriesFor: #keyClass!accessing!public! !
!SSWDBStaticDictionarySpec categoriesFor: #keyClass:!accessing!public! !
!SSWDBStaticDictionarySpec categoriesFor: #keyTable!accessing!public! !
!SSWDBStaticDictionarySpec categoriesFor: #keyTableForRead!accessing!public! !
!SSWDBStaticDictionarySpec categoriesFor: #keyTableForRefresh!accessing!public! !
!SSWDBStaticDictionarySpec categoriesFor: #readAllEntriesFor:!actions-internal!private! !
!SSWDBStaticDictionarySpec categoriesFor: #readAllFor:!actions-internal!private! !
!SSWDBStaticDictionarySpec categoriesFor: #readQuery!accessing-queries!public! !
!SSWDBStaticDictionarySpec categoriesFor: #recoverCollectionForProxy:!actions-internal!private! !
!SSWDBStaticDictionarySpec categoriesFor: #refreshCollectionWithContentsIfUpdatedForProxy:!actions-internal!private! !
!SSWDBStaticDictionarySpec categoriesFor: #refreshWithContentsIfUpdatedQuery!accessing-queries!public! !
!SSWDBStaticDictionarySpec categoriesFor: #setKeyClass:!accessing!public! !


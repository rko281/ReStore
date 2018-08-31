"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SSWDBInstancesCollection
	instanceVariableNames: 'reStore instancesClass parser sortBlock preFetchComponents'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBInstancesCollection guid: (GUID fromString: '{5a3e3dd0-3990-11d5-b1df-444553540000}')!
SSWDBInstancesCollection comment: 'Copyright 2000/2001 Solutions Software Limited'!
!SSWDBInstancesCollection categoriesForClass!Unclassified! !
!SSWDBInstancesCollection methodsFor!

addAll: anSSWDBInstancesCollection

	"29/3/2001

	'Add' the given instances collection to the receiver so that its elements
	are added to the receiver's following a query"

	"Can only add same/inherited classes"
	(self instancesClass = anSSWDBInstancesCollection instancesClass or:
		[self instancesClass = 
			(self reStore tableForClass: anSSWDBInstancesCollection instancesClass) rootClass])
				ifFalse: [self error: 'Cannot add unrelated instances collections'].

	self parser orWith: anSSWDBInstancesCollection parser.

	"Behave like a collection and return the added object"
	^anSSWDBInstancesCollection!

allSatisfy: aBlock

	"Uses two queries"
	
	^self size = (self satisfying: aBlock) size!

anySatisfy: aBlock
	
	"Uses one query"

	^(self satisfying: aBlock) isEmpty not!

asOrderedCollection

	^self collectInto: (OrderedCollection new: 16)!

asSet

	^self collectInto: (Set new: 16)!

asSortedCollection

	"If a sort is already defined, use that, else use the standard sort block"

	^self isSorted
		ifTrue: [self collectInto: (SortedCollection sortBlock: self sortBlock)]
		ifFalse: [self asSortedCollection: SortedCollection]!

asSortedCollection: aTwoArgBlock

	^self copy
		sortBlock: aTwoArgBlock;
		asSortedCollection!

collect: collectBlock
	
	^self collect: collectBlock into: (OrderedCollection new: 16)!

collect: collectBlock into: aCollection

	"Private - Add the objects resulting from collectBlock to aCollection.
	Return aCollection"
	
	^self query: (self parser collectQueryFrom: collectBlock) into: aCollection!

collectAsSet: collectBlock

	"Evaluate each elemen with collectBlock, returning the result as a Set.
	This is more efficient than e.g.
		(self collect: [ :cd | cd artistName]) asSet 
	...where a high level of duplication is expected"
	
	#deprecated. "Use project:"
	^self project: collectBlock into: (Set new: 16)!

collectInto: aCollection

	"Private - Add the objects resulting from the receiver to aCollection.
	Return aCollection"
	
	^self collect: [ :object | object] into: aCollection!

copy

	"27/3/2001"
	
	^self shallowCopy
		parser: self parser copy;
		yourself
		!

createParser

	"Private - 23/3/2001"
	
	self parser: (SSWDBBlockParser newForReStore: self reStore argumentClass: self instancesClass)
!

detect: detectBlock

	^self detect: detectBlock ifNone: [self errorNotFound: detectBlock]!

detect: detectBlock ifNone: noneBlock

	| query |
	
	query := self parser selectQueryFrom: detectBlock.

	^self reStore fetchObjectOfClass: self instancesClass withQuery: query ifNone: noneBlock!

do: aBlock

	"Use the streamed #do: to avoid creating a (potentially large) temporary collection"
	
	| stream |

	stream := self readStream.

	[stream do: aBlock] ensure: [stream close]!

fetchObjectsWithQuery: aQuery into: aCollection

	self reStore fetchObjectsOfClass: self instancesClass withQuery: aQuery into: aCollection.
	
	self preFetchComponents do: [ :tableComponent| tableComponent readAllFor: aCollection].

	^aCollection!

first

	"9/4/2001"
	
	^self detect: [ :each | true] ifNone: [#() errorSubscriptBounds: 1]!

first: anInteger

	| stream collection |

	stream := self readStream.
	collection := OrderedCollection new: anInteger.

	anInteger timesRepeat: [collection add: stream next].

	^collection!

includes: anObject

	| id |

	id := (anObject _dbProxyIfNone: [^false]) _id.

	^(self detect: [ :each | each _id = id] ifNone: [nil]) == anObject!

instancesClass

	"23/3/2001
	
	instancesClass stores the Class of persistent object which form the receiver's 'elements'	"
	
	^instancesClass!

instancesClass: aClass

	"23/3/2001
	
	instancesClass stores the Class of persistent object which form the receiver's 'elements'	"
	
	instancesClass := aClass!

isEmpty

	"23/3/2001"
	
	^self size = 0!

isSorted

	^self sortBlock notNil!

last

	^self readStream last!

lookup: aBlock

	^self detect: aBlock ifNone: [nil]!

modify: aBlock

	"29/3/2001
	
	Iterate over the elements in the database, modifying each according to aBlock.
	e.g. say the receiver represents all CDs with no artist assigned, then:

		self modify: [ :cd | cd artist: 'Unknown']
		
	...would update all instances in the database.	This can be compared to do:, except that:	
	 - modify: does not bring all instances into memory (uses a single query)
	 - aBlock must be a reasonably simple inst var update
	 - the number of modified rows is returned as the result"
	
	| query rows |
	
	query := self parser modifyQueryFrom: aBlock.

	((self reStore objectProxyClassFor: self instancesClass) modifyUpdatesFor: self table) do: 
		[ :each || subQuery |
		self parser reset.
		subQuery := self parser modifyQueryFrom: each.
		query fieldUpdates: (query fieldUpdates, subQuery fieldUpdates)].

	self reStore evaluateInTxn: [rows := self reStore executeQuery: query. true].
	
	^rows!

parser

	"23/3/2001
	
	parser stores an SSWDBBlockParser which parses enumerating blocks
	to generate corresponding SSWSQLQueries"
	
	^parser!

parser: anSSWDBBlockParser

	"23/3/2001
	
	parser stores an SSWDBBlockParser which parses enumerating blocks
	to generate corresponding SSWSQLQueries"
	
	parser := anSSWDBBlockParser!

preFetchComponents

	"preFetchComponents stores a collection of components of the receiver's database table.
	The contents of these components are bulk pre-fetched when elements of the receiver are read from the database"

	^preFetchComponents ifNil: [#()]!

preFetchComponents: aCollection

	"preFetchComponents stores a collection of components of the receiver's database table.
	The contents of these components are bulk pre-fetched when elements of the receiver are read from the database"

	preFetchComponents := aCollection!

project: projectBlock
	
	^self project: projectBlock into: (OrderedCollection new: 16)!

project: projectBlock into: aCollection

	"Private - Add the objects resulting from projectBlock to aCollection.
	Return aCollection"

	^self query: (self parser projectQueryFrom: projectBlock) into: aCollection!

qualifyWith: aBlock

	"27/3/2001
	
	Modify the receiver's parser so that it always qualifies any query it creates
	with the conditions extracted from aBlock"
	
	self parser qualifyWith: aBlock
!

query: query into: aCollection

	"Private - Add the objects resulting from query to aCollection.
	Return aCollection"

	"If a field-based collect block e.g. [ :cd | cd title] then there will be only one query field.
	If a 'target object' collect block e.g. [ :cd | cd] then the query field will be 'all fields in table'		"
	query fields isAllInTable
	ifTrue:
		[self fetchObjectsWithQuery: query into: aCollection]
	ifFalse:
		[self reStore rowsFromQuery: query do: 
			[ :row |
			query fields size = 1
			ifTrue:
				[aCollection add: (query fields first convertValue: (row atIndex: 1))]
			ifFalse:
				[| values |
				values := aCollection add: (Array new: query fields size).
				query fields keysAndValuesDo:
					[ :index :field || dbValue |
					dbValue := row atIndex: index.
					values at: index put: (field convertValue: dbValue)]]]].
		
	^self parser isCollectingAssociations
		ifTrue: [aCollection collect: [ :pair | pair first -> pair last]]
		ifFalse: [aCollection]!

readStream

	"28/3/2001
	
	Create and return an appropraite ReadStream-like object on the receiver"
	
	^SSWDBReadStream on: self!

reject: rejectBlock
	
	| query results |
	
	query := self parser rejectQueryFrom: rejectBlock.
	
	results := OrderedCollection new.
		
	self fetchObjectsWithQuery: query into: results.
	
	^results!

reStore

	"23/3/2001
	
	reStore stores the SSWReStore in which the receiver's 'elements' reside"
	
	^reStore!

reStore: anSSWReStore

	"23/3/2001
	
	reStore stores the SSWReStore in which the receiver's 'elements' reside"
	
	reStore := anSSWReStore!

resultSet

	"28/3/2001
	
	Return a DBResultSet (open query results) onto the collection of rows
	represented by the receiver"
	
	| query |
	
	query := self parser collectQueryFrom: [ :elem | elem].
	
	"Always use #keysetDriven to give a flexible, efficient result set"
	^self reStore executeQuery: query cursorType: #keysetDriven!

satisfying: aOneArgBlock

	"Return a copy of the receiver, but with its members qualified by aOneArgBlock,
	in addition to the receiver's existing qualifiers (if any).
	
	This is similar to a select:, but returns another SSWDBInstancesCollection,
	rather than a real collection of real instances.	Useful as an enumerating 'step' e.g.
		(anInstancesCollection select: [ :cd | cd label name = '4AD']) collect: [ :cd | cd title]
		(anInstancesCollection satisfying: [ :cd | cd label name = '4AD']) collect: [ :cd | cd title]
	Both would get the title of all CDs released by 4AD, but the second would do this
	without having to fault in all CD instances from the database"
	
	^self copy
		qualifyWith: aOneArgBlock;
		yourself!

select: selectBlock
	
	| query results |
	
	query := self parser selectQueryFrom: selectBlock.
	
	results := OrderedCollection new.
			
	self fetchObjectsWithQuery: query into: results.
	
	^results!

select: selectBlock thenCollect: collectBlock

	"This method is compatible with Collection>>select:thenCollect: but uses satisfying: to avoid faulting in all instances of the receiver's instanceClass"
	
	^(self satisfying: selectBlock) collect: collectBlock!

size

	"Evaluate the 'size' (number of persistent instances) of the receiver via a COUNT query"
	
	| query size |

	query := self parser projectQueryFrom: [ :object | object count].

	"Ordering unnecessary for simple count query"
	query hasOrdering ifTrue: [query forgetOrdering].
			
	self reStore rowsFromQuery: query do: [ :row | size := row atIndex: 1].
	
	^size!

sortBlock

	"Order the receiver's elements by aTwoArgBlock - a 'simple' sort block:
	 - only >, >=, <, <= comparisons (= is redundant and ignored for SQL translation)
	 - only & and | conjunctions
	 - comparisons on same field only

	e.g. 	[ :p1 :p2 | 
		(p1 surname < p2 surname) |  ((p1 surname = p2 surname) & (p1 forename < p2 forename))]"

	^sortBlock!

sortBlock: aTwoArgBlock

	"Order the receiver's elements by aTwoArgBlock - a 'simple' sort block:
	 - only >, >=, <, <= comparisons (= is redundant and ignored for SQL translation)
	 - only & and | conjunctions
	 - comparisons on same field only

	e.g. 	[ :p1 :p2 | 
		(p1 surname < p2 surname) |  ((p1 surname = p2 surname) & (p1 forename < p2 forename))]"

	sortBlock := aTwoArgBlock.

	aTwoArgBlock isNil
		ifTrue: [self parser beUnsorted]
		ifFalse: [self parser sortBlock: aTwoArgBlock]!

table

	"28/3/2001
	
	Return the table associated with the receiver's instancesClass"
	
	"The Parser knows this"
	^self parser argumentTable!

unstore: aBlock

	"Unstore elements of the receiver satisfying aBlock from the database
	Return the number of rows deleted"

	| rows |

	self reStore evaluateInTxn: 
		[rows := self reStore executeQuery: (self parser deleteQueryFrom: aBlock).
		true].

	^rows!

unstoreAll

	"Unstore all elements of the receiver from the database"

	^self unstore: [ :each | true]!

withComponent: aSymbol

	"Arrange for the content of the inst var named aSymbol to be bulk pre-fetched when elements of the receiver are read from the database"

	self withComponents: (Array with: aSymbol)!

withComponents: aCollectionOfInstVarNames

	"Arrange for the contents of aCollectionOfInstVarNames (representing components of the receiver) to be bulk pre-fetched when elements of the receiver are read from the database"

	self preFetchComponents: (aCollectionOfInstVarNames collect: [ :instVarName| self table componentAccessing: instVarName])!

withDependentComponents

	"Arrange for dependent contents to be bulk pre-fetched when elements of the receiver are read from the database"

	self preFetchComponents: self table dependentComponents!

withoutInheritance

	"18/4/2001
	
	If the receiver's instancesClass has persistent subclasses, then by default
	instances of those subclasses are included in the receiver 'collection'.
	
	Prevent this behaviour by restricting to only elements of the instancesClass"
	
	^self satisfying: [ :each | each class = self instancesClass]!

withRelatedComponents

	"Arrange for related contents to be bulk pre-fetched when elements of the receiver are read from the database"

	self preFetchComponents: self table relatedComponents! !
!SSWDBInstancesCollection categoriesFor: #addAll:!actions!public! !
!SSWDBInstancesCollection categoriesFor: #allSatisfy:!enumerating!public! !
!SSWDBInstancesCollection categoriesFor: #anySatisfy:!enumerating!public! !
!SSWDBInstancesCollection categoriesFor: #asOrderedCollection!converting!public! !
!SSWDBInstancesCollection categoriesFor: #asSet!converting!public! !
!SSWDBInstancesCollection categoriesFor: #asSortedCollection!converting!public! !
!SSWDBInstancesCollection categoriesFor: #asSortedCollection:!converting!public! !
!SSWDBInstancesCollection categoriesFor: #collect:!enumerating!public! !
!SSWDBInstancesCollection categoriesFor: #collect:into:!helpers!private! !
!SSWDBInstancesCollection categoriesFor: #collectAsSet:!enumerating!public! !
!SSWDBInstancesCollection categoriesFor: #collectInto:!helpers!private! !
!SSWDBInstancesCollection categoriesFor: #copy!copying!public! !
!SSWDBInstancesCollection categoriesFor: #createParser!initializing!private! !
!SSWDBInstancesCollection categoriesFor: #detect:!enumerating!public! !
!SSWDBInstancesCollection categoriesFor: #detect:ifNone:!enumerating!public! !
!SSWDBInstancesCollection categoriesFor: #do:!enumerating!public! !
!SSWDBInstancesCollection categoriesFor: #fetchObjectsWithQuery:into:!helpers!private! !
!SSWDBInstancesCollection categoriesFor: #first!evaluating!public! !
!SSWDBInstancesCollection categoriesFor: #first:!evaluating!public! !
!SSWDBInstancesCollection categoriesFor: #includes:!public!testing! !
!SSWDBInstancesCollection categoriesFor: #instancesClass!accessing!public! !
!SSWDBInstancesCollection categoriesFor: #instancesClass:!accessing!public! !
!SSWDBInstancesCollection categoriesFor: #isEmpty!public!testing! !
!SSWDBInstancesCollection categoriesFor: #isSorted!public!testing! !
!SSWDBInstancesCollection categoriesFor: #last!evaluating!public! !
!SSWDBInstancesCollection categoriesFor: #lookup:!enumerating!public! !
!SSWDBInstancesCollection categoriesFor: #modify:!enumerating!public! !
!SSWDBInstancesCollection categoriesFor: #parser!accessing!public! !
!SSWDBInstancesCollection categoriesFor: #parser:!accessing!public! !
!SSWDBInstancesCollection categoriesFor: #preFetchComponents!accessing!public! !
!SSWDBInstancesCollection categoriesFor: #preFetchComponents:!accessing!public! !
!SSWDBInstancesCollection categoriesFor: #project:!enumerating!public! !
!SSWDBInstancesCollection categoriesFor: #project:into:!helpers!private! !
!SSWDBInstancesCollection categoriesFor: #qualifyWith:!initializing!public! !
!SSWDBInstancesCollection categoriesFor: #query:into:!helpers!private! !
!SSWDBInstancesCollection categoriesFor: #readStream!evaluating!public! !
!SSWDBInstancesCollection categoriesFor: #reject:!enumerating!public! !
!SSWDBInstancesCollection categoriesFor: #reStore!accessing!public! !
!SSWDBInstancesCollection categoriesFor: #reStore:!accessing!public! !
!SSWDBInstancesCollection categoriesFor: #resultSet!evaluating!public! !
!SSWDBInstancesCollection categoriesFor: #satisfying:!enumerating!public! !
!SSWDBInstancesCollection categoriesFor: #select:!enumerating!public! !
!SSWDBInstancesCollection categoriesFor: #select:thenCollect:!enumerating!public! !
!SSWDBInstancesCollection categoriesFor: #size!evaluating!public! !
!SSWDBInstancesCollection categoriesFor: #sortBlock!accessing!public! !
!SSWDBInstancesCollection categoriesFor: #sortBlock:!accessing!public! !
!SSWDBInstancesCollection categoriesFor: #table!evaluating!public! !
!SSWDBInstancesCollection categoriesFor: #unstore:!actions!public! !
!SSWDBInstancesCollection categoriesFor: #unstoreAll!actions!public! !
!SSWDBInstancesCollection categoriesFor: #withComponent:!initializing!public! !
!SSWDBInstancesCollection categoriesFor: #withComponents:!initializing!public! !
!SSWDBInstancesCollection categoriesFor: #withDependentComponents!initializing!public! !
!SSWDBInstancesCollection categoriesFor: #withoutInheritance!evaluating!public! !
!SSWDBInstancesCollection categoriesFor: #withRelatedComponents!initializing!public! !

!SSWDBInstancesCollection class methodsFor!

forClass: aClass in: anSSWReStore

	"23/3/2001"
	
	^self new
		instancesClass: aClass;
		reStore: anSSWReStore;
		createParser;
		yourself! !
!SSWDBInstancesCollection class categoriesFor: #forClass:in:!instance creation!public! !


"Filed out from Dolphin Smalltalk"!

Object subclass: #SSWDBInstancesCollection
	instanceVariableNames: 'reStore instancesClass parser sortBlock preReadActions postReadActions'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWDBInstancesCollection guid: (GUID fromString: '{5a3e3dd0-3990-11d5-b1df-444553540000}')!

SSWDBInstancesCollection comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!

!SSWDBInstancesCollection categoriesForClass!Unclassified! !

!SSWDBInstancesCollection methodsFor!

addAll: anSSWDBInstancesCollection

	"'Add' the given instances collection to the receiver so that its elements
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

anyOne

	^self first!

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
		ifFalse: [self asSortedCollection: SortedCollection defaultSortBlock]!

asSortedCollection: aTwoArgBlock

	^self copy
		sortBlock: aTwoArgBlock;
		asSortedCollection!

beOrdered

	"Order the receiver based on the ID field.
	This will normally tally with insertion order where instances have the default numeric ID"

	self sortBlock: [ :a :b | a _id < b _id]!

beSorted

	"Order the receiver based on the default sort for the instanceClass"

	self sortBlock: SortedCollection defaultSortBlock!

collect: collectBlock
	
	^self collect: collectBlock into: (OrderedCollection new: 16)!

collect: collectBlock into: aCollection

	"Private - Add the objects resulting from collectBlock to aCollection.
	Return aCollection"
	
	^self query: (self parser collectQueryFrom: collectBlock) into: aCollection!

collectInto: aCollection

	"Private - Add the objects resulting from the receiver to aCollection.
	Return aCollection"
	
	^self collect: [ :object | object] into: aCollection!

createParser

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

fetchObjectsFromTable: aDBTable withQuery: aQuery into: aCollection

	self preReadActions do: [ :each | each value].

	self reStore fetchObjectsFromTable: aDBTable withQuery: aQuery into: aCollection.
	
	self postReadActions do: [ :each | each value: aCollection].

	^aCollection!

fetchObjectsWithQuery: aQuery into: aCollection

	^self fetchObjectsFromTable: self table withQuery: aQuery into: aCollection!

first

	^self detect: [ :each | true] ifNone: [#() errorSubscriptBounds: 1]!

first: anInteger

	^self readStream next: anInteger!

include: aSymbol

	"Arrange for the content of the inst var named aSymbol to be bulk fetched when elements of the receiver are read from the database"

	self includeAll: (Array with: aSymbol)!

includeAll: aCollectionOfInstVarNames

	"Arrange for the contents of aCollectionOfInstVarNames (representing components of the receiver) to be bulk fetched when elements of the receiver are read from the database"

	self includeTableComponents: (aCollectionOfInstVarNames collect: [ :instVarName | self table componentAccessing: instVarName])!

includeDependentComponents

	"Arrange for dependent contents to be bulk pre-fetched when elements of the receiver are read from the database"

	self includeTableComponents: self table dependentComponents!

includeRelatedComponents

	"Arrange for related contents to be bulk pre-fetched when elements of the receiver are read from the database"

	self includeTableComponents: self table relatedComponents!

includes: anObject

	| id |

	id := (anObject _dbProxyIfNone: [^false]) _id.

	^(self detect: [ :each | each _id = id] ifNone: [nil]) == anObject!

includeTableComponents: aCollectionOfTableComponents

	"Private - Arrange for the contents of aCollectionOfTableComponents to be bulk fetched when elements of the receiver are read from the database"

	aCollectionOfTableComponents do: 
		[ :component | 
		self postReadActions add: [ :elements | component readAllFor: elements]]!

instancesClass

	"instancesClass stores the Class of persistent object which form the receiver's 'elements'	"
	
	^instancesClass!

instancesClass: aClass

	"instancesClass stores the Class of persistent object which form the receiver's 'elements'	"
	
	instancesClass := aClass!

isEmpty

	^self size = 0!

isSorted

	^self sortBlock notNil!

last

	^self reverse first!

last: anInteger

	^(self reverse first: anInteger) reverse!

lookup: aBlock

	^self detect: aBlock ifNone: [nil]!

modify: aBlock

	"Iterate over the elements in the database, modifying each according to aBlock.
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

	"parser stores an SSWDBBlockParser which parses enumerating blocks
	to generate corresponding SSWSQLQueries"
	
	^parser!

parser: anSSWDBBlockParser

	"parser stores an SSWDBBlockParser which parses enumerating blocks
	to generate corresponding SSWSQLQueries"
	
	parser := anSSWDBBlockParser!

postCopy

	self parser: self parser copy!

postReadActions

	"postReadActions stores an OrderedCollection of actions (1-arg Blocks or MessageSends) which are evaluated with a collection of the receiver's elements after they are read from the database"

	^postReadActions!

postReadActions: anOrderedCollection

	"postReadActions stores an OrderedCollection of actions (1-arg Blocks or MessageSends) which are evaluated with a collection of the receiver's elements after they are read from the database"

	postReadActions := anOrderedCollection!

preReadActions

	"preReadActions stores an OrderedCollection of actions (zero-arg Blocks or MessageSends) which are evaluated before the receiver's elements are read from the database"

	^preReadActions!

preReadActions: anOrderedCollection

	"preReadActions stores an OrderedCollection of actions (zero-arg Blocks or MessageSends) which are evaluated before the receiver's elements are read from the database"

	preReadActions := anOrderedCollection!

project: projectBlock
	
	^self project: projectBlock into: (OrderedCollection new: 16)!

project: projectBlock into: aCollection

	"Private - Add the objects resulting from projectBlock to aCollection.
	Return aCollection"

	^self query: (self parser projectQueryFrom: projectBlock) into: aCollection!

qualifyWith: aBlock

	"Modify the receiver's parser so that it always qualifies any query it creates
	with the conditions extracted from aBlock"
	
	self parser qualifyWith: aBlock
!

query: query into: aCollection

	"Private - Add the objects resulting from query to aCollection.
	Return aCollection"

	"If a single object field collect block e.g. [ :person | person friend] then the query field will be 'all fields in table'	"
	query fields isAllInTable ifTrue: [^self fetchObjectsFromTable: query fields table withQuery: query into: aCollection].

	self reStore rowsFromQuery: query do: 
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
				values at: index put: (field convertValue: dbValue)]]].
		
	^self parser isCollectingAssociations
		ifTrue: [aCollection collect: [ :pair | pair first -> pair last]]
		ifFalse: [aCollection]!

readStream

	"Create and return an appropraite ReadStream-like object on the receiver"

	^self readStream: self reStore sqlDialect defaultCursorType!

readStream: aSymbol

	"Create and return an appropraite ReadStream-like object on the receiver.
	aSymbol describes the cursor type for the result set"

	^(self resultSet: aSymbol) readStream
		setInstancesCollection: self;
		yourself!

refreshed

	"Arrange for a softRollback to take place immediately before reading the receiver's elements from the database.
	This will ensure any objects already in the image are refreshed with the newly-fetched rows"

	self preReadActions add: [self reStore softRollback]!

reject: rejectBlock
	
	| query results |
	
	query := self parser rejectQueryFrom: rejectBlock.
	
	results := OrderedCollection new.
		
	self fetchObjectsWithQuery: query into: results.
	
	^results!

reStore

	"reStore stores the SSWReStore in which the receiver's 'elements' reside"
	
	^reStore!

reStore: anSSWReStore

	"reStore stores the SSWReStore in which the receiver's 'elements' reside"
	
	reStore := anSSWReStore!

resultSet: aSymbol

	"Private - Return a DBResultSet (open query results) onto the collection of rows represented by the receiver.
	aSymbol describes the cursor type for the result set"
	
	| query |

	query := self parser collectQueryFrom: [ :elem | elem].

	^self reStore executeQuery: query cursorType: aSymbol!

reverse

	"Return a copy of the receiver with reversed ordering"

	| reversed |

	reversed := self copy.

	"If no explicit ordering apply ID ordering - this at least gives us something to reverse"
	reversed isSorted ifFalse: [reversed beOrdered].
	
	reversed parser invertOrdering.

	^reversed!

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

	"Return the table associated with the receiver's instancesClass"
	
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

withoutInheritance

	"If the receiver's instancesClass has persistent subclasses, then by default
	instances of those subclasses are included in the receiver 'collection'.
	
	Prevent this behaviour by restricting to only elements of the instancesClass"
	
	^self satisfying: [ :each | each class = self instancesClass]! !

!SSWDBInstancesCollection categoriesForMethods!
addAll:!actions!public! !
allSatisfy:!enumerating!public! !
anyOne!evaluating!public! !
anySatisfy:!enumerating!public! !
asOrderedCollection!converting!public! !
asSet!converting!public! !
asSortedCollection!converting!public! !
asSortedCollection:!converting!public! !
beOrdered!initializing!public! !
beSorted!initializing!public! !
collect:!enumerating!public! !
collect:into:!helpers!private! !
collectInto:!helpers!private! !
createParser!initializing!private! !
detect:!enumerating!public! !
detect:ifNone:!enumerating!public! !
do:!enumerating!public! !
fetchObjectsFromTable:withQuery:into:!helpers!private! !
fetchObjectsWithQuery:into:!helpers!private! !
first!evaluating!public! !
first:!evaluating!public! !
include:!initializing!public! !
includeAll:!initializing!public! !
includeDependentComponents!initializing!public! !
includeRelatedComponents!initializing!public! !
includes:!public!testing! !
includeTableComponents:!initializing!private! !
instancesClass!accessing!public! !
instancesClass:!accessing!public! !
isEmpty!public!testing! !
isSorted!public!testing! !
last!evaluating!public! !
last:!evaluating!public! !
lookup:!enumerating!public! !
modify:!enumerating!public! !
parser!accessing!public! !
parser:!accessing!public! !
postCopy!copying!public! !
postReadActions!accessing!public! !
postReadActions:!accessing!public! !
preReadActions!accessing!public! !
preReadActions:!accessing!public! !
project:!enumerating!public! !
project:into:!helpers!private! !
qualifyWith:!initializing!private! !
query:into:!helpers!private! !
readStream!evaluating!public! !
readStream:!evaluating!public! !
refreshed!initializing!public! !
reject:!enumerating!public! !
reStore!accessing!public! !
reStore:!accessing!public! !
resultSet:!evaluating!private! !
reverse!evaluating!public! !
satisfying:!enumerating!public! !
select:!enumerating!public! !
select:thenCollect:!enumerating!public! !
size!evaluating!public! !
sortBlock!accessing!public! !
sortBlock:!accessing!public! !
table!evaluating!public! !
unstore:!actions!public! !
unstoreAll!actions!public! !
withoutInheritance!evaluating!public! !
!

!SSWDBInstancesCollection class methodsFor!

forClass: aClass in: anSSWReStore

	^self new
		instancesClass: aClass;
		reStore: anSSWReStore;
		createParser;
		yourself!

new

	^super new
		preReadActions: OrderedCollection new;
		postReadActions: OrderedCollection new;
		yourself! !

!SSWDBInstancesCollection class categoriesForMethods!
forClass:in:!instance creation!public! !
new!instance creation!public! !
!


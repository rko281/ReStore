﻿"Filed out from Dolphin Smalltalk"!

SSWDBCollectionSpec subclass: #SSWDBOwnedCollectionSpec
	instanceVariableNames: 'targetClass ownerField ownerAccessor orderingSpecs'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBOwnedCollectionSpec guid: (GUID fromString: '{fb82fd82-49e2-11d5-b1df-0010a70883e2}')!
SSWDBOwnedCollectionSpec comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBOwnedCollectionSpec categoriesForClass!Unclassified! !
!SSWDBOwnedCollectionSpec methodsFor!

allElementsIn: aCollection

	^aCollection!

copyCollection: aCollection

	^aCollection copy!

dbInstancesFor: aCollectionProxy

	"Return a DBInstancesCollection representing the instances owned by aCollectionProxy
	and specified by the receiver"

	| instances |

	self ownerField == nil ifTrue: [self setOwnerFieldFrom: aCollectionProxy _reStore].

	instances := aCollectionProxy _reStore instancesOf: self targetClass.

	instances parser qualifyingConditions: (instances parser qualifyingConditions sqlAnd:
		(SSWSQLCondition field: self ownerField equalTo: aCollectionProxy _ownerID)).

	^instances
		!

deleteQuery

	self ownerField == nil ifTrue: [self setOwnerFieldFrom: self reStore].

	^SSWSQLDeleteQuery new
		table: self targetTable;
		conditions: (SSWSQLCondition field: self ownerField equalTo: SSWSQLQueryParameter);
		yourself!

elementsIn: aCollection notIn: anotherCollection

	^aCollection reject: [ :each | anotherCollection identityIncludes: each]!

hasCollection: updatedCollection anyAdditionsOrRemovalsFrom: originalCollection

	^updatedCollection size ~= originalCollection size or: [updatedCollection anySatisfy: [ :each | (originalCollection identityIncludes: each) not]]!

orderingSpecs

	orderingSpecs isNil ifTrue: [self setOrderingSpecs].

	^orderingSpecs!

orderingSpecs: anOrderedCollection

	orderingSpecs := anOrderedCollection!

owner: aSymbol

	self ownerAccessor: (SSWInstVarAccessor toAccess: aSymbol in: self targetClass)!

ownerAccessor

	"ownerAccessor stores an Accessor configured to access instance variable 
	of the targetClass that holds the reference to the owner object"
	
	^ownerAccessor!

ownerAccessor: anInstVarAccessor

	"ownerAccessor stores an Accessor configured to access instance variable 
	of the targetClass that holds the reference to the owner object"
	
	ownerAccessor := anInstVarAccessor!

ownerClass

	"Return the class of object that owns the collection specified by the receiver"
	
	^self table instanceClass!

ownerField

	"ownerField stores the SSWDBField from the dbTable of the targetClass
	which refers to the the 'owner' object to which the many objects belong.
	
	This is initialized the first time it is required by setOwnerFieldFrom:"
	
	^ownerField!

ownerField: anSSWDBField

	"ownerField stores the SSWDBField from the dbTable of the targetClass
	which refers to the the 'owner' object to which the many objects belong.
	
	This is initialized the first time it is required by setOwnerFieldFrom:"
	
	ownerField := anSSWDBField!

queryClass

	"Return the correct query class to use for the receiver"
	
	^self templateCollection isOrdered
		ifTrue: [SSWSQLOrderedSelectQuery]
		ifFalse: [SSWSQLSelectQuery]!

readAllFor: aCollection

	"Using a single query (ideally, multiple batched queries if aCollection is too large), read all untouched collections specified by the receiver for members of aCollection"

	| untouched ids stream allResults collections|

	untouched := aCollection select: [ :each | (self accessor valueIn: each) isDBProxy].
	untouched isEmpty ifTrue: [^self].

	ids := untouched collect: [ :each | each _idIn: self reStore].
	stream := ReadStream on: ids.

	allResults := OrderedCollection new: untouched size.
	[stream atEnd] whileFalse: 
		[self readAllStatement readValuesFrom: stream.
		self reStore fetchObjectsOfClass: self targetClass withStatement: self readAllStatement into: allResults].

	collections := Dictionary new: untouched size.
	allResults do: [ :each | (collections at: (self ownerAccessor valueIn: each) _id ifAbsentPut: [self newCollection]) _dbAdd: each].

	(aCollection reject: [ :each | (self accessor valueIn: each) _isRecovered]) do: 
		[ :proxy | 
		(collections at: proxy _id ifAbsent: [self newCollection]) _proxifyIn: (self accessor valueIn: proxy)]!

readAllQuery

	| params |

	params := self newReadAllParameters.
	params atAllPut: SSWSQLQueryParameter.

	^self readQuery
		conditions: (SSWSQLCondition field: self ownerField is: (SSWSQLOperator messageSelector: #includedIn:) to: params);
		yourself!

readQuery

	^self selectQueryIn: self reStore!

recoverCollectionForProxy: aCollectionProxy

	"Return the recovered member objects"

	| statement collection |

	collection := self newCollection.
	statement := self readStatement.
	statement values: (Array with: aCollectionProxy _ownerID).
	self reStore fetchObjectsOfClass: self targetClass withStatement: statement into: collection.
	
	^collection _proxifyIn: aCollectionProxy!

refreshCollectionForProxy: aCollectionProxy

	"Refresh as opposed to read - just fetch the IDs. 
	Return the refreshed contents, i.e. none"

	| reStore statement collection idField |

	reStore := self reStore.
	self ownerField isNil ifTrue: [self setOwnerFieldFrom: reStore].
	idField := (reStore tableForClass: self targetClass) idField.

	collection := self newCollection.
	statement := self refreshStatement.
	statement values: (Array with: aCollectionProxy _ownerID).
	reStore rowsFromStatement: statement do:
		[ :row |
		collection _dbAdd: (reStore deferredObjectOfClass: self targetClass withID: (idField lookupIn: row))].
	
	collection _proxifyIn: aCollectionProxy.

	"Since we haven't refreshed any contents return an empty collection"
	^#()!

refreshCollectionWithContentsIfUpdatedForProxy: aCollectionProxy

	"Refresh the receiver collection and its contents if they have been updated
	Return the refreshed contents, i.e. the collection itself"

	| reStore versionField statement collection idField |

	reStore := self reStore.

	"Without versioning we revert to a standard withContents refresh"
	reStore supportsVersioning ifFalse: [^self refreshCollectionWithContentsForProxy: aCollectionProxy].

	idField := (reStore tableForClass: self targetClass) idField.
	versionField := self targetTable versionControlField.
	collection := self newCollection.

	statement := self refreshWithContentsIfUpdatedStatement. 
	statement values: (Array with: aCollectionProxy _ownerID).
	reStore rowsFromStatement: statement do: [ :row | collection _dbAdd: (reStore deferredObjectOfClass: self targetClass withID: (idField lookupIn: row) version: (versionField lookupIn: row))].

	^collection _proxifyIn: aCollectionProxy!

refreshQuery

	^self readQuery
		fields: (SSWSQLFieldCollection with: self targetTable idField);
		yourself!

refreshWithContentsIfUpdatedQuery

	| query |

	query := self refreshQuery.
	query fields add: self targetTable versionControlField.
	^query
!

selectQueryIn: anSSWReStore

	"Private - Patched for issue 120-007"

	| targetTable query |

	self ownerField == nil ifTrue: [self setOwnerFieldFrom: anSSWReStore].
	targetTable := self targetTable.

	query := self queryClass new.

	query
		table: targetTable;
		conditions: (SSWSQLCondition field: self ownerField equalTo: SSWSQLQueryParameter).

	self orderingSpecs do: 
		[ :spec || field |
		spec criteria isSymbol
			ifTrue: [field := targetTable fieldAccessing: spec criteria]
			ifFalse: [field := spec criteria].
		spec isAscending
			ifTrue: [query orderAscendingBy: field]
			ifFalse: [query orderDescendingBy: field]].

	^query!

setOrderingSpecs

	^self templateCollection isOrdered
		ifTrue: [self orderingSpecs: (Array with: (SSWDBOrderingSpec ascending: self targetTable idField))]
		ifFalse: [self orderingSpecs: #()]!

setOwnerFieldFrom: anSSWReStore

	| targetTable |
	
	targetTable := anSSWReStore tableForClass: self targetClass.
	
	self ownerField: (targetTable dataFields detect: [ :field | field accessor = self ownerAccessor])!

setTargetClass: aClass

	"Double-despatch to the argument"
	
	aClass beTargetClassOf: self!

targetClass

	"targetClass stores the Class of object held in the collection specified by the receiver.
	Instances of this class must hold a reference to their owner object"
	
	^targetClass!

targetClass: aClass

	"targetClass stores the Class of object held in the collection specified by the receiver.
	Instances of this class must hold a reference to their owner object"
	
	targetClass := aClass!

targetTable 

	^self reStore tableForClass: self targetClass! !
!SSWDBOwnedCollectionSpec categoriesForMethods!
allElementsIn:!accessing!private! !
copyCollection:!actions!public! !
dbInstancesFor:!accessing!public! !
deleteQuery!accessing-queries!public! !
elementsIn:notIn:!accessing!private! !
hasCollection:anyAdditionsOrRemovalsFrom:!private!testing! !
orderingSpecs!accessing!public! !
orderingSpecs:!accessing!public! !
owner:!accessing!public! !
ownerAccessor!accessing!public! !
ownerAccessor:!accessing!public! !
ownerClass!accessing!public! !
ownerField!accessing!public! !
ownerField:!accessing!public! !
queryClass!accessing!public! !
readAllFor:!actions!public! !
readAllQuery!accessing-queries!public! !
readQuery!accessing-queries!public! !
recoverCollectionForProxy:!actions!public! !
refreshCollectionForProxy:!actions!public! !
refreshCollectionWithContentsIfUpdatedForProxy:!actions!public! !
refreshQuery!accessing-queries!public! !
refreshWithContentsIfUpdatedQuery!accessing-queries!public! !
selectQueryIn:!accessing-queries!private! !
setOrderingSpecs!initializing!public! !
setOwnerFieldFrom:!initializing!public! !
setTargetClass:!initializing!public! !
targetClass!accessing!public! !
targetClass:!accessing!public! !
targetTable!accessing!public! !
!


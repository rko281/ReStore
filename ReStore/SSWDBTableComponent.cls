﻿"Filed out from Dolphin Smalltalk"!

SSWSQLTableComponent subclass: #SSWDBTableComponent
	instanceVariableNames: 'accessor readAllStatement'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBTableComponent guid: (GUID fromString: '{266e4dd0-398e-11d5-b1df-444553540000}')!
SSWDBTableComponent comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBTableComponent categoriesForClass!Unclassified! !
!SSWDBTableComponent methodsFor!

aboutToBeUnstored: anSSWDBProxy

	"anSSWDBProxy (which originated in the receiver's table) is about to be removed from the DB.
	Carry out any necessary actions"

	"Default - no action"
	^self!

accesses: aSymbol

	^self accessor accesses: aSymbol!

accessor

	"accessor stores an 'Accessor' object which is used to get and set the value
	represented by this component in its eventual Smalltalk object.
	The accessor does this via #valueIn: and value:in: - typically it is an SSWInstVarAccessor"
	
	^accessor!

accessor: anAccessor

	"accessor stores an 'Accessor' object which is used to get and set the value
	represented by this component in its eventual Smalltalk object.
	The accessor does this via #valueIn: and value:in: - typically it is an SSWInstVarAccessor"
	
	accessor := anAccessor!

componentsOf: anObject do: aBlock

	"For each component of anObject represented by the receiver, evaluate aBlock"

	aBlock value: (self accessor valueIn: anObject)!

freePreparedStatements

	readAllStatement notNil ifTrue: 
		[readAllStatement free.
		readAllStatement := nil]!

newReadAllParameters

	^Array new: self table readAllBatchSize!

printOn: aStream

	super printOn: aStream.

	aStream
		nextPutAll: ' - ';
		nextPutAll: self table name!

readAllFor: aCollection

	"Bulk-read (ideally in a single query, but possibly batched into several queries) all target objects of this table component belonging to any member of aCollection.
	The bulk-read objects are then assigned to the owning member of aCollection, thus avoiding (aCollection size) individual queries"

	self subclassResponsibility!

readAllQuery

	"Return a SQL query for reading all elements of this table component for a selection of owning objects"

	^self subclassResponsibility!

readAllStatement

	"Return a prepared statement for reading all elements of this table component for a selection of owning objects"

	^readAllStatement ifNil: [readAllStatement := self reStore prepareStatementForQuery: self readAllQuery]!

relatedComponentsOf: anObject do: aBlock

	"For each component of anObject represented by the receiver, which are related to anObject, evaluate aBlock"

	self subclassResponsibility!

reStore

	^self table reStore!

sqlDialect

	^self table sqlDialect! !
!SSWDBTableComponent categoriesForMethods!
aboutToBeUnstored:!actions!public! !
accesses:!public!testing! !
accessor!accessing!public! !
accessor:!accessing!public! !
componentsOf:do:!evaluating!public! !
freePreparedStatements!initialize/release!public! !
newReadAllParameters!accessing-queries!private! !
printOn:!printing!public! !
readAllFor:!actions!public! !
readAllQuery!accessing-queries!public! !
readAllStatement!accessing!public! !
relatedComponentsOf:do:!evaluating!public! !
reStore!accessing!public! !
sqlDialect!accessing!public! !
!

!SSWDBTableComponent class methodsFor!

new

	^super new initialize! !
!SSWDBTableComponent class categoriesForMethods!
new!instance creation!public! !
!


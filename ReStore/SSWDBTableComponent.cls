"Filed out from Dolphin Smalltalk 7"!

SSWSQLTableComponent subclass: #SSWDBTableComponent
	instanceVariableNames: 'accessor readAllStatement'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBTableComponent guid: (GUID fromString: '{266e4dd0-398e-11d5-b1df-444553540000}')!
SSWDBTableComponent comment: 'Copyright 2000/2001 Solutions Software Limited'!
!SSWDBTableComponent categoriesForClass!Unclassified! !
!SSWDBTableComponent methodsFor!

aboutToBeUnstored: anObject

	"30/9/2001

	anObject (which originated in the receiver's table) is about to be removed from the DB.
	Carry out any necessary actions"

	"Default - no action"
	^self!

accessor

	"6/8/2000
	
	accessor stores an 'Accessor' object which is used to get and set the value
	represented by this component in its eventual Smalltalk object.
	The accessor does this via #valueIn: and value:in: - typically it is an SSWInstVarAccessor"
	
	^accessor!

accessor: anAccessor

	"6/8/2000
	
	accessor stores an 'Accessor' object which is used to get and set the value
	represented by this component in its eventual Smalltalk object.
	The accessor does this via #valueIn: and value:in: - typically it is an SSWInstVarAccessor"
	
	accessor := anAccessor!

componentsOf: anObject do: aBlock

	"For each component of anObject represented by the receiver, evaluate aBlock"

	aBlock value: (self accessor valueIn: anObject)!

newReadAllParameters

	^Array new: self table readAllBatchSize!

printOn: aStream

	"6/8/2000"

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
!SSWDBTableComponent categoriesFor: #aboutToBeUnstored:!actions!public! !
!SSWDBTableComponent categoriesFor: #accessor!accessing!public! !
!SSWDBTableComponent categoriesFor: #accessor:!accessing!public! !
!SSWDBTableComponent categoriesFor: #componentsOf:do:!evaluating!public! !
!SSWDBTableComponent categoriesFor: #newReadAllParameters!accessing-queries!private! !
!SSWDBTableComponent categoriesFor: #printOn:!printing!public! !
!SSWDBTableComponent categoriesFor: #readAllFor:!actions!public! !
!SSWDBTableComponent categoriesFor: #readAllQuery!accessing-queries!public! !
!SSWDBTableComponent categoriesFor: #readAllStatement!accessing!public! !
!SSWDBTableComponent categoriesFor: #relatedComponentsOf:do:!evaluating!public! !
!SSWDBTableComponent categoriesFor: #reStore!accessing!public! !
!SSWDBTableComponent categoriesFor: #sqlDialect!accessing!public! !

!SSWDBTableComponent class methodsFor!

new

	^super new initialize! !
!SSWDBTableComponent class categoriesFor: #new!instance creation!public! !


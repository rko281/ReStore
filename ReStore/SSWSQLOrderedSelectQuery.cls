"Filed out from Dolphin Smalltalk 7"!

SSWSQLSelectQuery subclass: #SSWSQLOrderedSelectQuery
	instanceVariableNames: 'orderingSpecs'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLOrderedSelectQuery guid: (GUID fromString: '{6266c935-3983-11d5-b1df-444553540000}')!
SSWSQLOrderedSelectQuery comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLOrderedSelectQuery categoriesForClass!Unclassified! !
!SSWSQLOrderedSelectQuery methodsFor!

forgetOrdering

	self orderingSpecs: OrderedCollection new!

hasOrdering

	^self orderingSpecs isEmpty not!

orderAscendingBy: anSSWSQLDatabaseField

	self orderingSpecs add: (SSWDBOrderingSpec ascending: anSSWSQLDatabaseField)!

orderDescendingBy: anSSWSQLDatabaseField

	self orderingSpecs add: (SSWDBOrderingSpec descending: anSSWSQLDatabaseField)!

orderingSpecs

	"orderingSpecs stores an OrderedCollection of SSWDBOrderingSpecs
	which define the ordering used by this query (criteria is an SSWDBField)"
	
	^orderingSpecs!

orderingSpecs: anOrderedCollection

	"orderingSpecs stores an OrderedCollection of SSWDBOrderingSpecs
	which define the ordering used by this query (criteria is an SSWDBField)"
	
	orderingSpecs := anOrderedCollection!

writeOrderingSQLOn: aStream
	
	self orderingSpecs isEmpty ifTrue: [^self].

	aStream nextPutAll: ' ORDER BY '.

	self orderingSpecs do: 
		[ :spec |
		spec criteria writeSQLOn: aStream.
		spec isAscending
			ifTrue: [aStream nextPutAll: ' ASC ']
			ifFalse: [aStream nextPutAll: ' DESC ']] separatedBy: [aStream nextPutAll: ', ']!

writeSQLOn: aStream

	self
		writeUnorderedSQLOn: aStream;
		writeOrderingSQLOn: aStream!

writeUnorderedSQLOn: aStream

	super writeSQLOn: aStream! !
!SSWSQLOrderedSelectQuery categoriesFor: #forgetOrdering!defining!public! !
!SSWSQLOrderedSelectQuery categoriesFor: #hasOrdering!public!testing! !
!SSWSQLOrderedSelectQuery categoriesFor: #orderAscendingBy:!defining!public! !
!SSWSQLOrderedSelectQuery categoriesFor: #orderDescendingBy:!defining!public! !
!SSWSQLOrderedSelectQuery categoriesFor: #orderingSpecs!accessing!public! !
!SSWSQLOrderedSelectQuery categoriesFor: #orderingSpecs:!accessing!public! !
!SSWSQLOrderedSelectQuery categoriesFor: #writeOrderingSQLOn:!output!public! !
!SSWSQLOrderedSelectQuery categoriesFor: #writeSQLOn:!output!public! !
!SSWSQLOrderedSelectQuery categoriesFor: #writeUnorderedSQLOn:!output!public! !

!SSWSQLOrderedSelectQuery class methodsFor!

new

	^super new
		orderingSpecs: OrderedCollection new;
		yourself! !
!SSWSQLOrderedSelectQuery class categoriesFor: #new!instance creation!public! !


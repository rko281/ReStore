"Filed out from Dolphin Smalltalk 7"!

SSWSQLTableCollection variableSubclass: #SSWSQLJoinedTableCollection
	instanceVariableNames: 'joinConditions'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLJoinedTableCollection guid: (GUID fromString: '{6266c926-3983-11d5-b1df-444553540000}')!
SSWSQLJoinedTableCollection comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLJoinedTableCollection categoriesForClass!Unclassified! !
!SSWSQLJoinedTableCollection methodsFor!

add: anSSWDBTable joinedWith: anSSWSQLCondition

	"Add the given table joined with the given condition; return the table added.
	Duplicate entries are permitted - see withoutDuplicates"

	self add: anSSWDBTable. 
	self joinConditions add: anSSWSQLCondition.
	^anSSWDBTable!

copy

	^super copy
		joinConditions: self joinConditions copy;
		yourself!

copyLikeOfSize: anInteger

	^(super copyLikeOfSize: anInteger)
		joinConditions: self joinConditions copy;
		yourself!

doWithJoins: aTwoArgBlock

	"Iterate over the receiver's *joined* tables, evaluating aTwoArgBlock with each table-join condition pair.
	NB this IGNORES the receiver's first entry (i.e. its soleTable) since this has no matching join condition"
	
	2 to: self size do: [ :index | aTwoArgBlock value: (self at: index) value: (self joinConditions at: (index - 1))]!

hasJoins

	^self joinConditions size > 0!

includes: anSSWDBTable joinedWith: anSSWSQLCondition
	
	2 to: self size do:
		[ :index || table join |
		table := self at: index.
		join := self joinConditions at: (index - 1).
		(table = anSSWDBTable and: [join = anSSWSQLCondition]) ifTrue: [^true]].

	^false!

joinConditions

	"joinConditions stores a collection of SSWSQLConditions that join the receiver collection of tables.
	e.g. the first table is joined to the second by the first joinCondition, 2>3 by the second etc.
	Hence there should always be one less joinCondition than the size of the receiver"
	
	^joinConditions!

joinConditions: anOrderedCollection

	"joinConditions stores a collection of SSWSQLConditions that join the receiver collection of tables.
	e.g. the first table is joined to the second by the first joinCondition, 2>3 by the second etc.
	Hence there should always be one less joinCondition than the size of the receiver"
	
	joinConditions := anOrderedCollection!

merge: anSSWSQLJoinedTableCollection

	"Add the tables and joins from anSSWSQLJoinedTableCollection to the receiver.
	NB if the receiver is non-empty, this method does *not* add the first (starting) table
	 - this is *assumed* to be the same. 	Also excludes duplicates"
	
	self isEmpty ifTrue: [self addFirst: anSSWSQLJoinedTableCollection first].
	
	anSSWSQLJoinedTableCollection doWithJoins:
		[ :table :joinCondition |
		(self includes: table joinedWith: joinCondition) ifFalse: [self add: table joinedWith: joinCondition]]!

removeLast

	self joinConditions removeLast. 
	^super removeLast!

tableJoinedWithField: anSSWDBField
	
	self joinConditions keysAndValuesDo: [ :index :each | (each value = anSSWDBField and: [each value accessorPath = anSSWDBField accessorPath]) ifTrue: [^self at: (index + 1)]].

	^nil!

withoutDuplicates

	"Return a copy of the receiver, excluding duplicate entries.
	A duplicate entry is defined as the same table joined with the same condition"
	
	| withoutDuplicates |
	
	withoutDuplicates := self copy soleTable: self first.
	
	self doWithJoins:
		[ :table :condition |		
		(withoutDuplicates includes: table joinedWith: condition) ifFalse: [withoutDuplicates add: table joinedWith: condition]].
		
	^withoutDuplicates! !
!SSWSQLJoinedTableCollection categoriesFor: #add:joinedWith:!adding/removing!public! !
!SSWSQLJoinedTableCollection categoriesFor: #copy!evaluating!public! !
!SSWSQLJoinedTableCollection categoriesFor: #copyLikeOfSize:!evaluating!public! !
!SSWSQLJoinedTableCollection categoriesFor: #doWithJoins:!enumerating!public! !
!SSWSQLJoinedTableCollection categoriesFor: #hasJoins!public!testing! !
!SSWSQLJoinedTableCollection categoriesFor: #includes:joinedWith:!public!testing! !
!SSWSQLJoinedTableCollection categoriesFor: #joinConditions!accessing!public! !
!SSWSQLJoinedTableCollection categoriesFor: #joinConditions:!accessing!public! !
!SSWSQLJoinedTableCollection categoriesFor: #merge:!adding/removing!public! !
!SSWSQLJoinedTableCollection categoriesFor: #removeLast!adding/removing!public! !
!SSWSQLJoinedTableCollection categoriesFor: #tableJoinedWithField:!accessing!public! !
!SSWSQLJoinedTableCollection categoriesFor: #withoutDuplicates!evaluating!public! !

!SSWSQLJoinedTableCollection class methodsFor!

new

	^super new
		joinConditions: SSWSQLConditionCollection forAND;
		yourself!

new: aSize

	^(super new: aSize)
		joinConditions: SSWSQLConditionCollection forAND;
		yourself! !
!SSWSQLJoinedTableCollection class categoriesFor: #new!instance creation!public! !
!SSWSQLJoinedTableCollection class categoriesFor: #new:!instance creation!public! !


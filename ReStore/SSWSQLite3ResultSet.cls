"Filed out from Dolphin Smalltalk"!

SQLite3Cursor subclass: #SSWSQLite3ResultSet
	instanceVariableNames: 'firstRow query columns'
	classVariableNames: ''
	poolDictionaries: 'SQLite3Constants'
	classInstanceVariableNames: ''!

SSWSQLite3ResultSet guid: (GUID fromString: '{cd22f984-8475-4ee3-9d18-195a9f903add}')!

SSWSQLite3ResultSet comment: ''!

!SSWSQLite3ResultSet categoriesForClass!Unclassified! !

!SSWSQLite3ResultSet methodsFor!

columns

	^columns!

cursorType

	^#forwardOnly!

do: aBlock

	[self next
		ifNil: [ false ]
		ifNotNil: [ :next | aBlock value: next. true]] whileTrue!

first
	^firstRow ifNil: [ self next ]!

free

	statement isNil ifFalse: 
		[statement free.
		statement := nil]!

initialize 

	super initialize.
	self rowClass: SSWSQLite3Row !

keysAndValuesDo: aBlock

	| index |

	index := 0.
	[self next 
	ifNil: 
		[false]
	ifNotNil: 
		[ :row | 
		index := index + 1.
		aBlock value: index value: row.
		true]] whileTrue!

last

	| next last |

	[next := self next
	next isNil ] whileFalse: [last := next].

	^last!

next

	^firstRow isNil 
		ifTrue: [ firstRow := super next ]
		ifFalse: [ super next ]!

nextOfClass: aRowClass

	^(super nextOfClass: aRowClass) ifNotNil: [ :row | row columns: self columns; yourself]!

numRows

	^connection changes!

query

	^query!

readStream

	^SSWDBForwardOnlyReadStream on: self!

results

	^self!

size

	"size as in number of rows.
	nil = unknown"

	^nil!

species

	^OrderedCollection !

statement: anSSWSQLite3Statement

	statement := anSSWSQLite3Statement.
	connection := anSSWSQLite3Statement parent!

statement: aStatement moreRows: aBoolean rows: rCollection

	self statement: aStatement.
	aStatement query ifNotNil: 
		[ :stmtQuery |
		query := stmtQuery.
	
		columns := self statement columnNames collect: 
			[ :each | 
			SSWDBColAttr new 
				name: each; 
				field:  (query fieldNamed: each);
				yourself]].

	moreRows := aBoolean.
	rows := rCollection! !

!SSWSQLite3ResultSet categoriesForMethods!
columns!accessing!public! !
cursorType!accessing!public! !
do:!enumerating!public! !
first!accessing!public! !
free!initialization!public! !
initialize!initialization!public! !
keysAndValuesDo:!enumerating!public! !
last!accessing!public! !
next!API!public! !
nextOfClass:!accessing!public! !
numRows!accessing!public! !
query!accessing!public! !
readStream!accessing!public! !
results!accessing!public! !
size!accessing!public! !
species!accessing!public! !
statement:!accessing!public! !
statement:moreRows:rows:!initialization!public! !
!


"Filed out from Dolphin Smalltalk"!

MySQLResultSet subclass: #SSWMySQLResultSet
	instanceVariableNames: 'columns'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWMySQLResultSet guid: (GUID fromString: '{b011b7e1-8ad8-4c95-af03-e496e2fa1c61}')!

SSWMySQLResultSet comment: ''!

!SSWMySQLResultSet categoriesForClass!SSW ReStore MySQL! !

!SSWMySQLResultSet methodsFor!

close

	"In Dolphin this closes the result set, leaving the statement open.
	Nothing to do here"!

columns

	^columns!

cursorType
	^#forwardOnly!

do: aBlock

	self rows do: aBlock!

first

	^rows isEmpty
		ifTrue: [ nil ] 
		ifFalse: [ rows first ]!

free

	statement free!

keysAndValuesDo: aBlock

	self rows keysAndValuesDo: aBlock!

last

	^rows isEmpty
		ifTrue: [ nil ] 
		ifFalse: [ rows last ]!

next 
	^self nextRow
		columns: self columns;
		yourself!

numRows 

	^rows size!

readStream

	^SSWDBForwardOnlyReadStream on: self!

size

	"size as in number of rows.
	nil = unknown"

	^nil!

species

	^OrderedCollection!

statement: anSSWMySQLStatement

	| query |

	super statement: anSSWMySQLStatement.
	fields isEmpty ifTrue: [^self].

	statement adoptResultSet: self.
	query := statement query.
	columns :=  fields collect: 
		[ :each | 
		SSWDBColAttr new 
			name: each name; 
			field:  (query fieldNamed: each name);
			yourself].

	rows ifNotNil: [rows do: [ :each | each columns: columns]]! !

!SSWMySQLResultSet categoriesForMethods!
close!initialize/release!public! !
columns!accessing!public! !
cursorType!public! !
do:!enumerating!public! !
first!accessing!public! !
free!initialize/release!public! !
keysAndValuesDo:!enumerating!public! !
last!accessing!public! !
next!accessing!public! !
numRows!accessing!public! !
readStream!accessing!public! !
size!accessing!public! !
species!accessing!public! !
statement:!accessing!public! !
!


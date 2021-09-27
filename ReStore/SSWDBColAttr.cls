"Filed out from Dolphin Smallalk"!

Object subclass: #SSWDBColAttr
	instanceVariableNames: 'name index table connection field'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBColAttr guid: (GUID fromString: '{0a6d0cfb-741d-432e-bd31-5c6e3eb44c68}')!
SSWDBColAttr comment: ''!
!SSWDBColAttr categoriesForClass!Kernel-Objects! !
!SSWDBColAttr methodsFor!

connection
	^ connection!

connection: anObject
	connection := anObject!

field

	"field stores the SSWSQLField from a SELECT query 
	that gave rise to this column in the resut set"

	^field!

field: anSSWSQLField

	"field stores the SSWSQLField from a SELECT query 
	that gave rise to this column in the resut set"

	field := anSSWSQLField!

fieldName

	^self name!

index
	^ index!

index: anObject
	index := anObject!

name
	^ name!

name: anObject
	name := anObject!

precision 

	^self size!

size 

	"Simple support, primarily for SUnits"

	| declaration stream |

	declaration := (self connection declaredColumnTypesForTable: self table) at: self index.
	stream := declaration readStream.
	[ stream atEnd or: [ stream peek isDigit ] ] whileFalse: [ stream next ].
	^stream atEnd
		ifTrue: [ nil ]
		ifFalse: [ Integer readFrom: stream ]!

table
	^ table!

table: anObject
	table := anObject!

tableName
	^ self table name! !
!SSWDBColAttr categoriesForMethods!
connection!accessing!public! !
connection:!accessing!public! !
field!accessing!public! !
field:!accessing!public! !
fieldName!accessing!public! !
index!accessing!public! !
index:!accessing!public! !
name!accessing!public! !
name:!accessing!public! !
precision!accessing!public! !
size!accessing!public! !
table!accessing!public! !
table:!accessing!public! !
tableName!accessing!public! !
!

!SSWDBColAttr class methodsFor!

forString: aString

	^self new! !
!SSWDBColAttr class categoriesForMethods!
forString:!instance creation!public! !
!


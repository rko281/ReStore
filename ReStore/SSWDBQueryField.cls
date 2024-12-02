"Filed out from Dolphin Smalltalk"!

Object subclass: #SSWDBQueryField
	instanceVariableNames: 'field columnIndex'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWDBQueryField guid: (GUID fromString: '{266e4dc8-398e-11d5-b1df-444553540000}')!

SSWDBQueryField comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!

!SSWDBQueryField categoriesForClass!Unclassified! !

!SSWDBQueryField methodsFor!

accessor

	^self field accessor!

accessorPath

	^self field path!

canBeParameterized

	"Defer to the field"
	^self field canBeParameterized!

columnIndex

	"columnIndex stores the expected index of the receiver's column in a DBRow after the most recent query involving the receiver.
	It is set during query result preparation and is checked first during subsequent lookups for this field"

	^columnIndex!

columnIndex: anInteger

	"columnIndex stores the expected index of the receiver's column in a DBRow after the most recent query involving the receiver.
	It is set during query result preparation and is checked first during subsequent lookups for this field"

	columnIndex := anInteger!

convertValue: aValue

	"Forward to the real field"
	
	^self field convertValue: aValue!

field

	"The receiver is created to stand in place of a regular SSWDBField 
	See subclasses for when/why this may happen.
	
	field stores the original SSWDBField which the receiver replaces"
	
	^field!

field: anSSWDBField

	"The receiver is created to stand in place of a regular SSWDBField 
	See subclasses for when/why this may happen.
	
	field stores the original SSWDBField which the receiver replaces"

	field := anSSWDBField!

fieldNamed: aString

	"Defer to the real field"
	^self field fieldNamed: aString!

hasAggregateFunction

	"Defer to the field"
	^self field hasAggregateFunction!

isFieldCollection

	^false!

lookupIn: aDBRow

	^aDBRow lookupField: self!

name

	"Forward to the real field"
	
	^self field name!

requiresAliasing

	"Defer to the field"
	^self field requiresAliasing!

reStore

	^self table reStore!

sqlCanBeParameterized

	"When expressing this field as a value, can its SQL be parameterized?
	Different to canBeParameterized!!"

	^false!

sqlDialect

	^self field sqlDialect!

table

	^self field table!

targetClass

	"Forward to the real field"
	
	^self field targetClass!

targetClass: aClass
	
	aClass = self targetClass ifFalse: 
		[self field: 
			(self field withFunction: 
				('%1' asSQLFunction
					staticResultClass: aClass;
					yourself))]!

withFunction: aSQLFunction

	"Return an SSWDBFunctionField base on the receiver with the given function"
	
	^self withFunction: aSQLFunction arguments: #()!

withFunction: aString arguments: aCollection

	"Return an SSWDBFunctionField base on the receiver with the given function String and arguments"
	
	^SSWDBFunctionField new
		field: self;
		function: aString;
		arguments: aCollection;
		yourself!

writeSQLForUpdateOn: aStream

	"Forward to the contained field"

	^self field writeSQLForUpdateOn: aStream! !

!SSWDBQueryField categoriesForMethods!
accessor!evaluating!public! !
accessorPath!accessing!public! !
canBeParameterized!public!testing! !
columnIndex!accessing!private! !
columnIndex:!accessing!private! !
convertValue:!evaluating!public! !
field!accessing!public! !
field:!accessing!public! !
fieldNamed:!evaluating!public! !
hasAggregateFunction!public!testing! !
isFieldCollection!public!testing! !
lookupIn:!accessing!public! !
name!evaluating!public! !
requiresAliasing!public!testing! !
reStore!accessing!public! !
sqlCanBeParameterized!public!testing! !
sqlDialect!accessing!public! !
table!accessing!public! !
targetClass!accessing!public! !
targetClass:!accessing!public! !
withFunction:!evaluating!public! !
withFunction:arguments:!evaluating!public! !
writeSQLForUpdateOn:!printing!public! !
!


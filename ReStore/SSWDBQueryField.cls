"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SSWDBQueryField
	instanceVariableNames: 'field'
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

	^false!

isFieldCollection

	^false!

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

table

	^self field table!

targetClass

	"Forward to the real field"
	
	^self field targetClass!

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
!SSWDBQueryField categoriesFor: #accessor!evaluating!public! !
!SSWDBQueryField categoriesFor: #accessorPath!accessing!public! !
!SSWDBQueryField categoriesFor: #canBeParameterized!public!testing! !
!SSWDBQueryField categoriesFor: #convertValue:!evaluating!public! !
!SSWDBQueryField categoriesFor: #field!accessing!public! !
!SSWDBQueryField categoriesFor: #field:!accessing!public! !
!SSWDBQueryField categoriesFor: #fieldNamed:!evaluating!public! !
!SSWDBQueryField categoriesFor: #hasAggregateFunction!public!testing! !
!SSWDBQueryField categoriesFor: #isFieldCollection!public!testing! !
!SSWDBQueryField categoriesFor: #name!evaluating!public! !
!SSWDBQueryField categoriesFor: #requiresAliasing!public!testing! !
!SSWDBQueryField categoriesFor: #reStore!accessing!public! !
!SSWDBQueryField categoriesFor: #sqlCanBeParameterized!public!testing! !
!SSWDBQueryField categoriesFor: #table!accessing!public! !
!SSWDBQueryField categoriesFor: #targetClass!evaluating!public! !
!SSWDBQueryField categoriesFor: #withFunction:!evaluating!public! !
!SSWDBQueryField categoriesFor: #withFunction:arguments:!evaluating!public! !
!SSWDBQueryField categoriesFor: #writeSQLForUpdateOn:!printing!public! !


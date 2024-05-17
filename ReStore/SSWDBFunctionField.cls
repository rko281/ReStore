"Filed out from Dolphin Smallalk"!

SSWDBQueryField subclass: #SSWDBFunctionField
	instanceVariableNames: 'function arguments'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBFunctionField guid: (GUID fromString: '{266e4dc9-398e-11d5-b1df-444553540000}')!
SSWDBFunctionField comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBFunctionField categoriesForClass!Unclassified! !
!SSWDBFunctionField methodsFor!

anySatisfy: aBlock

	"Make the receiver polymorphic with an SQLConditionCollection"
	
	^aBlock value: self!

arguments

	"arguments stores the collection of objects which are the arguments to the receiver's function.
	e.g. in the expression MID(SURNAME, 4, 9) the arguments would be #(4 9)"
	
	^arguments!

arguments: aCollection

	"arguments stores the collection of objects which are the arguments to the receiver's function.
	e.g. in the expression MID(SURNAME, 4, 9) the arguments would be #(4 9)"
	
	arguments := aCollection!

convertValue: aValue

	"Convert the given DB value object to the receiver's targetClass.
	Return the converted object"

	^self function convertValue: aValue forFunctionField: self!

fieldAtIndex: anInteger

	^anInteger = 1
		ifTrue: [self field]
		ifFalse: [self arguments at: (anInteger - 1)]!

function

	"function stores the SQL string of the function applied to the receiver's field,
	with %x placeholders for the arguments (at least one, for the receiver's field)
	e.g. for the expression SIZE(SURNAME), the function would be 'SIZE(%1)'	"
	
	^function!

function: aString

	"function stores the SQL string of the function applied to the receiver's field,
	with %x placeholders for the arguments (at least one, for the receiver's field)
	e.g. for the expression SIZE(SURNAME), the function would be 'SIZE(%)'	"
	
	function := aString!

hasAggregateFunction

	^self function isAggregateFunction!

isEmpty

	"Make the receiver polymorphic with an SQLConditionCollection"
	
	^false!

requiresAliasing

	"Function fields need aliasing for effective lookup, e.g. COUNT(ID) AS Field1"
	^true!

targetClass

	^self function targetClassForFunctionField: self!

writeAliasedSQLOn: aStream

	"The receiver does not support the concept of an 'aliased' name; 
	it either appears in conditions (alias not needed), or if in a result set it will be the sole field"
	
	^aStream nextPutAliasedField: self!

writeSQLOn: aStream

	| funcStream |
	
	funcStream := ReadStream on: self function parameterizedString.

	[funcStream atEnd] whileFalse:
		["Handle doubled-up %%"
		[aStream nextPutAll: (funcStream upTo: $%).
		funcStream peek = $%] whileTrue: [aStream nextPut: funcStream next].

		funcStream atEnd ifFalse:
			[| argIndex |
			argIndex := funcStream next digitValue - 1.
			argIndex = 0
				ifTrue: [self field writeSQLOn: aStream]
				ifFalse: [(self arguments at: argIndex) writeSQLOn: aStream]]]! !
!SSWDBFunctionField categoriesForMethods!
anySatisfy:!public!testing! !
arguments!accessing!public! !
arguments:!accessing!public! !
convertValue:!helpers!public! !
fieldAtIndex:!accessing!public! !
function!accessing!public! !
function:!accessing!public! !
hasAggregateFunction!public!testing! !
isEmpty!public!testing! !
requiresAliasing!public!testing! !
targetClass!helpers!public! !
writeAliasedSQLOn:!output!public! !
writeSQLOn:!output!public! !
!


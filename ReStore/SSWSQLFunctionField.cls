"Filed out from Dolphin Smalltalk 7"!

SSWSQLField subclass: #SSWSQLFunctionField
	instanceVariableNames: 'function arguments'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLFunctionField guid: (GUID fromString: '{98f99d6b-3bcf-4a05-ac5a-f6b7eb406142}')!
SSWSQLFunctionField comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLFunctionField categoriesForClass!Unclassified! !
!SSWSQLFunctionField methodsFor!

arguments

	"arguments stores the collection of objects which are the arguments to the receiver's function.
	e.g. in the expression MID(SURNAME, 4, 9) the arguments would be #(4 9)"
	
	^arguments!

arguments: aCollection

	"arguments stores the collection of objects which are the arguments to the receiver's function.
	e.g. in the expression MID(SURNAME, 4, 9) the arguments would be #(4 9)"
	
	arguments := aCollection!

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

requiresAliasing

	"Function fields need aliasing for effective lookup, e.g. COUNT(ID) AS Field1"
	^true!

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
				ifTrue: [super writeSQLOn: aStream]
				ifFalse: [(self arguments at: argIndex) writeSQLOn: aStream]]]! !
!SSWSQLFunctionField categoriesFor: #arguments!accessing!public! !
!SSWSQLFunctionField categoriesFor: #arguments:!accessing!public! !
!SSWSQLFunctionField categoriesFor: #function!accessing!public! !
!SSWSQLFunctionField categoriesFor: #function:!accessing!public! !
!SSWSQLFunctionField categoriesFor: #requiresAliasing!public!testing! !
!SSWSQLFunctionField categoriesFor: #writeAliasedSQLOn:!output!public! !
!SSWSQLFunctionField categoriesFor: #writeSQLOn:!output!public! !


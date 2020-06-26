"Filed out from Dolphin Smalltalk 7"!

SSWSQLFieldCollection variableSubclass: #SSWDBQueryFieldCollection
	instanceVariableNames: 'parser'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBQueryFieldCollection guid: (GUID fromString: '{2ddde173-b0fa-4a2d-8249-1806d31a0414}')!
SSWDBQueryFieldCollection comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBQueryFieldCollection categoriesForClass!Unclassified! !
!SSWDBQueryFieldCollection methodsFor!

|| anObject

	^anObject forConcatenation concatenatedWith: self!

asSQLFields

	"Convert the receiver to the standard non-query subsystem representation"

	| sql |

	sql := SSWSQLFieldCollection new: self size.

	^self inject: sql into: [ :all :each | all add: each asSQLFields; yourself]!

concatenateCondition: aCondition

	self add: (self parser unprocessedConditionsCombinedWithArgument: aCondition)!

doesNotUnderstand: aMessage
	
	"Attempt to interpret selector as a function message send"
	(self first table reStore sqlDialect sqlFunctionFor: aMessage selector) ifNotNil: 
		[ :function | 
		^self parser applyFunction: function to: self withArguments: aMessage arguments].

	^super doesNotUnderstand: aMessage!

parser
	^parser!

parser: anObject
	parser := anObject! !
!SSWDBQueryFieldCollection categoriesFor: #||!accessing!public! !
!SSWDBQueryFieldCollection categoriesFor: #asSQLFields!converting!public! !
!SSWDBQueryFieldCollection categoriesFor: #concatenateCondition:!accessing!public! !
!SSWDBQueryFieldCollection categoriesFor: #doesNotUnderstand:!parsing - internal!public! !
!SSWDBQueryFieldCollection categoriesFor: #parser!accessing!private! !
!SSWDBQueryFieldCollection categoriesFor: #parser:!accessing!private! !


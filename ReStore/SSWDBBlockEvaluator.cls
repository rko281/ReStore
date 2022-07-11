"Filed out from Dolphin Smallalk"!

SSWDBProtoObject subclass: #SSWDBBlockEvaluator
	instanceVariableNames: 'parser'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBBlockEvaluator guid: (GUID fromString: '{5a3e3dcc-3990-11d5-b1df-444553540000}')!
SSWDBBlockEvaluator comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBBlockEvaluator categoriesForClass!Unclassified! !
!SSWDBBlockEvaluator methodsFor!

|| aBlockEvaluatorOrCondition

	"Concatenate with another block evaluator or condition (primarily for multi-field collect: and project:)"

	^(self parser unprocessedConditionsCombinedForConcatenation: aBlockEvaluatorOrCondition) concatenatedWith: self forConcatenation!

chainPerform: aCollection

	"perform: each member (Symbol) of aCollection against the receiver as a chain
	i.e. the second Symbol is perform:'d against the result of perform:ing the first, etc."

	^aCollection inject: self into: [ :receiver :symbol | receiver perform: symbol]
!

concatenatedWith: aCollection

	| queryCollection |

	(aCollection isKindOf: ConcatenatedCollection) 
		ifTrue: [queryCollection := (SSWDBQueryFieldCollection withAll: (aCollection collect: [ :each | SSWSQLParameterField forValue: each])) parser: self parser; yourself]
		ifFalse: [queryCollection := aCollection].

	^queryCollection concatenateCondition: self forConcatenation!

currentTable

	^self subclassResponsibility!

finalField

	^self subclassResponsibility!

forConcatenation

	"When received by an instance of this class, the current final field (rather than an actual condition) is being concatenated with another object, e.g. [ :person | person firstName || person surname]
	Return a corresponding field-only condition"

	^self parser newCondition 
		fieldOnly: 
			(self hasFinalField 
				ifTrue: [self finalField]
				ifFalse: [SSWDBQueryIDField forTable: self currentTable]);
		yourself!

hasFinalField

	^self subclassResponsibility!

imageDo: imageBlock databaseDo: databaseBlock

	"Allow different code to be 'evaluated' depending on whether execution is in-image or 'in' the database (in the latter case code is not actually executed but converted to SQL)"

	^databaseBlock value!

isSimilarTo: anObject

	^self perform: anObject similarityComparator with: anObject!

newCondition

	^self parser newCondition!

parser

	^parser!

parser: anSSWDBBlockParser

	parser := anSSWDBBlockParser!

path

	"The path of accessors form which this evaluator was created"

	^#()!

printOn: aStream

	aStream nextPutAll: 'an '; print: self basicClass!

printString

	^'an ', self basicClass name!

reStore

	"reStore stores the SSWReStore for which the receiver parses blocks"
	
	^self parser reStore! !
!SSWDBBlockEvaluator categoriesForMethods!
||!parsing - functions!public! !
chainPerform:!message sending!public! !
concatenatedWith:!parsing - functions!public! !
currentTable!accessing!public! !
finalField!public!testing! !
forConcatenation!converting!public! !
hasFinalField!public!testing! !
imageDo:databaseDo:!helpers!public! !
isSimilarTo:!public!testing! !
newCondition!accessing!public! !
parser!accessing!public! !
parser:!accessing!public! !
path!accessing!public! !
printOn:!parsing - internal!public! !
printString!parsing - internal!public! !
reStore!accessing!public! !
!


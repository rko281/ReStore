"Filed out from Dolphin Smalltalk 7"!

ProtoObject subclass: #SSWDBBlockEvaluator
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

	^(self parser unprocessedConditionsCombinedForConcatenation: aBlockEvaluatorOrCondition) concatenateWith: self forConcatenation!

chainPerform: aCollection

	"perform: each member (Symbol) of aCollection against the receiver as a chain
	i.e. the second Symbol is perform:'d against the result of perform:ing the first, etc."

	^aCollection inject: self into: [ :receiver :symbol | receiver perform: symbol]
!

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

perform: selector
	"Send the receiver the unary message indicated by the <selector> argument,
	answering the result. 

	Primitive failure reasons:
		0 -	The number of arguments expected with the selector is not zero."

	<primitive: 83>
	^Error perform: selector failedFor: self withArgs: Array new!

perform: selector with: argument1
	"Send the receiver the keyword message indicated by the arguments, answering the result. 
	The first argument selector is the <selector> of the message. The second <Object> argument, 
	argument1, is the argument of the message to be sent. 

	Primitive failure reasons:
		0 -	The number of arguments expected with the selector is not one."

	<primitive: 83>
	^Error perform: selector failedFor: self withArgs: (Array with: argument1)!

reStore

	"reStore stores the SSWReStore for which the receiver parses blocks"
	
	^self parser reStore!

subclassResponsibility

	"Private - Just here to prevent code warnings"

	^nil subclassResponsibility! !
!SSWDBBlockEvaluator categoriesFor: #||!parsing - functions!public! !
!SSWDBBlockEvaluator categoriesFor: #chainPerform:!message sending!public! !
!SSWDBBlockEvaluator categoriesFor: #currentTable!accessing!public! !
!SSWDBBlockEvaluator categoriesFor: #finalField!public!testing! !
!SSWDBBlockEvaluator categoriesFor: #forConcatenation!converting!public! !
!SSWDBBlockEvaluator categoriesFor: #hasFinalField!public!testing! !
!SSWDBBlockEvaluator categoriesFor: #imageDo:databaseDo:!helpers!public! !
!SSWDBBlockEvaluator categoriesFor: #isSimilarTo:!public!testing! !
!SSWDBBlockEvaluator categoriesFor: #newCondition!accessing!public! !
!SSWDBBlockEvaluator categoriesFor: #parser!accessing!public! !
!SSWDBBlockEvaluator categoriesFor: #parser:!accessing!public! !
!SSWDBBlockEvaluator categoriesFor: #path!accessing!public! !
!SSWDBBlockEvaluator categoriesFor: #perform:!message sending!public! !
!SSWDBBlockEvaluator categoriesFor: #perform:with:!message sending!public! !
!SSWDBBlockEvaluator categoriesFor: #reStore!accessing!public! !
!SSWDBBlockEvaluator categoriesFor: #subclassResponsibility!helpers!private! !


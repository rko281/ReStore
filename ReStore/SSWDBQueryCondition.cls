"Filed out from Dolphin Smalltalk 7"!

SSWSQLCondition subclass: #SSWDBQueryCondition
	instanceVariableNames: 'parser'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBQueryCondition guid: (GUID fromString: '{019d523c-7327-472c-8f85-167bce12d1e2}')!
SSWDBQueryCondition comment: ''!
!SSWDBQueryCondition categoriesForClass!Unclassified! !
!SSWDBQueryCondition methodsFor!

_sqlAnd: aCondition

	"Private - Bypass the local implementation"

	^super sqlAnd: aCondition!

_sqlOr: aCondition

	"Private - Bypass the local implementation"

	^super sqlOr: aCondition!

|| anObject

	"Primarily for multi-field collect: and project: - concatenate with anObject, which may be aBlockEvaluator or another Condition"

	^anObject forConcatenation concatenateWith: self!

asSQLConditions

	"Convert the receiver to the standard non-query subsystem representation"

	^SSWSQLCondition field: self field is: self operator to: self value!

asSQLFields

	"Convert the receiver to the standard non-query subsystem representation for fields"

	^self isFieldOnly 
		ifTrue: [self field]
		ifFalse: [self asSQLConditions]!

concatenateCondition: aCondition

	"Since the receiver is a condition and not a FieldCollection (the result of a concatenation), it must be the first condition in the concatenation"

	| argument receiver |

	argument := self parser unprocessedConditionsCombinedWithArgument: aCondition.
	receiver := self parser unprocessedConditionsCombinedWithReceiver: self.

	^SSWDBQueryFieldCollection new
		parser: self parser;
		add: receiver;
		add: argument;
		yourself!

concatenateWith: anObject

	"Private - Double-despatch entry point"

	^anObject concatenateCondition: self!

forConcatenation

	^self!

mustBeBoolean

	"Private - Received when this condition has been subject to an inlined and: / or: message in a query block.
	Ask the parser to handle"

	^self parser handleMustBeBooleanIn: self!

newCollection

	^self parser newConditionCollection!

parser
	^parser!

parser: anObject
	parser := anObject!

sqlAnd: aCondition

	| argument receiver |

	argument := self parser unprocessedConditionsCombinedWithArgument: aCondition.
	receiver := self parser unprocessedConditionsCombinedWithReceiver: self.

	^receiver _sqlAnd: argument!

sqlOr: aCondition

	| argument receiver |

	argument := self parser unprocessedConditionsCombinedWithArgument: aCondition.
	receiver := self parser unprocessedConditionsCombinedWithReceiver: self.

	^receiver _sqlOr: argument! !
!SSWDBQueryCondition categoriesFor: #_sqlAnd:!evaluating!private! !
!SSWDBQueryCondition categoriesFor: #_sqlOr:!evaluating!private! !
!SSWDBQueryCondition categoriesFor: #||!evaluating!public! !
!SSWDBQueryCondition categoriesFor: #asSQLConditions!converting!public! !
!SSWDBQueryCondition categoriesFor: #asSQLFields!converting!public! !
!SSWDBQueryCondition categoriesFor: #concatenateCondition:!evaluating!public! !
!SSWDBQueryCondition categoriesFor: #concatenateWith:!evaluating!private! !
!SSWDBQueryCondition categoriesFor: #forConcatenation!converting!public! !
!SSWDBQueryCondition categoriesFor: #mustBeBoolean!evaluating!private! !
!SSWDBQueryCondition categoriesFor: #newCollection!accessing!public! !
!SSWDBQueryCondition categoriesFor: #parser!accessing!private! !
!SSWDBQueryCondition categoriesFor: #parser:!accessing!private! !
!SSWDBQueryCondition categoriesFor: #sqlAnd:!evaluating!public! !
!SSWDBQueryCondition categoriesFor: #sqlOr:!evaluating!public! !


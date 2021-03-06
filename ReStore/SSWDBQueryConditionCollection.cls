﻿"Filed out from Dolphin Smalltalk 7"!

SSWSQLConditionCollection variableSubclass: #SSWDBQueryConditionCollection
	instanceVariableNames: 'parser blockEndpoint postCondition'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBQueryConditionCollection guid: (GUID fromString: '{8fc6fd1c-d815-47c0-bb6d-8d073b2df2b1}')!
SSWDBQueryConditionCollection comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBQueryConditionCollection categoriesForClass!Unclassified! !
!SSWDBQueryConditionCollection methodsFor!

_sqlAnd: aCondition

	"Private - Bypass the local implementation"

	^super sqlAnd: aCondition!

_sqlOr: aCondition

	"Private - Bypass the local implementation"

	^super sqlOr: aCondition!

|| anObject

	"Primarily for multi-field collect: and project: - concatenate with anObject, which may be aBlockEvaluator or another Condition(Collection).
	Polymorphic with SSWDBBlockEvaluator; used when collect: queries have a condition as a result field, e.g. object cancelDate notNil"

	^anObject forConcatenation concatenatedWith: self!

asSQLConditions

	"Convert the receiver to the standard non-query subsystem representation"

	| sql |

	sql := SSWSQLConditionCollection new: self size.
	sql sqlConcatenator: self sqlConcatenator.

	^self inject: sql into: [ :all :each | all add: each asSQLConditions; yourself]!

asSQLFields

	"Convert the receiver to the standard non-query subsystem representation for fields"

	"The receiver represents the concept of a result field which is a composite condition"
	^self size = 1 
		ifTrue: [self first asSQLFields] 
		ifFalse: [self asSQLConditions]!

blockEndpoint
	^blockEndpoint!

blockEndpoint: anObject
	blockEndpoint := anObject!

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

concatenatedWith: anObject

	"Private - Double-despatch entry point"

	^anObject concatenateCondition: self!

copyEmpty: anInteger

	^(super copyEmpty: anInteger)
		parser: self parser;
		yourself
!

copyLikeOfSize: anInteger

	^(super copyLikeOfSize: anInteger)
		parser: self parser;
		yourself
!

forConcatenation

	^true!

parser
	^parser!

parser: anObject
	parser := anObject!

postCondition
	^postCondition!

postCondition: anObject
	postCondition := anObject!

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
!SSWDBQueryConditionCollection categoriesFor: #_sqlAnd:!evaluating!private! !
!SSWDBQueryConditionCollection categoriesFor: #_sqlOr:!evaluating!private! !
!SSWDBQueryConditionCollection categoriesFor: #||!evaluating!public! !
!SSWDBQueryConditionCollection categoriesFor: #asSQLConditions!converting!public! !
!SSWDBQueryConditionCollection categoriesFor: #asSQLFields!converting!public! !
!SSWDBQueryConditionCollection categoriesFor: #blockEndpoint!accessing!private! !
!SSWDBQueryConditionCollection categoriesFor: #blockEndpoint:!accessing!private! !
!SSWDBQueryConditionCollection categoriesFor: #concatenateCondition:!evaluating!public! !
!SSWDBQueryConditionCollection categoriesFor: #concatenatedWith:!evaluating!private! !
!SSWDBQueryConditionCollection categoriesFor: #copyEmpty:!copying!public! !
!SSWDBQueryConditionCollection categoriesFor: #copyLikeOfSize:!copying!public! !
!SSWDBQueryConditionCollection categoriesFor: #forConcatenation!converting!public! !
!SSWDBQueryConditionCollection categoriesFor: #parser!accessing!private! !
!SSWDBQueryConditionCollection categoriesFor: #parser:!accessing!private! !
!SSWDBQueryConditionCollection categoriesFor: #postCondition!accessing!private! !
!SSWDBQueryConditionCollection categoriesFor: #postCondition:!accessing!private! !
!SSWDBQueryConditionCollection categoriesFor: #sqlAnd:!evaluating!public! !
!SSWDBQueryConditionCollection categoriesFor: #sqlOr:!evaluating!public! !


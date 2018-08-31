"Filed out from Dolphin Smalltalk 7"!

SSWSQLFieldCollection variableSubclass: #SSWDBQueryFieldCollection
	instanceVariableNames: 'parser'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBQueryFieldCollection guid: (GUID fromString: '{2ddde173-b0fa-4a2d-8249-1806d31a0414}')!
SSWDBQueryFieldCollection comment: ''!
!SSWDBQueryFieldCollection categoriesForClass!Unclassified! !
!SSWDBQueryFieldCollection methodsFor!

|| anObject

	^anObject forConcatenation concatenateWith: self!

asSQLFields

	"Convert the receiver to the standard non-query subsystem representation"

	| sql |

	sql := SSWSQLFieldCollection new: self size.

	^self inject: sql into: [ :all :each | all add: each asSQLFields; yourself]!

concatenateCondition: aCondition

	self add: (self parser unprocessedConditionsCombinedWithArgument: aCondition)!

parser
	^parser!

parser: anObject
	parser := anObject! !
!SSWDBQueryFieldCollection categoriesFor: #||!accessing!public! !
!SSWDBQueryFieldCollection categoriesFor: #asSQLFields!converting!public! !
!SSWDBQueryFieldCollection categoriesFor: #concatenateCondition:!accessing!public! !
!SSWDBQueryFieldCollection categoriesFor: #parser!accessing!private! !
!SSWDBQueryFieldCollection categoriesFor: #parser:!accessing!private! !


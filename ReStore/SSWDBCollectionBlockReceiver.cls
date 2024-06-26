﻿"Filed out from Dolphin Smallalk"!

SSWDBBlockEvaluator subclass: #SSWDBCollectionBlockReceiver
	instanceVariableNames: 'collectionSpec collection currentMode'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBCollectionBlockReceiver guid: (GUID fromString: '{f3ba2a03-cc13-4840-b5f2-b0c421a00fd1}')!
SSWDBCollectionBlockReceiver comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBCollectionBlockReceiver categoriesForClass!Unclassified! !
!SSWDBCollectionBlockReceiver methodsFor!

~= aValue

	self validateSizeMode.

	^self conditionWithAggregatedQuery: (self localSelectQueryFrom: [ :each | each count ~= aValue])!

<= aValue

	self validateSizeMode.

	^self conditionWithAggregatedQuery: (self localSelectQueryFrom: [ :each | each count <= aValue])!

= aValue

	self validateSizeMode.

	^aValue = 0
		ifTrue: [self isEmpty]
		ifFalse: [self conditionWithAggregatedQuery: (self localSelectQueryFrom: [ :each | each count = aValue])]!

> aValue

	self validateSizeMode.

	^self conditionWithAggregatedQuery: (self localSelectQueryFrom: [ :each | each count > aValue])!

>= aValue

	self validateSizeMode.

	^self conditionWithAggregatedQuery: (self localSelectQueryFrom: [ :each | each count >= aValue])!

anySatisfy: aBlock

	"Return an appropriate subquery condition"

	self resetCurrentMode.

	^self conditionWithQuery: 
		((self selectQueryFrom: aBlock)
			fields: self targetField;
			yourself)!

collection

	^collection ifNil: [collection := self reStore instancesOf: self collectionSpec targetClass]!

collectionParser

	^self collection parser!

collectionSpec
	^collectionSpec!

collectionSpec: anObject
	collectionSpec := anObject!

conditionWithAggregatedQuery: aQuery

	^self conditionWithQuery:
		(aQuery asAggregatedQuery
			fields: self targetFieldCollectQuery fields;
			groupByFields: self targetFieldCollectQuery fields;
			yourself)!

conditionWithQuery: aQuery

	^self newCondition 
		field: self collectionSpec table idField 
		is: (SSWSQLOperator messageSelector: #includedIn:)
		to: aQuery asSubQuery!

currentMode

	"currentMode stores a Symbol indicating the mode in which the next message send will be interpreted - this denotes any special handling of the next message.
	Should be reset to nil after each message is processed"

	^currentMode!

currentMode: aSymbol

	"currentMode stores a Symbol indicating the mode in which the next message send will be interpreted - this denotes any special handling of the next message.
	Should be reset to nil after each message is processed"

	currentMode := aSymbol!

currentTable

	self error: 'not appropriate'!

finalField

	self parser qualifyingConditions: (self parser qualifyingConditions sqlAnd: self collectionParser qualifyingConditions).

	^self finalFieldFor: self targetTableFromParser!

finalFieldFor: aTable

	"Private - Derive a SQL function from the current mode"

	self currentMode = #size ifTrue: [^(SSWDBQueryTableField forField: aTable idField in: aTable) withFunction: (self reStore sqlDialect sqlFunctionFor: #count)].
	self currentMode = #first ifTrue: [^(SSWDBQueryIDField forTable: aTable) withFunction: (self reStore sqlDialect sqlFunctionFor: #minimum)].
	self currentMode = #last ifTrue: [^(SSWDBQueryIDField forTable: aTable) withFunction: (self reStore sqlDialect sqlFunctionFor: #maximum)].

	^self error: 'unknown function ', self currentMode!

first

	self currentMode: #first!

hasFinalField

	^#(#size #first #last) includes: self currentMode!

includes: anObject

	"Turn into an equivalent anySatisfy:"

	^self anySatisfy: [ :each | each _id = anObject]!

includesAssociation: anAssociation

	"For dictionaires - turn into an equivalent anySatisfy:"

	^self anySatisfy: [ :each | ((self collectionSpec keyAccessor value: each) = anAssociation key) & (each _id = anAssociation value)]!

includesKey: anObject

	"For dictionaires - turn into an equivalent anySatisfy:"

	^self anySatisfy: [ :each | (self collectionSpec keyAccessor value: each) = anObject]!

isEmpty

	"Return an appropriate subquery condition"

	self resetCurrentMode.

	^self newCondition 
		field: self collectionSpec table idField 
		is: ((SSWSQLOperator messageSelector: #includedIn:) invert; yourself)
		to: self targetFieldCollectQuery asSubQuery!

isKindOf: aClass 

	"Overriden due to 'odd' behaviour of #class in the receiver"

	^(Array 
		with: SSWDBCollectionBlockReceiver
		with: SSWDBGeneralCollectionBlockReceiver
		with: SSWDBOwnedCollectionBlockReceiver) includes: aClass!

last

	self currentMode: #last!

localSelectQueryFrom: aOneArgBlock

	"For subqueries on the collection which originate in the receiver only (hence the #local prefix) - this may have implications for subclasses"

	^self collectionParser selectQueryFrom: aOneArgBlock!

qualifyCollectionParserWith: aBlock

	self collectionParser qualifyWith: aBlock!

resetCurrentMode

	self currentMode: nil!

select: aBlock

	"Qualify the targerParser for further processing"

	self resetCurrentMode.

	self qualifyCollectionParserWith: aBlock.

	^self!

selectQueryFrom: aOneArgBlock

	"For subqueries on the collection, e.g. [ :person | person orders select: [ :each | ...]] - the latter block is the subquery block"

	^self collectionParser selectQueryFrom: aOneArgBlock!

size

	self currentMode: #size!

targetField

	"Return the field which represents the target object of (actual member of) the collection"

	^self subclassResponsibility!

targetFieldCollectQuery

	"Return a collect: query for returning the target field from the collection"

	^self subclassResponsibility!

targetTableFromParser

	"Ensure the target collection table is included in the parser.
	Return the table, aliased if necessary"

	^self subclassResponsibility!

validateSizeMode

	self currentMode = #size ifFalse: [self error: 'comparison message received when not in #size mode'].
	self resetCurrentMode! !
!SSWDBCollectionBlockReceiver categoriesForMethods!
~=!parsing-comparisons!public! !
<=!parsing-comparisons!public! !
=!parsing-comparisons!public! !
>!parsing-comparisons!public! !
>=!parsing-comparisons!public! !
anySatisfy:!parsing-collection messages!public! !
collection!accessing!public! !
collectionParser!accessing!public! !
collectionSpec!accessing!public! !
collectionSpec:!accessing!public! !
conditionWithAggregatedQuery:!helpers!private! !
conditionWithQuery:!helpers!private! !
currentMode!accessing!public! !
currentMode:!accessing!public! !
currentTable!accessing!public! !
finalField!accessing!public! !
finalFieldFor:!helpers!private! !
first!parsing-collection messages!public! !
hasFinalField!public!testing! !
includes:!parsing-collection messages!public! !
includesAssociation:!parsing-collection messages!public! !
includesKey:!parsing-collection messages!public! !
isEmpty!parsing-collection messages!public! !
isKindOf:!public!testing! !
last!parsing-collection messages!public! !
localSelectQueryFrom:!helpers!private! !
qualifyCollectionParserWith:!helpers!private! !
resetCurrentMode!helpers!private! !
select:!parsing-collection messages!public! !
selectQueryFrom:!helpers!private! !
size!parsing-collection messages!public! !
targetField!accessing!public! !
targetFieldCollectQuery!accessing!public! !
targetTableFromParser!accessing!public! !
validateSizeMode!helpers!private! !
!


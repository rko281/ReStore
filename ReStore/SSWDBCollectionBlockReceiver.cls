"Filed out from Dolphin Smalltalk 7"!

SSWDBBlockEvaluator subclass: #SSWDBCollectionBlockReceiver
	instanceVariableNames: 'collectionSpec collection'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBCollectionBlockReceiver guid: (GUID fromString: '{f3ba2a03-cc13-4840-b5f2-b0c421a00fd1}')!
SSWDBCollectionBlockReceiver comment: ''!
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

currentTable

	self error: 'not appropriate'!

finalField

	self parser qualifyingConditions: self collectionParser qualifyingConditions.

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

isEmpty

	"Return an appropriate subquery condition"

	self resetCurrentMode.

	^self newCondition 
		field: self collectionSpec table idField 
		is: ((SSWSQLOperator messageSelector: #includedIn:) invert; yourself)
		to: self targetFieldCollectQuery asSubQuery!

last

	self currentMode: #last!

localSelectQueryFrom: aOneArgBlock

	"For subqueries on the collection which originate in the receiver only (hence the #local prefix) - this may have implications for subclasses"

	^self collectionParser selectQueryFrom: aOneArgBlock!

qualifyCollectionParserWith: aBlock

	self collectionParser qualifyWith: aBlock!

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
!SSWDBCollectionBlockReceiver categoriesFor: #~=!parsing-comparisons!public! !
!SSWDBCollectionBlockReceiver categoriesFor: #<=!parsing-comparisons!public! !
!SSWDBCollectionBlockReceiver categoriesFor: #=!parsing-comparisons!public! !
!SSWDBCollectionBlockReceiver categoriesFor: #>!parsing-comparisons!public! !
!SSWDBCollectionBlockReceiver categoriesFor: #>=!parsing-comparisons!public! !
!SSWDBCollectionBlockReceiver categoriesFor: #anySatisfy:!parsing-collection messages!public! !
!SSWDBCollectionBlockReceiver categoriesFor: #collection!accessing!public! !
!SSWDBCollectionBlockReceiver categoriesFor: #collectionParser!accessing!public! !
!SSWDBCollectionBlockReceiver categoriesFor: #collectionSpec!accessing!public! !
!SSWDBCollectionBlockReceiver categoriesFor: #collectionSpec:!accessing!public! !
!SSWDBCollectionBlockReceiver categoriesFor: #conditionWithAggregatedQuery:!helpers!private! !
!SSWDBCollectionBlockReceiver categoriesFor: #conditionWithQuery:!helpers!private! !
!SSWDBCollectionBlockReceiver categoriesFor: #currentTable!accessing!public! !
!SSWDBCollectionBlockReceiver categoriesFor: #finalField!accessing!public! !
!SSWDBCollectionBlockReceiver categoriesFor: #finalFieldFor:!helpers!private! !
!SSWDBCollectionBlockReceiver categoriesFor: #first!parsing-collection messages!public! !
!SSWDBCollectionBlockReceiver categoriesFor: #hasFinalField!public!testing! !
!SSWDBCollectionBlockReceiver categoriesFor: #includes:!parsing-collection messages!public! !
!SSWDBCollectionBlockReceiver categoriesFor: #isEmpty!parsing-collection messages!public! !
!SSWDBCollectionBlockReceiver categoriesFor: #last!parsing-collection messages!public! !
!SSWDBCollectionBlockReceiver categoriesFor: #localSelectQueryFrom:!helpers!private! !
!SSWDBCollectionBlockReceiver categoriesFor: #qualifyCollectionParserWith:!helpers!private! !
!SSWDBCollectionBlockReceiver categoriesFor: #select:!parsing-collection messages!public! !
!SSWDBCollectionBlockReceiver categoriesFor: #selectQueryFrom:!helpers!private! !
!SSWDBCollectionBlockReceiver categoriesFor: #size!parsing-collection messages!public! !
!SSWDBCollectionBlockReceiver categoriesFor: #targetField!accessing!public! !
!SSWDBCollectionBlockReceiver categoriesFor: #targetFieldCollectQuery!accessing!public! !
!SSWDBCollectionBlockReceiver categoriesFor: #targetTableFromParser!accessing!public! !
!SSWDBCollectionBlockReceiver categoriesFor: #validateSizeMode!helpers!private! !


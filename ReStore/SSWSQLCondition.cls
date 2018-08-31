"Filed out from Dolphin Smalltalk 7"!

SSWSQLFieldValueConjunction subclass: #SSWSQLCondition
	instanceVariableNames: 'operator'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLCondition guid: (GUID fromString: '{6266c929-3983-11d5-b1df-444553540000}')!
SSWSQLCondition comment: 'Copyright 2000/2001 Solutions Software Limited'!
!SSWSQLCondition categoriesForClass!Unclassified! !
!SSWSQLCondition methodsFor!

& aCondition

	"Double-dispatch to handle unexpected arguments"

	^aCondition sqlAndWithCondition: self!

| aCondition

	"Double-dispatch to handle unexpected arguments"

	^aCondition sqlOrWithCondition: self!

= anSSWSQLCondition

	"Class test necessary for when the receiver is used as a result field in a query - in this case the receiver may be compared to a DBField"
	^anSSWSQLCondition class = ##(self) and: [super = anSSWSQLCondition and: [self operator = anSSWSQLCondition operator]]!

aggregatedConditions

	^self hasAggregateFunction
		ifTrue: [self newCollection add: self; yourself]
		ifFalse: [self newCollection beAND]!

anySatisfy: aBlock

	"21/3/2001
	
	Make the receiver polymorphic with an SQLConditionCollection"
	
	^aBlock value: self!

asFieldAssignment

	"17/9/2001"

	^SSWSQLFieldAssignment field: self field value: self value!

asOrderingSpec

	"Return the receiver as an OrderingSpec
	 - for this the value is ignored, as it is assumed to be equivalent to the field"

	^self operator orderingSpecFor: self field!

canInvertValue

	^(self value == true or: [self value == false]) and: [self operator isEquality or: [self operator isInequality]]!

collect: aBlock

	"21/3/2001
	
	Make the receiver polymorphic with an SQLConditionCollection"
	
	^Array with: (aBlock value: self)!

do: aBlock

	"21/3/2001
	
	Make the receiver polymorphic with an SQLConditionCollection"
	
	^aBlock value: self!

field: anSSWDBField equalTo: aValue

	^self field: anSSWDBField is: SSWSQLOperator equals to: aValue!

field: anSSWDBField is: anSSWSQLOperator to: aValue

	^self
		field: anSSWDBField;
		operator: anSSWSQLOperator;
		value: aValue;
		yourself!

field: anSSWDBField value: aValue

	^self field: anSSWDBField is: SSWSQLOperator setValue to: aValue!

fieldOnly: anSSWDBField

	^self field: anSSWDBField is: nil to: nil!

flattened

	"Make the receiver polymorphic with an SQLConditionCollection"
	
	^Array with: self!

hasAggregateFunction

	^self field hasAggregateFunction!

isEmpty

	"21/3/2001
	
	Make the receiver polymorphic with an SQLConditionCollection"
	
	^false!

isFieldCollection

	"Polymorphic with SQLConditionCollection"

	^false!

isFieldOnly

	^self operator isNil and: [self value isNil]!

newCollection

	^SSWSQLConditionCollection new!

not

	"No operator for an implicit true expression"
	self isFieldOnly 
	ifTrue: 
		[self field: (self field withFunction: 'NOT(%1)' arguments: #())]
	ifFalse: 
		[self canInvertValue 
			ifTrue: [self value: self value not]
			ifFalse: [self operator invert]]!

operator

	"5/8/2000
	
	operator stores the comparison operation for this condition"
	
	^operator!

operator: anSSWSQLOperator

	"5/8/2000
	
	operator stores the comparison operation for this condition"
	
	operator := anSSWSQLOperator!

qAnd: aQueryBlockSection

	"Deprecated - can now use regular and: aBlock"
	#deprecated.
	^self sqlAnd: aQueryBlockSection value!

qOr: aQueryBlockSection

	"Deprecated - can now use regular or: aBlock"
	#deprecated.
	^self sqlOr: aQueryBlockSection value!

sqlAnd: aConditionOrCollection

	"5/8/2000
	
	Return an SQLConditionCollection consisting of the receiver ANDed with the given
	SQLCondition or SQLConditionCollection (the two are polymorphic)"

	^aConditionOrCollection isEmpty
	ifTrue:
		[self]
	ifFalse:
		[self newCollection
			beAND;
			add: self;
			add: aConditionOrCollection;
			yourself]!

sqlAndWithCondition: aConditionOrCollection

	"Double-despatch entry point"

	^aConditionOrCollection sqlAnd: self!

sqlOr: aConditionOrCollection

	"5/8/2000
	
	Return an SQLConditionCollection consisting of the receiver ORed with the given
	SQLCondition or SQLConditionCollection (the two are polymorphic)"

	^self newCollection
		beOR;
		add: self;
		add: aConditionOrCollection;
		yourself!

sqlOrWithCondition: aConditionOrCollection

	"Double-despatch entry point"

	^aConditionOrCollection sqlOr: self!

unaggregatedConditions

	^self hasAggregateFunction
		ifTrue: [self newCollection beAND]
		ifFalse: [self newCollection add: self; yourself]!

writeConjunctionSQLOn: aStream

	"Private - 5/8/2000"
	
	self operator writeSQLOn: aStream forTarget: self value!

writeSQLOn: aStream

	"Handle the special case where there is no operator or value (implicit true)"
	
	^self isFieldOnly
		ifTrue: [self writeFieldSQLOn: aStream]
		ifFalse: [super writeSQLOn: aStream]! !
!SSWSQLCondition categoriesFor: #&!evaluating!public! !
!SSWSQLCondition categoriesFor: #|!evaluating!public! !
!SSWSQLCondition categoriesFor: #=!comparing!public! !
!SSWSQLCondition categoriesFor: #aggregatedConditions!accessing!public! !
!SSWSQLCondition categoriesFor: #anySatisfy:!collection behavior!public! !
!SSWSQLCondition categoriesFor: #asFieldAssignment!evaluating!public! !
!SSWSQLCondition categoriesFor: #asOrderingSpec!evaluating!public! !
!SSWSQLCondition categoriesFor: #canInvertValue!public!testing! !
!SSWSQLCondition categoriesFor: #collect:!collection behavior!public! !
!SSWSQLCondition categoriesFor: #do:!collection behavior!public! !
!SSWSQLCondition categoriesFor: #field:equalTo:!initialize/release!public! !
!SSWSQLCondition categoriesFor: #field:is:to:!initialize/release!public! !
!SSWSQLCondition categoriesFor: #field:value:!initialize/release!public! !
!SSWSQLCondition categoriesFor: #fieldOnly:!initialize/release!public! !
!SSWSQLCondition categoriesFor: #flattened!collection behavior!public! !
!SSWSQLCondition categoriesFor: #hasAggregateFunction!public!testing! !
!SSWSQLCondition categoriesFor: #isEmpty!collection behavior!public! !
!SSWSQLCondition categoriesFor: #isFieldCollection!public!testing! !
!SSWSQLCondition categoriesFor: #isFieldOnly!public!testing! !
!SSWSQLCondition categoriesFor: #newCollection!accessing!public! !
!SSWSQLCondition categoriesFor: #not!evaluating!public! !
!SSWSQLCondition categoriesFor: #operator!accessing!public! !
!SSWSQLCondition categoriesFor: #operator:!accessing!public! !
!SSWSQLCondition categoriesFor: #qAnd:!evaluating!public! !
!SSWSQLCondition categoriesFor: #qOr:!evaluating!public! !
!SSWSQLCondition categoriesFor: #sqlAnd:!evaluating!public! !
!SSWSQLCondition categoriesFor: #sqlAndWithCondition:!evaluating!public! !
!SSWSQLCondition categoriesFor: #sqlOr:!evaluating!public! !
!SSWSQLCondition categoriesFor: #sqlOrWithCondition:!evaluating!public! !
!SSWSQLCondition categoriesFor: #unaggregatedConditions!accessing!public! !
!SSWSQLCondition categoriesFor: #writeConjunctionSQLOn:!output!private! !
!SSWSQLCondition categoriesFor: #writeSQLOn:!output!public! !

!SSWSQLCondition class methodsFor!

equals

	"6/8/2000"
	
	^self new
		!

field: anSSWDBField equalTo: aValue

	"6/8/2000"
	
	^self new field: anSSWDBField equalTo: aValue!

field: anSSWDBField greaterThan: aValue

	^self field: anSSWDBField is: SSWSQLOperator greaterThan to: aValue
!

field: anSSWDBField is: anSSWSQLOperator to: aValue

	"6/8/2000"
	
	^self new field: anSSWDBField is: anSSWSQLOperator to: aValue!

field: anSSWDBField value: aValue

	"21/1/2001"
	
	^self new field: anSSWDBField value: aValue!

fieldOnly: anSSWDBField

	"6/8/2000"
	
	^self new fieldOnly: anSSWDBField! !
!SSWSQLCondition class categoriesFor: #equals!instance creation!public! !
!SSWSQLCondition class categoriesFor: #field:equalTo:!instance creation!output!public! !
!SSWSQLCondition class categoriesFor: #field:greaterThan:!instance creation!output!public! !
!SSWSQLCondition class categoriesFor: #field:is:to:!instance creation!output!public! !
!SSWSQLCondition class categoriesFor: #field:value:!instance creation!output!public! !
!SSWSQLCondition class categoriesFor: #fieldOnly:!instance creation!output!public! !


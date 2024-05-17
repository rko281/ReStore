"Filed out from Dolphin Smalltalk"!

SSWSQLFieldValueConjunction subclass: #SSWSQLCondition
	instanceVariableNames: 'operator'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLCondition guid: (GUID fromString: '{6266c929-3983-11d5-b1df-444553540000}')!
SSWSQLCondition comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
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
	^anSSWSQLCondition class = SSWSQLCondition and: [super = anSSWSQLCondition and: [self operator = anSSWSQLCondition operator]]!

aggregatedConditions

	^self hasAggregateFunction
		ifTrue: [self newCollection add: self; yourself]
		ifFalse: [self newCollection beAND]!

anySatisfy: aBlock

	"Make the receiver polymorphic with an SQLConditionCollection"
	
	^aBlock value: self!

asFieldAssignment

	^SSWSQLFieldAssignment field: self field value: self value!

asOrderingSpec

	"Return the receiver as an OrderingSpec
	 - for this the value is ignored, as it is assumed to be equivalent to the field"

	^self operator orderingSpecFor: self field!

canInvertValue

	^(self value == true or: [self value == false]) and: [self operator isEquality or: [self operator isInequality]]!

collect: aBlock

	"Make the receiver polymorphic with an SQLConditionCollection"
	
	^Array with: (aBlock value: self)!

do: aBlock

	"Make the receiver polymorphic with an SQLConditionCollection"
	
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

	"Make the receiver polymorphic with an SQLConditionCollection"
	
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
		[self field: (self field withFunction: 'NOT(%1)' asSQLFunction arguments: #())]
	ifFalse: 
		[self canInvertValue 
			ifTrue: [self value: self value not]
			ifFalse: [self operator invert]]!

operator

	"operator stores the comparison operation for this condition"
	
	^operator!

operator: anSSWSQLOperator

	"operator stores the comparison operation for this condition"
	
	operator := anSSWSQLOperator!

sqlAnd: aConditionOrCollection

	"Return an SQLConditionCollection consisting of the receiver ANDed with the given
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

	"Return an SQLConditionCollection consisting of the receiver ORed with the given
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

	self operator writeSQLOn: aStream forTarget: self value!

writeSQLOn: aStream

	"Handle special cases"

	"1) Where there is no operator or value (implicit true)"
	self isFieldOnly ifTrue: [^self writeFieldSQLOn: aStream].

	"2) Empty IN condition"
	(self operator isIncludedIn and: [self value isEmpty]) ifTrue: 
		[^(self operator isInverted 
			ifTrue: [SSWSQLCondition field: self field equalTo: self field]
			ifFalse: [(SSWSQLCondition field: self field equalTo: self field) not]) writeSQLOn: aStream].

	^super writeSQLOn: aStream!

writeValueSQLOn: aStream

	self value writeSQLOn: aStream forCondition: self! !
!SSWSQLCondition categoriesForMethods!
&!evaluating!public! !
|!evaluating!public! !
=!comparing!public! !
aggregatedConditions!accessing!public! !
anySatisfy:!collection behavior!public! !
asFieldAssignment!evaluating!public! !
asOrderingSpec!evaluating!public! !
canInvertValue!public!testing! !
collect:!collection behavior!public! !
do:!collection behavior!public! !
field:equalTo:!initialize/release!public! !
field:is:to:!initialize/release!public! !
field:value:!initialize/release!public! !
fieldOnly:!initialize/release!public! !
flattened!collection behavior!public! !
hasAggregateFunction!public!testing! !
isEmpty!collection behavior!public! !
isFieldCollection!public!testing! !
isFieldOnly!public!testing! !
newCollection!accessing!public! !
not!evaluating!public! !
operator!accessing!public! !
operator:!accessing!public! !
sqlAnd:!evaluating!public! !
sqlAndWithCondition:!evaluating!public! !
sqlOr:!evaluating!public! !
sqlOrWithCondition:!evaluating!public! !
unaggregatedConditions!accessing!public! !
writeConjunctionSQLOn:!output!private! !
writeSQLOn:!output!public! !
writeValueSQLOn:!output!public! !
!

!SSWSQLCondition class methodsFor!

equals

	^self new
		!

field: anSSWDBField equalTo: aValue

	^self new field: anSSWDBField equalTo: aValue!

field: anSSWDBField is: anSSWSQLOperator to: aValue

	^self new field: anSSWDBField is: anSSWSQLOperator to: aValue!

field: anSSWDBField value: aValue

	^self new field: anSSWDBField value: aValue!

fieldOnly: anSSWDBField

	^self new fieldOnly: anSSWDBField! !
!SSWSQLCondition class categoriesForMethods!
equals!instance creation!public! !
field:equalTo:!instance creation!output!public! !
field:is:to:!instance creation!output!public! !
field:value:!instance creation!output!public! !
fieldOnly:!instance creation!output!public! !
!


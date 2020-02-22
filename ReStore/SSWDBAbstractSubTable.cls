"Filed out from Dolphin Smalltalk 7"!

SSWDBInheritedTable subclass: #SSWDBAbstractSubTable
	instanceVariableNames: 'rootClass classCondition'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBAbstractSubTable guid: (GUID fromString: '{b48d9a97-81aa-11d5-b1df-0010a70883e2}')!
SSWDBAbstractSubTable comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBAbstractSubTable categoriesForClass!Unclassified! !
!SSWDBAbstractSubTable methodsFor!

_classCondition

	^SSWSQLCondition field: self classField equalTo: self instanceClass!

classCondition

	"classCondition stores an SSWSQLCondition(Collection) which is applied to all SELECTs 
	on the receiver table, to ensure only instances of the receiver's instanceClass are selected"
	
	^classCondition ifNil: [classCondition := self _classCondition]!

defaultName

	"Overriden to use the rootClass name"
	
	^self sqlDialect transformClassName: self rootClass name!

forCreation

	"The receiver should not CREATE TABLE (its persistent superclass will take care of this).
	Return nil"
		
	^nil!

hasStaticConditions

	^true!

isRootTable

	^false!

registerClass

	"Objects created from this table are registered under the rootClass"

	^self rootClass!

rootClass

	"rootClass stores the Class which is the root of the persistent class hierarchy
	in which the receiver's instanceClass resides"
	
	^rootClass!

rootClass: aClass

	"rootClass stores the Class which is the root of the persistent class hierarchy
	in which the receiver's instanceClass resides"
	
	rootClass := aClass!

rootTable

	"For a sub-table, the root table is the table of the rootClass"

	^self reStore tableForClass: self rootClass!

sqlAndStaticConditionsWith: anSQLConditionCollection

	"Return the receiver's staticConditions ANDed with anSQLConditionCollection"
	
	"The receiver's staticConditions are redundant if there is a unique ID condition"
	^(anSQLConditionCollection anySatisfy: [ :cond | cond field = self idField and: [cond operator isEquality and: [cond value notNil]]]) 
		ifTrue: [anSQLConditionCollection]
		ifFalse: [self staticConditions sqlAnd: anSQLConditionCollection]!

staticConditions

	^self classCondition! !
!SSWDBAbstractSubTable categoriesFor: #_classCondition!accessing!private! !
!SSWDBAbstractSubTable categoriesFor: #classCondition!accessing!public! !
!SSWDBAbstractSubTable categoriesFor: #defaultName!evaluating!public! !
!SSWDBAbstractSubTable categoriesFor: #forCreation!evaluating!public! !
!SSWDBAbstractSubTable categoriesFor: #hasStaticConditions!public!testing! !
!SSWDBAbstractSubTable categoriesFor: #isRootTable!public!testing! !
!SSWDBAbstractSubTable categoriesFor: #registerClass!evaluating!public! !
!SSWDBAbstractSubTable categoriesFor: #rootClass!accessing!public! !
!SSWDBAbstractSubTable categoriesFor: #rootClass:!accessing!public! !
!SSWDBAbstractSubTable categoriesFor: #rootTable!evaluating!public! !
!SSWDBAbstractSubTable categoriesFor: #sqlAndStaticConditionsWith:!evaluating!public! !
!SSWDBAbstractSubTable categoriesFor: #staticConditions!public! !

!SSWDBAbstractSubTable class methodsFor!

forClass: aClass

	"Overriden to set the rootClass"
	
	^self new
		instanceClass: aClass;
		rootClass: aClass persistencyRootClass;
		yourself! !
!SSWDBAbstractSubTable class categoriesFor: #forClass:!instance creation!public! !


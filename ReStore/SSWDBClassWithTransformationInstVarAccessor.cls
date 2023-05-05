"Filed out from Dolphin Smalltalk"!

SSWInstVarAccessor subclass: #SSWDBClassWithTransformationInstVarAccessor
	instanceVariableNames: 'classWithTransformation'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBClassWithTransformationInstVarAccessor guid: (GUID fromString: '{b059285b-511c-4927-ad15-37817ab66cb4}')!
SSWDBClassWithTransformationInstVarAccessor comment: ''!
!SSWDBClassWithTransformationInstVarAccessor categoriesForClass!Unclassified! !
!SSWDBClassWithTransformationInstVarAccessor methodsFor!

classWithTransformation
	^classWithTransformation!

classWithTransformation: anObject
	classWithTransformation := anObject!

dbValue: valueObject in: anObject

	^self value: (classWithTransformation toImageTransformation cull: valueObject cull: anObject) in: anObject!

dbValueIn: anObject

	^classWithTransformation toDatabaseTransformation cull: (self valueIn: anObject) cull: anObject!

hasValueChangedIn: anObject fromValueIn: anotherObject

	^(classWithTransformation hasValueChangedBlock ifNotNil: [ :block | block value: anObject value: anotherObject]) 
		ifNil: [super hasValueChangedIn: anObject fromValueIn: anotherObject]!

valueIfChanged: valueObject in: targetObject
	
	| currentValue newValue |

	currentValue := self valueIn: targetObject.
	newValue := classWithTransformation toImageTransformation cull: valueObject cull: targetObject.

	^(currentValue _hasChangedFrom: newValue)
		ifTrue: [self value: newValue in: targetObject. true]
		ifFalse: [false]! !
!SSWDBClassWithTransformationInstVarAccessor categoriesForMethods!
classWithTransformation!accessing!private! !
classWithTransformation:!accessing!private! !
dbValue:in:!public! !
dbValueIn:!public! !
hasValueChangedIn:fromValueIn:!public!testing! !
valueIfChanged:in:!public! !
!


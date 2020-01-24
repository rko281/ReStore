"Filed out from Dolphin Smalltalk 7"!

SSWInstVarAccessor subclass: #SSWInlinedInstVarAccessor
	instanceVariableNames: 'inlinedAccessor inlinedClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWInlinedInstVarAccessor guid: (GUID fromString: '{5e5c5742-8564-414d-811e-2b73266cc582}')!
SSWInlinedInstVarAccessor comment: ''!
!SSWInlinedInstVarAccessor categoriesForClass!Unclassified! !
!SSWInlinedInstVarAccessor methodsFor!

accesses: aSymbol

	"Test whether the receiver itself directly (shallowly) accesses aSymbol.
	The inlinedAccessor's access path is not considered"

	^self accessesShallowly: aSymbol!

accessesDeeply: aSymbol

	"Return whether the receiver accesses an inst var named aSymbol at a level deeper than that tested for by #accesses:"

	^(self inlinedAccessor accesses: aSymbol) or: [self inlinedAccessor accessesDeeply: aSymbol]!

accessesShallowly: aSymbol

	"Return whether the receiver shallowly/immediately accesses an inst var named aSymbol.
	This is the type of access provided by the superclass"

	^super accesses: aSymbol!

copyValueIn: sourceObject to: targetObject

	"targetObject is a shallow copy of sourceObject; perform any additional copying necessary.
	The receiver needs to copy the inlined object if this hasn't already been done (i.e. by another inlined accessor on the same inst var), and pass on to its inlinedAccessor"

	| sourceValue targetValue |

	sourceValue := self shallowValueIn: sourceObject.
	sourceValue isNil ifTrue: [^self].

	targetValue := self shallowValueIn: targetObject.

	sourceValue == targetValue ifTrue: 
		[targetValue := sourceValue shallowCopy.
		self shallowValue: targetValue in: targetObject].

	self inlinedAccessor copyValueIn: sourceValue to: targetValue!

inlinedAccessor
	^inlinedAccessor!

inlinedAccessor: anObject
	inlinedAccessor := anObject!

inlinedClass
	^inlinedClass!

inlinedClass: anObject
	inlinedClass := anObject!

inlinedClassDeeply

	^self inlinedAccessor isInlined
		ifTrue: [self inlinedAccessor inlinedClassDeeply]
		ifFalse: [self inlinedClass]!

isInlined

	^true!

shallowValue: valueObject in: targetObject

	^super value: valueObject in: targetObject!

shallowValueIn: targetObject

	^super valueIn: targetObject!

value: valueObject in: targetObject

	| inlined |

	inlined := self shallowValueIn: targetObject.

	inlined isNil ifTrue: 
		[inlined := self inlinedClass new.
		self shallowValue: inlined in: targetObject].

	^self inlinedAccessor value: valueObject in: inlined!

valueIn: targetObject

	| inlined |

	inlined := self shallowValueIn: targetObject.

	^inlined isNil 
		ifTrue: [nil]
		ifFalse: [self inlinedAccessor valueIn: inlined]! !
!SSWInlinedInstVarAccessor categoriesFor: #accesses:!public!testing! !
!SSWInlinedInstVarAccessor categoriesFor: #accessesDeeply:!public!testing! !
!SSWInlinedInstVarAccessor categoriesFor: #accessesShallowly:!public!testing! !
!SSWInlinedInstVarAccessor categoriesFor: #copyValueIn:to:!evaluating!private! !
!SSWInlinedInstVarAccessor categoriesFor: #inlinedAccessor!accessing!private! !
!SSWInlinedInstVarAccessor categoriesFor: #inlinedAccessor:!accessing!private! !
!SSWInlinedInstVarAccessor categoriesFor: #inlinedClass!accessing!private! !
!SSWInlinedInstVarAccessor categoriesFor: #inlinedClass:!accessing!private! !
!SSWInlinedInstVarAccessor categoriesFor: #inlinedClassDeeply!accessing!public! !
!SSWInlinedInstVarAccessor categoriesFor: #isInlined!public!testing! !
!SSWInlinedInstVarAccessor categoriesFor: #shallowValue:in:!public!updating! !
!SSWInlinedInstVarAccessor categoriesFor: #shallowValueIn:!public!updating! !
!SSWInlinedInstVarAccessor categoriesFor: #value:in:!public!updating! !
!SSWInlinedInstVarAccessor categoriesFor: #valueIn:!public!updating! !


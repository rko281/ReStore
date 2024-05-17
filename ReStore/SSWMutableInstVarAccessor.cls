"Filed out from Dolphin Smallalk"!

SSWInstVarAccessor subclass: #SSWMutableInstVarAccessor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWMutableInstVarAccessor guid: (GUID fromString: '{f57a9342-65bc-4b95-8f0d-9389cdc4ad03}')!
SSWMutableInstVarAccessor comment: ''!
!SSWMutableInstVarAccessor categoriesForClass!Unclassified! !
!SSWMutableInstVarAccessor methodsFor!

copyValue: anObject in: targetObject

	"Since the receiver accesses mutable objects we must perform a copy"

	self value: anObject copy in: targetObject!

copyValueIn: sourceObject to: targetObject

	"Since the receiver accesses mutable objects we must perform a copy"

	self copyValue: (self valueIn: sourceObject) in: targetObject! !
!SSWMutableInstVarAccessor categoriesForMethods!
copyValue:in:!evaluating!public! !
copyValueIn:to:!evaluating!private! !
!


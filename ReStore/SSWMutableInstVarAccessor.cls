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

copyValueIn: sourceObject to: targetObject

	"Since the receiver accesses mutable objects we must perform a copy"

	self value: (self valueIn: sourceObject) copy in: targetObject! !
!SSWMutableInstVarAccessor categoriesForMethods!
copyValueIn:to:!evaluating!private! !
!


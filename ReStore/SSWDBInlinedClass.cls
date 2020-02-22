"Filed out from Dolphin Smalltalk 7"!

SSWDBClassWithInfo subclass: #SSWDBInlinedClass
	instanceVariableNames: 'inlinedClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBInlinedClass guid: (GUID fromString: '{ce0318ac-094e-492a-adde-c702b7d9de4e}')!
SSWDBInlinedClass comment: ''!
!SSWDBInlinedClass categoriesForClass!Unclassified! !
!SSWDBInlinedClass methodsFor!

defineAs: aSymbol in: aDBTable

	aDBTable define: aSymbol asInstVarHoldingInlined: self inlinedClass!

infoClass

	^self inlinedClass!

inlinedClass
	^inlinedClass!

inlinedClass: anObject
	inlinedClass := anObject! !
!SSWDBInlinedClass categoriesFor: #defineAs:in:!defining!public! !
!SSWDBInlinedClass categoriesFor: #infoClass!accessing!public! !
!SSWDBInlinedClass categoriesFor: #inlinedClass!accessing!private! !
!SSWDBInlinedClass categoriesFor: #inlinedClass:!accessing!private! !


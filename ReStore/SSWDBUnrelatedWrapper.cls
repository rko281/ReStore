"Filed out from Dolphin Smalltalk 7"!

SSWDBWrapper subclass: #SSWDBUnrelatedWrapper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBUnrelatedWrapper guid: (GUID fromString: '{92f64d6a-3558-43ba-8b01-ab771618d302}')!
SSWDBUnrelatedWrapper comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBUnrelatedWrapper categoriesForClass!Unclassified! !
!SSWDBUnrelatedWrapper methodsFor!

defineAs: aSymbol in: aDBTable

	"Define the wrapped object, making the resulting object unrelated"
		
	^(self unrelatedObject defineAs: aSymbol in: aDBTable) 
		beUnrelated;
		yourself!

unrelatedObject

	^self object! !
!SSWDBUnrelatedWrapper categoriesFor: #defineAs:in:!defining!public! !
!SSWDBUnrelatedWrapper categoriesFor: #unrelatedObject!accessing!public! !


"Filed out from Dolphin Smalltalk 7"!

SSWDBWrapper subclass: #SSWDBRelatedWrapper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBRelatedWrapper guid: (GUID fromString: '{25844f78-1961-429a-abcb-613bf3af8389}')!
SSWDBRelatedWrapper comment: ''!
!SSWDBRelatedWrapper categoriesForClass!Unclassified! !
!SSWDBRelatedWrapper methodsFor!

defineAs: aSymbol in: aDBTable

	"Define the wrapped object, making the resulting object related"
		
	^(self relatedObject defineAs: aSymbol in: aDBTable) 
		beRelated;
		yourself!

relatedObject

	^self object! !
!SSWDBRelatedWrapper categoriesFor: #defineAs:in:!defining!public! !
!SSWDBRelatedWrapper categoriesFor: #relatedObject!accessing!public! !


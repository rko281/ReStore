"Filed out from Dolphin Smalltalk 7"!

SSWDBRelatedWrapper subclass: #SSWDBDependentWrapper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBDependentWrapper guid: (GUID fromString: '{61531103-b0e9-11d5-b1e0-444553540000}')!
SSWDBDependentWrapper comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBDependentWrapper categoriesForClass!Unclassified! !
!SSWDBDependentWrapper methodsFor!

defineAs: aSymbol in: aDBTable

	"Define the wrapped object, making the resulting object dependent"
		
	^(super defineAs: aSymbol in: aDBTable) 
		beDependent;
		yourself!

dependentObject

	"dependentObject stores the object for which the receiver represents a database-dependent variant.
	'dependent' in this sense means the object is dependent on another object for its existence in a DB"

	^self object! !
!SSWDBDependentWrapper categoriesFor: #defineAs:in:!defining!public! !
!SSWDBDependentWrapper categoriesFor: #dependentObject!accessing!public! !


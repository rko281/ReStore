"Filed out from Dolphin Smalltalk 7"!

SSWDBAbstractSubTable subclass: #SSWDBSubTable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBSubTable guid: (GUID fromString: '{266e4dce-398e-11d5-b1df-444553540000}')!
SSWDBSubTable comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBSubTable categoriesForClass!Unclassified! !
!SSWDBSubTable methodsFor!

withAllFields

	"Return a table equivalent to the receiver but containing all possible fields.	
	For a subtable (not inherited further) can optimise this back to just the receiver"

	^self! !
!SSWDBSubTable categoriesFor: #withAllFields!evaluating!public! !


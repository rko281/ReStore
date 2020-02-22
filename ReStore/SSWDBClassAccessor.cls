"Filed out from Dolphin Smalltalk 7"!

SSWDBPrivateAccessor subclass: #SSWDBClassAccessor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBClassAccessor guid: (GUID fromString: '{266e4dc3-398e-11d5-b1df-444553540000}')!
SSWDBClassAccessor comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBClassAccessor categoriesForClass!Unclassified! !
!SSWDBClassAccessor methodsFor!

nameInDB

	^#instClass_!

specialSymbol

	^#class!

value: valueObject in: targetObject

	"The receiver 'accesses' the class of objects - cannot be changed"
	
	^self!

valueIn: anObject

	"The receiver 'accesses' the class of objects.
	anObject should be DBproxy-wrapped"
	
	^anObject class! !
!SSWDBClassAccessor categoriesFor: #nameInDB!constants!public! !
!SSWDBClassAccessor categoriesFor: #specialSymbol!constants!public! !
!SSWDBClassAccessor categoriesFor: #value:in:!public!updating! !
!SSWDBClassAccessor categoriesFor: #valueIn:!evaluating!public! !


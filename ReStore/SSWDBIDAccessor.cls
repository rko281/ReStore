"Filed out from Dolphin Smalltalk"!

SSWDBPrivateAccessor subclass: #SSWDBIDAccessor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBIDAccessor guid: (GUID fromString: '{266e4dc4-398e-11d5-b1df-444553540000}')!
SSWDBIDAccessor comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBIDAccessor categoriesForClass!Unclassified! !
!SSWDBIDAccessor methodsFor!

nameInDB

	^#id_!

specialSymbol

	"Accesses _id (unique ID) - this is a method defined by the object proxy"

	^#_id!

valueIn: anObject

	"The receiver accesses the unique ID of objects.
	anObject should be DBproxy-wrapped"
	
	^anObject _id! !
!SSWDBIDAccessor categoriesForMethods!
nameInDB!constants!public! !
specialSymbol!constants!public! !
valueIn:!evaluating!public! !
!


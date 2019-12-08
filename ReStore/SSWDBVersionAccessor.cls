"Filed out from Dolphin Smalltalk 7"!

SSWDBPrivateAccessor subclass: #SSWDBVersionAccessor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBVersionAccessor guid: (GUID fromString: '{266e4dc5-398e-11d5-b1df-444553540000}')!
SSWDBVersionAccessor comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBVersionAccessor categoriesForClass!Unclassified! !
!SSWDBVersionAccessor methodsFor!

nameInDB

	^#version_!

specialSymbol

	"Accesses _version - this is a method defined by the object proxy"

	^#_version!

value: valueObject in: targetObject

	"The receiver accesses the version number of objects.
	targetObject should be DBproxy-wrapped"
	
	targetObject _version: valueObject!

valueIn: anObject

	"The receiver accesses the version number of objects.
	anObject should be DBproxy-wrapped"
	
	^anObject _version! !
!SSWDBVersionAccessor categoriesFor: #nameInDB!constants!public! !
!SSWDBVersionAccessor categoriesFor: #specialSymbol!constants!public! !
!SSWDBVersionAccessor categoriesFor: #value:in:!public!updating! !
!SSWDBVersionAccessor categoriesFor: #valueIn:!evaluating!public! !


"Filed out from Dolphin Smallalk"!

SSWDBPrivateAccessor subclass: #SSWDBIDAccessor
	instanceVariableNames: 'instanceAccessor'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBIDAccessor guid: (GUID fromString: '{266e4dc4-398e-11d5-b1df-444553540000}')!
SSWDBIDAccessor comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBIDAccessor categoriesForClass!Unclassified! !
!SSWDBIDAccessor methodsFor!

accesses: aSymbol

	"Additionally check the instanceAccessor"
	
	^(super accesses: aSymbol) or: 
		[self instanceAccessor notNil and: [self instanceAccessor accesses: aSymbol]]!

instanceAccessor

	"instanceAccessor optionally stores an SSWInstVarAccessor that is used to assign 
	the ID value to actual persistent object instances (in addition to their proxy).

	By default this is nil - persistent objects do not normally store their ID
	If changed to a SSWInstVarAccessor, the ID value is assigned to an instance variable"

	^instanceAccessor!

instanceAccessor: anSSWAccessor

	"instanceAccessor optionally stores an SSWInstVarAccessor that is used to assign 
	the ID value to actual persistent object instances (in addition to their proxy).

	By default this is nil - persistent objects do not normally store their ID
	If changed to a SSWInstVarAccessor, the ID value is assigned to an instance variable"

	instanceAccessor := anSSWAccessor!

nameInDB

	^#id_!

specialSymbol

	"Accesses _id (unique ID) - this is a method defined by the object proxy"

	^#_id!

value: valueObject in: targetObject

	"The receiver accesses the unique ID of objects.
	However it never explicity sets the ID of a proxy (a proxy is created with this).
	Instead, it's instanceAccessor may set the ID within the persistent object itself"
	
	self instanceAccessor ~~ nil ifTrue: 
		[self instanceAccessor value: valueObject in: targetObject _proxiedObject].
	^valueObject!

valueIn: anObject

	"The receiver accesses the unique ID of objects.
	anObject should be DBproxy-wrapped"
	
	^anObject _id! !
!SSWDBIDAccessor categoriesForMethods!
accesses:!public!testing! !
instanceAccessor!accessing!public! !
instanceAccessor:!accessing!public! !
nameInDB!constants!public! !
specialSymbol!constants!public! !
value:in:!public!updating! !
valueIn:!evaluating!public! !
!


"Filed out from Dolphin Smalltalk"!

Object subclass: #SSWAccessor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWAccessor guid: (GUID fromString: '{266e4dc1-398e-11d5-b1df-444553540000}')!
SSWAccessor comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWAccessor categoriesForClass!Unclassified! !
!SSWAccessor methodsFor!

access: aSymbol in: aClass

	"Configure the receiver to access the inst var of aClass which is named aSymbol"
	
	self subclassResponsibility!

accesses: aSymbol

	"Return a Boolean indicating whether the receiver access the instance variable
	named aSymbol"
	
	^self subclassResponsibility!

dbValue: valueObject in: targetObject

	"Set the attribute of targetObject which the receiver accesses to valueObject, as returned from the database (but after initial conversions).
	Return the valueObject"
	
	^self value: valueObject in: targetObject!

dbValueIn: anObject

	"Extract and return the value of anObject which the receiver accesses, as it should be stored in aReStore.
	Default - same as normal valueIn: "
	
	^self valueIn: anObject!

hasValueChangedIn: anObject fromValueIn: anotherObject

	^(self valueIn: anObject) _hasChangedFrom: (self valueIn: anotherObject)!

isInlined

	^false!

name

	"Return the name of the inst var accessed by the receiver.
	Default - nil (unknown/undefined).
	Subclasses which can interpret this concept meaningfully should override"
	
	^nil!

value: valueObject in: targetObject

	"Set the attribute of targetObject which the receiver accesses to valueObject.
	Return the valueObject"
	
	self subclassResponsibility!

valueIfChanged: valueObject in: targetObject

	"Set the attribute of targetObject which the receiver accesses to valueObject, 
	if targetObject's current value for that attribute is different.
	Return whether it was updating or not"
	
	| currentValue |

	currentValue := self valueIn: targetObject.

	^(currentValue _hasChangedFrom: valueObject)
		ifTrue: [self value: valueObject in: targetObject. true]
		ifFalse: [false]!

valueIn: anObject

	"Extract and return the value of anObject which the receiver accesses"
	
	^self subclassResponsibility! !
!SSWAccessor categoriesForMethods!
access:in:!initializing!public! !
accesses:!public!testing! !
dbValue:in:!public!updating! !
dbValueIn:!evaluating!public! !
hasValueChangedIn:fromValueIn:!public!testing! !
isInlined!public!testing! !
name!evaluating!public! !
value:in:!public!updating! !
valueIfChanged:in:!public!updating! !
valueIn:!evaluating!public! !
!


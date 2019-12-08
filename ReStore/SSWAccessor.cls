"Filed out from Dolphin Smalltalk 7"!

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

name

	"Return the name of the inst var accessed by the receiver.
	Default - nil (unknown/undefined).
	Subclasses which can interpret this concept meaningfully should override"
	
	^nil!

value: valueObject in: targetObject

	"Set the attribute of targetObject which the receiver accesses to valueObject"
	
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
!SSWAccessor categoriesFor: #access:in:!initializing!public! !
!SSWAccessor categoriesFor: #accesses:!public!testing! !
!SSWAccessor categoriesFor: #name!evaluating!public! !
!SSWAccessor categoriesFor: #value:in:!public!updating! !
!SSWAccessor categoriesFor: #valueIfChanged:in:!public!updating! !
!SSWAccessor categoriesFor: #valueIn:!evaluating!public! !


"Filed out from Dolphin Smallalk"!

SSWAccessor subclass: #SSWInstVarAccessor
	instanceVariableNames: 'ownerClass slot name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWInstVarAccessor guid: (GUID fromString: '{266e4dc6-398e-11d5-b1df-444553540000}')!
SSWInstVarAccessor comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWInstVarAccessor categoriesForClass!Unclassified! !
!SSWInstVarAccessor methodsFor!

= anSSWAccessor

	^(self ownerClass = anSSWAccessor ownerClass) and: [self slot = anSSWAccessor slot]!

access: aSymbol in: aClass

	"Configure the receiver to access the inst var of aClass which is named aSymbol"
	
	| instVarName instVarSlot |

	"Veirfy a valid inst var slot"
	instVarName := aSymbol asInstVarName. "in case aSymbol is something else (e.g. SSWDBInstVarWithFieldName)"
	instVarSlot := aClass allInstVarNames indexOf: instVarName asString.
	instVarSlot < 1 ifTrue: [self error: ('Undefined instance variable ', aSymbol)].

	self 
		ownerClass: aClass;
		slot: instVarSlot;
		name: instVarName!

accesses: aSymbol

	^self name = aSymbol!

accessesDeeply: aSymbol

	^false!

copyValueIn: sourceObject to: targetObject

	"targetObject is a shallow copy of sourceObject.Perform any additional copying necessary.
	A no-op by default"

	^self!

hash

	^self ownerClass hash + self slot hash!

name

	"name stores the name of the instance variable accessed by the receiver,
	as a Symbol"
	
	^name!

name: aSymbol

	"name stores the name of the instance variable accessed by the receiver,
	as a Symbol"
	
	name := aSymbol!

ownerClass

	"ownerClass stores the class whose instance variable is accessed by the receiver"
	
	^ownerClass!

ownerClass: aClass

	"ownerClass stores the class whose instance variable is accessed by the receiver"
	
	ownerClass := aClass!

slot

	"slot stores the index of the instance variable accessed by the receiver"
	
	^slot!

slot: anInteger

	"slot stores the index of the instance variable accessed by the receiver"
	
	slot := anInteger!

value: targetObject

	"Polymorphic with Blocks and Messages"

	^targetObject perform: self name!

value: valueObject in: targetObject

	"Set the instance variable of targetObject represented by the receiver to valueObject"

	^targetObject _instVarAt: self slot put: valueObject!

valueIn: targetObject

	"Return the value of the instance variable of targetObject represented by the receiver"

	^targetObject _instVarAt: self slot! !
!SSWInstVarAccessor categoriesForMethods!
=!public!testing! !
access:in:!initializing!public! !
accesses:!public!testing! !
accessesDeeply:!public!testing! !
copyValueIn:to:!evaluating!private! !
hash!public!testing! !
name!accessing!public! !
name:!accessing!public! !
ownerClass!accessing!public! !
ownerClass:!accessing!public! !
slot!accessing!public! !
slot:!accessing!public! !
value:!evaluating!public! !
value:in:!public!updating! !
valueIn:!evaluating!public! !
!

!SSWInstVarAccessor class methodsFor!

toAccess: anInstVarName in: aClass

	^self new
		access: anInstVarName in: aClass;
		yourself! !
!SSWInstVarAccessor class categoriesForMethods!
toAccess:in:!instance creation!public! !
!


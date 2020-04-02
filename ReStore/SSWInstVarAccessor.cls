"Filed out from Dolphin Smalltalk 7"!

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
	
	| instVarSlot |

	"Veirfy a valid inst var slot"
	instVarSlot := aClass allInstVarNames indexOf: aSymbol asString.
	instVarSlot < 1 ifTrue: [self error: ('Undefined instance variable ', aSymbol)].

	self 
		ownerClass: aClass;
		slot: instVarSlot;
		name: aSymbol!

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

	^self valueIn: targetObject!

value: valueObject in: targetObject

	"Set the instance variable of targetObject represented by the receiver to valueObject"

	targetObject _instVarAt: self slot put: valueObject!

valueIn: targetObject

	"Return the value of the instance variable of targetObject represented by the receiver"

	^targetObject instVarAt: self slot! !
!SSWInstVarAccessor categoriesFor: #=!public!testing! !
!SSWInstVarAccessor categoriesFor: #access:in:!initializing!public! !
!SSWInstVarAccessor categoriesFor: #accesses:!public!testing! !
!SSWInstVarAccessor categoriesFor: #accessesDeeply:!public!testing! !
!SSWInstVarAccessor categoriesFor: #copyValueIn:to:!evaluating!private! !
!SSWInstVarAccessor categoriesFor: #hash!public!testing! !
!SSWInstVarAccessor categoriesFor: #name!accessing!public! !
!SSWInstVarAccessor categoriesFor: #name:!accessing!public! !
!SSWInstVarAccessor categoriesFor: #ownerClass!accessing!public! !
!SSWInstVarAccessor categoriesFor: #ownerClass:!accessing!public! !
!SSWInstVarAccessor categoriesFor: #slot!accessing!public! !
!SSWInstVarAccessor categoriesFor: #slot:!accessing!public! !
!SSWInstVarAccessor categoriesFor: #value:!evaluating!public! !
!SSWInstVarAccessor categoriesFor: #value:in:!public!updating! !
!SSWInstVarAccessor categoriesFor: #valueIn:!evaluating!public! !

!SSWInstVarAccessor class methodsFor!

toAccess: anInstVarName in: aClass

	^self new
		access: anInstVarName in: aClass;
		yourself! !
!SSWInstVarAccessor class categoriesFor: #toAccess:in:!instance creation!public! !


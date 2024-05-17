"Filed out from Dolphin Smallalk"!

SSWDBBlockArgument subclass: #SSWDBInlinedBlockReceiver
	instanceVariableNames: 'inlinedInstVar inlinedFields'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBInlinedBlockReceiver guid: (GUID fromString: '{6534619b-e978-4aad-936d-ae0d55dfab28}')!
SSWDBInlinedBlockReceiver comment: ''!
!SSWDBInlinedBlockReceiver categoriesForClass!Unclassified! !
!SSWDBInlinedBlockReceiver methodsFor!

_doesNotUnderstand: aMessage

	| result matchingFields |

	^aMessage argumentCount > 0 
	ifTrue: 
		[(aMessage selector last = $: and: [aMessage arguments size = 1])
		ifTrue:
			[self inlinedFields: (self inlinedFieldsAccessing: aMessage selector allButLast asSymbol).
			self hasFinalField
				ifTrue: [self sqlConditionFor: aMessage]
				ifFalse: [self parseError: 'unknown/ambiguous update']]
		ifFalse: 
			[self hasFinalField 
			ifTrue: 
				[result := super _doesNotUnderstand: aMessage. 
				self reset.
				result] 
			ifFalse: 
				[self simulateMessageSend: aMessage]]]
	ifFalse:
		[matchingFields := self inlinedFieldsAccessing: aMessage selector.
		matchingFields isEmpty
		ifTrue: 
			[super _doesNotUnderstand: aMessage]
		ifFalse: 
			[self inlinedFields: matchingFields.
			self]]!

currentClass

	^self inlinedFields first accessor inlinedClassDeeply!

finalField

	^self hasFinalField
		ifTrue: [self inlinedFields first]
		ifFalse: [self parseError: 'Parse error in inlined table']!

hasFinalField

	^self inlinedFields size = 1!

inlinedFields

	^inlinedFields ifNil: [inlinedFields := (self parser tableForClass: self rootClass) fieldsAccessing: self inlinedInstVar]
!

inlinedFields: anObject
	inlinedFields := anObject!

inlinedFieldsAccessing: aSymbol

	^self inlinedFields select: [ :each | each accessor accessesDeeply: aSymbol]!

inlinedInstVar
	^inlinedInstVar!

inlinedInstVar: anObject
	inlinedInstVar := anObject!

peekFinalField

	^self hasFinalField
		ifTrue: [self inlinedFields first]
		ifFalse: [nil]!

reset

	self inlinedFields: nil!

rootClass

	^super currentClass! !
!SSWDBInlinedBlockReceiver categoriesForMethods!
_doesNotUnderstand:!parsing!public! !
currentClass!accessing!public! !
finalField!accessing!public! !
hasFinalField!public!testing! !
inlinedFields!accessing!private! !
inlinedFields:!accessing!private! !
inlinedFieldsAccessing:!parsing!private! !
inlinedInstVar!accessing!private! !
inlinedInstVar:!accessing!private! !
peekFinalField!accessing!public! !
reset!parsing!private! !
rootClass!accessing!private! !
!


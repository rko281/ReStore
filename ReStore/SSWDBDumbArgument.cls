"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SSWDBDumbArgument
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'current'!
SSWDBDumbArgument guid: (GUID fromString: '{995c23ce-d02c-4c8e-9181-111c48934fbb}')!
SSWDBDumbArgument comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBDumbArgument categoriesForClass!Kernel-Objects! !
!SSWDBDumbArgument methodsFor!

_id

	"Avoid the superclass implementation"

	^self!

doesNotUnderstand: aMessage
	"The receiver is deaf to all requests. Answer the current instance to ensure that our answers are also dumb"
	
	^self class current! !
!SSWDBDumbArgument categoriesFor: #_id!accessing!public! !
!SSWDBDumbArgument categoriesFor: #doesNotUnderstand:!exceptions!public! !

!SSWDBDumbArgument class methodsFor!

current

	^current ifNil: [current := self new]!

icon

	^DeafObject icon!

reset

	current := nil! !
!SSWDBDumbArgument class categoriesFor: #current!accessing!public! !
!SSWDBDumbArgument class categoriesFor: #icon!accessing!public! !
!SSWDBDumbArgument class categoriesFor: #reset!initialize!public! !


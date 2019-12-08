"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SSWSQLParameterField
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLParameterField guid: (GUID fromString: '{00cf3b48-f1cf-4a29-a262-f00fff5d5b9e}')!
SSWSQLParameterField comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLParameterField categoriesForClass!Kernel-Objects! !
!SSWSQLParameterField methodsFor!

canBeParameterized

	^true!

value
	^value!

value: anObject
	value := anObject! !
!SSWSQLParameterField categoriesFor: #canBeParameterized!public!testing! !
!SSWSQLParameterField categoriesFor: #value!accessing!private! !
!SSWSQLParameterField categoriesFor: #value:!accessing!private! !

!SSWSQLParameterField class methodsFor!

forValue: anObject

	^self new
		value: anObject;
		yourself! !
!SSWSQLParameterField class categoriesFor: #forValue:!instance creation!public! !


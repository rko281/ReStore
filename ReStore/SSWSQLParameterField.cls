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

requiresAliasing

	^true!

value
	^value!

value: anObject
	value := anObject!

writeAliasedSQLOn: aStream

	"For situations where duplicate field names are anticipated
	- write the SQL of the receiver on aStream, but use aliased names to force uniqueness"
	
	aStream nextPutAliasedField: self!

writeSQLOn: aStream

	^self value writeSQLOn: aStream forField: self! !
!SSWSQLParameterField categoriesFor: #canBeParameterized!public!testing! !
!SSWSQLParameterField categoriesFor: #requiresAliasing!public!testing! !
!SSWSQLParameterField categoriesFor: #value!accessing!private! !
!SSWSQLParameterField categoriesFor: #value:!accessing!private! !
!SSWSQLParameterField categoriesFor: #writeAliasedSQLOn:!printing!public! !
!SSWSQLParameterField categoriesFor: #writeSQLOn:!printing!public! !

!SSWSQLParameterField class methodsFor!

forValue: anObject

	^self new
		value: anObject;
		yourself! !
!SSWSQLParameterField class categoriesFor: #forValue:!instance creation!public! !


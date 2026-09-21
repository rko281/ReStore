"Filed out from Dolphin Smalltalk"!

Object subclass: #SSWSQLHardCodedParameter
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWSQLHardCodedParameter guid: (GUID fromString: '{75daebb7-07ef-47d0-977d-5caa376fa0bb}')!

SSWSQLHardCodedParameter comment: ''!

!SSWSQLHardCodedParameter categoriesForClass!Unclassified! !

!SSWSQLHardCodedParameter methodsFor!

isSQLNull

	^self value isNil!

sqlCanBeParameterized

	"I am hard-coded"
	^false!

value
	^value!

value: anObject
	value := anObject!

writeSQLOn: aStream

	self value writeHardCodedSQLOn: aStream! !

!SSWSQLHardCodedParameter categoriesForMethods!
isSQLNull!public!testing! !
sqlCanBeParameterized!public!testing! !
value!accessing!private! !
value:!accessing!private! !
writeSQLOn:!printing!public! !
!

!SSWSQLHardCodedParameter class methodsFor!

value: anObject

	^self new 
		value: anObject;
		yourself! !

!SSWSQLHardCodedParameter class categoriesForMethods!
value:!instance creation!public! !
!


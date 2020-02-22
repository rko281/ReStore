"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SSWSQLFieldValueConjunction
	instanceVariableNames: 'field value'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLFieldValueConjunction guid: (GUID fromString: '{6266c928-3983-11d5-b1df-444553540000}')!
SSWSQLFieldValueConjunction comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLFieldValueConjunction categoriesForClass!Unclassified! !
!SSWSQLFieldValueConjunction methodsFor!

= anSSWSQLFieldValueConjunction

	^self field = anSSWSQLFieldValueConjunction field and: [self value = anSSWSQLFieldValueConjunction value]!

field

	"field stores the single field which is the subject of the receiver SQL clause"
	
	^field!

field: anSSWSQLField

	"field stores the single field which is the subject of the receiver SQL clause"
	
	field := anSSWSQLField!

hash

	^self field hash
!

value

	"value stores an object which is associated with the field in the receiver clause"
	
	^value!

value: anObject

	"value stores an object which is associated with the field in the receiver clause"

	value := anObject!

writeConjunctionSQLOn: aStream

	"Append to aStream whatever String/Character joins
	the receiver's field to the receiver's value"
	
	self subclassResponsibility!

writeFieldSQLOn: aStream

	self field writeSQLOn: aStream!

writeSQLOn: aStream

	self writeFieldSQLOn: aStream.
	aStream space.
	self writeConjunctionSQLOn: aStream.
	aStream space.
	self writeValueSQLOn: aStream!

writeValueSQLOn: aStream

	self value writeSQLOn: aStream forField: self field! !
!SSWSQLFieldValueConjunction categoriesFor: #=!comparing!public! !
!SSWSQLFieldValueConjunction categoriesFor: #field!accessing!public! !
!SSWSQLFieldValueConjunction categoriesFor: #field:!accessing!public! !
!SSWSQLFieldValueConjunction categoriesFor: #hash!comparing!public! !
!SSWSQLFieldValueConjunction categoriesFor: #value!accessing!public! !
!SSWSQLFieldValueConjunction categoriesFor: #value:!accessing!public! !
!SSWSQLFieldValueConjunction categoriesFor: #writeConjunctionSQLOn:!output!private! !
!SSWSQLFieldValueConjunction categoriesFor: #writeFieldSQLOn:!output!private! !
!SSWSQLFieldValueConjunction categoriesFor: #writeSQLOn:!output!public! !
!SSWSQLFieldValueConjunction categoriesFor: #writeValueSQLOn:!output!private! !

!SSWSQLFieldValueConjunction class methodsFor!

field: anSSWDBField value: aValue

	^self new
		field: anSSWDBField;
		value: aValue;
		yourself! !
!SSWSQLFieldValueConjunction class categoriesFor: #field:value:!instance creation!public! !


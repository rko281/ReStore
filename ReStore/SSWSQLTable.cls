"Filed out from Dolphin Smalltalk"!

Object subclass: #SSWSQLTable
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLTable guid: (GUID fromString: '{767240f7-a555-11d5-b1e0-444553540000}')!
SSWSQLTable comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLTable categoriesForClass!Unclassified! !
!SSWSQLTable methodsFor!

= anSSWSQLTable

	^self == anSSWSQLTable or: [self name = anSSWSQLTable name]!

displayOn: aStream

	aStream nextPutAll: self name!

hash

	^self name hash!

hasStaticConditions

	"Return a Boolean indicating if the receiver table has any SSWSQLConditions which are always applied when SELECTing from the receiver table.
	Unlike conditions that may be derived from other fields these conditions do not vary from object to object - they are static for all reads from this table.
	
	Default - false. Subclasses returning true should implement staticConditions accordingly"
	
	^false!

name

	"name stores the name of this table"
		
	^name
!

name: aString

	"name stores the name of this table"
	
	name := aString
!

postCreate

	"Private - Carry out an actions necessary after the receiver has been fully created"!

printOn: aStream

	super printOn: aStream.
	aStream 
		nextPutAll: ' (';
		display: self;
		nextPut: $)!

writeSQLNameOn: aStream

	aStream nextPutIdentifier: self name
!

writeSQLOn: aStream

	self writeSQLNameOn: aStream
! !
!SSWSQLTable categoriesForMethods!
=!comparing!public! !
displayOn:!displaying!public! !
hash!comparing!public! !
hasStaticConditions!public!testing! !
name!accessing!public! !
name:!accessing!public! !
postCreate!initializing!private! !
printOn:!displaying!public! !
writeSQLNameOn:!output!public! !
writeSQLOn:!output!public! !
!


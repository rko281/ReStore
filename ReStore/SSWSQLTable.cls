"Filed out from Dolphin Smalltalk 7"!

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
!SSWSQLTable categoriesFor: #=!comparing!public! !
!SSWSQLTable categoriesFor: #displayOn:!displaying!public! !
!SSWSQLTable categoriesFor: #hash!comparing!public! !
!SSWSQLTable categoriesFor: #hasStaticConditions!public!testing! !
!SSWSQLTable categoriesFor: #name!accessing!public! !
!SSWSQLTable categoriesFor: #name:!accessing!public! !
!SSWSQLTable categoriesFor: #printOn:!displaying!public! !
!SSWSQLTable categoriesFor: #writeSQLNameOn:!output!public! !
!SSWSQLTable categoriesFor: #writeSQLOn:!output!public! !


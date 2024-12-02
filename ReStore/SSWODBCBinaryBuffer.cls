"Filed out from Dolphin Smalltalk"!

DBBinaryBuffer subclass: #SSWODBCBinaryBuffer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWODBCBinaryBuffer guid: (GUID fromString: '{5e577cff-e8c3-4349-ad5f-375a7749d943}')!

SSWODBCBinaryBuffer comment: ''!

!SSWODBCBinaryBuffer categoriesForClass!Unclassified! !

!SSWODBCBinaryBuffer methodsFor!

dbConvert: anObject for: aDBField
	
	^super dbConvert: anObject asByteArray for: aDBField ! !

!SSWODBCBinaryBuffer categoriesForMethods!
dbConvert:for:!operations!public! !
!


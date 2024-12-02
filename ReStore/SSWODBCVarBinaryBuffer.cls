"Filed out from Dolphin Smalltalk"!

DBVarBinaryBuffer subclass: #SSWODBCVarBinaryBuffer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWODBCVarBinaryBuffer guid: (GUID fromString: '{8a753b85-9c80-409f-836a-4f709f7de78f}')!

SSWODBCVarBinaryBuffer comment: ''!

!SSWODBCVarBinaryBuffer categoriesForClass!Kernel-Objects! !

!SSWODBCVarBinaryBuffer methodsFor!

dbConvert: anObject for: aDBField
	
	^super dbConvert: anObject asByteArray for: aDBField ! !

!SSWODBCVarBinaryBuffer categoriesForMethods!
dbConvert:for:!operations!public! !
!


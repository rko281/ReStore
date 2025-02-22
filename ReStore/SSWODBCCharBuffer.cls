"Filed out from Dolphin Smalltalk"!

DBCharBuffer subclass: #SSWODBCCharBuffer
	instanceVariableNames: 'reStore'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWODBCCharBuffer guid: (GUID fromString: '{95d12899-ff81-4b3d-a593-480bdd582673}')!

SSWODBCCharBuffer comment: ''!

!SSWODBCCharBuffer categoriesForClass!Unclassified! !

!SSWODBCCharBuffer methodsFor!

dbUnmarshal: aDBField

	^self dbUnmarshalCharBuffer: aDBField in: reStore!

initializeForColumn: anSSWODBCColAttr

	super initializeForColumn: anSSWODBCColAttr.
	anSSWODBCColAttr field ifNotNil: [ :field | reStore := field reStore]! !

!SSWODBCCharBuffer categoriesForMethods!
dbUnmarshal:!operations!public! !
initializeForColumn:!initializing!public! !
!


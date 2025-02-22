"Filed out from Dolphin Smalltalk"!

DBWCharBuffer subclass: #SSWODBCWCharBuffer
	instanceVariableNames: 'reStore'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWODBCWCharBuffer guid: (GUID fromString: '{79162aff-c562-4095-bbaa-0d54d02188b0}')!

SSWODBCWCharBuffer comment: ''!

!SSWODBCWCharBuffer categoriesForClass!Unclassified! !

!SSWODBCWCharBuffer methodsFor!

dbUnmarshal: aDBField

	^self dbUnmarshalCharBuffer: aDBField in: reStore!

initializeForColumn: anSSWODBCColAttr

	super initializeForColumn: anSSWODBCColAttr.
	anSSWODBCColAttr field ifNotNil: [ :field | reStore := field reStore]! !

!SSWODBCWCharBuffer categoriesForMethods!
dbUnmarshal:!operations!public! !
initializeForColumn:!initializing!public! !
!


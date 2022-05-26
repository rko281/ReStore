"Filed out from Dolphin Smallalk"!

SSWDBInstVarDefinition subclass: #SSWDBRenamedInstVar
	instanceVariableNames: 'previousName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBRenamedInstVar guid: (GUID fromString: '{6e0dbe28-74b2-4798-b014-42a4157e9a7e}')!
SSWDBRenamedInstVar comment: ''!
!SSWDBRenamedInstVar categoriesForClass!Kernel-Objects! !
!SSWDBRenamedInstVar methodsFor!

databaseFieldNameIn: anSSWDBTable

	"Base the field name on the previousName"

	^anSSWDBTable dbNameFor: self previousName!

previousName
	^previousName!

previousName: anObject
	previousName := anObject! !
!SSWDBRenamedInstVar categoriesForMethods!
databaseFieldNameIn:!accessing!public! !
previousName!accessing!private! !
previousName:!accessing!private! !
!


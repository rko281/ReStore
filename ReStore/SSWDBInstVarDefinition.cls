"Filed out from Dolphin Smallalk"!

Object subclass: #SSWDBInstVarDefinition
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBInstVarDefinition guid: (GUID fromString: '{1631d2c4-3474-4bb3-ab9f-ccfa576872c6}')!
SSWDBInstVarDefinition comment: ''!
!SSWDBInstVarDefinition categoriesForClass!Kernel-Objects! !
!SSWDBInstVarDefinition methodsFor!

asInstVarName

	^self name!

databaseFieldNameIn: anSSWDBTable

	"Return the corresponding field name of this inst var in anSSWDBTable"

	^anSSWDBTable dbNameFor: self name!

name
	^name!

name: anObject
	name := anObject! !
!SSWDBInstVarDefinition categoriesForMethods!
asInstVarName!converting!public! !
databaseFieldNameIn:!accessing!public! !
name!accessing!private! !
name:!accessing!private! !
!

!SSWDBInstVarDefinition class methodsFor!

name: aSymbol

	^self new
		name: aSymbol;
		yourself! !
!SSWDBInstVarDefinition class categoriesForMethods!
name:!instance creation!public! !
!


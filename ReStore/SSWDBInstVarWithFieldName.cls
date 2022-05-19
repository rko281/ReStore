"Filed out from Dolphin Smallalk"!

Object subclass: #SSWDBInstVarWithFieldName
	instanceVariableNames: 'instVar fieldName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBInstVarWithFieldName guid: (GUID fromString: '{75038fd6-5eee-46d2-9dc2-bed65dcc8fc3}')!
SSWDBInstVarWithFieldName comment: ''!
!SSWDBInstVarWithFieldName categoriesForClass!Kernel-Objects! !
!SSWDBInstVarWithFieldName methodsFor!

asDatabaseFieldNameIn: anSSWDBTable

	"Use the configured fieldName"

	^self fieldName!

asInstVarName

	^self instVar!

databaseFieldNameIn: anSSWDBTable

	"Use the configured fieldName"

	^self fieldName!

fieldName
	^fieldName!

fieldName: anObject
	fieldName := anObject!

instVar
	^instVar!

instVar: anObject
	instVar := anObject! !
!SSWDBInstVarWithFieldName categoriesForMethods!
asDatabaseFieldNameIn:!converting!public! !
asInstVarName!converting!public! !
databaseFieldNameIn:!converting!public! !
fieldName!accessing!private! !
fieldName:!accessing!private! !
instVar!accessing!private! !
instVar:!accessing!private! !
!

!SSWDBInstVarWithFieldName class methodsFor!

instVar: aSymbol fieldName: aString

	^self new
		instVar: aSymbol;
		fieldName: aString;
		yourself! !
!SSWDBInstVarWithFieldName class categoriesForMethods!
instVar:fieldName:!instance creation!public! !
!


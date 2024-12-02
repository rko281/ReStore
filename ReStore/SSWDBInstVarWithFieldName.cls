"Filed out from Dolphin Smalltalk"!

SSWDBInstVarDefinition subclass: #SSWDBInstVarWithFieldName
	instanceVariableNames: 'fieldName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBInstVarWithFieldName guid: (GUID fromString: '{75038fd6-5eee-46d2-9dc2-bed65dcc8fc3}')!
SSWDBInstVarWithFieldName comment: ''!
!SSWDBInstVarWithFieldName categoriesForClass!Kernel-Objects! !
!SSWDBInstVarWithFieldName methodsFor!

databaseFieldNameIn: anSSWDBTable

	"Use the configured fieldName"

	^self fieldName!

fieldName
	^fieldName!

fieldName: anObject
	fieldName := anObject! !
!SSWDBInstVarWithFieldName categoriesForMethods!
databaseFieldNameIn:!accessing!public! !
fieldName!accessing!private! !
fieldName:!accessing!private! !
!


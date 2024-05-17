"Filed out from Dolphin Smallalk"!

Object subclass: #FieldNameTest
	instanceVariableNames: 'id name description'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'shouldUseAlternativeNames'!
FieldNameTest guid: (GUID fromString: '{3037f10e-778c-4b55-8ff8-773b13afa9b4}')!
FieldNameTest comment: ''!
!FieldNameTest categoriesForClass!Kernel-Objects! !
!FieldNameTest methodsFor!

description
	^description!

description: anObject
	description := anObject!

id
	^id!

id: anObject
	id := anObject!

name
	^name!

name: anObject
	name := anObject! !
!FieldNameTest categoriesForMethods!
description!accessing!private! !
description:!accessing!private! !
id!accessing!private! !
id:!accessing!private! !
name!accessing!private! !
name:!accessing!private! !
!

!FieldNameTest class methodsFor!

reStoreDefinition

	^self shouldUseAlternativeNames
		ifTrue: [self reStoreDefinitionWithAlternativeNames]
		ifFalse: [self reStoreDefinitionStandard]!

reStoreDefinitionStandard

	^super reStoreDefinition
		defineAsID: #id;
		define: #name as: (String maxSize: 128);
		define: #description as: (String maxSize: 255);
		yourself!

reStoreDefinitionWithAlternativeNames

	^super reStoreDefinition
		defineAsID: (#id withDatabaseName: 'my_id') ;
		define: (#name withDatabaseName: 'my_name') as: (String maxSize: 128);
		define: (#description previouslyNamed: #detailedDescription) as: (String maxSize: 255);
		yourself!

shouldUseAlternativeNames

	^shouldUseAlternativeNames ifNil: [false]!

shouldUseAlternativeNames: aBoolean

	shouldUseAlternativeNames := aBoolean! !
!FieldNameTest class categoriesForMethods!
reStoreDefinition!persistency!public! !
reStoreDefinitionStandard!persistency!public! !
reStoreDefinitionWithAlternativeNames!persistency!public! !
shouldUseAlternativeNames!accessing!public! !
shouldUseAlternativeNames:!accessing!public! !
!


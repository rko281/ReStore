"Filed out from Dolphin Smallalk"!

Object subclass: #FieldNameTest
	instanceVariableNames: 'id name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'shouldUseFieldNames'!
FieldNameTest guid: (GUID fromString: '{3037f10e-778c-4b55-8ff8-773b13afa9b4}')!
FieldNameTest comment: ''!
!FieldNameTest categoriesForClass!Kernel-Objects! !
!FieldNameTest methodsFor!

id
	^id!

id: anObject
	id := anObject!

name
	^name!

name: anObject
	name := anObject! !
!FieldNameTest categoriesForMethods!
id!accessing!private! !
id:!accessing!private! !
name!accessing!private! !
name:!accessing!private! !
!

!FieldNameTest class methodsFor!

reStoreDefinition

	^self shouldUseFieldNames
		ifTrue: [self reStoreDefinitionWithFieldNames]
		ifFalse: [self reStoreDefinitionStandard]!

reStoreDefinitionStandard

	^super reStoreDefinition
		defineAsID: #id;
		define: #name as: (String maxSize: 128);
		yourself!

reStoreDefinitionWithFieldNames

	^super reStoreDefinition
		defineAsID: (#id asDatabaseFieldNamed: 'my_id') ;
		define: (#name asDatabaseFieldNamed: 'my_name') as: (String maxSize: 128);
		yourself!

shouldUseFieldNames

	^shouldUseFieldNames ifNil: [false]!

shouldUseFieldNames: aBoolean

	shouldUseFieldNames := aBoolean! !
!FieldNameTest class categoriesForMethods!
reStoreDefinition!persistency!public! !
reStoreDefinitionStandard!persistency!public! !
reStoreDefinitionWithFieldNames!persistency!public! !
shouldUseFieldNames!accessing!public! !
shouldUseFieldNames:!accessing!public! !
!


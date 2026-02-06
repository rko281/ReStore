"Filed out from Dolphin Smalltalk"!

SSWDBDataField subclass: #SSWDBPolymorphicDataField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWDBPolymorphicDataField guid: (GUID fromString: '{3e2db01c-9189-4be8-a069-7701c2fa1343}')!

SSWDBPolymorphicDataField comment: ''!

!SSWDBPolymorphicDataField categoriesForClass!Unclassified! !

!SSWDBPolymorphicDataField methodsFor!

populateObject: anObject with: aValue from: anSSWDBTable

	"For polymorphic fields ask anSSWDBTable for its concrete equivalent to the receiver to carry this out"

	^(anSSWDBTable equivalentDataFieldTo: self) ifNotNil: [ :concreteField | concreteField populateObject: anObject with: aValue from: anSSWDBTable]! !

!SSWDBPolymorphicDataField categoriesForMethods!
populateObject:with:from:!accessing!public! !
!


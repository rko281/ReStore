"Filed out from Dolphin Smalltalk"!

SSWDBStaticField subclass: #SSWDBDataField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBDataField guid: (GUID fromString: '{caf73965-42bb-4a4b-bf79-34f5a71d3394}')!
SSWDBDataField comment: ''!
!SSWDBDataField categoriesForClass!Unclassified! !
!SSWDBDataField methodsFor!

populateObject: anObject with: aValue

	(self convertValue: aValue) ifNotNil: [ :obj | self accessor value: obj in: anObject]! !
!SSWDBDataField categoriesForMethods!
populateObject:with:!actions!private! !
!


"Filed out from Dolphin Smalltalk"!

SSWDBDumbTransaction subclass: #SSWDBPreSwappingDumbTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWDBPreSwappingDumbTransaction guid: (GUID fromString: '{1b7bef03-b7f6-46c3-b902-feb67f118a92}')!

SSWDBPreSwappingDumbTransaction comment: ''!

!SSWDBPreSwappingDumbTransaction categoriesForClass!Unclassified! !

!SSWDBPreSwappingDumbTransaction methodsFor!

postInstallIn: aReStore

	super postInstallIn: aReStore.
	aReStore swapAll! !

!SSWDBPreSwappingDumbTransaction categoriesForMethods!
postInstallIn:!actions!public! !
!


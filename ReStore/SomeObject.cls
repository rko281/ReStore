"Filed out from Dolphin Smalltalk"!

Object subclass: #SomeObject
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SomeObject guid: (GUID fromString: '{440d52c0-6319-4c02-883c-687494a4c50d}')!

SomeObject comment: ''!

!SomeObject categoriesForClass!Unclassified! !

!SomeObject class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #name as: String;
		yourself! !

!SomeObject class categoriesForMethods!
reStoreDefinition!public! !
!


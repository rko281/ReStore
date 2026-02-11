"Filed out from Dolphin Smalltalk"!

Object subclass: #ConcreteReferenceA
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ConcreteReferenceA guid: (GUID fromString: '{a2655220-0fab-450d-870d-04118189070b}')!

ConcreteReferenceA comment: ''!

!ConcreteReferenceA categoriesForClass!Unclassified! !

!ConcreteReferenceA methodsFor!

name
	^name!

name: anObject
	name := anObject! !

!ConcreteReferenceA categoriesForMethods!
name!accessing!private! !
name:!accessing!private! !
!

!ConcreteReferenceA class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #name as: (String maxSize: 100);
		yourself! !

!ConcreteReferenceA class categoriesForMethods!
reStoreDefinition!public! !
!


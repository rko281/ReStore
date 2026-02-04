"Filed out from Dolphin Smalltalk"!

Object subclass: #ConcreteReferenceB
	instanceVariableNames: 'number'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ConcreteReferenceB guid: (GUID fromString: '{0ea038f5-2e2e-44b1-a9bc-41837f4cf103}')!

ConcreteReferenceB comment: ''!

!ConcreteReferenceB categoriesForClass!Unclassified! !

!ConcreteReferenceB methodsFor!

number
	^number!

number: anObject
	number := anObject! !

!ConcreteReferenceB categoriesForMethods!
number!accessing!private! !
number:!accessing!private! !
!

!ConcreteReferenceB class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #number as: Integer;
		yourself! !

!ConcreteReferenceB class categoriesForMethods!
reStoreDefinition!public! !
!


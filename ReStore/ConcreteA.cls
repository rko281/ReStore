"Filed out from Dolphin Smalltalk"!

AbstractB subclass: #ConcreteA
	instanceVariableNames: 'a'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ConcreteA guid: (GUID fromString: '{63d5e45e-b7f4-477a-a90b-fa09627cae9c}')!

ConcreteA comment: ''!

!ConcreteA categoriesForClass!Unclassified! !

!ConcreteA class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #a as: String;
		define: #reference as: ConcreteReferenceA;
		yourself! !

!ConcreteA class categoriesForMethods!
reStoreDefinition!public! !
!


"Filed out from Dolphin Smallalk"!

Object subclass: #AbstractA
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AbstractA guid: (GUID fromString: '{a82b1cc8-3c15-4c46-8d9b-32fcd1bf89ab}')!
AbstractA comment: ''!
!AbstractA categoriesForClass!Unclassified! !
!AbstractA class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #name as: String;
		yourself!

shouldSubclassesInheritPersistencyFalse

	^self ~~ ##(self)! !
!AbstractA class categoriesForMethods!
reStoreDefinition!public! !
shouldSubclassesInheritPersistencyFalse!public! !
!


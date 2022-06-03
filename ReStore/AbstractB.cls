"Filed out from Dolphin Smallalk"!

AbstractA subclass: #AbstractB
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AbstractB guid: (GUID fromString: '{a925b7f2-6652-486f-8438-85177645d692}')!
AbstractB comment: ''!
!AbstractB categoriesForClass!Unclassified! !
!AbstractB class methodsFor!

addClassDefinitionToEmpty: aClassDef

	super addClassDefinitionTo: aClassDef!

reStoreDefinitionEmpty

	^super reStoreDefinition!

shouldSubclassesInheritPersistencyFalse

	^self ~~ ##(self)! !
!AbstractB class categoriesForMethods!
addClassDefinitionToEmpty:!public! !
reStoreDefinitionEmpty!public! !
shouldSubclassesInheritPersistencyFalse!public! !
!


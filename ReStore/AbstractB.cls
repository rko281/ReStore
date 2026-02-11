"Filed out from Dolphin Smalltalk"!

AbstractA subclass: #AbstractB
	instanceVariableNames: 'reference'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

AbstractB guid: (GUID fromString: '{a925b7f2-6652-486f-8438-85177645d692}')!

AbstractB comment: ''!

!AbstractB categoriesForClass!Unclassified! !

!AbstractB methodsFor!

reference
	^reference!

reference: anObject
	reference := anObject! !

!AbstractB categoriesForMethods!
reference!accessing!private! !
reference:!accessing!private! !
!

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


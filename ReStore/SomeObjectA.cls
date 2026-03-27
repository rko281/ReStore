"Filed out from Dolphin Smalltalk"!

SomeObject subclass: #SomeObjectA
	instanceVariableNames: 'varA'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SomeObjectA guid: (GUID fromString: '{4166d815-2de1-45de-b6aa-e1b55f74757f}')!

SomeObjectA comment: ''!

!SomeObjectA categoriesForClass!Unclassified! !

!SomeObjectA methodsFor!

varA
	^varA!

varA: anObject
	varA := anObject! !

!SomeObjectA categoriesForMethods!
varA!accessing!private! !
varA:!accessing!private! !
!

!SomeObjectA class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #varA as: TestBitmask;
		yourself! !

!SomeObjectA class categoriesForMethods!
reStoreDefinition!public! !
!


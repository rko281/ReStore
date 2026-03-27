"Filed out from Dolphin Smalltalk"!

SomeObject subclass: #SomeObjectB
	instanceVariableNames: 'varB'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SomeObjectB guid: (GUID fromString: '{eb0ce6b6-832c-4e58-94a6-5c729ce31ff5}')!

SomeObjectB comment: ''!

!SomeObjectB categoriesForClass!Unclassified! !

!SomeObjectB methodsFor!

varB
	^varB!

varB: anObject
	varB := anObject! !

!SomeObjectB categoriesForMethods!
varB!accessing!private! !
varB:!accessing!private! !
!

!SomeObjectB class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #varB as: String;
		yourself! !

!SomeObjectB class categoriesForMethods!
reStoreDefinition!public! !
!


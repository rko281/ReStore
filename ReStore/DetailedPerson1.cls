"Filed out from Dolphin Smalltalk 7"!

SuperPerson subclass: #DetailedPerson1
	instanceVariableNames: 'friend2'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DetailedPerson1 guid: (GUID fromString: '{12d491f9-8d56-456b-9e09-1cc59f5863fb}')!
DetailedPerson1 comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!DetailedPerson1 categoriesForClass!Unclassified! !
!DetailedPerson1 methodsFor!

friend2
	^friend2!

friend2: anObject
	friend2 := anObject! !
!DetailedPerson1 categoriesFor: #friend2!accessing!private! !
!DetailedPerson1 categoriesFor: #friend2:!accessing!private! !

!DetailedPerson1 class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #friend2 as: DetailedPerson2;
		yourself! !
!DetailedPerson1 class categoriesFor: #reStoreDefinition!public! !


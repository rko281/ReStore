"Filed out from Dolphin Smalltalk 7"!

SuperPerson subclass: #MidPerson
	instanceVariableNames: 'middleName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MidPerson guid: (GUID fromString: '{4fd8d6e1-f5b1-499c-be32-ec8007a78542}')!
MidPerson comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!MidPerson categoriesForClass!Unclassified! !
!MidPerson methodsFor!

middleName
	^middleName!

middleName: anObject
	middleName := anObject! !
!MidPerson categoriesFor: #middleName!accessing!private! !
!MidPerson categoriesFor: #middleName:!accessing!private! !

!MidPerson class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #middleName as: (String maxSize: 128);
		yourself! !
!MidPerson class categoriesFor: #reStoreDefinition!public! !


"Filed out from Dolphin Smalltalk 7"!

MidPerson subclass: #SubPerson
	instanceVariableNames: 'age'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SubPerson guid: (GUID fromString: '{8cf4a28a-6194-42be-8935-915cef1dbdd6}')!
SubPerson comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SubPerson categoriesForClass!Unclassified! !
!SubPerson methodsFor!

age
	^age!

age: anObject
	age := anObject! !
!SubPerson categoriesFor: #age!accessing!private! !
!SubPerson categoriesFor: #age:!accessing!private! !

!SubPerson class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #age as: Integer;
		yourself! !
!SubPerson class categoriesFor: #reStoreDefinition!public! !


"Filed out from Dolphin Smalltalk 7"!

MidPerson subclass: #SubPerson
	instanceVariableNames: 'age subFlags'
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
	age := anObject!

initialize
	super initialize.
	subFlags := TestBitmask new.!

subFlags
	^subFlags.! !
!SubPerson categoriesForMethods!
age!accessing!private! !
age:!accessing!private! !
initialize!initializing!private! !
subFlags!accessing!private! !
!

!SubPerson class methodsFor!

mutableAspects
	^super mutableAspects copyWith: #subFlags.!

reStoreDefinition
	^super reStoreDefinition
		define: #age as: Integer;
		define: #subFlags as: TestBitmask;
		yourself.! !
!SubPerson class categoriesForMethods!
mutableAspects!constants!public! !
reStoreDefinition!public! !
!


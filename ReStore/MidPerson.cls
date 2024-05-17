"Filed out from Dolphin Smalltalk 7"!

SuperPerson subclass: #MidPerson
	instanceVariableNames: 'middleName midFriend midFlags'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MidPerson guid: (GUID fromString: '{4fd8d6e1-f5b1-499c-be32-ec8007a78542}')!
MidPerson comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!MidPerson categoriesForClass!Unclassified! !
!MidPerson methodsFor!

initialize
	super initialize.
	midFlags := TestBitmask new.!

middleName
	^middleName!

middleName: anObject
	middleName := anObject!

midFlags
	^midFlags.!

midFriend
	^midFriend!

midFriend: anObject
	midFriend := anObject! !
!MidPerson categoriesForMethods!
initialize!initializing!private! !
middleName!accessing!private! !
middleName:!accessing!private! !
midFlags!accessing!private! !
midFriend!accessing!private! !
midFriend:!accessing!private! !
!

!MidPerson class methodsFor!

mutableAspects
	^super mutableAspects copyWith: #midFlags.!

reStoreDefinition
	^super reStoreDefinition
		define: #middleName as: (String maxSize: 128);
		define: #midFriend as: SuperPerson;
		define: #midFlags as: TestBitmask;
		yourself.! !
!MidPerson class categoriesForMethods!
mutableAspects!constants!public! !
reStoreDefinition!public! !
!


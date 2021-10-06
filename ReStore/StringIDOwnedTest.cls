"Filed out from Dolphin Smallalk"!

UUIDOwnedTest subclass: #StringIDOwnedTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StringIDOwnedTest guid: (GUID fromString: '{621f3bd8-cba9-4d92-b2a2-3dbe20c8ae10}')!
StringIDOwnedTest comment: ''!
!StringIDOwnedTest categoriesForClass!Unclassified! !
!StringIDOwnedTest methodsFor!

reStoreNewUniqueID

	(Delay forMilliseconds: 1) wait.
	^Time millisecondClockValue printString! !
!StringIDOwnedTest categoriesForMethods!
reStoreNewUniqueID!public! !
!

!StringIDOwnedTest class methodsFor!

reStoreIDClass

	^String maxSize: 32! !
!StringIDOwnedTest class categoriesForMethods!
reStoreIDClass!public! !
!


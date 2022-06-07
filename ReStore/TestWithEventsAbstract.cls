"Filed out from Dolphin Smallalk"!

Test subclass: #TestWithEventsAbstract
	instanceVariableNames: 'recoveryTime'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TestWithEventsAbstract guid: (GUID fromString: '{30f886d2-4785-43aa-8678-2a4d523e06b0}')!
TestWithEventsAbstract comment: ''!
!TestWithEventsAbstract categoriesForClass!Unclassified! !
!TestWithEventsAbstract methodsFor!

onRecovered

	recoveryTime := DateAndTime now!

recoveryTime
	^recoveryTime!

recoveryTime: anObject
	recoveryTime := anObject! !
!TestWithEventsAbstract categoriesForMethods!
onRecovered!event handling!public! !
recoveryTime!accessing!private! !
recoveryTime:!accessing!private! !
!

!TestWithEventsAbstract class methodsFor!

shouldSubclassesInheritPersistency

	^false! !
!TestWithEventsAbstract class categoriesForMethods!
shouldSubclassesInheritPersistency!public! !
!


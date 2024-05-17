"Filed out from Dolphin Smallalk"!

TestWithEventsAbstract subclass: #TestWithEventsItem
	instanceVariableNames: 'owner'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TestWithEventsItem guid: (GUID fromString: '{f4e471bf-4122-494d-a631-48c6f91c0c09}')!
TestWithEventsItem comment: ''!
!TestWithEventsItem categoriesForClass!Unclassified! !
!TestWithEventsItem methodsFor!

onAboutToUnstore

	self name: '<unstored>'!

onUnstored

	owner isNil ifFalse: [owner removeItem: self]!

owner
	^owner!

owner: anObject
	owner := anObject! !
!TestWithEventsItem categoriesForMethods!
onAboutToUnstore!event handling!public! !
onUnstored!event handling!public! !
owner!accessing!private! !
owner:!accessing!private! !
!


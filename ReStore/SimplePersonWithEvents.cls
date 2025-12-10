"Filed out from Dolphin Smalltalk"!

SimplePerson subclass: #SimplePersonWithEvents
	instanceVariableNames: 'events'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SimplePersonWithEvents guid: (GUID fromString: '{02b097e2-bfb7-432f-b9af-f858e2ac7aab}')!

SimplePersonWithEvents comment: ''!

!SimplePersonWithEvents categoriesForClass!Unclassified! !

!SimplePersonWithEvents methodsFor!

getEvents

	^events!

hasLocalEvents

	^events notNil and: [events isEmpty not]!

setEvents: anEventsCollection

	events := anEventsCollection! !

!SimplePersonWithEvents categoriesForMethods!
getEvents!accessing!public! !
hasLocalEvents!public!testing! !
setEvents:!accessing!public! !
!

!SimplePersonWithEvents class methodsFor!

shouldInheritPersistency

	^false! !

!SimplePersonWithEvents class categoriesForMethods!
shouldInheritPersistency!public! !
!


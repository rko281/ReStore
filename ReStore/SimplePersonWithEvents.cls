"Filed out from Dolphin Smalltalk"!

SimplePerson subclass: #SimplePersonWithEvents
	instanceVariableNames: 'events'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SimplePersonWithEvents guid: (GUID fromString: '{83d948ea-8fe7-44db-a036-7eedefef1969}')!

SimplePersonWithEvents comment: ''!

!SimplePersonWithEvents categoriesForClass!Unclassified! !

!SimplePersonWithEvents methodsFor!

actionMap

	^events ifNil: [ events := IdentityDictionary new ]!

getEvents

	^events!

hasLocalEvents

	^events notNil and: [events isEmpty not]!

setEvents: aCollection

	events := aCollection!

updateableActionMap

	^self actionMap! !

!SimplePersonWithEvents categoriesForMethods!
actionMap!accessing!public! !
getEvents!accessing!public! !
hasLocalEvents!public!testing! !
setEvents:!accessing!public! !
updateableActionMap!accessing!public! !
!

!SimplePersonWithEvents class methodsFor!

shouldInheritPersistency 

	^false! !

!SimplePersonWithEvents class categoriesForMethods!
shouldInheritPersistency!persistency!public! !
!


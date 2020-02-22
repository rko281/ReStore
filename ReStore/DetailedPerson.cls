"Filed out from Dolphin Smalltalk 7"!

SuperPerson subclass: #DetailedPerson
	instanceVariableNames: 'dob dateOfBirth friend bestFriend'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DetailedPerson guid: (GUID fromString: '{c14cf5ab-19a4-4a88-b5f7-71806f34c6a4}')!
DetailedPerson comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!DetailedPerson categoriesForClass!Unclassified! !
!DetailedPerson methodsFor!

bestFriend
	^bestFriend!

bestFriend: anObject
	bestFriend := anObject!

dateOfBirth
	^dateOfBirth!

dateOfBirth: anObject
	dateOfBirth := anObject!

dob
	^dob!

dob: anObject
	dob := anObject!

friend
	^friend!

friend: anObject
	friend := anObject! !
!DetailedPerson categoriesFor: #bestFriend!accessing!private! !
!DetailedPerson categoriesFor: #bestFriend:!accessing!private! !
!DetailedPerson categoriesFor: #dateOfBirth!accessing!private! !
!DetailedPerson categoriesFor: #dateOfBirth:!accessing!private! !
!DetailedPerson categoriesFor: #dob!accessing!private! !
!DetailedPerson categoriesFor: #dob:!accessing!private! !
!DetailedPerson categoriesFor: #friend!accessing!private! !
!DetailedPerson categoriesFor: #friend:!accessing!private! !

!DetailedPerson class methodsFor!

reStoreDefinition

	| definition | 

	definition := super reStoreDefinition.

	self useDateOfBirth
		ifTrue: [definition define: #dateOfBirth as: Date]
		ifFalse: [definition define: #dob as: Date].

	self useBestFriend
		ifTrue: [definition define: #bestFriend as: DetailedPerson]
		ifFalse: [definition define: #friend as: DetailedPerson].

	^definition!

useBestFriend

	^DetailedPerson2 useBestFriend!

useDateOfBirth

	^DetailedPerson2 useDateOfBirth! !
!DetailedPerson class categoriesFor: #reStoreDefinition!public! !
!DetailedPerson class categoriesFor: #useBestFriend!public! !
!DetailedPerson class categoriesFor: #useDateOfBirth!public! !


"Filed out from Dolphin Smalltalk 7"!

SuperPerson subclass: #DetailedPerson2
	instanceVariableNames: 'dob dateOfBirth friend bestFriend notes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'useDateOfBirth useBestFriend useLongNotes'!
DetailedPerson2 guid: (GUID fromString: '{250040a3-581d-4424-9203-ac4c50d88085}')!
DetailedPerson2 comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!DetailedPerson2 categoriesForClass!Unclassified! !
!DetailedPerson2 methodsFor!

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
	friend := anObject!

notes
	^notes!

notes: anObject
	notes := anObject! !
!DetailedPerson2 categoriesFor: #bestFriend!accessing!private! !
!DetailedPerson2 categoriesFor: #bestFriend:!accessing!private! !
!DetailedPerson2 categoriesFor: #dateOfBirth!accessing!private! !
!DetailedPerson2 categoriesFor: #dateOfBirth:!accessing!private! !
!DetailedPerson2 categoriesFor: #dob!accessing!private! !
!DetailedPerson2 categoriesFor: #dob:!accessing!private! !
!DetailedPerson2 categoriesFor: #friend!accessing!private! !
!DetailedPerson2 categoriesFor: #friend:!accessing!private! !
!DetailedPerson2 categoriesFor: #notes!accessing!private! !
!DetailedPerson2 categoriesFor: #notes:!accessing!private! !

!DetailedPerson2 class methodsFor!

notesSize

	^self useLongNotes 
		ifTrue: [60]
		ifFalse: [40]!

reStoreDefinition

	| definition |

	definition := super reStoreDefinition.

	self useDateOfBirth
		ifTrue: [definition define: #dateOfBirth as: Date]
		ifFalse: [definition define: #dob as: Date].

	self useBestFriend
		ifTrue: [definition define: #bestFriend as: DetailedPerson2]
		ifFalse: [definition define: #friend as: DetailedPerson2].

	definition define: #notes as: (String maxSize: self notesSize).
		
	^definition!

useBestFriend

	^useBestFriend ifNil: [false]!

useBestFriend: aBoolean

	useBestFriend := aBoolean!

useDateOfBirth
	^useDateOfBirth ifNil: [false]!

useDateOfBirth: anObject
	useDateOfBirth := anObject!

useLongNotes
	^useLongNotes ifNil: [false]!

useLongNotes: anObject
	useLongNotes := anObject! !
!DetailedPerson2 class categoriesFor: #notesSize!accessing!private! !
!DetailedPerson2 class categoriesFor: #reStoreDefinition!public! !
!DetailedPerson2 class categoriesFor: #useBestFriend!public! !
!DetailedPerson2 class categoriesFor: #useBestFriend:!public! !
!DetailedPerson2 class categoriesFor: #useDateOfBirth!accessing!private! !
!DetailedPerson2 class categoriesFor: #useDateOfBirth:!accessing!private! !
!DetailedPerson2 class categoriesFor: #useLongNotes!accessing!private! !
!DetailedPerson2 class categoriesFor: #useLongNotes:!accessing!private! !


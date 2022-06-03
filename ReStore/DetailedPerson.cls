"Filed out from Dolphin Smallalk"!

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

= aDetailedPerson

	^self fullName = aDetailedPerson fullName!

bestFriend
	^bestFriend!

bestFriend: anObject
	bestFriend := anObject!

dateOfBirth
	^dateOfBirth!

dateOfBirth: anObject
	dateOfBirth := anObject!

displayOn: aStream

	aStream display: self firstName; space; display: self surname!

dob
	^dob!

dob: anObject
	dob := anObject!

friend
	^friend!

friend: anObject
	friend := anObject!

hash

	^self fullName hash!

printOn: aStream
	"Answer the name of the receiver as a developer would wish to see it ."

	super printOn: aStream.
	aStream nextPut: $(.
	self displayOn: aStream.
	aStream nextPut: $).! !
!DetailedPerson categoriesForMethods!
=!comparing!public! !
bestFriend!accessing!private! !
bestFriend:!accessing!private! !
dateOfBirth!accessing!private! !
dateOfBirth:!accessing!private! !
displayOn:!displaying!public! !
dob!accessing!private! !
dob:!accessing!private! !
friend!accessing!private! !
friend:!accessing!private! !
hash!comparing!public! !
printOn:!displaying!public! !
!

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
!DetailedPerson class categoriesForMethods!
reStoreDefinition!public! !
useBestFriend!public! !
useDateOfBirth!public! !
!


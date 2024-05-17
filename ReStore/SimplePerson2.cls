"Filed out from Dolphin Smallalk"!

Object subclass: #SimplePerson2
	instanceVariableNames: 'firstName forename surname emailAddress time friend bestFriend notes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'useForename useBestFriend useLongNotes useNotes'!
SimplePerson2 guid: (GUID fromString: '{cc229961-aeb9-11d5-b1e0-444553540000}')!
SimplePerson2 comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SimplePerson2 categoriesForClass!Unclassified! !
!SimplePerson2 methodsFor!

= aDetailedPerson

	^self fullName = aDetailedPerson fullName!

bestFriend
	^bestFriend!

bestFriend: anObject
	bestFriend := anObject!

displayOn: aStream

	aStream display: self firstName; space; display: self surname!

emailAddress
	"Private - Answer the value of the receiver's ''emailAddress'' instance variable."

	^emailAddress!

emailAddress: anObject
	"Private - Set the value of the receiver's ''emailAddress'' instance variable to the argument, anObject."

	emailAddress := anObject!

firstName
	"Private - Answer the value of the receiver's ''firstName'' instance variable."

	^firstName!

firstName: anObject
	"Private - Set the value of the receiver's ''firstName'' instance variable to the argument, anObject."

	firstName := anObject!

forename
	"Private - Answer the value of the receiver's ''forename'' instance variable."

	^forename!

forename: anObject
	"Private - Set the value of the receiver's ''forename'' instance variable to the argument, anObject."

	forename := anObject!

friend
	^friend!

friend: anObject
	friend := anObject!

fullName

	^##(self) useForename 
		ifTrue: [self forename, ' ', self surname]
		ifFalse: [self firstName, ' ', self surname]!

hash

	^self fullName hash!

notes
	^notes!

notes: anObject
	notes := anObject!

printOn: aStream
	"Answer the name of the receiver as a developer would wish to see it ."

	super printOn: aStream.
	aStream nextPut: $(.
	self displayOn: aStream.
	aStream nextPut: $).!

surname
	"Private - Answer the value of the receiver's ''surname'' instance variable."

	^surname!

surname: anObject
	"Private - Set the value of the receiver's ''surname'' instance variable to the argument, anObject."

	surname := anObject!

time
	"Private - Answer the value of the receiver's ''time'' instance variable."

	^time!

time: anObject
	"Private - Set the value of the receiver's ''time'' instance variable to the argument, anObject."

	time := anObject! !
!SimplePerson2 categoriesForMethods!
=!comparing!public! !
bestFriend!accessing!private! !
bestFriend:!accessing!private! !
displayOn:!displaying!public! !
emailAddress!accessing!private! !
emailAddress:!accessing!private! !
firstName!accessing!private! !
firstName:!accessing!private! !
forename!accessing!private! !
forename:!accessing!private! !
friend!accessing!private! !
friend:!accessing!private! !
fullName!accessing!public! !
hash!comparing!public! !
notes!accessing!private! !
notes:!accessing!private! !
printOn:!displaying!public! !
surname!accessing!private! !
surname:!accessing!private! !
time!accessing!private! !
time:!accessing!private! !
!

!SimplePerson2 class methodsFor!

new

	^super new
		time: DateAndTime now;
		yourself!

notesSize

	^self useLongNotes 
		ifTrue: [20]
		ifFalse: [10]!

reStoreDefinition

	| definition |

	definition := super reStoreDefinition.

	definition
		define: #surname as: (String maxSize: 100).

	self useForename
		ifTrue: [definition define: #forename as: (String maxSize: 100)]
		ifFalse: [definition define: #firstName as: (String maxSize: 100)].

	definition
		define: #emailAddress as: (String maxSize: 100);
		define: #time as: DateAndTime.

	self useBestFriend
		ifTrue: [definition define: #bestFriend as: SimplePerson2]
		ifFalse: [definition define: #friend as: SimplePerson2].

	self useNotes ifTrue: [definition define: #notes as: (String maxSize: self notesSize)].

	^definition!

useBestFriend

	^useBestFriend ifNil: [false]!

useBestFriend: aBoolean

	useBestFriend := aBoolean!

useForename

	^useForename ifNil: [false]!

useForename: aBoolean

	useForename := aBoolean!

useLongNotes
	^useLongNotes ifNil: [false]!

useLongNotes: anObject
	useLongNotes := anObject!

useNotes

	^useNotes ifNil: [false]!

useNotes: aBoolean

	useNotes := aBoolean! !
!SimplePerson2 class categoriesForMethods!
new!public! !
notesSize!accessing!private! !
reStoreDefinition!public! !
useBestFriend!public! !
useBestFriend:!public! !
useForename!public! !
useForename:!public! !
useLongNotes!accessing!private! !
useLongNotes:!accessing!private! !
useNotes!public! !
useNotes:!public! !
!


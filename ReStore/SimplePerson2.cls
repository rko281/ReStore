"Filed out from Dolphin Smalltalk 7"!

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

bestFriend
	^bestFriend!

bestFriend: anObject
	bestFriend := anObject!

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

notes
	^notes!

notes: anObject
	notes := anObject!

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
!SimplePerson2 categoriesFor: #bestFriend!accessing!private! !
!SimplePerson2 categoriesFor: #bestFriend:!accessing!private! !
!SimplePerson2 categoriesFor: #emailAddress!accessing!private! !
!SimplePerson2 categoriesFor: #emailAddress:!accessing!private! !
!SimplePerson2 categoriesFor: #firstName!accessing!private! !
!SimplePerson2 categoriesFor: #firstName:!accessing!private! !
!SimplePerson2 categoriesFor: #forename!accessing!private! !
!SimplePerson2 categoriesFor: #forename:!accessing!private! !
!SimplePerson2 categoriesFor: #friend!accessing!private! !
!SimplePerson2 categoriesFor: #friend:!accessing!private! !
!SimplePerson2 categoriesFor: #notes!accessing!private! !
!SimplePerson2 categoriesFor: #notes:!accessing!private! !
!SimplePerson2 categoriesFor: #surname!accessing!private! !
!SimplePerson2 categoriesFor: #surname:!accessing!private! !
!SimplePerson2 categoriesFor: #time!accessing!private! !
!SimplePerson2 categoriesFor: #time:!accessing!private! !

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
!SimplePerson2 class categoriesFor: #new!public! !
!SimplePerson2 class categoriesFor: #notesSize!accessing!private! !
!SimplePerson2 class categoriesFor: #reStoreDefinition!public! !
!SimplePerson2 class categoriesFor: #useBestFriend!public! !
!SimplePerson2 class categoriesFor: #useBestFriend:!public! !
!SimplePerson2 class categoriesFor: #useForename!public! !
!SimplePerson2 class categoriesFor: #useForename:!public! !
!SimplePerson2 class categoriesFor: #useLongNotes!accessing!private! !
!SimplePerson2 class categoriesFor: #useLongNotes:!accessing!private! !
!SimplePerson2 class categoriesFor: #useNotes!public! !
!SimplePerson2 class categoriesFor: #useNotes:!public! !


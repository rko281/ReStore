"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SimplePerson
	instanceVariableNames: 'firstName surname emailAddress time friend age test orders address isDeceased'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SimplePerson guid: (GUID fromString: '{d9c0d862-aabe-11d5-b1e0-444553540000}')!
SimplePerson comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SimplePerson categoriesForClass!Unclassified! !
!SimplePerson methodsFor!

<= aPerson

	^self surname < aPerson surname | ((self surname = aPerson surname) & (self firstName <= aPerson firstName))!

<== aPerson

	"Same implementation as <= but using Blocks"

	^self surname < aPerson surname or: [self surname = aPerson surname and: [self firstName <= aPerson firstName]]!

<==> aPerson

	"Inverse implementation of <=="

	^aPerson surname > self surname or: [aPerson surname = self surname and: [aPerson firstName >= self firstName]]!

<=> aPerson

	"Inverse implementation of <="

	^aPerson surname > self surname | ((aPerson surname = self surname) & (aPerson firstName >= self firstName))!

address
	^address!

address: anObject
	address := anObject!

age
	^age!

age: anObject
	age := anObject!

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

friend
	^friend!

friend: anObject
	friend := anObject!

friendCompare: aSimplePerson

	^self friend standardCompare: aSimplePerson friend!

friendCompareWithBlocks: aSimplePerson

	^self friend standardCompareWithBlocks: aSimplePerson friend!

friendIsNilAndJohn

	^self friend isNil and: [self firstName = 'John']!

friendIsNilOrJohn

	^self friend isNil or: [self firstName = 'John']!

friendNotNilAndJim

	^self friend notNil and: [self firstName = 'Jim']!

friendNotNilOrJim

	^self friend notNil or: [self firstName = 'Jim']!

fullName

	^self firstName, ' ', self surname!

fullNameDirect

	^firstName, ' ', surname!

fullNameWithEvaluationLocation

	^self 
		imageDo: [self fullName, ' (IMAGE)']
		databaseDo: [self fullName, ' (DATABASE)']!

hasFriend

	^self friend notNil!

hasNoFriend

	^self friend isNil!

hasNoTest

	^self test isNil!

hasTest

	^self test notNil!

hasTestOrFriendHasTestBlock

	^self test notNil or: [self friend test notNil]!

isBrown20

	^self surname = 'Brown' and: [self age = 20]!

isDavidAndTestIsNil

	^self firstName = 'David' and: [self test isNil]!

isDavidOrTestIsNil

	^self firstName = 'David' or: [self test isNil]!

isDeceased
	^isDeceased!

isDeceased: anObject
	isDeceased := anObject!

isJohnAndTestIsNil

	^self firstName = 'John' and: [self test isNil]!

orderCount

	^self orders size!

orders
	^orders!

orders: anObject
	orders := anObject!

standardCompare: aPerson

	"Works with friendCompare:"

	^self surname < aPerson surname | ((self surname = aPerson surname) & (self firstName <= aPerson firstName))!

standardCompareWithBlocks: aPerson

	"Works with friendCompareWithBlocks:"

	^self surname < aPerson surname or: [self surname = aPerson surname and: [self firstName <= aPerson firstName]]!

surname
	"Private - Answer the value of the receiver's ''surname'' instance variable."

	^surname!

surname: anObject
	"Private - Set the value of the receiver's ''surname'' instance variable to the argument, anObject."

	surname := anObject!

test
	^test!

test: anObject
	test := anObject!

testIsNilJumpBytecodePattern1

	"JumpIfNil to ^True"

	^(self friend isNil or: [self firstName = 'John']) or: [self firstName = 'Zoe']!

testIsNilJumpBytecodePattern2

	"JumpIfNotNil to ^False"

	^self friend isNil and: [self firstName = 'John']!

testIsNilJumpBytecodePattern3a

	"JumpIfNotNil immediately followed by ^True"

	^self friend isNil or: [self firstName = 'John']!

testIsNilJumpBytecodePattern3b

	"JumpIfNotNil to just after ^True"

	^(self friend isNil and: [self firstName = 'John']) or: [self firstName = 'Zoe']!

testIsNilJumpBytecodePattern4

	"JumpIfNil to non-return without ^True in jumped-over code "

	^(self friend isNil or: [self test isNil]) and: [self firstName = 'Zoe']!

testNotNilJumpBytecodePattern1

	"JumpIfNotNil to ^True"

	^(self friend notNil or: [self firstName = 'Jim']) or: [self firstName = 'David']!

testNotNilJumpBytecodePattern2

	"JumpIfNil to ^False"

	^self friend notNil and: [self firstName = 'John']!

testNotNilJumpBytecodePattern3a

	"JumpIfNil immediately followed by ^True"

	^self friend notNil or: [self firstName = 'Jim']!

testNotNilJumpBytecodePattern3b

	"JumpIfNil to just after ^True"

	^(self friend notNil and: [self firstName = 'Jim']) or: [self firstName = 'Zoe']!

testNotNilJumpBytecodePattern4

	"JumpIfNotNil to non-return without ^True in jumped-over code "

	^(self friend notNil or: [self test isNil]) and: [self firstName = 'Zoe']!

time
	"Private - Answer the value of the receiver's ''time'' instance variable."

	^time!

time: anObject
	"Private - Set the value of the receiver's ''time'' instance variable to the argument, anObject."

	time := anObject! !
!SimplePerson categoriesFor: #<=!comparing!private! !
!SimplePerson categoriesFor: #<==!comparing!public! !
!SimplePerson categoriesFor: #<==>!comparing!private! !
!SimplePerson categoriesFor: #<=>!comparing!private! !
!SimplePerson categoriesFor: #address!accessing!private! !
!SimplePerson categoriesFor: #address:!accessing!private! !
!SimplePerson categoriesFor: #age!accessing!private! !
!SimplePerson categoriesFor: #age:!accessing!private! !
!SimplePerson categoriesFor: #emailAddress!accessing!private! !
!SimplePerson categoriesFor: #emailAddress:!accessing!private! !
!SimplePerson categoriesFor: #firstName!accessing!private! !
!SimplePerson categoriesFor: #firstName:!accessing!private! !
!SimplePerson categoriesFor: #friend!accessing!private! !
!SimplePerson categoriesFor: #friend:!accessing!private! !
!SimplePerson categoriesFor: #friendCompare:!comparing!public! !
!SimplePerson categoriesFor: #friendCompareWithBlocks:!comparing!public! !
!SimplePerson categoriesFor: #friendIsNilAndJohn!public!testing! !
!SimplePerson categoriesFor: #friendIsNilOrJohn!public!testing! !
!SimplePerson categoriesFor: #friendNotNilAndJim!public!testing! !
!SimplePerson categoriesFor: #friendNotNilOrJim!public!testing! !
!SimplePerson categoriesFor: #fullName!accessing!public! !
!SimplePerson categoriesFor: #fullNameDirect!accessing!public! !
!SimplePerson categoriesFor: #fullNameWithEvaluationLocation!accessing!public! !
!SimplePerson categoriesFor: #hasFriend!public!testing! !
!SimplePerson categoriesFor: #hasNoFriend!public!testing! !
!SimplePerson categoriesFor: #hasNoTest!public!testing! !
!SimplePerson categoriesFor: #hasTest!public!testing! !
!SimplePerson categoriesFor: #hasTestOrFriendHasTestBlock!public!testing! !
!SimplePerson categoriesFor: #isBrown20!public!testing! !
!SimplePerson categoriesFor: #isDavidAndTestIsNil!public!testing! !
!SimplePerson categoriesFor: #isDavidOrTestIsNil!public!testing! !
!SimplePerson categoriesFor: #isDeceased!accessing!private! !
!SimplePerson categoriesFor: #isDeceased:!accessing!private! !
!SimplePerson categoriesFor: #isJohnAndTestIsNil!public!testing! !
!SimplePerson categoriesFor: #orderCount!accessing!public! !
!SimplePerson categoriesFor: #orders!accessing!public! !
!SimplePerson categoriesFor: #orders:!accessing!public! !
!SimplePerson categoriesFor: #standardCompare:!comparing!private! !
!SimplePerson categoriesFor: #standardCompareWithBlocks:!comparing!private! !
!SimplePerson categoriesFor: #surname!accessing!private! !
!SimplePerson categoriesFor: #surname:!accessing!private! !
!SimplePerson categoriesFor: #test!accessing!private! !
!SimplePerson categoriesFor: #test:!accessing!private! !
!SimplePerson categoriesFor: #testIsNilJumpBytecodePattern1!public!testing! !
!SimplePerson categoriesFor: #testIsNilJumpBytecodePattern2!public!testing! !
!SimplePerson categoriesFor: #testIsNilJumpBytecodePattern3a!public!testing! !
!SimplePerson categoriesFor: #testIsNilJumpBytecodePattern3b!public!testing! !
!SimplePerson categoriesFor: #testIsNilJumpBytecodePattern4!public!testing! !
!SimplePerson categoriesFor: #testNotNilJumpBytecodePattern1!public!testing! !
!SimplePerson categoriesFor: #testNotNilJumpBytecodePattern2!public!testing! !
!SimplePerson categoriesFor: #testNotNilJumpBytecodePattern3a!public!testing! !
!SimplePerson categoriesFor: #testNotNilJumpBytecodePattern3b!public!testing! !
!SimplePerson categoriesFor: #testNotNilJumpBytecodePattern4!public!testing! !
!SimplePerson categoriesFor: #time!accessing!private! !
!SimplePerson categoriesFor: #time:!accessing!private! !

!SimplePerson class methodsFor!

new

	^super new
		time: DateAndTime now;
		orders: OrderedCollection new;
		isDeceased: false;
		yourself!

reStoreDefinition

	^super reStoreDefinition
		define: #surname as: (String maxSize: 100);
		define: #firstName as: (String maxSize: 8);
		define: #emailAddress as: (String maxSize: 100);
		define: #time as: DateAndTime;
		define: #friend as: SimplePerson;
		define: #age as: Integer;
		define: #test as: Test;
		define: #address as: SimpleAddress dependent;
		define: #isDeceased as: Boolean;
		yourself! !
!SimplePerson class categoriesFor: #new!public! !
!SimplePerson class categoriesFor: #reStoreDefinition!public! !


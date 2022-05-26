"Filed out from Dolphin Smallalk"!

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

time
	"Private - Answer the value of the receiver's ''time'' instance variable."

	^time!

time: anObject
	"Private - Set the value of the receiver's ''time'' instance variable to the argument, anObject."

	time := anObject! !
!SimplePerson categoriesForMethods!
<=!comparing!private! !
<==!comparing!public! !
<==>!comparing!private! !
<=>!comparing!private! !
address!accessing!private! !
address:!accessing!private! !
age!accessing!private! !
age:!accessing!private! !
emailAddress!accessing!private! !
emailAddress:!accessing!private! !
firstName!accessing!private! !
firstName:!accessing!private! !
friend!accessing!private! !
friend:!accessing!private! !
friendCompare:!comparing!public! !
friendCompareWithBlocks:!comparing!public! !
friendIsNilAndJohn!public!testing! !
friendIsNilOrJohn!public!testing! !
friendNotNilAndJim!public!testing! !
friendNotNilOrJim!public!testing! !
fullName!accessing!public! !
fullNameDirect!accessing!public! !
fullNameWithEvaluationLocation!accessing!public! !
hasFriend!public!testing! !
hasNoFriend!public!testing! !
hasNoTest!public!testing! !
hasTest!public!testing! !
hasTestOrFriendHasTestBlock!public!testing! !
isBrown20!public!testing! !
isDavidAndTestIsNil!public!testing! !
isDavidOrTestIsNil!public!testing! !
isDeceased!accessing!private! !
isDeceased:!accessing!private! !
isJohnAndTestIsNil!public!testing! !
orderCount!accessing!public! !
orders!accessing!public! !
orders:!accessing!public! !
standardCompare:!comparing!private! !
standardCompareWithBlocks:!comparing!private! !
surname!accessing!private! !
surname:!accessing!private! !
test!accessing!private! !
test:!accessing!private! !
time!accessing!private! !
time:!accessing!private! !
!

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
		define: #firstName as: (String maxSize: 50);
		define: #emailAddress as: (String maxSize: 100);
		define: #time as: DateAndTime;
		define: #friend as: SimplePerson;
		define: #age as: Integer;
		define: #test as: Test;
		define: #address as: SimpleAddress dependent;
		define: #isDeceased as: Boolean;
		yourself! !
!SimplePerson class categoriesForMethods!
new!public! !
reStoreDefinition!public! !
!


"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SSWDBOrderingSpec
	instanceVariableNames: 'criteria isAscending'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBOrderingSpec guid: (GUID fromString: '{5c3635a1-3bdf-11d5-b1df-444553540000}')!
SSWDBOrderingSpec comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBOrderingSpec categoriesForClass!Unclassified! !
!SSWDBOrderingSpec methodsFor!

compare: objectA with: objectB

	"Use the receiver to compare the two objects.
	Return true or false, or nil if the two are equal.
	ASSERT: the receiver's criteria is a perform'able message name for both objects"

	| a b |

	a := objectA perform: self criteria.
	b := objectB perform: self criteria.

	^a = b
	ifTrue: 
		[nil]
	ifFalse:
		[self isAscending
			ifTrue: [a <= b]
			ifFalse: [a > b]]!

criteria

	"criteria stores an Object used for ordering
	(the class of Object is dependent on the client of the receiver).
	The direction of ordering is given by isAscending"
	
	^criteria!

criteria: anOrderedCollection

	"criteria stores an Object used for ordering
	(the class of Object is dependent on the client of the receiver).
	The direction of ordering is given by isAscending"
	
	criteria := anOrderedCollection!

invert

	self isAscending: self isAscending not!

inverted

	"Answer a new ordering spec equivalent to the receiver but with reversed ordering"

	^self copy invert!

isAscending

	"isAscending stores a Boolean indicating if ordering by the receiver's criteria
	should be ascending (true) or descending (false)"
	
	^isAscending!

isAscending: aBoolean

	"isAscending stores a Boolean indicating if ordering by the receiver's criteria
	should be ascending (true) or descending (false)"
	
	isAscending := aBoolean! !
!SSWDBOrderingSpec categoriesFor: #compare:with:!comparing!public! !
!SSWDBOrderingSpec categoriesFor: #criteria!accessing!public! !
!SSWDBOrderingSpec categoriesFor: #criteria:!accessing!public! !
!SSWDBOrderingSpec categoriesFor: #invert!operations!public! !
!SSWDBOrderingSpec categoriesFor: #inverted!converting!public! !
!SSWDBOrderingSpec categoriesFor: #isAscending!accessing!public! !
!SSWDBOrderingSpec categoriesFor: #isAscending:!accessing!public! !

!SSWDBOrderingSpec class methodsFor!

ascending: anObject

	^self new
		criteria: anObject;
		isAscending: true;
		yourself!

descending: anObject

	^self new
		criteria: anObject;
		isAscending: false;
		yourself! !
!SSWDBOrderingSpec class categoriesFor: #ascending:!instance creation!public! !
!SSWDBOrderingSpec class categoriesFor: #descending:!instance creation!public! !


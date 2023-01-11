"Filed out from Dolphin Smalltalk"!

SSWDBReadStream subclass: #SSWDBForwardOnlyReadStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBForwardOnlyReadStream guid: (GUID fromString: '{b1562d82-aa7b-4fc6-a62d-a252b87dbc7f}')!
SSWDBForwardOnlyReadStream comment: ''!
!SSWDBForwardOnlyReadStream categoriesForClass!Unclassified! !
!SSWDBForwardOnlyReadStream methodsFor!

evaluatePostReadActionsFor: aCollection

	"We can't back-up so if we're at the end free things up"
	self atEnd ifTrue: [self close].

	^super evaluatePostReadActionsFor: aCollection!

position: anInteger

	anInteger >= self position ifTrue: [^(anInteger - self position) timesRepeat: [self collectionNext]].

	self resetResultsSet.
	anInteger timesRepeat: [self collectionNext]!

resetResultsSet

	collection isNil ifFalse: [collection free].
	self reinitialize! !
!SSWDBForwardOnlyReadStream categoriesForMethods!
evaluatePostReadActionsFor:!evaluating!private! !
position:!positioning!public! !
resetResultsSet!positioning!public! !
!


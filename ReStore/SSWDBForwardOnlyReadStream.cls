"Filed out from Dolphin Smalltalk 7"!

SSWDBReadStream subclass: #SSWDBForwardOnlyReadStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBForwardOnlyReadStream guid: (GUID fromString: '{b1562d82-aa7b-4fc6-a62d-a252b87dbc7f}')!
SSWDBForwardOnlyReadStream comment: ''!
!SSWDBForwardOnlyReadStream categoriesForClass!Unclassified! !
!SSWDBForwardOnlyReadStream methodsFor!

position: anInteger

	anInteger >= self position ifTrue: [^(anInteger - self position) timesRepeat: [self collectionNext]].

	self reinitialize.
	anInteger timesRepeat: [self collectionNext]!

resetResultsSet

	self reinitialize! !
!SSWDBForwardOnlyReadStream categoriesFor: #position:!positioning!public! !
!SSWDBForwardOnlyReadStream categoriesFor: #resetResultsSet!positioning!public! !


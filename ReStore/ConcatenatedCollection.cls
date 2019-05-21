"Filed out from Dolphin Smalltalk 7"!

OrderedCollection variableSubclass: #ConcatenatedCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ConcatenatedCollection guid: (GUID fromString: '{d03919e9-3951-41b3-91e9-3b52f6d66f63}')!
ConcatenatedCollection comment: ''!
!ConcatenatedCollection categoriesForClass!Collections-Sequenceable! !
!ConcatenatedCollection methodsFor!

|| anObject

	^anObject concatenatedWith: self!

concatenatedWith: aConcatenatedCollection

	^aConcatenatedCollection 
		addAllLast: self; 
		yourself! !
!ConcatenatedCollection categoriesFor: #||!operations!public! !
!ConcatenatedCollection categoriesFor: #concatenatedWith:!double dispatch!private! !


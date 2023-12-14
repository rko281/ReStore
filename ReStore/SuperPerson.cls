"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SuperPerson
	instanceVariableNames: 'surname firstName superFlags'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SuperPerson guid: (GUID fromString: '{5e5f0fa2-399b-11d5-b1df-444553540000}')!
SuperPerson comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SuperPerson categoriesForClass!Unclassified! !
!SuperPerson methodsFor!

firstName

	^firstName!

firstName: a

	firstName := a!

fullName

	^self firstName, ' ', self surname!

initialize
	super initialize.
	superFlags := TestBitmask new.!

superFlags
	^superFlags.!

surname

	^surname!

surname: a

	surname := a! !
!SuperPerson categoriesForMethods!
firstName!accessing!public! !
firstName:!accessing!public! !
fullName!accessing!public! !
initialize!initializing!private! !
superFlags!accessing!public! !
surname!accessing!public! !
surname:!accessing!public! !
!

!SuperPerson class methodsFor!

mutableAspects
	^#(#superFlags).!

new
	^self basicNew initialize.!

reStoreDefinition
	^super reStoreDefinition
		define: #surname as: (String maxSize: 255);
		define: #firstName as: (String maxSize: 255);
		define: #superFlags as: TestBitmask;
		yourself.! !
!SuperPerson class categoriesForMethods!
mutableAspects!constants!public! !
new!instance creation!public! !
reStoreDefinition!public! !
!


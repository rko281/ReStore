"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SuperPerson
	instanceVariableNames: 'surname firstName'
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

surname

	^surname!

surname: a

	surname := a! !
!SuperPerson categoriesFor: #firstName!public! !
!SuperPerson categoriesFor: #firstName:!public! !
!SuperPerson categoriesFor: #surname!public! !
!SuperPerson categoriesFor: #surname:!public! !

!SuperPerson class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #surname as: (String maxSize: 255);
		define: #firstName as: (String maxSize: 255);
		yourself! !
!SuperPerson class categoriesFor: #reStoreDefinition!public! !


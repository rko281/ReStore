"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SimpleAddress
	instanceVariableNames: 'line1 postcode'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SimpleAddress guid: (GUID fromString: '{d8427db1-42ff-48a8-ace3-3f4b40eb2f00}')!
SimpleAddress comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SimpleAddress categoriesForClass!Unclassified! !
!SimpleAddress methodsFor!

line1
	^line1!

line1: anObject
	line1 := anObject!

postcode
	^postcode!

postcode: anObject
	postcode := anObject! !
!SimpleAddress categoriesFor: #line1!accessing!private! !
!SimpleAddress categoriesFor: #line1:!accessing!private! !
!SimpleAddress categoriesFor: #postcode!accessing!private! !
!SimpleAddress categoriesFor: #postcode:!accessing!private! !

!SimpleAddress class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #line1 as: (String maxSize: 128);
		define: #postcode as: (String maxSize: 32);
		yourself! !
!SimpleAddress class categoriesFor: #reStoreDefinition!public! !


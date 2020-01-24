"Filed out from Dolphin Smalltalk 7"!

Object subclass: #InlinedAddress
	instanceVariableNames: 'line1 postcode'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
InlinedAddress guid: (GUID fromString: '{57254d6f-1d25-4248-a58d-7c61103617db}')!
InlinedAddress comment: ''!
!InlinedAddress categoriesForClass!Unclassified! !
!InlinedAddress methodsFor!

= anotherAddress

	^(self line1 = anotherAddress line1) & (self postcode = anotherAddress postcode)!

hash

	^self line1 hash!

line1
	^line1!

line1: anObject
	line1 := anObject!

postcode
	^postcode!

postcode: anObject
	postcode := anObject! !
!InlinedAddress categoriesFor: #=!comparing!public! !
!InlinedAddress categoriesFor: #hash!accessing!public! !
!InlinedAddress categoriesFor: #line1!accessing!private! !
!InlinedAddress categoriesFor: #line1:!accessing!private! !
!InlinedAddress categoriesFor: #postcode!accessing!private! !
!InlinedAddress categoriesFor: #postcode:!accessing!private! !

!InlinedAddress class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #line1 as: (String maxSize: 128);
		define: #postcode as: InlinedPostcode inlined! !
!InlinedAddress class categoriesFor: #reStoreDefinition!public! !


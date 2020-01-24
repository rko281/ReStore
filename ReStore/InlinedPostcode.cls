"Filed out from Dolphin Smalltalk 7"!

Object subclass: #InlinedPostcode
	instanceVariableNames: 'code1 code2'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
InlinedPostcode guid: (GUID fromString: '{406377bd-cd94-498f-a6e2-d9faaad4fb09}')!
InlinedPostcode comment: ''!
!InlinedPostcode categoriesForClass!Unclassified! !
!InlinedPostcode methodsFor!

= anotherPostcode

	^(self code1 = anotherPostcode code1) & (self code2 = anotherPostcode code2)!

code1
	^code1!

code1: anObject
	code1 := anObject!

code2
	^code2!

code2: anObject
	code2 := anObject!

hash

	^self code1 hash! !
!InlinedPostcode categoriesFor: #=!comparing!public! !
!InlinedPostcode categoriesFor: #code1!accessing!private! !
!InlinedPostcode categoriesFor: #code1:!accessing!private! !
!InlinedPostcode categoriesFor: #code2!accessing!private! !
!InlinedPostcode categoriesFor: #code2:!accessing!private! !
!InlinedPostcode categoriesFor: #hash!accessing!public! !

!InlinedPostcode class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #code1 as: (String maxSize: 16);
		define: #code2 as: (String maxSize: 16)! !
!InlinedPostcode class categoriesFor: #reStoreDefinition!public! !


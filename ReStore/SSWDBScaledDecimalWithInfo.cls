"Filed out from Dolphin Smalltalk 7"!

SSWDBClassWithInfo subclass: #SSWDBScaledDecimalWithInfo
	instanceVariableNames: 'scale precision'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBScaledDecimalWithInfo guid: (GUID fromString: '{f9276a82-4893-11d5-b1df-0010a70883e2}')!
SSWDBScaledDecimalWithInfo comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBScaledDecimalWithInfo categoriesForClass!Unclassified! !
!SSWDBScaledDecimalWithInfo methodsFor!

infoClass

	^ScaledDecimal!

precision

	"precision stores the total number of digits that should be in this pseudo-ScaledDecimal.
	precision is optional; it is used by SQL (to create tables) and not ScaledDecimal itself
	 - if omitted, a sensible fallback will be used"

	^precision!

precision: anInteger

	"precision stores the total number of digits that should be in this pseudo-ScaledDecimal.
	precision is optional; it is used by SQL (to create tables) and not ScaledDecimal itself
	 - if omitted, a sensible fallback will be used"

	precision := anInteger!

scale

	"scale stores the scale of ScaledDecimal which the receiver creates/represents"

	^scale!

scale: anInteger

	"scale stores the scale of ScaledDecimal which the receiver creates/represents"

	scale := anInteger! !
!SSWDBScaledDecimalWithInfo categoriesFor: #infoClass!constants!public! !
!SSWDBScaledDecimalWithInfo categoriesFor: #precision!accessing!public! !
!SSWDBScaledDecimalWithInfo categoriesFor: #precision:!accessing!public! !
!SSWDBScaledDecimalWithInfo categoriesFor: #scale!accessing!public! !
!SSWDBScaledDecimalWithInfo categoriesFor: #scale:!accessing!public! !


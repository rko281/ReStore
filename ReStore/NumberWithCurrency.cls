"Filed out from Dolphin Smalltalk 7"!

Object subclass: #NumberWithCurrency
	instanceVariableNames: 'number currency'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NumberWithCurrency guid: (GUID fromString: '{a3d4b711-20cd-4f26-82fc-83cfe657be40}')!
NumberWithCurrency comment: ''!
!NumberWithCurrency categoriesForClass!Kernel-Objects! !
!NumberWithCurrency methodsFor!

= aNumberWithCurrency

	^(self number = aNumberWithCurrency number) & (self currency = aNumberWithCurrency currency)!

currency
	^currency!

currency: anObject
	currency := anObject!

displayString

	^self number printString, ' ', self currency!

hash

	^self number hash!

number
	^number!

number: anObject
	number := anObject! !
!NumberWithCurrency categoriesFor: #=!comparing!public! !
!NumberWithCurrency categoriesFor: #currency!accessing!private! !
!NumberWithCurrency categoriesFor: #currency:!accessing!private! !
!NumberWithCurrency categoriesFor: #displayString!displaying!public! !
!NumberWithCurrency categoriesFor: #hash!accessing!public! !
!NumberWithCurrency categoriesFor: #number!accessing!private! !
!NumberWithCurrency categoriesFor: #number:!accessing!private! !

!NumberWithCurrency class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #number as: Float;
		define: #currency as: (String maxSize: 3)!

shouldInlinePersistency

	^true! !
!NumberWithCurrency class categoriesFor: #reStoreDefinition!public! !
!NumberWithCurrency class categoriesFor: #shouldInlinePersistency!public! !


"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SimpleProductOrder
	instanceVariableNames: 'customer product quantity date'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SimpleProductOrder guid: (GUID fromString: '{0617938f-4a67-4c97-b1d8-db49eb2e275b}')!
SimpleProductOrder comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SimpleProductOrder categoriesForClass!Unclassified! !
!SimpleProductOrder methodsFor!

<= anOrder

	^self quantity <= anOrder quantity!

customer
	^customer!

customer: anObject
	customer := anObject!

date
	^date!

date: anObject
	date := anObject!

product
	^product!

product: anObject
	product := anObject!

quantity
	^quantity!

quantity: anObject
	quantity := anObject! !
!SimpleProductOrder categoriesFor: #<=!comparing!public! !
!SimpleProductOrder categoriesFor: #customer!accessing!private! !
!SimpleProductOrder categoriesFor: #customer:!accessing!private! !
!SimpleProductOrder categoriesFor: #date!accessing!private! !
!SimpleProductOrder categoriesFor: #date:!accessing!private! !
!SimpleProductOrder categoriesFor: #product!accessing!private! !
!SimpleProductOrder categoriesFor: #product:!accessing!private! !
!SimpleProductOrder categoriesFor: #quantity!accessing!private! !
!SimpleProductOrder categoriesFor: #quantity:!accessing!private! !

!SimpleProductOrder class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #customer as: SimplePerson;
		define: #product as: SimpleProduct;
		define: #date as: Date;
		define: #quantity as: Integer;
		yourself! !
!SimpleProductOrder class categoriesFor: #reStoreDefinition!public! !


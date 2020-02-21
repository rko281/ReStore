"Filed out from Dolphin Smalltalk 7"!

Object subclass: #CustomerOrder
	instanceVariableNames: 'orderDate customer items totalPrice'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CustomerOrder guid: (GUID fromString: '{f6fdfc37-1a7f-47eb-9b5e-aefcad2ea8ef}')!
CustomerOrder comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!CustomerOrder categoriesForClass!Kernel-Objects! !
!CustomerOrder methodsFor!

addItem: aCustomerOrderItem

	self items add: aCustomerOrderItem.
	self totalPrice: (self totalPrice + aCustomerOrderItem totalPrice).
	^aCustomerOrderItem!

customer
	^customer!

customer: anObject
	customer := anObject!

items
	^items!

items: anObject
	items := anObject!

orderDate
	^orderDate!

orderDate: anObject
	orderDate := anObject!

totalPrice
	^totalPrice!

totalPrice: anObject
	totalPrice := anObject! !
!CustomerOrder categoriesFor: #addItem:!adding!public! !
!CustomerOrder categoriesFor: #customer!accessing!private! !
!CustomerOrder categoriesFor: #customer:!accessing!private! !
!CustomerOrder categoriesFor: #items!accessing!private! !
!CustomerOrder categoriesFor: #items:!accessing!private! !
!CustomerOrder categoriesFor: #orderDate!accessing!private! !
!CustomerOrder categoriesFor: #orderDate:!accessing!private! !
!CustomerOrder categoriesFor: #totalPrice!accessing!private! !
!CustomerOrder categoriesFor: #totalPrice:!accessing!private! !

!CustomerOrder class methodsFor!

new

	^super new
		items: OrderedCollection new;
		totalPrice: 0s2;
		yourself!

reStoreDefinition

	^super reStoreDefinition
		define: #orderDate as: Date;
		define: #customer as: Customer;
		define: #items as: (OrderedCollection of: CustomerOrderItem dependent owner: #order);
		define: #totalPrice as: (ScaledDecimal withPrecision: 8 scale: 2);
		yourself.! !
!CustomerOrder class categoriesFor: #new!public! !
!CustomerOrder class categoriesFor: #reStoreDefinition!public! !


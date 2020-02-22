"Filed out from Dolphin Smalltalk 7"!

Object subclass: #CustomerOrderItem
	instanceVariableNames: 'order product quantity'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CustomerOrderItem guid: (GUID fromString: '{d7c902ed-4274-4426-917b-c1102d091321}')!
CustomerOrderItem comment: ''!
!CustomerOrderItem categoriesForClass!Kernel-Objects! !
!CustomerOrderItem methodsFor!

displayOn: aStream

	aStream nextPutAll: self product name; space; nextPutAll: ' x'; print: self quantity!

order
	^order!

order: anObject
	order := anObject!

printOn: aStream
	"Answer the name of the receiver as a developer would wish to see it ."

	super printOn: aStream.
	aStream nextPut: $(.
	self displayOn: aStream.
	aStream nextPut: $).!

product
	^product!

product: anObject
	product := anObject!

quantity
	^quantity!

quantity: anObject
	quantity := anObject!

totalPrice

	^self quantity * self product price! !
!CustomerOrderItem categoriesFor: #displayOn:!displaying!public! !
!CustomerOrderItem categoriesFor: #order!accessing!private! !
!CustomerOrderItem categoriesFor: #order:!accessing!private! !
!CustomerOrderItem categoriesFor: #printOn:!printing!public! !
!CustomerOrderItem categoriesFor: #product!accessing!private! !
!CustomerOrderItem categoriesFor: #product:!accessing!private! !
!CustomerOrderItem categoriesFor: #quantity!accessing!private! !
!CustomerOrderItem categoriesFor: #quantity:!accessing!private! !
!CustomerOrderItem categoriesFor: #totalPrice!accessing!public! !

!CustomerOrderItem class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #order as: CustomerOrder;
		define: #product as: Product;
		define: #quantity as: Integer;
		yourself.! !
!CustomerOrderItem class categoriesFor: #reStoreDefinition!public! !


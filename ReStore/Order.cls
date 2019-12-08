"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Order
	instanceVariableNames: 'date product quantity customer'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Order guid: (GUID fromString: '{f6fdfc37-1a7f-47eb-9b5e-aefcad2ea8ef}')!
Order comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!Order categoriesForClass!Kernel-Objects! !
!Order methodsFor!

customer
	^customer!

customer: anObject
	customer := anObject!

date
	^date!

date: anObject
	date := anObject!

displayOn: aStream

	aStream nextPutAll: self product; space; nextPutAll: ' x'; print: self quantity!

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
	quantity := anObject! !
!Order categoriesFor: #customer!accessing!private! !
!Order categoriesFor: #customer:!accessing!private! !
!Order categoriesFor: #date!accessing!private! !
!Order categoriesFor: #date:!accessing!private! !
!Order categoriesFor: #displayOn:!displaying!public! !
!Order categoriesFor: #printOn:!printing!public! !
!Order categoriesFor: #product!accessing!private! !
!Order categoriesFor: #product:!accessing!private! !
!Order categoriesFor: #quantity!accessing!private! !
!Order categoriesFor: #quantity:!accessing!private! !

!Order class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #date as: Date;
		define: #product as: Product;
		define: #quantity as: Integer;
		define: #customer as: Customer;
		yourself.! !
!Order class categoriesFor: #reStoreDefinition!public! !


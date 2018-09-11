"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Customer
	instanceVariableNames: 'firstName surname emailAddress dateOfBirth address orders'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Customer guid: (GUID fromString: '{794f2f53-2a26-4325-96b2-5cce6c4e4653}')!
Customer comment: ''!
!Customer categoriesForClass!Unclassified! !
!Customer methodsFor!

addOrder: anOrder

	self orders addLast: anOrder!

address
	^address!

address: anObject
	address := anObject!

dateOfBirth
	^dateOfBirth!

dateOfBirth: anObject
	dateOfBirth := anObject!

displayOn: aStream

	aStream nextPutAll: self fullName!

emailAddress
	^emailAddress!

emailAddress: anObject
	emailAddress := anObject!

firstName
	^firstName!

firstName: anObject
	firstName := anObject!

fullName

	^self firstName, ' ', self surname!

orders
	^orders!

orders: anObject
	orders := anObject!

printOn: aStream
	"Answer the name of the receiver as a developer would wish to see it ."

	super printOn: aStream.
	aStream nextPut: $(.
	self displayOn: aStream.
	aStream nextPut: $).!

surname
	^surname!

surname: anObject
	surname := anObject! !
!Customer categoriesFor: #addOrder:!adding!public! !
!Customer categoriesFor: #address!accessing!private! !
!Customer categoriesFor: #address:!accessing!private! !
!Customer categoriesFor: #dateOfBirth!accessing!private! !
!Customer categoriesFor: #dateOfBirth:!accessing!private! !
!Customer categoriesFor: #displayOn:!displaying!public! !
!Customer categoriesFor: #emailAddress!accessing!private! !
!Customer categoriesFor: #emailAddress:!accessing!private! !
!Customer categoriesFor: #firstName!accessing!private! !
!Customer categoriesFor: #firstName:!accessing!private! !
!Customer categoriesFor: #fullName!accessing!public! !
!Customer categoriesFor: #orders!accessing!private! !
!Customer categoriesFor: #orders:!accessing!private! !
!Customer categoriesFor: #printOn:!printing!public! !
!Customer categoriesFor: #surname!accessing!private! !
!Customer categoriesFor: #surname:!accessing!private! !

!Customer class methodsFor!

new

	^super new
		orders: OrderedCollection new;
		yourself!

reStoreDefinition

	^super reStoreDefinition
		define: #surname as: (String maxSize: 100);
		define: #firstName as: (String maxSize: 100);
		define: #emailAddress as: (String maxSize: 100);
		define: #dateOfBirth as: Date;
		define: #address as: Address dependent;
		define: #orders as: (OrderedCollection of: Order dependent owner: #customer);
		yourself.! !
!Customer class categoriesFor: #new!instance creation!public! !
!Customer class categoriesFor: #reStoreDefinition!persistency!public! !


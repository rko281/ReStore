"Filed out from Dolphin Smalltalk"!

SSWReStoreDeleteRelatedGeneralCollectionTest subclass: #SSWReStoreDeleteRelatedDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWReStoreDeleteRelatedDictionaryTest guid: (GUID fromString: '{8d33e6c0-9f02-4448-a18f-8cf8d74334ef}')!

SSWReStoreDeleteRelatedDictionaryTest comment: ''!

!SSWReStoreDeleteRelatedDictionaryTest categoriesForClass!Unclassified! !

!SSWReStoreDeleteRelatedDictionaryTest methodsFor!

addOrderFor: aProduct to: aCustomer quantity: anInteger

	"Need to convert orders to Dictionary if not already done - ensure unproxied before transformation"
	reStore abandonTransaction.
	(aCustomer orders _proxiedObject isKindOf: Dictionary) ifFalse: [aCustomer orders _proxiedObject become: Dictionary new].

	^aCustomer orders at: (SimpleAddress new postcode: (aProduct description, anInteger displayString); yourself) put: 
		(SimpleProductOrder new 
			product: aProduct; 
			quantity: anInteger; 
			customer: aCustomer; 
			yourself)! !

!SSWReStoreDeleteRelatedDictionaryTest categoriesForMethods!
addOrderFor:to:quantity:!public!running! !
!

!SSWReStoreDeleteRelatedDictionaryTest class methodsFor!

isAbstract

	^self = SSWReStoreDeleteRelatedDictionaryTest! !

!SSWReStoreDeleteRelatedDictionaryTest class categoriesForMethods!
isAbstract!public! !
!


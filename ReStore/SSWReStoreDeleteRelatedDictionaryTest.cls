"Filed out from Dolphin Smalltalk 7"!

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
	aCustomer orders size.
	(aCustomer orders isKindOf: Dictionary) ifFalse: [aCustomer orders become: Dictionary new].

	^aCustomer orders at: (SimpleAddress new postcode: (aProduct description, anInteger displayString); yourself) put: 
		(SimpleProductOrder new 
			product: aProduct; 
			quantity: anInteger; 
			customer: aCustomer; 
			yourself)! !
!SSWReStoreDeleteRelatedDictionaryTest categoriesFor: #addOrderFor:to:quantity:!public!running! !

!SSWReStoreDeleteRelatedDictionaryTest class methodsFor!

isAbstract

	^self = SSWReStoreDeleteRelatedDictionaryTest! !
!SSWReStoreDeleteRelatedDictionaryTest class categoriesFor: #isAbstract!public! !


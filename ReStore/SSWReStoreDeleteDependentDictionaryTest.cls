"Filed out from Dolphin Smalltalk"!

SSWReStoreDeleteDependentGeneralCollectionTest subclass: #SSWReStoreDeleteDependentDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWReStoreDeleteDependentDictionaryTest guid: (GUID fromString: '{33991a5e-f853-4f0d-ad14-aa1f9c6c75df}')!

SSWReStoreDeleteDependentDictionaryTest comment: ''!

!SSWReStoreDeleteDependentDictionaryTest categoriesForClass!Unclassified! !

!SSWReStoreDeleteDependentDictionaryTest methodsFor!

addOrderFor: aProduct to: aCustomer quantity: anInteger

	"Need to convert orders to Dictionary if not already done"
	reStore abandonTransaction.
	(aCustomer orders _proxiedObject isKindOf: Dictionary) ifFalse: [aCustomer orders _proxiedObject become: Dictionary new].

	^aCustomer orders at: (SimpleAddress new postcode: (aProduct description, anInteger displayString); yourself) put: 
		(SimpleProductOrder new 
			product: aProduct; 
			quantity: anInteger; 
			customer: aCustomer; 
			yourself)! !

!SSWReStoreDeleteDependentDictionaryTest categoriesForMethods!
addOrderFor:to:quantity:!public!running! !
!

!SSWReStoreDeleteDependentDictionaryTest class methodsFor!

isAbstract

	^self = SSWReStoreDeleteDependentDictionaryTest! !

!SSWReStoreDeleteDependentDictionaryTest class categoriesForMethods!
isAbstract!public! !
!


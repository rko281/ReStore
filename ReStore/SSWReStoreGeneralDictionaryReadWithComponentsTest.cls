"Filed out from Dolphin Smalltalk 7"!

SSWReStoreReadWithComponentsTest subclass: #SSWReStoreGeneralDictionaryReadWithComponentsTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreGeneralDictionaryReadWithComponentsTest guid: (GUID fromString: '{2e410b34-083d-4c10-824c-da6ac299b578}')!
SSWReStoreGeneralDictionaryReadWithComponentsTest comment: ''!
!SSWReStoreGeneralDictionaryReadWithComponentsTest categoriesForClass!Unclassified! !
!SSWReStoreGeneralDictionaryReadWithComponentsTest methodsFor!

addOrderFor: aProduct to: aCustomer quantity: anInteger

	"Need to convert orders to Dictionary if not already done - ensure unproxied before transformation"
	aCustomer orders size.
	(aCustomer orders isKindOf: Dictionary) ifFalse: [aCustomer orders become: Dictionary new].

	^aCustomer orders at: (SimpleAddress new postcode: (aProduct description, anInteger displayString); yourself) put: 
		(SimpleProductOrder new 
			product: aProduct; 
			quantity: anInteger; 
			customer: aCustomer; 
			yourself)!

ordersCollectionDefinition

	^Dictionary of: (SimpleAddress related -> SimpleProductOrder related)!

testCollection

	super testCollection.

	self validateKeysAlreadyFetched!

testEmptyCollection

	super testEmptyCollection.

	self validateKeysAlreadyFetched!

testProxyCollection

	super testProxyCollection.

	self validateKeysAlreadyFetched!

testProxyCollectionMultipleRead

	super testProxyCollectionMultipleRead.

	self validateKeysAlreadyFetched!

testProxySingleObject

	super testProxySingleObject.

	self validateKeysAlreadyFetched!

testProxySingleObjectMultipleRead

	super testProxySingleObjectMultipleRead.

	self validateKeysAlreadyFetched!

testRefreshCollection

	super testRefreshCollection.

	self validateKeysAlreadyFetched!

testRefreshCollectionKey

	| allCustomers testAddress originalPostcode |

	allCustomers := customers asOrderedCollection.
	
	testAddress := allCustomers first orders keys anyOne.
	originalPostcode := testAddress postcode.

	"Update directly in database"
	reStore executeSQLAsTxn: {('update <1s> set postcode = ''x'' where id_ = <2p>' expandMacrosWith: (reStore tableForClass: testAddress class) name with: testAddress _id)}.

	"fetch: will miss the update since testOrder already exists in the image and has been viewed/touched"
	allCustomers fetch: #orders.
	self assert: testAddress postcode equals: originalPostcode.

	"Following a soft rollback however we should pick it up"
	reStore softRollback.
	allCustomers fetch: #orders.
	self assert: testAddress postcode equals: 'x'.
	self assert: ((SimpleAddress storedInstancesIn: reStore) select: [ :each | each postcode = 'x']) size equals: 1!

testRefreshProxyCollection

	super testRefreshProxyCollection.

	self validateKeysAlreadyFetched!

testRefreshSingleObject

	super testRefreshSingleObject.

	self validateKeysAlreadyFetched!

validateKeysAlreadyFetched

	"Validate the keys are correct, and ensure they are already fetched (no further queries necessary)"

	"Need to ensure products are present"
	customer4 orders do: [ :each | each product description].

	self resetQueryCount.
	customer4 orders keysAndValuesDo: [ :address :order | self assert: address postcode equals: '<1s><2p>' << {order product description. order quantity}].
	self assert: self queryCount equals: 0! !
!SSWReStoreGeneralDictionaryReadWithComponentsTest categoriesFor: #addOrderFor:to:quantity:!helpers!private! !
!SSWReStoreGeneralDictionaryReadWithComponentsTest categoriesFor: #ordersCollectionDefinition!constants!public! !
!SSWReStoreGeneralDictionaryReadWithComponentsTest categoriesFor: #testCollection!public!unit tests! !
!SSWReStoreGeneralDictionaryReadWithComponentsTest categoriesFor: #testEmptyCollection!public!unit tests! !
!SSWReStoreGeneralDictionaryReadWithComponentsTest categoriesFor: #testProxyCollection!public!unit tests! !
!SSWReStoreGeneralDictionaryReadWithComponentsTest categoriesFor: #testProxyCollectionMultipleRead!public!unit tests! !
!SSWReStoreGeneralDictionaryReadWithComponentsTest categoriesFor: #testProxySingleObject!public!unit tests! !
!SSWReStoreGeneralDictionaryReadWithComponentsTest categoriesFor: #testProxySingleObjectMultipleRead!public!unit tests! !
!SSWReStoreGeneralDictionaryReadWithComponentsTest categoriesFor: #testRefreshCollection!public!unit tests! !
!SSWReStoreGeneralDictionaryReadWithComponentsTest categoriesFor: #testRefreshCollectionKey!public!unit tests! !
!SSWReStoreGeneralDictionaryReadWithComponentsTest categoriesFor: #testRefreshProxyCollection!public!unit tests! !
!SSWReStoreGeneralDictionaryReadWithComponentsTest categoriesFor: #testRefreshSingleObject!public!unit tests! !
!SSWReStoreGeneralDictionaryReadWithComponentsTest categoriesFor: #validateKeysAlreadyFetched!helpers!private! !

!SSWReStoreGeneralDictionaryReadWithComponentsTest class methodsFor!

testSelectors

	^self myTestSelectors, #(#testRefreshCollectionKey)! !
!SSWReStoreGeneralDictionaryReadWithComponentsTest class categoriesFor: #testSelectors!public! !


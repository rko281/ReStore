"Filed out from Dolphin Smalltalk 7"!

SSWReStoreDeleteRelatedCollectionTest subclass: #SSWReStoreDeleteRelatedOwnedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreDeleteRelatedOwnedCollectionTest guid: (GUID fromString: '{a64816db-db0e-4694-b366-f601bc68613f}')!
SSWReStoreDeleteRelatedOwnedCollectionTest comment: ''!
!SSWReStoreDeleteRelatedOwnedCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreDeleteRelatedOwnedCollectionTest methodsFor!

deleteCustomer1QueriesCount

	"To respect the change detection mechanism, the removal of elements from an owned collection (which involves setting the owner link to nil) must be done to each element individually"
	^1  + 11 "customer + 11 collection entries"!

deleteCustomer2QueriesCount

	"To respect the change detection mechanism, the removal of elements from an owned collection (which involves setting the owner link to nil) must be done to each element individually"
	^1 + 10 "customer + 10 collection elements"!

deleteQueriesCount

	"Not used here; just to satisfy subclassResponsibility"
	^self shouldNotImplement!

ordersCollectionDefinition

	"Owned collection"

	^(OrderedCollection of: SimpleProductOrder related owner: #customer)!

testDeleteProxiedCollection

	| customer2Orders |

	customer2Orders := (SimpleProductOrder storedInstancesIn: reStore) select: [ :each | each customer = customer2].
	self assert: (customer2Orders allSatisfy: [ :each | each customer = customer2]).

	super testDeleteProxiedCollection.

	"Verify the backpointers are nil"
	self assert: (customer2Orders allSatisfy: [ :each | each customer isNil])!

testDeleteUnproxiedCollection

	| customer1Orders |

	customer1Orders := (SimpleProductOrder storedInstancesIn: reStore) select: [ :each | each customer = customer1].
	self assert: (customer1Orders allSatisfy: [ :each | each customer = customer1]).

	super testDeleteUnproxiedCollection.

	"Verify the backpointers are nil"
	self assert: (customer1Orders allSatisfy: [ :each | each customer isNil])! !
!SSWReStoreDeleteRelatedOwnedCollectionTest categoriesFor: #deleteCustomer1QueriesCount!constants!public! !
!SSWReStoreDeleteRelatedOwnedCollectionTest categoriesFor: #deleteCustomer2QueriesCount!constants!public! !
!SSWReStoreDeleteRelatedOwnedCollectionTest categoriesFor: #deleteQueriesCount!constants!public! !
!SSWReStoreDeleteRelatedOwnedCollectionTest categoriesFor: #ordersCollectionDefinition!constants!public! !
!SSWReStoreDeleteRelatedOwnedCollectionTest categoriesFor: #testDeleteProxiedCollection!public!unit tests! !
!SSWReStoreDeleteRelatedOwnedCollectionTest categoriesFor: #testDeleteUnproxiedCollection!public!unit tests! !

!SSWReStoreDeleteRelatedOwnedCollectionTest class methodsFor!

testSelectors

	^self myTestSelectors! !
!SSWReStoreDeleteRelatedOwnedCollectionTest class categoriesFor: #testSelectors!public! !


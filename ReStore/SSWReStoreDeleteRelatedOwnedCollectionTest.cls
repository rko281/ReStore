"Filed out from Dolphin Smallalk"!

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
	self assert: (customer1Orders allSatisfy: [ :each | each customer isNil])!

testUnstoreCollectionElements

	"Verify unstoring collection elements does not delete the owning customer (previous error case)"

	| id expectedCount |

	self deny: customer1 orders isEmpty.

	id := customer1 _id.
	expectedCount := (reStore instancesOf: SimpleProductOrder) size - customer1 orders size.

	"For dialects which do not supportsDeleteWithJoin this isn't supported"
	reStore sqlDialect supportsDeleteWithJoin
		ifTrue: [(reStore instancesOf: SimpleProductOrder) unstore: [ :each | each customer firstName = customer1 firstName]]
		ifFalse: [^self should: [(reStore instancesOf: SimpleProductOrder) unstore: [ :each | each customer firstName = customer1 firstName]] raise: Error].

	reStore simulateReconnect.
	customer1 := (reStore instancesOf: SimplePerson) detect: [ :each | each _id = id] ifNone: [nil].

	"Verify customer1 still exists"
	self assert: customer1 notNil.

	"Verify deletion has happened"
	self assert: customer1 orders isEmpty.	
	self assert: (reStore instancesOf: SimpleProductOrder) size equals: expectedCount! !
!SSWReStoreDeleteRelatedOwnedCollectionTest categoriesForMethods!
deleteCustomer1QueriesCount!constants!public! !
deleteCustomer2QueriesCount!constants!public! !
deleteQueriesCount!constants!public! !
ordersCollectionDefinition!constants!public! !
testDeleteProxiedCollection!public!unit tests! !
testDeleteUnproxiedCollection!public!unit tests! !
testUnstoreCollectionElements!public!unit tests! !
!

!SSWReStoreDeleteRelatedOwnedCollectionTest class methodsFor!

testSelectors

	^self myTestSelectors! !
!SSWReStoreDeleteRelatedOwnedCollectionTest class categoriesForMethods!
testSelectors!public! !
!


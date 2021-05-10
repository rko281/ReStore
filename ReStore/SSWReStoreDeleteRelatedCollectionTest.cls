"Filed out from Dolphin Smalltalk 7"!

SSWReStoreDeleteCollectionTest subclass: #SSWReStoreDeleteRelatedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreDeleteRelatedCollectionTest guid: (GUID fromString: '{7d53204a-6a11-4b22-941e-83c65fd834a0}')!
SSWReStoreDeleteRelatedCollectionTest comment: ''!
!SSWReStoreDeleteRelatedCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreDeleteRelatedCollectionTest methodsFor!

testDeleteProxiedCollection

	| allOrders totalOrderCount id |

	allOrders := SimpleProductOrder storedInstancesIn: reStore.
	totalOrderCount := allOrders size.

	id := customer2 _id.
	self assert: customer2 isDBProxy.
	self assert: customer2 unstore.

	self deny: ((SimplePerson storedInstancesIn: reStore) anySatisfy: [ :each | each _id = id]).
	self assert: allOrders size equals: totalOrderCount!

testDeleteUnproxiedCollection

	| allOrders totalOrderCount id |

	allOrders := SimpleProductOrder storedInstancesIn: reStore.
	totalOrderCount := allOrders size.

	id := customer1 _id.
	self deny: customer1 isDBProxy.
	self assert: customer1 unstore.

	self deny: ((SimplePerson storedInstancesIn: reStore) anySatisfy: [ :each | each _id = id]).
	self assert: allOrders size equals: totalOrderCount! !
!SSWReStoreDeleteRelatedCollectionTest categoriesFor: #testDeleteProxiedCollection!public!unit tests! !
!SSWReStoreDeleteRelatedCollectionTest categoriesFor: #testDeleteUnproxiedCollection!public!unit tests! !

!SSWReStoreDeleteRelatedCollectionTest class methodsFor!

isAbstract

	^self = SSWReStoreDeleteRelatedCollectionTest!

myTestSelectors

	^SSWReStoreDeleteCollectionTest testSelectors, SSWReStoreDeleteRelatedCollectionTest testSelectors! !
!SSWReStoreDeleteRelatedCollectionTest class categoriesFor: #isAbstract!public! !
!SSWReStoreDeleteRelatedCollectionTest class categoriesFor: #myTestSelectors!public! !


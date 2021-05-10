"Filed out from Dolphin Smalltalk 7"!

SSWReStoreDeleteCollectionTest subclass: #SSWReStoreDeleteDependentCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreDeleteDependentCollectionTest guid: (GUID fromString: '{c3b90a88-5bf4-4fc2-992c-d988ca2c474b}')!
SSWReStoreDeleteDependentCollectionTest comment: ''!
!SSWReStoreDeleteDependentCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreDeleteDependentCollectionTest methodsFor!

testDeleteProxiedCollection

	| allOrders totalOrderCount customer1OrderCount customer2OrderCount customer3OrderCount id |

	allOrders := SimpleProductOrder storedInstancesIn: reStore.
	totalOrderCount := allOrders size.
	customer1OrderCount := customer1 orders size.
	customer2OrderCount := (allOrders satisfying: [ :each | each customer = customer2]) size.
	customer3OrderCount := customer3 orders size.

	id := customer2 _id.
	self assert: customer2 isDBProxy.
	self assert: customer2 unstore.

	self deny: ((SimplePerson storedInstancesIn: reStore) anySatisfy: [ :each | each _id = id]).
	self assert: allOrders size equals: (totalOrderCount - customer2OrderCount).
	self assert: (allOrders satisfying: [ :each | each customer = customer1]) size equals: customer1OrderCount.
	self assert: (allOrders satisfying: [ :each | each customer = customer3]) size equals: customer3OrderCount!

testDeleteUnproxiedCollection

	| allOrders totalOrderCount customer1OrderCount customer2OrderCount customer3OrderCount id |

	allOrders := SimpleProductOrder storedInstancesIn: reStore.
	totalOrderCount := allOrders size.
	customer1OrderCount := customer1 orders size.
	customer2OrderCount := customer2 orders size.
	customer3OrderCount := customer3 orders size.

	id := customer1 _id.
	self deny: customer1 isDBProxy.
	self assert: customer1 unstore.

	self deny: ((SimplePerson storedInstancesIn: reStore) anySatisfy: [ :each | each _id = id]).
	self assert: allOrders size equals: (totalOrderCount - customer1OrderCount).
	self assert: (allOrders satisfying: [ :each | each customer = customer2]) size equals: customer2OrderCount.
	self assert: (allOrders satisfying: [ :each | each customer = customer3]) size equals: customer3OrderCount! !
!SSWReStoreDeleteDependentCollectionTest categoriesFor: #testDeleteProxiedCollection!public!unit tests! !
!SSWReStoreDeleteDependentCollectionTest categoriesFor: #testDeleteUnproxiedCollection!public!unit tests! !

!SSWReStoreDeleteDependentCollectionTest class methodsFor!

isAbstract

	^self = SSWReStoreDeleteDependentCollectionTest!

myTestSelectors

	^SSWReStoreDeleteCollectionTest testSelectors, SSWReStoreDeleteDependentCollectionTest testSelectors! !
!SSWReStoreDeleteDependentCollectionTest class categoriesFor: #isAbstract!public! !
!SSWReStoreDeleteDependentCollectionTest class categoriesFor: #myTestSelectors!public! !


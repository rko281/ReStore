"Filed out from Dolphin Smalltalk 7"!

SSWReStoreQueryTest subclass: #SSWReStoreProductOrdersTest
	instanceVariableNames: 'widget gadget wobulator customer1 customer2 customer3 customer4'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreProductOrdersTest guid: (GUID fromString: '{4d731556-08d6-4651-a9fc-3700fcc75320}')!
SSWReStoreProductOrdersTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreProductOrdersTest categoriesForClass!Unclassified! !
!SSWReStoreProductOrdersTest methodsFor!

addClassesTo: aReStore

	super addClassesTo: aReStore.
	aReStore addClass: SimpleProductOrder.

	(aReStore tableForClass: SimplePerson) define: #orders as: self ordersCollectionDefinition!

ordersCollectionDefinition

	"Owned collection"

	^(OrderedCollection of: SimpleProductOrder related owner: #customer)!

setUp

	| products customers |

	super setUp.

	self createProducts.

	products := (reStore instancesOf: SimpleProduct) asOrderedCollection.
	widget := products detect: [ :each | each description = 'widget'].
	gadget := products detect: [ :each | each description = 'gadget'].
	wobulator := products detect: [ :each | each description = 'wobulator'].

	customers := (reStore instancesOf: SimplePerson) asOrderedCollection.
	customers size = 4 ifFalse: [self error: 'test data incorrect'].
	customer1 := customers first.
	customer2 := customers second.
	customer3 := customers third.
	customer4 := customers last! !
!SSWReStoreProductOrdersTest categoriesFor: #addClassesTo:!public!running! !
!SSWReStoreProductOrdersTest categoriesFor: #ordersCollectionDefinition!constants!public! !
!SSWReStoreProductOrdersTest categoriesFor: #setUp!public!running! !

!SSWReStoreProductOrdersTest class methodsFor!

isAbstract

	^self == SSWReStoreProductOrdersTest!

shouldInheritSelectors

	^false! !
!SSWReStoreProductOrdersTest class categoriesFor: #isAbstract!public! !
!SSWReStoreProductOrdersTest class categoriesFor: #shouldInheritSelectors!public! !


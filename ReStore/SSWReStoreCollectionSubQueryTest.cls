﻿"Filed out from Dolphin Smallalk"!

SSWReStoreProductOrdersTest subclass: #SSWReStoreCollectionSubQueryTest
	instanceVariableNames: 'customers goldPlatedWobulator'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreCollectionSubQueryTest guid: (GUID fromString: '{595da126-bf23-4658-9895-e241a1053ff4}')!
SSWReStoreCollectionSubQueryTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreCollectionSubQueryTest categoriesForClass!Unclassified! !
!SSWReStoreCollectionSubQueryTest methodsFor!

createTestData

	| orders |

	super createTestData.

	reStore evaluateAsTransaction: 
		[SimpleProduct new
			description: 'gold-plated wobulator';
			supplierPrice: 1000;
			retailPrice: 2000;
			storeIn: reStore].

	goldPlatedWobulator := (SimpleProduct storedInstancesIn: reStore) detect: [ :each | each retailPrice = 2000].

	orders := OrderedCollection new.

	1 to: 10 do: [ :index | orders add: (customer1 orders add: (SimpleProductOrder new product: widget; quantity: (index * 10); customer: customer1; yourself))].
	1 to: 5 do: [ :index | orders add: (customer2 orders add: (SimpleProductOrder new product: widget; quantity: (index * 10); customer: customer2; yourself))].
	5 to: 10 do: [ :index | orders add: (customer3 orders add: (SimpleProductOrder new product: widget; quantity: (index * 10); customer: customer3; yourself))].

	1 to: 5 do: [ :index | orders add: (customer1 orders add: (SimpleProductOrder new product: gadget; quantity: (index * 10); customer: customer1; yourself))].
	1 to: 15 do: [ :index | orders add: (customer2 orders add: (SimpleProductOrder new product: gadget; quantity: (index * 10); customer: customer2; yourself))].
	
	1 to: 10 do: [ :index | orders add: (customer1 orders add: (SimpleProductOrder new product: wobulator; quantity: (index * 100); customer: customer1; yourself))].

	((OrderedCollection withAll: orders)
		add: customer1;
		add: customer2;
		add: customer3;
		yourself) storeAllIn: reStore.

	reStore refreshAllObjects.

	customers := SimplePerson storedInstancesIn: reStore!

testAnySatisfyDeep

	| matches |

	matches := customers select: [ :each | each orders anySatisfy: [ :order | order product supplierPrice = 1]].
	self assert: (matches size = 3).
	self assert: (matches includes: customer1).
	self assert: (matches includes: customer2).
	self assert: (matches includes: customer3).
	self deny: (matches includes: customer4).

	matches := customers select: [ :each | each orders anySatisfy: [ :order | order product retailPrice = 6]].
	self assert: (matches size = 2).
	self assert: (matches includes: customer1).
	self assert: (matches includes: customer2).
	self deny: (matches includes: customer3).
	self deny: (matches includes: customer4).

	matches := customers select: [ :each | each orders anySatisfy: [ :order | order product supplierPrice = 100]].
	self assert: (matches size = 1).
	self assert: (matches first == customer1).

	matches := customers select: [ :each | each orders anySatisfy: [ :order | order product retailPrice = 2000]].
	self assert: (matches isEmpty)!

testAnySatisfyPersistent

	| matches |

	matches := customers select: [ :each | each orders anySatisfy: [ :order | order product = widget]].
	self assert: (matches size = 3).
	self assert: (matches includes: customer1).
	self assert: (matches includes: customer2).
	self assert: (matches includes: customer3).
	self deny: (matches includes: customer4).

	matches := customers select: [ :each | each orders anySatisfy: [ :order | order product = gadget]].
	self assert: (matches size = 2).
	self assert: (matches includes: customer1).
	self assert: (matches includes: customer2).
	self deny: (matches includes: customer3).
	self deny: (matches includes: customer4).

	matches := customers select: [ :each | each orders anySatisfy: [ :order | order product = wobulator]].
	self assert: (matches size = 1).
	self assert: (matches first == customer1).

	matches := customers select: [ :each | each orders anySatisfy: [ :order | order product = goldPlatedWobulator]].
	self assert: (matches isEmpty)!

testAnySatisfySimple

	| matches |

	matches := customers select: [ :each | each orders anySatisfy: [ :order | order quantity >= 100]].
	self assert: (matches size = 3).
	self assert: (matches includes: customer1).
	self assert: (matches includes: customer2).
	self assert: (matches includes: customer3).
	self deny: (matches includes: customer4).

	matches := customers select: [ :each | each orders anySatisfy: [ :order | order quantity >= 150]].
	self assert: (matches size = 2).
	self assert: (matches includes: customer1).
	self assert: (matches includes: customer2).
	self deny: (matches includes: customer3).
	self deny: (matches includes: customer4).

	matches := customers select: [ :each | each orders anySatisfy: [ :order | order quantity >= 200]].
	self assert: (matches size = 1).
	self assert: (matches first == customer1).

	matches := customers select: [ :each | each orders anySatisfy: [ :order | order quantity >= 1000]].
	self assert: (matches size = 1).
	self assert: (matches first == customer1).

	matches := customers select: [ :each | each orders anySatisfy: [ :order | order quantity > 1000]].
	self assert: (matches isEmpty)!

testCollectFirst

	| results |

	results := Dictionary withAll: (customers collect: [ :each | each -> each orders first]).

	"Note we don't get an error for an empty collection"
	self assert: results size = 4.
	self assert: ((results at: customer1) quantity = 10).
	self assert: ((results at: customer2) quantity = 10).
	self assert: ((results at: customer3) quantity = 50).
	self assert: ((results at: customer4) isNil)!

testCollectionSize

	| matches |

	matches := customers select: [ :each | each orders size >= 6].
	self assert: (matches size = 3).
	self assert: (matches includes: customer1).
	self assert: (matches includes: customer2).
	self assert: (matches includes: customer3).

	matches := customers select: [ :each | each orders size > 6].
	self assert: (matches size = 2).
	self assert: (matches includes: customer1).
	self assert: (matches includes: customer2).

	matches := customers select: [ :each | each orders size = 25].
	self assert: (matches size = 1).
	self assert: (matches first = customer1).

	matches := customers select: [ :each | each orders size <= 6].
	self assert: (matches size = 1).
	self assert: (matches first = customer3).

	matches := customers select: [ :each | each orders size = 0].
	self assert: (matches size = 1).
	self assert: (matches first = customer4).!

testCollectLast

	| results |

	results := Dictionary withAll: (customers collect: [ :each | each -> each orders last]).

	"Note we don't get an error for an empty collection"
	self assert: results size = 4.
	self assert: ((results at: customer1) quantity = 1000).
	self assert: ((results at: customer2) quantity = 150).
	self assert: ((results at: customer3) quantity = 100).
	self assert: ((results at: customer4) isNil)!

testCollectSize

	| results |

	results := Dictionary withAll: (customers collect: [ :each | each -> each orderCount]).

	self assert: results size equals: 4.
	self assert: (results at: customer1) equals: 25.
	self assert: (results at: customer2) equals: 20.
	self assert: (results at: customer3) equals: 6.
	self assert: (results at: customer4) equals: 0!

testConditionAndCollectWithSize

	"Test for a previously-failing case where a size expression in a collect: block overwrote and removed conditions expressed in an earlier satisfying: block"

	| browns results jim zoe |

	browns := (SimplePerson storedInstancesIn: reStore) satisfying: [ :each | each surname = 'Brown'].
	results := browns collect: [ :each | each fullName || each orderCount].

	self assert: results size equals: 2.

	jim := customers detect: [ :each | each firstName = 'Jim'].
	zoe := customers detect: [ :each | each firstName = 'Zoe'].
	self assert: (results asSortedCollection: [ :a :b | a first <= b first]) asArray equals: {{jim fullName. jim orderCount}. {zoe fullName. zoe orderCount}}!

testConditionAndCollectWithSubQuery

	"Test for a previously-erroring case where a subquery expression in a collect: block gave SSWDBStaticField MNU: #hasAggregateFunction"

	| browns results jim zoe |

	browns := (SimplePerson storedInstancesIn: reStore) satisfying: [ :each | each surname = 'Brown'].
	self shouldnt: [results := browns collect: [ :each | each fullName || each orders isEmpty not]] raise: MessageNotUnderstood.

	self assert: results size equals: 2.
	jim := customers detect: [ :each | each firstName = 'Jim'].
	zoe := customers detect: [ :each | each firstName = 'Zoe'].
	self assert: (results asSortedCollection: [ :a :b | a first <= b first]) asArray equals: {{jim fullName. jim orderCount > 0}. {zoe fullName. zoe orderCount > 0}}!

testIncludes

	{customer1. customer2. customer3} do:
		[ :customer || testOrder matches otherCustomers |
		testOrder := customer orders first.

		matches := customers select: [ :each | each orders includes: testOrder].
		self assert: (matches size = 1).
		self assert: (matches first == customer).

		otherCustomers := customers asOrderedCollection reject: [ :each | each == customer].

		matches := customers select: [ :each | (each orders includes: testOrder) not].
		self assert: (matches size = 3).
		self deny: (matches includes: customer).
		self assert: (otherCustomers allSatisfy: [ :otherCustomer | matches includes: otherCustomer])]!

testIsEmpty

	| matches |

	matches := customers select: [ :each | each orders isEmpty].
	self assert: (matches size = 1).
	self assert: (matches first == customer4)!

testIsNotEmpty

	| matches |

	matches := customers select: [ :each | each orders isEmpty not].
	self assert: (matches size = 3).
	self deny: (matches anySatisfy: [ :each | each == customer4])!

testSelectSimpleCollectFirst

	| results |

	results := Dictionary withAll: (customers collect: [ :each | each -> ((each orders select: [ :order | order quantity >= 100]) first)]).

	self assert: results size = 3.
	self assert: ((results at: customer1) quantity = 100).
	self assert: ((results at: customer2) quantity = 100).
	self assert: ((results at: customer3) quantity = 100)!

testSelectSimpleCollectSize

	| results |

	results := Dictionary withAll: (customers collect: [ :each | each -> ((each orders select: [ :order | order quantity >= 100]) size)]).

	self assert: results size = 3.
	self assert: ((results at: customer1) = 11).
	self assert: ((results at: customer2) = 6).
	self assert: ((results at: customer3) = 1)!

testSelectSimpleSizeComparison

	| matches |

	matches := customers select: [ :each | (each orders select: [ :order | order quantity >= 100]) size >=1].
	self assert: (matches size = 3).
	self assert: (matches includes: customer1).
	self assert: (matches includes: customer2).
	self assert: (matches includes: customer3).
	self deny: (matches includes: customer4).

	matches := customers select: [ :each | (each orders select: [ :order | order quantity >= 100]) size >= 5].
	self assert: (matches size = 2).
	self assert: (matches includes: customer1).
	self assert: (matches includes: customer2).
	self deny: (matches includes: customer3).
	self deny: (matches includes: customer4).

	matches := customers select: [ :each | (each orders select: [ :order | order quantity >= 100]) size >= 10].
	self assert: (matches size = 1).
	self assert: (matches first == customer1).

	matches := customers select: [ :each | (each orders select: [ :order | order quantity >= 1000]) size >= 10].
	self assert: (matches isEmpty)! !
!SSWReStoreCollectionSubQueryTest categoriesForMethods!
createTestData!public!running! !
testAnySatisfyDeep!public!unit tests! !
testAnySatisfyPersistent!public!unit tests! !
testAnySatisfySimple!public!unit tests! !
testCollectFirst!public!unit tests! !
testCollectionSize!public!unit tests! !
testCollectLast!public!unit tests! !
testCollectSize!public!unit tests! !
testConditionAndCollectWithSize!public!unit tests! !
testConditionAndCollectWithSubQuery!public! !
testIncludes!public!unit tests! !
testIsEmpty!public!unit tests! !
testIsNotEmpty!public!unit tests! !
testSelectSimpleCollectFirst!public!unit tests! !
testSelectSimpleCollectSize!public!unit tests! !
testSelectSimpleSizeComparison!public!unit tests! !
!

!SSWReStoreCollectionSubQueryTest class methodsFor!

isAbstract

	^self == SSWReStoreCollectionSubQueryTest!

myTestSelectors

	^SSWReStoreCollectionSubQueryTest testSelectors! !
!SSWReStoreCollectionSubQueryTest class categoriesForMethods!
isAbstract!public! !
myTestSelectors!public! !
!


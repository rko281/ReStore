﻿"Filed out from Dolphin Smallalk"!

SSWReStoreProductOrdersTest subclass: #SSWReStoreAggregateQueryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreAggregateQueryTest guid: (GUID fromString: '{0509f259-27ea-4153-9aea-f3ff8bb8bb40}')!
SSWReStoreAggregateQueryTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreAggregateQueryTest categoriesForClass!Unclassified! !
!SSWReStoreAggregateQueryTest methodsFor!

createTestData

	| orders |

	super createTestData.

	orders := OrderedCollection new.

	1 to: 10 do: [ :index | orders add: (SimpleProductOrder new product: widget; quantity: index; customer: (index odd ifTrue: [customer1] ifFalse: [customer2]); yourself)].
	1 to: 5 do: [ :index | orders add: (SimpleProductOrder new product: gadget; quantity: (index * 10); customer: (index odd ifTrue: [customer1] ifFalse: [customer2]); yourself)].
	1 to: 2 do: [ :index | orders add: (SimpleProductOrder new product: wobulator; quantity: (index * 100); customer: (index odd ifTrue: [customer1] ifFalse: [customer2]); yourself)].

	orders storeAllIn: reStore!

testAll

	| orders mins maxs sums avgs counts |

	orders := SimpleProductOrder storedInstancesIn: reStore.
	counts := Dictionary new.
	mins := Dictionary new.
	maxs := Dictionary new.
	sums := Dictionary new.
	avgs := Dictionary new.

	(orders project: [ :each | each product || each count || each quantity minimum || each quantity maximum || each quantity sum || each quantity average]) do: 
		[ :coll| 
		counts at: coll first put: (coll at: 2).
		mins at: coll first put: (coll at: 3).
		maxs at: coll first put: (coll at: 4).
		sums at: coll first put: (coll at: 5).
		avgs at: coll first put: (coll at: 6)].

	self assert: (counts at: widget) = 10.
	self assert: (counts at: gadget) = 5.
	self assert: (counts at: wobulator) = 2.

	self assert: (mins at: widget) = 1.
	self assert: (mins at: gadget) = 10.
	self assert: (mins at: wobulator) = 100.

	self assert: (maxs at: widget) = 10.
	self assert: (maxs at: gadget) = 50.
	self assert: (maxs at: wobulator) = 200.

	self assert: (sums at: widget) = 55.
	self assert: (sums at: gadget) = 150.
	self assert: (sums at: wobulator) = 300.

	"SQL Server applies the column type (Integer) to the aggregated value"
	reStore sqlDialect class = SSWSQLServerDialect 
		ifTrue: [self assert: (avgs at: widget) = 5]
		ifFalse: [self assert: (avgs at: widget) = 5.5].
	self assert: (avgs at: gadget) = 30.
	self assert: (avgs at: wobulator) = 150!

testGroupedAverage

	| orders results |

	orders := SimpleProductOrder storedInstancesIn: reStore.
	results := Dictionary new.

	(orders project: [ :each | each product || each quantity average]) do: [ :pair | results at: pair first put: pair last].

	self assert: results size = 3.
	"SQL Server applies the column type (Integer) to the aggregated value"
	reStore sqlDialect class = SSWSQLServerDialect 
		ifTrue: [self assert: (results at: widget) = 5]
		ifFalse: [self assert: (results at: widget) = 5.5].
	self assert: (results at: gadget) = 30.
	self assert: (results at: wobulator) = 150!

testGroupedCount

	| orders results |

	orders := SimpleProductOrder storedInstancesIn: reStore.
	results := Dictionary new.

	(orders project: [ :each | each product || each count]) do: [ :pair | results at: pair first put: pair last].

	self assert: results size = 3.
	self assert: (results at: widget) = 10.
	self assert: (results at: gadget) = 5.
	self assert: (results at: wobulator) = 2!

testGroupedMaximum

	| orders results |

	orders := SimpleProductOrder storedInstancesIn: reStore.
	results := Dictionary new.

	(orders project: [ :each | each product || each quantity maximum]) do: [ :pair | results at: pair first put: pair last].

	self assert: results size = 3.
	self assert: (results at: widget) = 10.
	self assert: (results at: gadget) = 50.
	self assert: (results at: wobulator) = 200!

testGroupedMinimum

	| orders results |

	orders := SimpleProductOrder storedInstancesIn: reStore.
	results := Dictionary new.

	(orders project: [ :each | each product || each quantity minimum]) do: [ :pair | results at: pair first put: pair last].

	self assert: results size = 3.
	self assert: (results at: widget) = 1.
	self assert: (results at: gadget) = 10.
	self assert: (results at: wobulator) = 100!

testGroupedSum

	| orders results |

	orders := SimpleProductOrder storedInstancesIn: reStore.
	results := Dictionary new.

	(orders project: [ :each | each product || each quantity sum]) do: [ :pair | results at: pair first put: pair last].

	self assert: results size = 3.
	self assert: (results at: widget) = 55.
	self assert: (results at: gadget) = 150.
	self assert: (results at: wobulator) = 300!

testGroupWithObject

	| uniqueProducts |

	"SELECT * FROM TABLE GROUP BY FIELD not supported on Access or SQL Server"
	((reStore sqlDialect isKindOf: SSWMSAccessDialect) or: [reStore sqlDialect isKindOf: SSWSQLServerDialect]) ifTrue: [self skip].

	uniqueProducts := (SimpleProductOrder storedInstancesIn: reStore) project: [ :each | each product].

	self assert: (uniqueProducts size = 3)!

testMultiGroupedCount

	| orders results |

	orders := SimpleProductOrder storedInstancesIn: reStore.
	results := Dictionary new.

	(orders project: [ :each | each product || each customer || each count]) do: [ :pair | (results at: pair first ifAbsentPut: [Dictionary new]) at: pair second put: pair last].

	self assert: results size = 3.

	self assert: (results at: widget) size = 2.
	self assert: ((results at: widget) at: customer1) = 5.
	self assert: ((results at: widget) at: customer2) = 5.

	self assert: (results at: gadget) size = 2.
	self assert: ((results at: gadget) at: customer1) = 3.
	self assert: ((results at: gadget) at: customer2) = 2.

	self assert: (results at: wobulator) size = 2.
	self assert: ((results at: wobulator) at: customer1) = 1.
	self assert: ((results at: wobulator) at: customer2) = 1.
!

testSimpleAverage

	| orders |

	orders := SimpleProductOrder storedInstancesIn: reStore.

	self assert: (orders project: [ :each | each quantity average]) asArray first truncated = 29!

testSimpleCount

	| orders |

	orders := SimpleProductOrder storedInstancesIn: reStore.

	self assert: (orders project: [ :each | each count]) asArray = #(17)!

testSimpleGroup

	| people  uniqueSurnames |

	people := SimplePerson storedInstancesIn: reStore.

	uniqueSurnames := people project: [ :each | each surname].

	self assert: (uniqueSurnames size = 3).
	self assert: (uniqueSurnames asSortedCollection asArray = #('Brown' 'Smith' 'Smythe'))!

testSimpleMaximum

	| orders |

	orders := SimpleProductOrder storedInstancesIn: reStore.

	self assert: (orders project: [ :each | each quantity maximum]) asArray = #(200)!

testSimpleMinimum

	| orders |

	orders := SimpleProductOrder storedInstancesIn: reStore.

	self assert: (orders project: [ :each | each quantity minimum]) asArray = #(1)!

testSimpleSum

	| orders |

	orders := SimpleProductOrder storedInstancesIn: reStore.

	self assert: (orders project: [ :each | each quantity sum]) asArray = #(505)!

testSize_ie_Count

	"InstancesCollection size is implemented via the aggregation mechanism using COUNT"

	| orders |

	orders := SimpleProductOrder storedInstancesIn: reStore.

	self assert: (orders size = 17)! !
!SSWReStoreAggregateQueryTest categoriesForMethods!
createTestData!public!running! !
testAll!public! !
testGroupedAverage!public!unit tests! !
testGroupedCount!public!unit tests! !
testGroupedMaximum!public!unit tests! !
testGroupedMinimum!public!unit tests! !
testGroupedSum!public!unit tests! !
testGroupWithObject!public!unit tests! !
testMultiGroupedCount!public!unit tests! !
testSimpleAverage!public!unit tests! !
testSimpleCount!public!unit tests! !
testSimpleGroup!public!unit tests! !
testSimpleMaximum!public!unit tests! !
testSimpleMinimum!public!unit tests! !
testSimpleSum!public!unit tests! !
testSize_ie_Count!public!unit tests! !
!


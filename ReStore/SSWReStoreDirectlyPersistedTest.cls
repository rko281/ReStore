"Filed out from Dolphin Smalltalk"!

SSWReStore2Test subclass: #SSWReStoreDirectlyPersistedTest
	instanceVariableNames: 'owner'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreDirectlyPersistedTest guid: (GUID fromString: '{5e4d0065-e7f6-49fe-8304-9071baa6ffb6}')!
SSWReStoreDirectlyPersistedTest comment: ''!
!SSWReStoreDirectlyPersistedTest categoriesForClass!Unclassified! !
!SSWReStoreDirectlyPersistedTest methodsFor!

_testCollection: aSymbol

	| collection |

	collection := owner perform: aSymbol.
	aSymbol = #sortedCollection ifFalse: [collection := collection asSortedCollection].

	self assert: collection size equals: 8.
	self assert: (collection collect: [ :each | each value]) asArray equals: #(1 2 3 4 5 6 7 8).
	self assert: collection asArray equals: ((1 to: 8) collect: [ :each | TestBitmask value: each])!

_testCollectionMutationCommit: aSymbol

	| collection |

	collection := owner perform: aSymbol.
	collection do: [ :each | each bitSet: 8].

	owner store.

	reStore simulateReconnect.
	self reReadTestData.
	collection := owner perform: aSymbol.
	aSymbol = #sortedCollection ifFalse: [collection := collection asSortedCollection].

	self assert: (collection collect: [ :each | each value]) asArray equals: #(129 130 131 132 133 134 135 136).
	self assert: collection asArray equals: ((129 to: 136) collect: [ :each | TestBitmask value: each])!

_testCollectionMutationHasChanged: aSymbol

	| collection |

	collection := owner perform: aSymbol.
	self deny: owner hasChanged.
	self deny: collection hasChanged.

	collection do: [ :each | each bitSet: 8].

	self assert: owner hasChanged.
	self assert: collection hasChanged.!

_testCollectionMutationRefresh: aSymbol

	| owner2 collection |

	owner2 := (reStore2 instancesOf: TestWithBitmask) first.
	(owner2 perform: aSymbol) do: [ :each | each bitSet: 8].
	owner2 store.

	self refreshDelay.

	self _testCollection: aSymbol.
	owner refresh.
	collection := owner perform: aSymbol.
	aSymbol = #sortedCollection ifFalse: [collection := collection asSortedCollection].

	self assert: (collection collect: [ :each | each value]) asArray equals: #(129 130 131 132 133 134 135 136).
	self assert: collection asArray equals: ((129 to: 136) collect: [ :each | TestBitmask value: each])!

_testCollectionMutationRollback: aSymbol

	| collection |

	collection := owner perform: aSymbol.
	collection do: [ :each | each bitSet: 8].

	owner rollback.

	self _testCollection: aSymbol.

	"And again to verify the rollback makes a full copy"
	collection do: [ :each | each bitSet: 8].

	owner rollback.

	self _testCollection: aSymbol.
!

_testSequenceableCollectionCommit: aSymbol

	| collection |

	collection := owner perform: aSymbol.
	collection removeFirst; removeFirst; removeLast; removeLast; removeLast; add: (TestBitmask new value: 99).
	owner store.

	reStore simulateReconnect.
	self reReadTestData.
	collection := owner perform: aSymbol.

	self assert: collection size equals: 4.
	self assert: (collection collect: [ :each | each value]) asArray equals: #(3 4 5 99).
	self assert: collection asArray equals: (#(3 4 5 99) collect: [ :each | TestBitmask value: each])!

_testSequenceableCollectionRefresh: aSymbol

	| owner2 collection |

	owner2 := (reStore2 instancesOf: TestWithBitmask) first.
	(owner2 perform: aSymbol) removeFirst; removeFirst; removeLast; removeLast; removeLast; add: (TestBitmask new value: 99).
	owner2 store.

	self refreshDelay.
	self _testCollection: aSymbol.

	owner refresh.
	collection := owner perform: aSymbol.

	self assert: collection size equals: 4.
	self assert: (collection collect: [ :each | each value]) asArray equals: #(3 4 5 99).
	self assert: collection asArray equals: (#(3 4 5 99) collect: [ :each | TestBitmask value: each])!

_testSequenceableCollectionRollback: aSymbol

	| collection |

	collection := owner perform: aSymbol.

	collection removeFirst; removeFirst; removeLast; removeLast.
	collection last value: 99.
	self assert: collection size equals: 4.
	self assert: (collection collect: [ :each | each value]) asArray equals: #(3 4 5 99).
	self assert: collection asArray equals: (#(3 4 5 99) collect: [ :each | TestBitmask value: each]).

	owner rollback.

	self _testCollection: aSymbol.

	"And again to verify the rollback makes a full copy"
	collection removeFirst; removeFirst; removeLast; removeLast.
	collection last value: 99.
	self assert: collection size equals: 4.
	self assert: (collection collect: [ :each | each value]) asArray equals: #(3 4 5 99).
	self assert: collection asArray equals: (#(3 4 5 99) collect: [ :each | TestBitmask value: each]).

	owner rollback.

	self _testCollection: aSymbol!

addClassesTo: aReStore

	super addClassesTo: aReStore.

	aReStore addClass: TestWithBitmask!

createTestData

	| collection dictionary |

	collection := (1 to: 8) collect: [ :each | TestBitmask value: each].
	dictionary := Dictionary new.
	collection do: [ :each | dictionary at: each put: (each copy bitSet: 9)].

	owner := 
		TestWithBitmask new 
			name: 'owner'; 
			orderedCollection: collection asOrderedCollection;
			sortedCollection: collection asSortedCollection;
			array: collection asArray;
			set: collection asSet;
			dictionary: dictionary;
			storeIn: reStore; 
			yourself!

reReadTestData

	owner := (TestWithBitmask storedInstancesIn: reStore) detect: [ :each | each name = 'owner']!

storeNewOwnersWithBitmaskValues: aCollection

	^(aCollection collect: 
		[ :each |
		TestWithBitmask new 
			bitmask: (TestBitmask value: each);
			yourself]) storeAllIn: reStore; yourself!

testArray

	self _testCollection: #array!

testArrayCommit

	| collection |

	collection := owner array.
	collection at: 1 put: nil; at: 8 put: (TestBitmask new value: 99).
	owner store.

	reStore simulateReconnect.
	self reReadTestData.
	collection := owner array.

	self assert: collection size equals: 8.
	self assert: (collection collect: [ :each | each ifNotNil: [each value]]) asArray equals: #(nil 2 3 4 5 6 7 99).
	self assert: collection asArray equals: (#(nil 2 3 4 5 6 7 99) collect: [ :each | each ifNotNil: [TestBitmask value: each]])!

testArrayMutationCommit

	self _testCollectionMutationCommit: #array!

testArrayMutationHasChanged

	self _testCollectionMutationHasChanged: #array!

testArrayMutationRefresh

	self _testCollectionMutationRefresh: #array!

testArrayMutationRollback

	self _testCollectionMutationRollback: #array!

testArrayRefresh

	| owner2 collection |

	owner2 := (reStore2 instancesOf: TestWithBitmask) first.
	owner2 array at: 1 put: nil; at: 8 put: (TestBitmask new value: 99).
	owner2 store.

	self refreshDelay.
	self testSet.
	owner refresh.
	collection := owner array.

	self assert: collection size equals: 8.
	self assert: (collection collect: [ :each | each ifNotNil: [each value]]) asArray equals: #(nil 2 3 4 5 6 7 99).
	self assert: collection asArray equals: (#(nil 2 3 4 5 6 7 99) collect: [ :each | each ifNotNil: [TestBitmask value: each]])!

testArrayRollback

	owner array at: 1 put: nil; at: 8 put: (TestBitmask new value: 99).
	owner rollback.

	self testArray!

testAutoRefresh

	self assert: owner bitmask value equals: 0.

	(reStore2 instancesOf: TestWithBitmask) first 
		bitmask: (TestBitmask value: 99);
		store.

	self refreshDelay.

	"Re-reading after a rollback will perform an auto refresh"
	reStore rollbackTransaction.
	(reStore instancesOf: TestWithBitmask) first.

	self assert: owner isDBProxy.
	self assert: owner _proxiedObject bitmask value equals: 99.
	self assert: owner _copyObject bitmask value equals: 99.
!

testCollectQuery

	| instances |

	self storeNewOwnersWithBitmaskValues: (1 to: 8).

	instances := TestWithBitmask storedInstancesIn: reStore.
	self assert: (instances collect: [ :each | each bitmask]) asArray equals: ((0 to: 8) collect: [ :each | TestBitmask new value: each])!

testCollectQueryOnValue

	| instances |

	self storeNewOwnersWithBitmaskValues: (1 to: 8).

	instances := TestWithBitmask storedInstancesIn: reStore.
	self assert: (instances collect: [ :each | each bitmask value]) asArray equals: (0 to: 8) asArray!

testCollectQueryWithMethod

	| instances |

	self storeNewOwnersWithBitmaskValues: (1 to: 8).

	instances := TestWithBitmask storedInstancesIn: reStore.
	self assert: (instances collect: [ :each | each bitmask isBitSet: 1]) asArray equals: ((0 to: 8) collect: [ :each | each isBitSet: 1]).
	self assert: (instances collect: [ :each | each bitmask isBitSet: 2]) asArray equals: ((0 to: 8) collect: [ :each | each isBitSet: 2])!

testCommit

	self assert: owner bitmask value equals: 0.

	owner bitmask: (TestBitmask value: 99).
	owner store.

	reStore simulateReconnect.
	self reReadTestData.

	self assert: owner bitmask value equals: 99!

testDeletedObjectRecovery

	"Verify recovery of a deleted object containing a mutable directly persisted object (previously caused an error)"

	| person table |

	reStore addClass: SimplePerson.
	table := reStore tableForClass: SimplePerson.
	(table fieldAccessing: #friend) targetClass: TestWithBitmask.
	reStore synchronizeClass: SimplePerson.

	person := SimplePerson new friend: owner.
	person storeIn: reStore.
	self shouldnt: [owner unstore] raise: Error.

	reStore simulateReconnect.

	person := (SimplePerson storedInstancesIn: reStore) first.
	self assert: person friend isDBDeleted.!

testDictionary

	self assert: owner dictionary size equals: 8.

	self assert: (owner dictionary keys collect: [ :each | each value]) asSortedCollection asArray equals: #(1 2 3 4 5 6 7 8).
	self assert: owner dictionary keys asSortedCollection asArray equals: ((1 to: 8) collect: [ :each | TestBitmask value: each]).

	self assert: (owner dictionary values collect: [ :each | each value]) asSortedCollection asArray equals: #(257 258 259 260 261 262 263 264).
	self assert: owner dictionary values asSortedCollection asArray equals: ((257 to: 264) collect: [ :each | TestBitmask value: each]).

	owner dictionary keysAndValuesDo: [ :key :value | self assert: value value equals: key value + 256]!

testDictionaryCommit

	owner dictionary removeKey: (TestBitmask value: 1); removeKey: (TestBitmask value: 2); removeKey: (TestBitmask value: 6); removeKey: (TestBitmask value: 7); removeKey: (TestBitmask value: 8); at: (TestBitmask value: 9) put: (TestBitmask value: 265).
	owner store.

	reStore simulateReconnect.
	self reReadTestData.

	self assert: owner dictionary size equals: 4.

	self assert: (owner dictionary keys collect: [ :each | each value]) asSortedCollection asArray equals: #(3 4 5 9).
	self assert: owner dictionary keys asSortedCollection asArray equals: (#(3 4 5 9) collect: [ :each | TestBitmask value: each]).

	self assert: (owner dictionary values collect: [ :each | each value]) asSortedCollection asArray equals: #(259 260 261 265).
	self assert: owner dictionary values asSortedCollection asArray equals: (#(259 260 261 265) collect: [ :each | TestBitmask value: each]).

	owner dictionary keysAndValuesDo: [ :key :bitmask | self assert: bitmask value equals: key value + 256]!

testDictionaryMutationCommit

	(owner dictionary at: (TestBitmask value: 1)) bitSet: 8.
	(owner dictionary at: (TestBitmask value: 8)) bitSet: 10.
	owner store.

	reStore simulateReconnect.
	self reReadTestData.

	self assert: owner dictionary size = 8.

	owner dictionary keysAndValuesDo: 
		[ :key :bitmask | 
		key value = 1
		ifTrue: 
			[self assert: bitmask value equals: (1+256+128)]
		ifFalse: 
			[key value = 8
				ifTrue: [self assert: bitmask value equals: (8 + 256 + 512)]
				ifFalse: [self assert: bitmask value equals: key value + 256]]]!

testDictionaryMutationHasChanged

	self deny: owner hasChanged.
	self deny: owner dictionary hasChanged.

	(owner dictionary at: (TestBitmask value: 1)) bitSet: 8.

	self assert: owner hasChanged.
	self assert: owner dictionary hasChanged.!

testDictionaryRollback

	owner dictionary removeKey: (TestBitmask value: 1); removeKey: (TestBitmask value: 2); removeKey: (TestBitmask value: 7); removeKey: (TestBitmask value: 8).
	(owner dictionary at: (TestBitmask value: 6)) value: 999.

	self assert: owner dictionary size equals: 4.
	self assert: (owner dictionary keys collect: [ :each | each value]) asSortedCollection asArray equals: #(3 4 5 6).
	self assert: owner dictionary keys asSortedCollection asArray equals: (#(3 4 5 6) collect: [ :each | TestBitmask value: each]).

	self assert: (owner dictionary values collect: [ :each | each value]) asSortedCollection asArray equals: #(259 260 261 999).
	self assert: owner dictionary values asSortedCollection asArray equals: (#(259 260 261 999) collect: [ :each | TestBitmask value: each]).

	owner dictionary keysAndValuesDo: 
		[ :key :bitmask | 
		key value = 6
			ifTrue: [self assert: bitmask value equals: 999]
			ifFalse: [self assert: bitmask value equals: key value + 256]].

	owner rollback.

	self testDictionary!

testHasChanged

	self deny: owner hasChanged.

	owner bitmask bitSet: 1.

	self assert: owner hasChanged.
	owner store.
	self deny: owner hasChanged.

	owner bitmask bitSet: 2.
	self assert: owner hasChanged.
	owner store.
	self deny: owner hasChanged!

testMutationCommit

	self assert: owner bitmask value equals: 0.

	owner bitmask bitSet: 3.
	owner store.

	reStore simulateReconnect.
	self reReadTestData.

	self assert: owner bitmask value equals: 4!

testMutationRollback

	self assert: owner bitmask value equals: 0.

	owner bitmask bitSet: 2.
	self assert: owner bitmask value equals: 2.

	owner rollback.
	self assert: owner bitmask value equals: 0.

	"And again to verify the rollback makes a full copy"
	owner bitmask bitSet: 2.
	self assert: owner bitmask value equals: 2.

	owner rollback.
	self assert: owner bitmask value equals: 0!

testOrderedCollection

	self _testCollection: #orderedCollection!

testOrderedCollectionCommit

	self _testSequenceableCollectionCommit: #orderedCollection!

testOrderedCollectionMutationCommit

	self _testCollectionMutationCommit: #orderedCollection!

testOrderedCollectionMutationHasChanged

	self _testCollectionMutationHasChanged: #orderedCollection!

testOrderedCollectionMutationRefresh

	self _testCollectionMutationRefresh: #orderedCollection!

testOrderedCollectionMutationRollback

	self _testCollectionMutationRollback: #orderedCollection!

testOrderedCollectionRefresh

	self _testSequenceableCollectionRefresh: #orderedCollection!

testOrderedCollectionRollback

	self _testSequenceableCollectionRollback: #orderedCollection!

testQuery

	| newOwners instances |

	newOwners := self storeNewOwnersWithBitmaskValues: (1 to: 8).

	instances := TestWithBitmask storedInstancesIn: reStore.

	self assert: (instances select: [ :each | each bitmask = (TestBitmask new value: 0)]) size equals: 1.
	self assert: (instances detect: [ :each | each bitmask = (TestBitmask new value: 0)]) identicalTo: owner.
	self assert: (instances detect: [ :each | each bitmask = (TestBitmask new value: 8)]) identicalTo: newOwners last
	!

testQueryByExample

	| template matches |

	self storeNewOwnersWithBitmaskValues: (1 to: 8).
	self storeNewOwnersWithBitmaskValues: (1 to: 4).

	template := TestWithBitmask new.

	matches := template similarInstancesIn: reStore.
	self assert: matches size equals: 1.
	self assert: matches first identicalTo: owner.

	template bitmask value: 4.
	matches := template similarInstancesIn: reStore.
	self assert: matches size equals: 2.
	self assert: (matches allSatisfy: [ :each | each bitmask value = 4]).

	template bitmask value: 8.
	matches := template similarInstancesIn: reStore.
	self assert: matches size equals: 1.
	self assert: matches first bitmask value equals: 8.

	template bitmask value: 16.
	matches := template similarInstancesIn: reStore.
	self assert: matches isEmpty.

	template bitmask: nil required.
	matches := template similarInstancesIn: reStore.
	self assert: matches isEmpty.

	owner bitmask: nil; store.
	matches := template similarInstancesIn: reStore.
	self assert: matches size equals: 1.
	self assert: matches first identicalTo: owner!

testQueryOnValue

	| newOwners instances |

	newOwners := self storeNewOwnersWithBitmaskValues: (1 to: 8).

	instances := TestWithBitmask storedInstancesIn: reStore.

	self assert: (instances select: [ :each | each bitmask value = 0]) size equals: 1.
	self assert: (instances detect: [ :each | each bitmask value = 0]) identicalTo: owner.
	self assert: (instances detect: [ :each | each bitmask value = 8]) identicalTo: newOwners last
	!

testQueryWithMethod

	| newOwners instances |

	newOwners := self storeNewOwnersWithBitmaskValues: (1 to: 8).

	instances := TestWithBitmask storedInstancesIn: reStore.

	self assert: (instances select: [ :each | each bitmask isBitSet: 1]) size equals: 4.
	self assert: (instances select: [ :each | each bitmask isBitSet: 4]) size equals: 1.
	self assert: (instances detect: [ :each | each bitmask isBitSet: 4]) identicalTo: newOwners last	!

testRefresh

	self assert: owner bitmask value equals: 0.

	(reStore2 instancesOf: TestWithBitmask) first 
		bitmask: (TestBitmask value: 99);
		store.

	self refreshDelay.

	self assert: owner bitmask value equals: 0.
	owner refresh.

	self assert: owner isDBProxy.
	self assert: owner _proxiedObject bitmask value equals: 99.
	self assert: owner _copyObject bitmask value equals: 99.
!

testRollback

	self assert: owner bitmask value equals: 0.

	owner bitmask: (TestBitmask value: 99).
	owner rollback.

	self assert: owner bitmask value equals: 0!

testSet

	self _testCollection: #set!

testSetCommit

	| collection |

	collection := owner set.
	#(1 2 6 7 8) do: [ :each | collection remove: (TestBitmask value: each)].
	collection add: (TestBitmask value: 99).
	owner store.

	reStore simulateReconnect.
	self reReadTestData.
	collection := owner set asSortedCollection.

	self assert: collection size equals: 4.
	self assert: (collection collect: [ :each | each value]) asArray equals: #(3 4 5 99).
	self assert: collection asArray equals: (#(3 4 5 99) collect: [ :each | TestBitmask value: each])!

testSetMutationCommit

	self _testCollectionMutationCommit: #set!

testSetMutationHasChanged

	self _testCollectionMutationHasChanged: #set!

testSetMutationRefresh

	self _testCollectionMutationRefresh: #set!

testSetMutationRollback

	self _testCollectionMutationRollback: #set!

testSetRefresh

	| owner2 collection |

	owner2 := (reStore2 instancesOf: TestWithBitmask) first.
	collection := owner2 set.
	#(1 2 6 7 8) do: [ :each | collection remove: (TestBitmask value: each)].
	collection add: (TestBitmask value: 99).
	owner2 store.

	self refreshDelay.
	self testSet.
	owner refresh.
	collection := owner set asSortedCollection.

	self assert: collection size equals: 4.
	self assert: (collection collect: [ :each | each value]) asArray equals: #(3 4 5 99).
	self assert: collection asArray equals: (#(3 4 5 99) collect: [ :each | TestBitmask value: each])!

testSetRollback

	| collection |

	collection := owner set.
	#(1 2 6 7 8) do: [ :each | collection remove: (TestBitmask value: each)].
	collection add: (TestBitmask value: 99).
	owner rollback.

	self testSet!

testSortedCollection

	self _testCollection: #sortedCollection.

	"Also verify sorting"
	owner sortedCollection add: (TestBitmask value: -1).
	owner store.

	reStore simulateReconnect.
	self reReadTestData.

	self assert: owner sortedCollection first value equals: -1!

testSortedCollectionCommit

	self _testSequenceableCollectionCommit: #sortedCollection!

testSortedCollectionMutationCommit

	self _testCollectionMutationCommit: #sortedCollection!

testSortedCollectionMutationHasChanged

	self _testCollectionMutationHasChanged: #sortedCollection!

testSortedCollectionMutationRefresh

	self _testCollectionMutationRefresh: #sortedCollection!

testSortedCollectionMutationRollback

	self _testCollectionMutationRollback: #sortedCollection!

testSortedCollectionRefresh

	self _testSequenceableCollectionRefresh: #sortedCollection!

testSortedCollectionRollback

	self _testSequenceableCollectionRollback: #sortedCollection! !
!SSWReStoreDirectlyPersistedTest categoriesForMethods!
_testCollection:!private!unit tests! !
_testCollectionMutationCommit:!private!unit tests! !
_testCollectionMutationHasChanged:!private!unit tests! !
_testCollectionMutationRefresh:!private!unit tests! !
_testCollectionMutationRollback:!private!unit tests! !
_testSequenceableCollectionCommit:!private!unit tests! !
_testSequenceableCollectionRefresh:!private!unit tests! !
_testSequenceableCollectionRollback:!private!unit tests! !
addClassesTo:!public!running! !
createTestData!public!running! !
reReadTestData!public!running! !
storeNewOwnersWithBitmaskValues:!helpers!private! !
testArray!public!unit tests! !
testArrayCommit!public!unit tests! !
testArrayMutationCommit!public!unit tests! !
testArrayMutationHasChanged!public!unit tests! !
testArrayMutationRefresh!public!unit tests! !
testArrayMutationRollback!public!unit tests! !
testArrayRefresh!public!unit tests! !
testArrayRollback!public!unit tests! !
testAutoRefresh!public!unit tests! !
testCollectQuery!public!unit tests! !
testCollectQueryOnValue!public!unit tests! !
testCollectQueryWithMethod!public!unit tests! !
testCommit!public!unit tests! !
testDeletedObjectRecovery!public!unit tests! !
testDictionary!public!unit tests! !
testDictionaryCommit!public!unit tests! !
testDictionaryMutationCommit!public!unit tests! !
testDictionaryMutationHasChanged!public!unit tests! !
testDictionaryRollback!public!unit tests! !
testHasChanged!public!unit tests! !
testMutationCommit!public!unit tests! !
testMutationRollback!public!unit tests! !
testOrderedCollection!public!unit tests! !
testOrderedCollectionCommit!public!unit tests! !
testOrderedCollectionMutationCommit!public!unit tests! !
testOrderedCollectionMutationHasChanged!public!unit tests! !
testOrderedCollectionMutationRefresh!public!unit tests! !
testOrderedCollectionMutationRollback!public!unit tests! !
testOrderedCollectionRefresh!public!unit tests! !
testOrderedCollectionRollback!public!unit tests! !
testQuery!public!unit tests! !
testQueryByExample!public!unit tests! !
testQueryOnValue!public!unit tests! !
testQueryWithMethod!public!unit tests! !
testRefresh!public!unit tests! !
testRollback!public!unit tests! !
testSet!public!unit tests! !
testSetCommit!public!unit tests! !
testSetMutationCommit!public!unit tests! !
testSetMutationHasChanged!public!unit tests! !
testSetMutationRefresh!public!unit tests! !
testSetMutationRollback!public!unit tests! !
testSetRefresh!public!unit tests! !
testSetRollback!public!unit tests! !
testSortedCollection!public!unit tests! !
testSortedCollectionCommit!public!unit tests! !
testSortedCollectionMutationCommit!public!unit tests! !
testSortedCollectionMutationHasChanged!public!unit tests! !
testSortedCollectionMutationRefresh!public!unit tests! !
testSortedCollectionMutationRollback!public!unit tests! !
testSortedCollectionRefresh!public!unit tests! !
testSortedCollectionRollback!public!unit tests! !
!


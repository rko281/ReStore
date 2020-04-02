"Filed out from Dolphin Smalltalk 7"!

SSWReStoreGenericTest subclass: #SSWReStoreMultiValueCacheDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreMultiValueCacheDictionaryTest guid: (GUID fromString: '{c60a609a-c92f-4de2-862b-52d97c9de712}')!
SSWReStoreMultiValueCacheDictionaryTest comment: 'ReStore
©2020 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreMultiValueCacheDictionaryTest categoriesForClass!Unclassified! !
!SSWReStoreMultiValueCacheDictionaryTest methodsFor!

componentDefinition

	^Dictionary of: #key -> (OrderedCollection of: GenericOwnedTest dependent) !

templateTestObject

	| template |

	template := GenericTest new.
	template component: Dictionary new.

	#('Alan' 'Andrew' 'Anton' 'Barry' 'Bernard' 'Colin') do: 
		[ :name |
		template addToMultiKeyDictionary: (self testNamed: name)].

	^template

	!

testNamed: aString

	^GenericOwnedTest new 
		name: aString; 
		key: (String with: aString first asLowercase);
		yourself!

testReadAllFetch

	| testObjects queryCount |

	5 timesRepeat: [self createTestObject].
	reStore simulateReconnect.

	self assert: (self countQueriesDuring: [testObjects := (GenericTest storedInstancesIn: reStore) asOrderedCollection]) equals: 1.
	self assert: (self countQueriesDuring: [testObjects fetch: #component]) equals: 1.

	queryCount := self countQueriesDuring: 
		[testObjects do: 
			[ :obj |
			obj component do: 
				[ :values |
				self assert: (values allSatisfy: [ :each | each _isRecovered])]]].

	self assert: queryCount equals: 0!

testReadAllInclude

	| testObjects queryCount |

	5 timesRepeat: [self createTestObject].
	reStore simulateReconnect.

	queryCount := self countQueriesDuring: [testObjects := (GenericTest storedInstancesIn: reStore) include: #component; asOrderedCollection].
	self assert: queryCount equals: 2. "1 for all GenericTests + 1 for all components"

	queryCount := self countQueriesDuring: 
		[testObjects do: 
			[ :obj |
			obj component do: 
				[ :values |
				self assert: (values allSatisfy: [ :each | each _isRecovered])]]].

	self assert: queryCount equals: 0!

testRefreshAdditionAtExistingKey

	| clive |

	clive := self testNamed: 'Clive'.

	testObject2 addToMultiKeyDictionary: clive.
	testObject2 store.

	testObject refresh.

	self assert: testObject component size equals: 3.
	self assert: (testObject component at: 'c') size equals: 2.
	self assert: ((testObject component at: 'c') collect: [ :each | each name]) asSortedCollection asArray equals: #('Clive' 'Colin')!

testRefreshAdditionOfNewKey

	| dave |

	dave := self testNamed: 'Dave'.

	testObject2 addToMultiKeyDictionary: dave.
	testObject2 store.

	testObject refresh.

	self assert: testObject component size equals: 4.
	self assert: (testObject component at: 'd') size equals: 1.
	self assert: (testObject component at: 'd') first equals: dave!

testRefreshRemovalAtExistingKey

	| colin |

	colin := (testObject2 component at: 'c') removeFirst.

	testObject2 store.

	testObject refresh.

	self assert: testObject component size equals: 2.
	self deny: (testObject component includesKey: 'c').
	self assert: ((GenericOwnedTest storedInstancesIn: reStore) select: [ :each | each name = colin name]) isEmpty!

testRefreshRemovalOfAllKeys

	testObject2 component keys do: [ :each | testObject2 component removeKey: each].
	testObject2 store.

	testObject refresh.

	self assert: testObject component isEmpty.
	self assert: (GenericOwnedTest storedInstancesIn: reStore) isEmpty!

testRefreshRemovalOfKey

	testObject2 component removeKey: 'b'.
	testObject2 store.

	testObject refresh.

	self assert: testObject component size equals: 2.
	self assert: testObject component keys asSortedCollection asArray = #('a' 'c').
	self assert: ((GenericOwnedTest storedInstancesIn: reStore) select: [ :each | each name first asLowercase = $b]) isEmpty!

testRefreshReplacementAtExistingKey

	| barry bill |

	barry := (testObject2 component at: 'b') removeFirst.
	bill := self testNamed: 'Bill'.
	testObject2 addToMultiKeyDictionary: bill.
	testObject2 store.

	testObject refresh.

	self assert: testObject component size equals: 3.
	self assert: (testObject component at: 'b') size equals: 2.
	self assert: ((testObject component at: 'b') collect: [ :each | each name]) asSortedCollection asArray equals: #('Bernard' 'Bill').
	self assert: ((GenericOwnedTest storedInstancesIn: reStore) select: [ :each | each name = barry name]) isEmpty!

testRefreshReplacementOfKey

	testObject2 component removeKey: 'b'.
	testObject2 addToMultiKeyDictionary: (self testNamed: 'Bertram'); addToMultiKeyDictionary: (self testNamed: 'Bob').
	testObject2 store.

	testObject refresh.

	self assert: testObject component size equals: 3.
	self assert: (testObject component at: 'b') size equals: 2.
	self assert: ((testObject component at: 'b') collect: [ :each | each name]) asSortedCollection asArray equals: #('Bertram' 'Bob').
	self assert: ((GenericOwnedTest storedInstancesIn: reStore) select: [ :each | (each name = 'Barry') | (each name = 'Bernard')]) isEmpty!

testRollbackAdditionAtExistingKey

	| clive |

	clive := self testNamed: 'Clive'.

	testObject addToMultiKeyDictionary: clive.
	testObject rollback.

	self assert: testObject component size equals: 3.
	self assert: (testObject component at: 'c') size equals: 1.
	self assert: ((testObject component at: 'c') collect: [ :each | each name]) asSortedCollection asArray equals: #('Colin')!

testRollbackAdditionOfNewKey

	| dave |

	dave := self testNamed: 'Dave'.

	testObject addToMultiKeyDictionary: dave.
	testObject rollback.

	self assert: testObject component size equals: 3.
	self assert: testObject component keys asSortedCollection asArray equals: #('a' 'b' 'c')!

testRollbackRemovalAtExistingKey

	| colin |

	colin := (testObject component at: 'c') removeFirst.

	testObject rollback.

	self assert: testObject component size equals: 3.
	self assert: (testObject component includesKey: 'c').
	self assert: ((testObject component at: 'c') collect: [ :each | each name]) asSortedCollection asArray equals: #('Colin').
	self deny: ((GenericOwnedTest storedInstancesIn: reStore) select: [ :each | each name = colin name]) isEmpty!

testRollbackRemovalOfAllKeys

	testObject component keys do: [ :each | testObject component removeKey: each].
	testObject rollback.

	self assert: testObject component size equals: 3.
	self assert: testObject component keys asSortedCollection asArray = #('a' 'b' 'c').
	self deny: (GenericOwnedTest storedInstancesIn: reStore) isEmpty!

testRollbackRemovalOfKey

	testObject component removeKey: 'b'.
	testObject rollback.

	self assert: testObject component size equals: 3.
	self assert: (testObject component includesKey: 'b').
	self assert: testObject component keys asSortedCollection asArray = #('a' 'b' 'c').
	self deny: ((GenericOwnedTest storedInstancesIn: reStore) select: [ :each | each name first asLowercase = $b]) isEmpty!

testRollbackReplacementAtExistingKey

	| barry bill |

	barry := (testObject component at: 'b') removeFirst.
	bill := self testNamed: 'Bill'.
	testObject addToMultiKeyDictionary: bill.
	testObject rollback.

	self assert: testObject component size equals: 3.
	self assert: (testObject component at: 'b') size equals: 2.
	self assert: ((testObject component at: 'b') collect: [ :each | each name]) asSortedCollection asArray equals: #('Barry' 'Bernard').
	self deny: ((GenericOwnedTest storedInstancesIn: reStore) select: [ :each | each name = barry name]) isEmpty!

testRollbackReplacementOfKey

	testObject component removeKey: 'b'.
	testObject addToMultiKeyDictionary: (self testNamed: 'Bertram'); addToMultiKeyDictionary: (self testNamed: 'Bob').
	testObject rollback.

	self assert: testObject component size equals: 3.
	self assert: (testObject component at: 'b') size equals: 2.
	self assert: ((testObject component at: 'b') collect: [ :each | each name]) asSortedCollection asArray equals: #('Barry' 'Bernard').
	self deny: ((GenericOwnedTest storedInstancesIn: reStore) select: [ :each | each name = 'Barry']) isEmpty.
	self deny: ((GenericOwnedTest storedInstancesIn: reStore) select: [ :each | each name = 'Bernard']) isEmpty!

testStoreAdditionAtExistingKey

	| clive |

	clive := self testNamed: 'Clive'.

	testObject addToMultiKeyDictionary: clive.
	testObject store.

	self fetchTestObjects.

	self assert: testObject component size equals: 3.
	self assert: (testObject component at: 'c') size equals: 2.
	self assert: ((testObject component at: 'c') collect: [ :each | each name]) asSortedCollection asArray equals: #('Clive' 'Colin')!

testStoreAdditionOfNewKey

	| dave |

	dave := self testNamed: 'Dave'.

	testObject addToMultiKeyDictionary: dave.
	testObject store.

	self fetchTestObjects.

	self assert: testObject component size equals: 4.
	self assert: (testObject component at: 'd') size equals: 1.
	self assert: (testObject component at: 'd') first equals: dave!

testStoreRemovalAtExistingKey

	| colin |

	colin := (testObject component at: 'c') removeFirst.

	testObject store.
	self fetchTestObjects.

	self assert: testObject component size equals: 2.
	self deny: (testObject component includesKey: 'c').
	self assert: ((GenericOwnedTest storedInstancesIn: reStore) select: [ :each | each name = colin name]) isEmpty!

testStoreRemovalOfAllKeys

	testObject component keys do: [ :each | testObject component removeKey: each].
	testObject store.

	self fetchTestObjects.

	self assert: testObject component isEmpty.
	self assert: (GenericOwnedTest storedInstancesIn: reStore) isEmpty!

testStoreRemovalOfKey

	testObject component removeKey: 'b'.
	testObject store.

	self fetchTestObjects.

	self assert: testObject component size equals: 2.
	self assert: testObject component keys asSortedCollection asArray = #('a' 'c').
	self assert: ((GenericOwnedTest storedInstancesIn: reStore) select: [ :each | each name first asLowercase = $b]) isEmpty!

testStoreReplacementAtExistingKey

	| barry bill |

	barry := (testObject component at: 'b') removeFirst.
	bill := self testNamed: 'Bill'.
	testObject addToMultiKeyDictionary: bill.
	testObject store.

	self fetchTestObjects.

	self assert: testObject component size equals: 3.
	self assert: (testObject component at: 'b') size equals: 2.
	self assert: ((testObject component at: 'b') collect: [ :each | each name]) asSortedCollection asArray equals: #('Bernard' 'Bill').
	self assert: ((GenericOwnedTest storedInstancesIn: reStore) select: [ :each | each name = barry name]) isEmpty!

testStoreReplacementOfKey

	testObject component removeKey: 'b'.
	testObject addToMultiKeyDictionary: (self testNamed: 'Bertram'); addToMultiKeyDictionary: (self testNamed: 'Bob').
	testObject store.

	self fetchTestObjects.

	self assert: testObject component size equals: 3.
	self assert: (testObject component at: 'b') size equals: 2.
	self assert: ((testObject component at: 'b') collect: [ :each | each name]) asSortedCollection asArray equals: #('Bertram' 'Bob').
	self assert: ((GenericOwnedTest storedInstancesIn: reStore) select: [ :each | (each name = 'Barry') | (each name = 'Bernard')]) isEmpty! !
!SSWReStoreMultiValueCacheDictionaryTest categoriesFor: #componentDefinition!public! !
!SSWReStoreMultiValueCacheDictionaryTest categoriesFor: #templateTestObject!accessing!public! !
!SSWReStoreMultiValueCacheDictionaryTest categoriesFor: #testNamed:!accessing!private! !
!SSWReStoreMultiValueCacheDictionaryTest categoriesFor: #testReadAllFetch!public!unit tests! !
!SSWReStoreMultiValueCacheDictionaryTest categoriesFor: #testReadAllInclude!public!unit tests! !
!SSWReStoreMultiValueCacheDictionaryTest categoriesFor: #testRefreshAdditionAtExistingKey!public!unit tests! !
!SSWReStoreMultiValueCacheDictionaryTest categoriesFor: #testRefreshAdditionOfNewKey!public!unit tests! !
!SSWReStoreMultiValueCacheDictionaryTest categoriesFor: #testRefreshRemovalAtExistingKey!public!unit tests! !
!SSWReStoreMultiValueCacheDictionaryTest categoriesFor: #testRefreshRemovalOfAllKeys!public!unit tests! !
!SSWReStoreMultiValueCacheDictionaryTest categoriesFor: #testRefreshRemovalOfKey!public!unit tests! !
!SSWReStoreMultiValueCacheDictionaryTest categoriesFor: #testRefreshReplacementAtExistingKey!public!unit tests! !
!SSWReStoreMultiValueCacheDictionaryTest categoriesFor: #testRefreshReplacementOfKey!public!unit tests! !
!SSWReStoreMultiValueCacheDictionaryTest categoriesFor: #testRollbackAdditionAtExistingKey!public!unit tests! !
!SSWReStoreMultiValueCacheDictionaryTest categoriesFor: #testRollbackAdditionOfNewKey!public!unit tests! !
!SSWReStoreMultiValueCacheDictionaryTest categoriesFor: #testRollbackRemovalAtExistingKey!public!unit tests! !
!SSWReStoreMultiValueCacheDictionaryTest categoriesFor: #testRollbackRemovalOfAllKeys!public!unit tests! !
!SSWReStoreMultiValueCacheDictionaryTest categoriesFor: #testRollbackRemovalOfKey!public!unit tests! !
!SSWReStoreMultiValueCacheDictionaryTest categoriesFor: #testRollbackReplacementAtExistingKey!public!unit tests! !
!SSWReStoreMultiValueCacheDictionaryTest categoriesFor: #testRollbackReplacementOfKey!public!unit tests! !
!SSWReStoreMultiValueCacheDictionaryTest categoriesFor: #testStoreAdditionAtExistingKey!public!unit tests! !
!SSWReStoreMultiValueCacheDictionaryTest categoriesFor: #testStoreAdditionOfNewKey!public!unit tests! !
!SSWReStoreMultiValueCacheDictionaryTest categoriesFor: #testStoreRemovalAtExistingKey!public!unit tests! !
!SSWReStoreMultiValueCacheDictionaryTest categoriesFor: #testStoreRemovalOfAllKeys!public!unit tests! !
!SSWReStoreMultiValueCacheDictionaryTest categoriesFor: #testStoreRemovalOfKey!public!unit tests! !
!SSWReStoreMultiValueCacheDictionaryTest categoriesFor: #testStoreReplacementAtExistingKey!public!unit tests! !
!SSWReStoreMultiValueCacheDictionaryTest categoriesFor: #testStoreReplacementOfKey!public!unit tests! !


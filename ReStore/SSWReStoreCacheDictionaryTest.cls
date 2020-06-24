"Filed out from Dolphin Smalltalk 7"!

SSWReStoreGenericTest subclass: #SSWReStoreCacheDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreCacheDictionaryTest guid: (GUID fromString: '{502a31f1-8635-4a21-823b-0e5dd3ccdbd2}')!
SSWReStoreCacheDictionaryTest comment: 'ReStore
©2020 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreCacheDictionaryTest categoriesForClass!Unclassified! !
!SSWReStoreCacheDictionaryTest methodsFor!

componentDefinition

	^Dictionary of: #key -> GenericOwnedTest dependent!

templateTestObject

	| template |

	template := GenericTest new.
	template component: Dictionary new.

	#('Alan' 'Barry' 'Colin') do: [ :name | template addToSingleKeyDictionary: (self testNamed: name)].

	^template
	!

testIncludes

	| instances people alan dave |

	instances := GenericTest storedInstancesIn: reStore.
	people := GenericOwnedTest storedInstancesIn: reStore.
	alan := people detect: [ :each | each name = 'Alan'].
	dave := self testNamed: 'Dave'.

	self assert: (instances anySatisfy: [ :each | each component includes: alan]).
	self deny: (instances anySatisfy: [ :each | each component includes: dave]).

	testObject addToSingleKeyDictionary: dave.
	testObject store.

	self assert: (instances anySatisfy: [ :each | each component includes: dave])
!

testIncludesAssociation

	| instances people alan dave |

	instances := GenericTest storedInstancesIn: reStore.
	people := GenericOwnedTest storedInstancesIn: reStore.
	alan := people detect: [ :each | each name = 'Alan'].
	dave := self testNamed: 'Dave'.

	self assert: (instances anySatisfy: [ :each | each component includesAssociation: ('a' -> alan)]).
	self deny: (instances anySatisfy: [ :each | each component includesAssociation: ('b' -> alan)]).
	self deny: (instances anySatisfy: [ :each | each component includesAssociation: ('d' -> dave)]).

	testObject addToSingleKeyDictionary: dave.
	testObject store.

	self assert: (instances anySatisfy: [ :each | each component includesAssociation: ('d' -> dave)])
!

testIncludesKey

	| instances |

	instances := GenericTest storedInstancesIn: reStore.
	self assert: (instances anySatisfy: [ :each | each component includesKey: 'a']).
	self deny: (instances anySatisfy: [ :each | each component includesKey: 'z'])!

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
				[ :each |
				self assert: each _isRecovered]]].

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
				[ :each |
				self assert: each _isRecovered]]].

	self assert: queryCount equals: 0!

testRefreshAdditionOfNewKey

	| dave |

	dave := self testNamed: 'Dave'.

	testObject2 addToSingleKeyDictionary: dave.
	testObject2 store.

	testObject refresh.

	self assert: testObject component size equals: 4.
	self assert: (testObject component at: 'd') equals: dave!

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

	| barry bill barryName |

	barry := testObject component at: 'b'.
	bill := self testNamed: 'Bill'.
	testObject2 addToSingleKeyDictionary: bill.
	testObject2 store.

	"Cache barry's name since he will become a deleted object on refresh"
	barryName := barry name.

	testObject refresh.

	self assert: testObject component size equals: 3.
	self assert: (testObject component at: 'b') equals: bill.
	self deny: (testObject component includes: barry).
	self assert: ((GenericOwnedTest storedInstancesIn: reStore) select: [ :each | each name = barryName]) isEmpty!

testRollbackAdditionOfNewKey

	| dave |

	dave := self testNamed: 'Dave'.

	testObject addToSingleKeyDictionary: dave.
	testObject rollback.

	self assert: testObject component size equals: 3.
	self assert: testObject component keys asSortedCollection asArray equals: #('a' 'b' 'c')!

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
	self assert: testObject component keys asSortedCollection asArray = #('a' 'b' 'c').
	self deny: ((GenericOwnedTest storedInstancesIn: reStore) select: [ :each | each name first asLowercase = $b]) isEmpty!

testRollbackReplacementAtExistingKey

	| barry bill |

	barry := testObject component at: 'b'.
	bill := self testNamed: 'Bill'.
	testObject addToSingleKeyDictionary: bill.
	testObject rollback.

	self assert: testObject component size equals: 3.
	self assert: (testObject component at: 'b') equals: barry.
	self deny: ((GenericOwnedTest storedInstancesIn: reStore) select: [ :each | each name = barry name]) isEmpty!

testStoreAdditionOfNewKey

	| dave |

	dave := self testNamed: 'Dave'.

	testObject addToSingleKeyDictionary: dave.
	testObject store.

	self fetchTestObjects.

	self assert: testObject component size equals: 4.
	self assert: (testObject component at: 'd') equals: dave!

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

	barry := testObject component at: 'b'.
	bill := self testNamed: 'Bill'.
	testObject addToSingleKeyDictionary: bill.
	testObject store.

	self fetchTestObjects.

	self assert: testObject component size equals: 3.
	self assert: (testObject component at: 'b') equals: bill.
	self deny: (testObject component includes: barry).
	self assert: ((GenericOwnedTest storedInstancesIn: reStore) select: [ :each | each name = barry name]) isEmpty! !
!SSWReStoreCacheDictionaryTest categoriesFor: #componentDefinition!public! !
!SSWReStoreCacheDictionaryTest categoriesFor: #templateTestObject!accessing!public! !
!SSWReStoreCacheDictionaryTest categoriesFor: #testIncludes!public!unit tests! !
!SSWReStoreCacheDictionaryTest categoriesFor: #testIncludesAssociation!public!unit tests! !
!SSWReStoreCacheDictionaryTest categoriesFor: #testIncludesKey!public!unit tests! !
!SSWReStoreCacheDictionaryTest categoriesFor: #testNamed:!accessing!private! !
!SSWReStoreCacheDictionaryTest categoriesFor: #testReadAllFetch!public!unit tests! !
!SSWReStoreCacheDictionaryTest categoriesFor: #testReadAllInclude!public!unit tests! !
!SSWReStoreCacheDictionaryTest categoriesFor: #testRefreshAdditionOfNewKey!public!unit tests! !
!SSWReStoreCacheDictionaryTest categoriesFor: #testRefreshRemovalOfAllKeys!public!unit tests! !
!SSWReStoreCacheDictionaryTest categoriesFor: #testRefreshRemovalOfKey!public!unit tests! !
!SSWReStoreCacheDictionaryTest categoriesFor: #testRefreshReplacementAtExistingKey!public!unit tests! !
!SSWReStoreCacheDictionaryTest categoriesFor: #testRollbackAdditionOfNewKey!public!unit tests! !
!SSWReStoreCacheDictionaryTest categoriesFor: #testRollbackRemovalOfAllKeys!public!unit tests! !
!SSWReStoreCacheDictionaryTest categoriesFor: #testRollbackRemovalOfKey!public!unit tests! !
!SSWReStoreCacheDictionaryTest categoriesFor: #testRollbackReplacementAtExistingKey!public!unit tests! !
!SSWReStoreCacheDictionaryTest categoriesFor: #testStoreAdditionOfNewKey!public!unit tests! !
!SSWReStoreCacheDictionaryTest categoriesFor: #testStoreRemovalOfAllKeys!public!unit tests! !
!SSWReStoreCacheDictionaryTest categoriesFor: #testStoreRemovalOfKey!public!unit tests! !
!SSWReStoreCacheDictionaryTest categoriesFor: #testStoreReplacementAtExistingKey!public!unit tests! !


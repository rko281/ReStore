"Filed out from Dolphin Smalltalk 7"!

SSWReStorePersonTest subclass: #SSWReStoreReadStreamTest
	instanceVariableNames: 'readStream'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreReadStreamTest guid: (GUID fromString: '{87f53dec-12b5-4b17-b6b6-885a162996ae}')!
SSWReStoreReadStreamTest comment: 'ReStore
©2020 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreReadStreamTest categoriesForClass!Unclassified! !
!SSWReStoreReadStreamTest methodsFor!

_testIncludeDuring: aBlock

	| results |

	"We include: #address in the instances collection (1 query), therefore requesting address should not take any additional queries"
	self assert: (self countQueriesDuring: [results := aBlock value]) equals: 1.
	self assert: (self countQueriesDuring: [results do: [ :each | each address]]) equals: 0!

_testRead: anInteger during: aBlock

	"Private - Verify no more than anInteger number of SimplePersons are read during aBlock"

	| before |

	before := SimplePerson allInstances size.
	aBlock value.

	self assert: SimplePerson allInstances size <= (before + (anInteger * 2)) "* 2 since a copy is created for each instance read"!

createTestData

	self sampleSet storeAllIn: reStore.

	reStore simulateReconnect.

	readStream := ((SimplePerson storedInstancesIn: reStore) beOrdered; include: #address; yourself) readStream!

sampleSet

	^(1 to: self sampleSize) collect: 
		[ :e | 
		SimplePerson new 
			surname: 'Smith'; 
			firstName: 'John', e displayString; 
			emailAddress: 'john@something'; 
			address: SimpleAddress new;
			yourself]!

sampleSize

	^50!

testAtEnd

	self _testRead: (self sampleSize - 1) during: 
		[(readStream next: (self sampleSize - 1)) keysAndValuesDo: 
			[ :index :each | 
			self assert: each firstName equals: 'John', index displayString.
			self deny: readStream atEnd]].

	self assert: readStream next firstName equals: 'John', self sampleSize displayString.
	self assert: readStream atEnd!

testNext

	self _testRead: 2 during: 
		[self assert: readStream next firstName equals: 'John1'.
		self assert: readStream next firstName equals: 'John2']!

testNextAvailable

	self _testRead: (self sampleSize - 1) during: 
		[(readStream next: (self sampleSize - 1)) keysAndValuesDo: 
			[ :index :each | 
			self assert: each firstName equals: 'John', index displayString]].

	self assert: readStream nextAvailable firstName equals: 'John', self sampleSize displayString.
	self assert: readStream nextAvailable isNil!

testNextAvailableInclude

	self _testIncludeDuring: [{readStream nextAvailable}]!

testNextAvailableN

	self _testRead: (self sampleSize - 5) during: 
		[| available |
		available := readStream nextAvailable: (self sampleSize - 5).
		self assert: available size equals: (self sampleSize - 5).
		available keysAndValuesDo: 
			[ :index :each | 
			self assert: each firstName equals: 'John', index displayString]].

	self _testRead: 5 during: 
		[| available |
		available := readStream nextAvailable: 10.
		self assert: available size equals: 5.
		available keysAndValuesDo: 
			[ :index :each | 
			self assert: each firstName equals: 'John', ((self sampleSize - 5) + index) displayString]]!

testNextAvailableNInclude

	self _testIncludeDuring: [readStream nextAvailable: 10]!

testNextInclude

	self _testIncludeDuring: [{readStream next}]!

testNextN

	self _testRead: 30 during: 
		[(readStream next: 10) keysAndValuesDo: 
			[ :index :each | 
			self assert: each firstName equals: 'John', index displayString].

		(readStream next: 20) keysAndValuesDo: 
			[ :index :each | 
			self assert: each firstName equals: 'John', (10 + index) displayString]]!

testNextNInclude

	self _testIncludeDuring: [readStream next: 10]!

testPeek

	self _testRead: 3 during: 
		[self assert: readStream peek firstName equals: 'John1'.
		self assert: readStream next firstName equals: 'John1'.

		self assert: readStream peek firstName equals: 'John2'.
		self assert: readStream next firstName equals: 'John2'.

		self assert: readStream peek firstName equals: 'John3']!

testPositionBackwards

	readStream position: 19.
	self assert: readStream next firstName equals: 'John20'.

	readStream position: 9.
	self assert: readStream peek firstName equals: 'John10'.
	self assert: readStream next firstName equals: 'John10'.
	self assert: readStream next firstName equals: 'John11'!

testPositionForwards

	readStream position: 9.
	self assert: readStream next firstName equals: 'John10'.

	readStream position: 19.
	self assert: readStream peek firstName equals: 'John20'.
	self assert: readStream next firstName equals: 'John20'.
	self assert: readStream next firstName equals: 'John21'!

testReset

	10 timesRepeat: [readStream next].
	self assert: readStream next firstName equals: 'John11'.

	self _testRead: 1 during: 
		[readStream reset.
		self assert: readStream peek firstName equals: 'John1'.
		self assert: readStream next firstName equals: 'John1'].

	self _testRead: 1 during: 
		[readStream reset.
		self assert: readStream next firstName equals: 'John1'].

	self assert: readStream next firstName equals: 'John2'!

testSize

	self _testRead: 0 during: [self assert: readStream size equals: self sampleSize]!

testUpTo

	| j25 jN |

	j25 := (SimplePerson storedInstancesIn: reStore) detect: [ :each | each firstName = 'John25'].
	self _testRead: 25 during: 
		[| upTo |
		upTo := readStream upTo: j25.
		self assert: upTo size equals: 24.
		upTo keysAndValuesDo: 
			[ :index :each | 
			self assert: each firstName equals: 'John', index displayString]].
	self assert: readStream next firstName = 'John26'.

	jN := SimplePerson new.
	self _testRead: (self sampleSize - 26) during: 
		[| upTo |
		upTo := readStream upTo: jN.
		self assert: upTo size equals: (self sampleSize - 26).
		upTo keysAndValuesDo: 
			[ :index :each | 
			self assert: each firstName equals: 'John', (26 + index) displayString]].
	self assert: readStream atEnd
!

testUpToEnd

	self _testRead: (self sampleSize - 25) during: 
		[| available |
		available := readStream next: (self sampleSize - 25).
		self assert: available size equals: (self sampleSize - 25).
		available keysAndValuesDo: 
			[ :index :each | 
			self assert: each firstName equals: 'John', index displayString]].

	self _testRead: 25 during: 
		[| available |
		available := readStream upToEnd.
		self assert: available size equals: 25.
		available keysAndValuesDo: 
			[ :index :each | 
			self assert: each firstName equals: 'John', ((self sampleSize - 25) + index) displayString]]!

testUpToEndInclude

	self _testIncludeDuring: [readStream upToEnd]!

testUpToInclude

	| j25 |

	j25 := (SimplePerson storedInstancesIn: reStore) detect: [ :each | each firstName = 'John25'].

	self _testIncludeDuring: [readStream upTo: j25]! !
!SSWReStoreReadStreamTest categoriesFor: #_testIncludeDuring:!private!unit tests! !
!SSWReStoreReadStreamTest categoriesFor: #_testRead:during:!private!unit tests! !
!SSWReStoreReadStreamTest categoriesFor: #createTestData!public!running! !
!SSWReStoreReadStreamTest categoriesFor: #sampleSet!public!running! !
!SSWReStoreReadStreamTest categoriesFor: #sampleSize!public!running! !
!SSWReStoreReadStreamTest categoriesFor: #testAtEnd!public!unit tests! !
!SSWReStoreReadStreamTest categoriesFor: #testNext!public!unit tests! !
!SSWReStoreReadStreamTest categoriesFor: #testNextAvailable!public!unit tests! !
!SSWReStoreReadStreamTest categoriesFor: #testNextAvailableInclude!public!unit tests! !
!SSWReStoreReadStreamTest categoriesFor: #testNextAvailableN!public!unit tests! !
!SSWReStoreReadStreamTest categoriesFor: #testNextAvailableNInclude!public!unit tests! !
!SSWReStoreReadStreamTest categoriesFor: #testNextInclude!public!unit tests! !
!SSWReStoreReadStreamTest categoriesFor: #testNextN!public!unit tests! !
!SSWReStoreReadStreamTest categoriesFor: #testNextNInclude!public!unit tests! !
!SSWReStoreReadStreamTest categoriesFor: #testPeek!public!unit tests! !
!SSWReStoreReadStreamTest categoriesFor: #testPositionBackwards!public!unit tests! !
!SSWReStoreReadStreamTest categoriesFor: #testPositionForwards!public!unit tests! !
!SSWReStoreReadStreamTest categoriesFor: #testReset!public!unit tests! !
!SSWReStoreReadStreamTest categoriesFor: #testSize!public!unit tests! !
!SSWReStoreReadStreamTest categoriesFor: #testUpTo!public!unit tests! !
!SSWReStoreReadStreamTest categoriesFor: #testUpToEnd!public!unit tests! !
!SSWReStoreReadStreamTest categoriesFor: #testUpToEndInclude!public!unit tests! !
!SSWReStoreReadStreamTest categoriesFor: #testUpToInclude!public!unit tests! !


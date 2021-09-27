"Filed out from Dolphin Smallalk"!

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

tearDown

	readStream close.
	super tearDown!

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
!SSWReStoreReadStreamTest categoriesForMethods!
_testIncludeDuring:!private!unit tests! !
_testRead:during:!private!unit tests! !
createTestData!public!running! !
sampleSet!public!running! !
sampleSize!public!running! !
tearDown!public!running! !
testAtEnd!public!unit tests! !
testNext!public!unit tests! !
testNextAvailable!public!unit tests! !
testNextAvailableInclude!public!unit tests! !
testNextAvailableN!public!unit tests! !
testNextAvailableNInclude!public!unit tests! !
testNextInclude!public!unit tests! !
testNextN!public!unit tests! !
testNextNInclude!public!unit tests! !
testPeek!public!unit tests! !
testPositionBackwards!public!unit tests! !
testPositionForwards!public!unit tests! !
testReset!public!unit tests! !
testSize!public!unit tests! !
testUpTo!public!unit tests! !
testUpToEnd!public!unit tests! !
testUpToEndInclude!public!unit tests! !
testUpToInclude!public!unit tests! !
!


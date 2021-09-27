"Filed out from Dolphin Smallalk"!

TestCase subclass: #SSWReStoreTest
	instanceVariableNames: 'reStore'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'queryCount'!
SSWReStoreTest guid: (GUID fromString: '{ec150c15-d723-4219-ad12-70acdbad6c9e}')!
SSWReStoreTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreTest categoriesForClass!Unclassified! !
!SSWReStoreTest methodsFor!

addClassesTo: aReStore

	aReStore addClass: Test; addClass: OwnedTest; addClass: OwnerTest!

countQueries

	self resetQueryCount!

countQueriesDuring: aBlock

	self countQueries.
	^[aBlock value.
	self queryCount] ensure: [self stopQueryCounting]!

createReStore

	reStore := SSWReStore new!

createStandardTestInstance

	"Private - Initialize the database"
	
	| t |

	reStore beginTransaction.
	t := OwnerTest new.
	t
		name: 'owner';
		number: 123;
		single1: (Test new name: 'single1');
		single2: (Test new name: 'single2');
		single3: t single2;

		ownedArray: 
			(Array
				with: (OwnedTest new name: 'owned1')
				with: (OwnedTest new name: 'owned2'));
		ownedSet: (Set new addAll: t ownedArray; yourself);
		ownedOrdered: (OrderedCollection new addAll: t ownedArray; yourself);
		ownedSorted: (OrderedCollection new addAll: t ownedArray; yourself);
		ownedList: (SSWReStoreTest listModelOn: (OrderedCollection new addAll: t ownedArray; yourself));

		setOfDates: (Set with: Date today with: (Date today subtractDays: 92));
		arrayOfNames: (Array with: 'Bill' with: 'Ben');
		orderedBools: (OrderedCollection with: true with: false with: nil);
		sortedNumbers: (SortedCollection with: 2 with: 3 with: 1);
		descNumbers: (SortedCollection with: 2 with: 3 with: 1);
		listOfTimes: (SSWReStoreTest listModelOn: (OrderedCollection with: Time now));
		dictOfSizes: (Dictionary new at: 'Pogle' put: 'Pogle' size; at: 'Tog' put: 'Tog' size; yourself);

		set: 
			(Set 
				with: (Test new name: 'set1')
				with: (Test new name: 'set2'));
		array: 
			(Array
				with: (Test new name: 'array1')
				with: (Test new name: 'array2'));
		ordered: 
			(OrderedCollection 
				with: (Test new name: 'ordered1')
				with: (Test new name: 'ordered2'));
		sorted:
			(OrderedCollection 
				with: (Test new name: 'sorted1')
				with: (Test new name: 'sorted2'));
		list: (SSWReStoreTest listModelOn:
			(OrderedCollection 
				with: (Test new name: 'list1')
				with: (Test new name: 'list2')));
		aspectDictionary: 
			(Dictionary new 
				at: 'aspdic1' put: (Test new name: 'aspdic1'; yourself); 
				at: 'aspdic2' put: (Test new name: 'aspdic2'; yourself); 
				at: 'aspdic3' put: (Test new name: 'aspdic3'; yourself);
				yourself);
		keyedBaseDictionary: 
			(Dictionary new 
				at: 'a' put: (Test new name: 'keydic1'; yourself); 
				at: 'b' put: (Test new name: 'keydic2'; yourself); 
				at: 'c' put: (Test new name: 'keydic3'; yourself);
				yourself);
		keyedGeneralDictionary: 
			(Dictionary new 
				at: (Test new name: 'key1'; yourself) put: (Test new name: 'value1'; yourself); 
				at: (Test new name: 'key2'; yourself) put: (Test new name: 'value2'; yourself); 
				at: (Test new name: 'key3'; yourself) put: (Test new name: 'value3'; yourself);
				yourself);
		storeIn: reStore.

	reStore commitTransaction!

createTestData!

destroyAllClasses

	self shouldDestroyClasses
		ifTrue: [reStore destroyAllClasses]
		ifFalse: [self destroyAllData]!

destroyAllData

	| nextID |

	nextID := (reStore tableForClass: SSWDBTableRecord) name.

	reStore evaluateAsTxn: 
		[| foundNextID count |
		foundNextID := false.
		reStore connection tables do: 
			[ :each | 
			each = nextID 
				ifTrue: [foundNextID := true]
				ifFalse: [reStore executeSQL: 'delete from ', each]].
		foundNextID ifTrue: 
			[count := (reStore instancesOf: SSWDBTableRecord) project: [ :each | each _id maximum].
			reStore 
				executeSQL: 'update <1s> set next_id = 1 where table_name %<> <1p>' << nextID;
				executeSQL: 'update <1s> set next_id = <2p> where table_name = <1p>' << {nextID. count first + 1}].
		true]!

initReStore: aReStore

	self initConnectionFor: aReStore!

performTest

	reStore debugTo: self debugStream.
	^super performTest!

queryCount

	^reStore connection queryCount!

refreshDelay

	^(Delay forSeconds: reStore sqlDialect updateDelaySeconds) wait!

releaseReStore: aReStore

	aReStore isConnected ifTrue: [aReStore disconnect].

	aReStore clearTableCache!

resetQueryCount

	reStore connection resetQueryCount!

setUp

	self createReStore.
	self initReStore: reStore.
	reStore connect.
	self addClassesTo: reStore.
	self destroyAllClasses.
	reStore synchronizeAllClasses.
	self createTestData!

shouldDestroyClasses

	"For efficiency with some databases we don't destroy classes (this can take a long time) but erase all data instead (see my sender).
	However some tests may always require a fresh database, in which case return true"

	^reStore sqlDialect shouldDropTablesForTestCases!

stopQueryCounting

	reStore connection resetQueryCount!

tearDown

	self resetQueryCount; stopQueryCounting.

	reStore isNil ifFalse: 
		[reStore reconnect.
		self destroyAllClasses.
		self releaseReStore: reStore.
		reStore := nil]! !
!SSWReStoreTest categoriesForMethods!
addClassesTo:!public!running! !
countQueries!public!running! !
countQueriesDuring:!public!running! !
createReStore!private!running! !
createStandardTestInstance!private!running! !
createTestData!public!running! !
destroyAllClasses!public!running! !
destroyAllData!public!running! !
initReStore:!public!running! !
performTest!public! !
queryCount!accessing!public! !
refreshDelay!accessing!public! !
releaseReStore:!public!running! !
resetQueryCount!public!running! !
setUp!public!running! !
shouldDestroyClasses!public!testing! !
stopQueryCounting!public!running! !
tearDown!public!running! !
!

!SSWReStoreTest class methodsFor!

isAbstract

	^self == SSWReStoreTest! !
!SSWReStoreTest class categoriesForMethods!
isAbstract!public! !
!


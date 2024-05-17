"Filed out from Dolphin Smalltalk"!

SSWReStoreAbstractQueryTest subclass: #SSWReStoreResourcesTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreResourcesTest guid: (GUID fromString: '{a439bf10-940a-40be-8457-c690806f33d9}')!
SSWReStoreResourcesTest comment: ''!
!SSWReStoreResourcesTest categoriesForClass!Unclassified! !
!SSWReStoreResourcesTest methodsFor!

testStatementFinalizedAfterStreaming

	self _testStatementFinalizedAfter: 
		["Compared to testStatementFreedAfterStreaming we don't want to trigger the end-of-stream free, so just create the stream"
		(SimplePerson storedInstancesIn: reStore) readStream]!

testStatementFreedAfterDetect

	self _testStatementFreedAfter: [(SimplePerson storedInstancesIn: reStore) detect: [ :each | each firstName = 'John']]!

testStatementFreedAfterModify

	self _testStatementFreedAfter: [(SimplePerson storedInstancesIn: reStore) modify: [ :each | each age: 21]]!

testStatementFreedAfterQuery

	self _testStatementFreedAfter: [(SimplePerson storedInstancesIn: reStore) size]
!

testStatementFreedAfterStreaming

	self _testStatementFreedAfter: 
		[| stream |
		stream := (SimplePerson storedInstancesIn: reStore) readStream.
		[stream atEnd] whileFalse: [stream next].

		"Forward-only streams close themselves"
		stream class = SSWDBForwardOnlyReadStream ifFalse: [stream close]]!

testStatementFreedAfterUpdate

	| john table |

	john := self john.

	table := reStore tableForClass: john class.
	self _testStatementFreedAfter: 
		[reStore executeQuery: 
			(SSWSQLUpdateObjectQuery new 
				object: john; 
				table: table;
				fieldUpdates: (SSWSQLFieldAssignment field: (table fieldAccessing: #firstName) value: 'Jack');
				yourself)]! !
!SSWReStoreResourcesTest categoriesForMethods!
testStatementFinalizedAfterStreaming!public!unit tests! !
testStatementFreedAfterDetect!public!unit tests! !
testStatementFreedAfterModify!public!unit tests! !
testStatementFreedAfterQuery!public!unit tests! !
testStatementFreedAfterStreaming!public!unit tests! !
testStatementFreedAfterUpdate!public!unit tests! !
!


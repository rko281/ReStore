"Filed out from Dolphin Smalltalk"!

SSWReStoreReadStreamTest subclass: #SSWReStoreDynamicReadStreamTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWReStoreDynamicReadStreamTest guid: (GUID fromString: '{e21282e5-f42e-400d-b0a9-02c36ef65bb0}')!

SSWReStoreDynamicReadStreamTest comment: ''!

!SSWReStoreDynamicReadStreamTest categoriesForClass!Unclassified! !

!SSWReStoreDynamicReadStreamTest methodsFor!

_testNonScrollableConnection

	"Private - Sent in case of this class not being relevent, i.e. connection does not support scrollable cursors.
	Just verify this is the case"

	self deny: reStore connection supportsScrollableCursors!

createTestData

	"Shortcut this if we're not relevant"
	reStore connection supportsScrollableCursors ifFalse: [^readStream := ReadStream on: #()].

	self sampleSet storeAllIn: reStore.

	reStore simulateReconnect.

	readStream := ((SimplePerson storedInstancesIn: reStore) beOrdered; include: #address; yourself) readStream: (reStore connection supportsScrollableDynamicCursorType ifTrue: [#dynamic] ifFalse: [#static])!

setUp

	"This class is only relevant to connections which support scrollable cursors"

	super setUp.

	reStore connection supportsScrollableCursors ifFalse: [testSelector := #_testNonScrollableConnection]!

testPositionBackwardsSpeed

	"For a dynamic cursor reversing position should ~ as fast as going forward"

	| speedFwd speedReverse |

	"Need a larger working set for this test to be meaningful"
	((self sampleSize + 1 to: 1000) collect: 
		[ :e | 
		SimplePerson new 
			surname: 'Smith'; 
			firstName: 'John', e displayString; 
			emailAddress: 'john@something'; 
			address: SimpleAddress new;
			yourself]) storeAllIn: reStore.

	reStore simulateReconnect.

	readStream := ((SimplePerson storedInstancesIn: reStore) beOrdered; yourself) readStream: #dynamic.

	"Warm things up"
	readStream position: 890.
	self assert: readStream next firstName equals: 'John891'.

	speedFwd := 
		Time microsecondsToRun: 
			[readStream position: 990.
			self assert: readStream next firstName equals: 'John991'].

	speedReverse := 
		Time microsecondsToRun: 
			[readStream position: 890.
			self assert: readStream peek firstName equals: 'John891'].

	self assert: speedReverse < (speedFwd * 2)!

testReadStreamClass

	"For a dynamic cursor we should have an SSWDBReadStream, not SSWDBForwardOnlyReadStream"

	self assert: readStream class equals: SSWDBReadStream! !

!SSWReStoreDynamicReadStreamTest categoriesForMethods!
_testNonScrollableConnection!private!unit tests! !
createTestData!public!running! !
setUp!public!running! !
testPositionBackwardsSpeed!public!unit tests! !
testReadStreamClass!public!unit tests! !
!


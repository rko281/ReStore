"Filed out from Dolphin Smalltalk 7"!

SSWReStorePersonTest subclass: #SSWReStoreSpeedTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreSpeedTest guid: (GUID fromString: '{b971340a-1aa8-4d6b-a8f1-0c9907e63817}')!
SSWReStoreSpeedTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreSpeedTest categoriesForClass!Unclassified! !
!SSWReStoreSpeedTest methodsFor!

sampleSet

	^(1 to: self sampleSize) collect: 
		[ :e | 
		SimplePerson new 
			surname: 'Smith'; 
			firstName: 'John'; 
			emailAddress: 'john@something'; 
			yourself]!

sampleSize

	^100!

test1Write

	| people time |

	reStore destroyAllClasses.
	reStore synchronizeAllClasses.

	people := self sampleSet.

	Transcript 
		cr; 
		show: 'Writing '; print: self sampleSize; show: ' objects... ';
		show: (time := Time millisecondsToRun: [people storeIn: reStore]) displayString;
		show: ' ms'.

	self assert: ((reStore instancesOf: SimplePerson) size = self sampleSize).
	self assert: (time < (self sampleSize * 2)) "Fairly arbitrary but keeps an eye on things"!

test2Read

	| people time |

	reStore destroyAllClasses.
	reStore synchronizeAllClasses.
	self sampleSet storeAllIn: reStore.

	reStore simulateReconnect.

	people := reStore instancesOf: SimplePerson.

	Transcript 
		cr; 
		show: 'Reading '; print: self sampleSize; show: ' objects... ';
		show:  (time := Time millisecondsToRun: [people := people asOrderedCollection]) displayString;
		show: ' ms'.

	self assert: (people size = self sampleSize).
	self assert: (time < (self sampleSize // 2)) "Fairly arbitrary but keeps an eye on things"!

test3Update

	| people time |

	reStore destroyAllClasses.
	reStore synchronizeAllClasses.
	self sampleSet storeAllIn: reStore.

	reStore simulateReconnect.

	people := (reStore instancesOf: SimplePerson) asOrderedCollection.
	people do: 
		[ :person || id |
		id := person _id.
		id odd 
			ifTrue: [person firstName: (person firstName, id displayString)] 
			ifFalse: [person surname: (person surname, id displayString)]].

	Transcript 
		cr; 
		show: 'Updating '; print: self sampleSize; show: ' objects... ';
		show:  (time := Time millisecondsToRun: [people storeAll]) displayString;
		show: ' ms'.

	reStore simulateReconnect.
	(reStore instancesOf: SimplePerson) asOrderedCollection do: 
		[ :person || id |
		id := person _id.
		id odd 
			ifTrue: [self assert: person firstName equals: ('John', id displayString)] 
			ifFalse: [self assert: person surname equals: ('Smith', id displayString)]].

	self assert: (time < (self sampleSize * 2)) "Fairly arbitrary but keeps an eye on things"!

test4RefreshNoChange

	| people time |

	reStore destroyAllClasses.
	reStore synchronizeAllClasses.
	self sampleSet storeAllIn: reStore.

	reStore simulateReconnect.

	people := (reStore instancesOf: SimplePerson) asOrderedCollection.

	Transcript 
		cr; 
		show: 'Refreshing (no change) '; print: self sampleSize; show: ' objects... ';
		show:  (time := Time millisecondsToRun: [people refreshAll]) displayString;
		show: ' ms'.

	self assert: (time < (self sampleSize * 2)) "Fairly arbitrary but keeps an eye on things"!

test5RefreshWithChange

	| people time |

	reStore destroyAllClasses.
	reStore synchronizeAllClasses.
	self sampleSet storeAllIn: reStore.

	reStore simulateReconnect.

	people := (reStore instancesOf: SimplePerson) asOrderedCollection.

	reStore connection evaluateAsTxn:
		[people do: 
			[ :person || id |
			id := person _id.
			id odd ifTrue: [reStore connection exec: ('update simple_person set first_name = ''changed'', version_ = version_ + 1 where id_ = <1p>' expandMacrosWith: id)]].
		true].

	Transcript 
		cr; 
		show: 'Refreshing (changed) '; print: self sampleSize; show: ' objects... ';
		show:  (time := Time millisecondsToRun: [people refreshAll]) displayString;
		show: ' ms'.

	people do: 
		[ :person || id |
		id := person _id.
		id odd
			ifTrue: [self assert: person firstName equals: 'changed'] 
			ifFalse: [self assert: person firstName equals: 'John']].

	self assert: (time < (self sampleSize * 3)) "Fairly arbitrary but keeps an eye on things"!

test9Delete

	| people time |

	reStore destroyAllClasses.
	reStore synchronizeAllClasses.
	self sampleSet storeAllIn: reStore.

	reStore simulateReconnect.

	people := (reStore instancesOf: SimplePerson) asOrderedCollection.
	
	Transcript 
		cr; 
		show: 'Deleting '; print: self sampleSize; show: ' objects... ';
		show:  (time := Time millisecondsToRun: [people unstoreAll]) displayString;
		show: ' ms'.

	self assert: (reStore instancesOf: SimplePerson) isEmpty.
	self assert: (time < (self sampleSize * 2)) "Fairly arbitrary but keeps an eye on things"! !
!SSWReStoreSpeedTest categoriesFor: #sampleSet!public! !
!SSWReStoreSpeedTest categoriesFor: #sampleSize!public!Running! !
!SSWReStoreSpeedTest categoriesFor: #test1Write!public!unit tests! !
!SSWReStoreSpeedTest categoriesFor: #test2Read!public!unit tests! !
!SSWReStoreSpeedTest categoriesFor: #test3Update!public! !
!SSWReStoreSpeedTest categoriesFor: #test4RefreshNoChange!public! !
!SSWReStoreSpeedTest categoriesFor: #test5RefreshWithChange!public! !
!SSWReStoreSpeedTest categoriesFor: #test9Delete!public! !


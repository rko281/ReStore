"Filed out from Dolphin Smalltalk 7"!

SSWReStoreTest subclass: #SSWReStoreTypeTest
	instanceVariableNames: 'date time datetime'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreTypeTest guid: (GUID fromString: '{989359ed-2e4c-4ebb-bdc0-861c1f8eb0e4}')!
SSWReStoreTypeTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreTypeTest categoriesForClass!Unclassified! !
!SSWReStoreTypeTest methodsFor!

addClassesTo: aReStore

	aReStore addClass: TypeTest!

createTestInstance
reStore debugTo: Transcript.
	reStore destroyAllClasses.
	reStore synchronizeAllClasses.

	datetime := DateAndTime now withResolution: reStore sqlDialect maxDateTimeResolution.
	date := datetime asDate.
	time := datetime asTime.

	reStore beginTransaction.
	TypeTest new
		char: 'CHAR';
		varchar: 'VARCHAR';
		medText: ((String new: 2000) atAllPut: $M; yourself);
		largeText: ((String new: 5000) atAllPut: $L; yourself);
		unsizedText: ((String new: 6000) atAllPut: $U; yourself);

		tinyBlob: (ByteArray withAll: (0 to: 240));
		medBlob: ((ByteArray new: 2000) atAllPut: 200; yourself);
		largeBlob: ((ByteArray new: 5000) atAllPut: 220; yourself);
		unsizedBlob: ((ByteArray new: 6000) atAllPut: 240; yourself);

		integer: 123;
		float: 123.456;
		decimal: 12345.67891;

		date: date;
		time: time;
		datetime: datetime;
		datetimeWithMilliseconds: datetime;

		trueBoolean: true;
		falseBoolean: false;

		storeIn: reStore.
	reStore commitTransaction.

	reStore simulateReconnect.
	^(reStore instancesOf: TypeTest) first!

testANSI

	"Test a String containing only ANSI characters"

	self testStrings: #[99 97 102 101] asAnsiString "cafe"!

testBytes

	| bytes allBytes tiny med large t id |

	bytes := ByteArray withAll: (0 to: 255).
	allBytes := bytes.
	(10000 / bytes size) rounded timesRepeat: [allBytes := allBytes, bytes].

	tiny := allBytes copyFrom: 1 to: 255.
	med := allBytes copyFrom: 1 to: 2000.
	large := allBytes copyFrom: 1 to: 5000.

	t := self createTestInstance.
	t 
		tinyBlob: tiny;
		medBlob: med;
		largeBlob: large;
		unsizedBlob: allBytes;
		store.
	id := t _id.

	reStore simulateReconnect.
	t := (reStore instancesOf: TypeTest) detect: [ :each | each _id = id].

	self assert: t tinyBlob equals: tiny.
	self assert: t medBlob equals: med.
	self assert: t largeBlob equals: large.
	self assert: t unsizedBlob equals: allBytes.

	"SQLServer can't query on binary columns"
	reStore sqlDialect class ~~ SSWSQLServerDialect ifTrue: 
		[self assert: ((reStore instancesOf: TypeTest) detect: [ :each | each tinyBlob = tiny]) identicalTo: t.
		self assert: ((reStore instancesOf: TypeTest) detect: [ :each | each medBlob = med]) identicalTo: t.
		self assert: ((reStore instancesOf: TypeTest) detect: [ :each | each largeBlob = large]) identicalTo: t.
		self assert: ((reStore instancesOf: TypeTest) detect: [ :each | each unsizedBlob = allBytes]) identicalTo: t]!

testDate

	| t |

	t := self createTestInstance.

	self assert: (t date = date)!

testDateQuery

	| t t2|

	t := self createTestInstance.

	reStore simulateReconnect.
	t2 := (reStore instancesOf: TypeTest) detect: [ :each | each date = t date] ifNone: [nil].
	self assert: t2 notNil.
	self assert: t2 time = t time!

testDateTime

	| t |

	t := self createTestInstance.

	self assert: (t datetime = (datetime withResolution: reStore sqlDialect defaultDateTimeResolution))!

testDateTimeQuery

	| t |

	self createTestInstance.

	t := (reStore instancesOf: TypeTest) detect: [ :each | each datetime = (datetime withResolution: reStore sqlDialect defaultDateTimeResolution)] ifNone: [nil].
	
	self assert: t notNil!

testDateTimeWithMilliseconds

	| t |

	reStore sqlDialect maxDateTimeResolution < 3 ifTrue: [^self].

	t := self createTestInstance.

	"Take account of rounding differences between image and sql dialect"
	self assert: ((t datetimeWithMilliseconds - (datetime withResolution: 3)) <= 1 milliseconds)!

testDecimal

	| t |

	t := self createTestInstance.

	self assert: (t decimal = 12345.6789s4)!

testExtendedANSI

	"Test a String containing an extended ANSI character"

	self testStrings: #[99 97 102 233] asAnsiString "café"!

testGeneral

	| t |

	t := self createTestInstance.

	self assert: (t char trimBlanks = 'CHAR').
	self assert: (t varchar = 'VARCHAR').
	self assert: (t medText = ((String new: 2000) atAllPut: $M; yourself)).
	self assert: (t largeText = ((String new: 5000) atAllPut: $L; yourself)).
	self assert: (t unsizedText = ((String new: 6000) atAllPut: $U; yourself)).
	self assert: (t integer = 123).
	self assert: (t float = 123.456).
	self assert: (t falseBoolean = false)!

testStrings: aString

	| t id |

	t := self createTestInstance.
	t 
		varchar: aString;
		medText: aString;
		largeText: aString;
		unsizedText: aString;
		store.
	id := t _id.

	reStore simulateReconnect.
	t := (reStore instancesOf: TypeTest) detect: [ :each | each _id = id].

	self assert: t varchar equals: aString.
	self assert: t medText equals: aString.
	self assert: t largeText equals: aString.
	self assert: t unsizedText equals: aString.

	self assert: ((reStore instancesOf: TypeTest) detect: [ :each | each varchar = aString]) identicalTo: t.
	self assert: ((reStore instancesOf: TypeTest) detect: [ :each | each medText = aString]) identicalTo: t.
	self assert: ((reStore instancesOf: TypeTest) detect: [ :each | each largeText = aString]) identicalTo: t.

	"SQLServer can't compare on unsized text columns"
	reStore sqlDialect class ~~ SSWSQLServerDialect ifTrue: 
		[self assert: ((reStore instancesOf: TypeTest) detect: [ :each | each unsizedText = aString]) identicalTo: t]!

testTime

	| t |

	t := self createTestInstance.

	"Use difference of <= 1 second to take account of different roundings in image and db"
	self assert: (t time asSeconds - time asSeconds) abs <= 1!

testTimeQuery

	| t t2|

	t := self createTestInstance.

	reStore simulateReconnect.

	t2 := (reStore instancesOf: TypeTest) detect: [ :each | each time = time] ifNone: [nil].
	self assert: t2 notNil.
	self assert: t2 date = t date!

testUTF8_2

	"Test a String containing a 2-byte UTF8 character"

	self testStrings: (Utf8String fromByteArray: #[99 97 102 195 169]) "café"!

testUTF8_3

	"Test a String containing a 3-byte UTF8 character"

	self testStrings: (Utf8String fromByteArray: #[99 97 102 226 130 172]) "caf€"!

testUTF8_4

	"Test a String containing a 4-byte UTF8 character"

	self testStrings: (Utf8String fromByteArray: #[99 97 102 240 160 156 142]) "caf𠜎"!

testUTF8_mixed

	"Test a String containing a mixture of UTF8 characters"

	self testStrings: (Utf8String fromByteArray: #[195 156 98 195 168 114 115 116 114 195 174 195 177 103 195 169]) "Übèrstrîñgé"! !
!SSWReStoreTypeTest categoriesFor: #addClassesTo:!public!running! !
!SSWReStoreTypeTest categoriesFor: #createTestInstance!public!running! !
!SSWReStoreTypeTest categoriesFor: #testANSI!public!unit tests! !
!SSWReStoreTypeTest categoriesFor: #testBytes!public!running! !
!SSWReStoreTypeTest categoriesFor: #testDate!public!unit tests! !
!SSWReStoreTypeTest categoriesFor: #testDateQuery!public!unit tests! !
!SSWReStoreTypeTest categoriesFor: #testDateTime!public! !
!SSWReStoreTypeTest categoriesFor: #testDateTimeQuery!public! !
!SSWReStoreTypeTest categoriesFor: #testDateTimeWithMilliseconds!public! !
!SSWReStoreTypeTest categoriesFor: #testDecimal!public!unit tests! !
!SSWReStoreTypeTest categoriesFor: #testExtendedANSI!public!unit tests! !
!SSWReStoreTypeTest categoriesFor: #testGeneral!public!unit tests! !
!SSWReStoreTypeTest categoriesFor: #testStrings:!private!running! !
!SSWReStoreTypeTest categoriesFor: #testTime!public!unit tests! !
!SSWReStoreTypeTest categoriesFor: #testTimeQuery!public!unit tests! !
!SSWReStoreTypeTest categoriesFor: #testUTF8_2!public!unit tests! !
!SSWReStoreTypeTest categoriesFor: #testUTF8_3!public!unit tests! !
!SSWReStoreTypeTest categoriesFor: #testUTF8_4!public!unit tests! !
!SSWReStoreTypeTest categoriesFor: #testUTF8_mixed!public!unit tests! !


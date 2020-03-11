"Filed out from Dolphin Smalltalk 7"!

SSWReStore2Test subclass: #SSWReStoreUpdateClashTestPersistent
	instanceVariableNames: 'singleA1 singleB1 singleC1 singleA2 singleB2 singleC2'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreUpdateClashTestPersistent guid: (GUID fromString: '{44959c07-4f0e-48c2-885a-cfcdcfaa60e5}')!
SSWReStoreUpdateClashTestPersistent comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreUpdateClashTestPersistent categoriesForClass!Unclassified! !
!SSWReStoreUpdateClashTestPersistent methodsFor!

createStandardTestInstance

	super createStandardTestInstance.

	singleA1 := Test new name: 'singleA'.
	singleB1 := Test new name: 'singleB'.
	singleC1 := Test new name: 'singleC'.

	self assert: ((Array with: singleA1 with: singleB1 with: singleC1) storeAllIn: reStore)!

createTestData

	self createStandardTestInstance.
	reStore simulateReconnect.
	self refreshDelay!

reinitSingles1

	singleA1 := (Test storedInstancesIn: reStore) detect: [ :e | e name = 'singleA'].
	singleB1 := (Test storedInstancesIn: reStore) detect: [ :e | e name = 'singleB'].
	singleC1 := (Test storedInstancesIn: reStore) detect: [ :e | e name = 'singleC']!

reinitSingles2

	singleA2 := (Test storedInstancesIn: reStore2) detect: [ :e | e name = 'singleA'].
	singleB2 := (Test storedInstancesIn: reStore2) detect: [ :e | e name = 'singleB'].
	singleC2 := (Test storedInstancesIn: reStore2) detect: [ :e | e name = 'singleC']!

test01

	"Check detect and pass (independent changes)"

	| inst1 inst2 |

	self reinitSingles1.
	self reinitSingles2.

	inst1 := (OwnerTest storedInstancesIn: reStore) asOrderedCollection first.
	inst2 := (OwnerTest storedInstancesIn: reStore2) asOrderedCollection first.

	self assert: (reStore evaluateAsTransaction: [inst1 single1: inst1 single2]).
	self assert: (reStore2 evaluateAsTransaction: [inst2 single2: inst2 single1]).

	self assert: (inst1 isDBProxy).
	self assert: (inst2 isDBProxy).

	reStore refreshAllObjects. 
	reStore2 refreshAllObjects. 

	self assert: (inst1 single1 name = 'single2').
	self assert: (inst2 single2 name = 'single1')!

test02

	"Check detect-fail-rollback"

	| inst1 inst2 oldName |

	self reinitSingles1.
	self reinitSingles2.

	inst1 := (OwnerTest storedInstancesIn: reStore) asOrderedCollection first.
	inst2 := (OwnerTest storedInstancesIn: reStore2) asOrderedCollection first.

	oldName := inst2 name.

	self assert: (reStore evaluateAsTransaction: [inst1 single1: singleA1]).
	self deny: (reStore2 evaluateAsTransaction: [inst2 name: 'XYZ'; single1: singleB2]).

	reStore2 rollbackAndRefreshTransaction.
	self deny: (reStore2 hasTransaction).
	self assert: (inst1 isDBProxy).
	self assert: (inst2 isDBProxy).
	self assert: (inst2 name = oldName).
	self assert: (inst2 single1 = singleA2).

	reStore refreshAllObjects.

	self assert: (inst1 single1 = singleA1).
	self assert: (inst2 single1 = singleA2).
	self deny: (inst2 name = 'XYZ')! !
!SSWReStoreUpdateClashTestPersistent categoriesFor: #createStandardTestInstance!private!Running! !
!SSWReStoreUpdateClashTestPersistent categoriesFor: #createTestData!public!Running! !
!SSWReStoreUpdateClashTestPersistent categoriesFor: #reinitSingles1!private!Running! !
!SSWReStoreUpdateClashTestPersistent categoriesFor: #reinitSingles2!private!Running! !
!SSWReStoreUpdateClashTestPersistent categoriesFor: #test01!public!unit tests! !
!SSWReStoreUpdateClashTestPersistent categoriesFor: #test02!public!unit tests! !


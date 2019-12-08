"Filed out from Dolphin Smalltalk 7"!

SSWReStoreDefaultTest subclass: #SSWReStoreProcessAffiliationTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreProcessAffiliationTest guid: (GUID fromString: '{d47a43ee-69a6-4c9f-81f0-7948ff1db3a8}')!
SSWReStoreProcessAffiliationTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreProcessAffiliationTest categoriesForClass!Unclassified! !
!SSWReStoreProcessAffiliationTest methodsFor!

testDefaultStoredInstancesWithProcessWithOtherReStore

	"Test use of storedInstances with the default ReStore and another instance affiliated to another process"

	| zoe1 zoe2 sem |

	zoe1 := SimplePerson storedInstances detect: [ :each | each fullName = 'Zoe Brown'].

	sem := Semaphore new.
	([zoe2 := SimplePerson storedInstances detect: [ :each | each fullName = 'Zoe Brown'].
	sem signal] newProcess)
		reStore: reStore2;
		resume.
	sem wait.

	self assert: zoe1 ~~ zoe2.

	self assert: zoe1 _reStore = SSWReStore globalDefault.
	self assert: zoe1 _reStore = reStore.

	self assert: zoe2 _reStore = reStore2!

testDefaultStoredInstancesWithProcessWithSameReStore

	"Test use of storedInstances with the default ReStore in a forked process"

	| zoe1 zoe2 sem |

	zoe1 := SimplePerson storedInstances detect: [ :each | each fullName = 'Zoe Brown'].

	sem := Semaphore new.
	[zoe2 := SimplePerson storedInstances detect: [ :each | each fullName = 'Zoe Brown'].
	sem signal] fork.
	sem wait.

	self assert: zoe1 == zoe2.

	self assert: zoe1 _reStore = SSWReStore globalDefault.
	self assert: zoe2 _reStore = SSWReStore globalDefault.
	self assert: zoe1 _reStore = reStore.
	self assert: zoe2 _reStore = reStore!

testDefaultWithProcessWithOtherReStore

	"Test separation of the default ReStore and another instance affiliated to another process"

	| sem |

	self assert: SSWReStore default == reStore.
	self assert: ReStore == reStore.

	sem := Semaphore new.
	([self assert: SSWReStore default == reStore2.
	self assert: Processor activeProcess reStore == reStore2.
	self assert: ReStore == reStore.
	sem signal] newProcess)
		reStore: reStore2;
		resume.
	sem wait!

testDefaultWithProcessWithSameReStore

	"Test use of the default ReStore in a forked process"

	| sem |

	self assert: SSWReStore default == reStore.
	self assert: ReStore == reStore.

	sem := Semaphore new.
	[self assert: SSWReStore default == reStore.
	self assert: Processor activeProcess reStore == reStore.
	self assert: ReStore == reStore.
	sem signal] fork.

	sem wait!

testDisaffiliation

	"Test a process disaffiliated from its ReStore returns to the default global ReStore"

	| zoe2 zoe2a sem |

	sem := Semaphore new.
	([zoe2 := SimplePerson storedInstances detect: [ :each | each fullName = 'Zoe Brown'].
	self assert: SSWReStore default == reStore2.
	self assert: zoe2 _reStore == reStore2.

	Processor activeProcess reStore: nil.
	zoe2a := SimplePerson storedInstances detect: [ :each | each fullName = 'Zoe Brown'].
	self assert: SSWReStore default == reStore.
	self assert: zoe2a _reStore == reStore.

	sem signal] newProcess)
		reStore: reStore2;
		resume.
	sem wait!

testDynamicChangeOfProcessReStore

	"Test switching of a process's reStore"

	| zoe1 zoe2 zoe1A |

	zoe1 := SimplePerson storedInstances detect: [ :each | each fullName = 'Zoe Brown'].
	
	Processor activeProcess reStore: reStore2.
	zoe2 := SimplePerson storedInstances detect: [ :each | each fullName = 'Zoe Brown'].

	Processor activeProcess reStore: nil.
	zoe1A := SimplePerson storedInstances detect: [ :each | each fullName = 'Zoe Brown'].
	
	self assert: zoe1 ~~ zoe2.
	self assert: zoe1 == zoe1A.

	self assert: zoe1 _reStore = SSWReStore globalDefault.
	self assert: zoe1 _reStore = reStore.
	self assert: zoe2 _reStore = reStore2.
	self assert: zoe1A _reStore = SSWReStore globalDefault.
	self assert: zoe1A _reStore = reStore!

testExistingStoreInProcessWithOtherReStore

	"Test that a store of an existing object commits in the object's reStore, not the current default (process or global)"

	| zoe1 john1 zoe2 john2 sem |

	zoe1 := SimplePerson storedInstances detect: [ :each | each fullName = 'Zoe Brown'].
	zoe1 emailAddress: 'ztest1'.

	john1 := SimplePerson storedInstances detect: [ :each | each fullName = 'John Smith'].
	john1 emailAddress: 'jtest1'.

	sem := Semaphore new.
	[zoe2 := SimplePerson storedInstances detect: [ :each | each fullName = 'Zoe Brown'].
	zoe2 emailAddress: 'ztest2'.

	john2 := SimplePerson storedInstances detect: [ :each | each fullName = 'John Smith'].
	john2 emailAddress: 'jtest2'.

	zoe1 store.
	john2 store.

	sem signal] newProcess
		reStore: reStore2;
		resume.

	sem wait.

	self refreshDelay.

	self assert: (SimplePerson storedInstances detect: [ :each | each emailAddress = 'ztest1']) == zoe1.
	self assert: (SimplePerson storedInstances detect: [ :each | each emailAddress = 'jtest2']) == john1!

testNewStoreInProcessWithOtherReStore

	"Test that a store in a process with another reStore commits in that ReStore, not the default"

	| alan sem |

	alan := self newAlan.

	sem := Semaphore new.
	[alan store.
	sem signal] newProcess
		reStore: reStore2;
		resume.

	sem wait.

	self assert: alan _reStore == reStore2!

testObjectReStoreInProcessWithOtherReStore

	"Test that a check for an existing object's reStore returns the object's reStore, not the current default (process or global)"

	| alan zoe1 zoe2 sem |

	alan := self newAlan.
	zoe1 := SimplePerson storedInstances detect: [ :each | each fullName = 'Zoe Brown'].

	sem := Semaphore new.

	[zoe2 := SimplePerson storedInstances detect: [ :each | each fullName = 'Zoe Brown'].

	self assert: alan _reStore isNil.

	self assert: zoe1 _reStore == reStore.
	self assert: zoe1 _reStore == SSWReStore globalDefault.

	self assert: zoe2 _reStore == reStore2.

	sem signal] newProcess
		reStore: reStore2;
		resume.

	sem wait.

	self assert: alan _reStore isNil.

	self assert: zoe1 _reStore == reStore.
	self assert: zoe1 _reStore == SSWReStore globalDefault.

	self assert: zoe2 _reStore == reStore2!

testTwoProcessesWithSameReStore

	"Test a ReStore affiliated with two different processes results in the same objects"

	| zoe1 zoe2 sem |

	sem := Semaphore new.
	([zoe1 := SimplePerson storedInstances detect: [ :each | each fullName = 'Zoe Brown'].
	sem signal] newProcess)
		reStore: reStore2;
		resume.
	sem wait.

	sem := Semaphore new.
	([zoe2 := SimplePerson storedInstances detect: [ :each | each fullName = 'Zoe Brown'].
	sem signal] newProcess)
		reStore: reStore2;
		resume.
	sem wait.

	self assert: zoe1 == zoe2.

	self assert: zoe1 _reStore = reStore2.
	self assert: zoe2 _reStore = reStore2! !
!SSWReStoreProcessAffiliationTest categoriesFor: #testDefaultStoredInstancesWithProcessWithOtherReStore!public!unit tests! !
!SSWReStoreProcessAffiliationTest categoriesFor: #testDefaultStoredInstancesWithProcessWithSameReStore!public!unit tests! !
!SSWReStoreProcessAffiliationTest categoriesFor: #testDefaultWithProcessWithOtherReStore!public!unit tests! !
!SSWReStoreProcessAffiliationTest categoriesFor: #testDefaultWithProcessWithSameReStore!public!unit tests! !
!SSWReStoreProcessAffiliationTest categoriesFor: #testDisaffiliation!public!unit tests! !
!SSWReStoreProcessAffiliationTest categoriesFor: #testDynamicChangeOfProcessReStore!public!unit tests! !
!SSWReStoreProcessAffiliationTest categoriesFor: #testExistingStoreInProcessWithOtherReStore!public!unit tests! !
!SSWReStoreProcessAffiliationTest categoriesFor: #testNewStoreInProcessWithOtherReStore!public!unit tests! !
!SSWReStoreProcessAffiliationTest categoriesFor: #testObjectReStoreInProcessWithOtherReStore!public!unit tests! !
!SSWReStoreProcessAffiliationTest categoriesFor: #testTwoProcessesWithSameReStore!public!unit tests! !


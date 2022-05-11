"Filed out from Dolphin Smallalk"!

SSWReStoreTest subclass: #SSWReStoreHierarchyTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreHierarchyTest guid: (GUID fromString: '{fe506bd0-b0c1-4b63-b613-b8597358f150}')!
SSWReStoreHierarchyTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreHierarchyTest categoriesForClass!Unclassified! !
!SSWReStoreHierarchyTest methodsFor!

_testClassOfProxyOfIndirectInstanceOf: aClass

	"Verify that, even when recovered via a second path, the class of the proxy of an object from a persistent hierarchy is set correctly (previously not the case for leaf classes)"

	self _testClassOfProxyOfInstanceOf: aClass recoveredBy: [ :proxy | (reStore instancesOf: aClass) asOrderedCollection collect: [ :each | each firstName]]!

_testClassOfProxyOfInstanceOf: aClass

	self _testClassOfProxyOfInstanceOf: aClass recoveredBy: [ :proxy | proxy firstName]!

_testClassOfProxyOfInstanceOf: aClass recoveredBy: aBlock

	"Verify that, when recovered using aBlock after initially being an unrecovered proxy, the class of the proxy of an object from a persistent hierarchy is set correctly"

	| owner |

	"Just using MidPerson here for its reference to SuperPerson in its midFriend inst var"
	owner := MidPerson new firstName: 'owner'.
	owner midFriend: ((aClass storedInstancesIn: reStore) first).
	owner storeIn: reStore.

	reStore simulateReconnect.

	"Read the owner; at this stage midFriend will just be an unrecovered proxy"
	owner := (MidPerson storedInstancesIn: reStore) detect: [ :each | each firstName = 'owner'].
	self assert: owner midFriend isDBProxy.
	self assert: owner midFriend _proxiedObject isNil.
	self assert: owner midFriend _class equals: SuperPerson. "at this stage - proxied object has not been read"

	"Recover it"
	aBlock value: owner midFriend.
	self deny: owner midFriend isDBProxy.
	self assert: owner midFriend class equals: aClass.
	self assert: (owner midFriend _dbProxyIn: reStore) _class equals: aClass!

addClassesTo: aReStore

	aReStore
		addClassWithSubclasses: SuperPerson!

createTestData

	(Array
		with: (SuperPerson new firstName: 'john')
		with: (MidPerson new firstName: 'dave'; middleName: 'davison')
		with: (SubPerson new firstName: 'mike'; middleName: 'michaelson'; age: 22)) storeAllIn: reStore.

	reStore simulateReconnect!

test01VerifySetUp
	self assert: ((SuperPerson storedInstancesIn: reStore ) size = 3)!

test02Counts

	| insts |

	insts := SuperPerson storedInstancesIn: reStore.
	self assert: (insts size = 3).

	insts := (SuperPerson storedInstancesIn: reStore ) withoutInheritance.
	self assert: (insts size = 1).

	insts := MidPerson storedInstancesIn: reStore.
	self assert: (insts size = 2).

	insts := (MidPerson storedInstancesIn: reStore) withoutInheritance.
	self assert: (insts size = 1).

	insts := SubPerson storedInstancesIn: reStore.
	self assert: (insts size = 1).

	insts := (SubPerson storedInstancesIn: reStore) withoutInheritance.
	self assert: (insts size = 1)!

test03Querying

	"Querying for actual aspects"

	| persons midPersons subPersons |

	persons := SuperPerson storedInstancesIn: reStore.
	midPersons := MidPerson storedInstancesIn: reStore.
	subPersons := SubPerson storedInstancesIn: reStore.
	
	self assert: ((persons satisfying: [ :each | each firstName = 'john']) size = 1).
	self assert: ((midPersons satisfying: [ :each | each firstName = 'john']) size = 0).
	self assert: ((subPersons satisfying: [ :each | each firstName = 'john']) size = 0).
	
	self assert: ((persons satisfying: [ :each | each firstName = 'dave']) size = 1).
	self assert: ((persons withoutInheritance satisfying: [ :each | each firstName = 'dave']) size = 0).
	self assert: ((midPersons satisfying: [ :each | each firstName = 'dave']) size = 1).
	self assert: ((subPersons satisfying: [ :each | each firstName = 'dave']) size = 0).

	self assert: ((persons satisfying: [ :each | each firstName = 'mike']) size = 1).
	self assert: ((persons withoutInheritance satisfying: [ :each | each firstName = 'mike']) size = 0).
	self assert: ((midPersons satisfying: [ :each | each firstName = 'mike']) size = 1).
	self assert: ((midPersons withoutInheritance satisfying: [ :each | each firstName = 'mike']) size = 0).
	self assert: ((subPersons satisfying: [ :each | each firstName = 'mike']) size = 1).!

test04Classes

	"Test proxies respond correctly to class both with and without cached proxy"

	| insts john dave mike |

	insts := SuperPerson storedInstancesIn: reStore.
	
	john := insts detect: [ :e | e firstName = 'john'].
	self assert: john isDBProxy.
	self assert: (john class = SuperPerson).
	john _forgetProxiedObject.
	self assert: (john class = SuperPerson).

	dave := insts detect: [ :e | e firstName = 'dave'].
	self assert: dave isDBProxy.
	self assert: (dave class = MidPerson).
	dave _forgetProxiedObject.
	self assert: (dave class = MidPerson).
	self assert: (dave middleName = 'davison').

	mike := insts detect: [ :e | e firstName = 'mike'].
	self assert: mike isDBProxy.
	self assert: (mike class = SubPerson).
	mike _forgetProxiedObject.
	self assert: (mike class = SubPerson).
	self assert: (mike middleName = 'michaelson').
	self assert: (mike age = 22)!

test05MidFirst

	"Test a previously-erroring case where #first failed for mid and sub class collections (did not filter by class)"

	| midPersons |

	midPersons := MidPerson storedInstancesIn: reStore.
	self assert: ({MidPerson. SubPerson} includes: midPersons first class).
	self should: [(midPersons satisfying: [ :each | each firstName = 'john']) first] raise: Error!

test06SubFirst

	"Test a previously-erroring case where #first failed for mid and sub class collections (did not filter by class)"

	| subPersons |

	subPersons := SubPerson storedInstancesIn: reStore.

	self assert: (subPersons first class = SubPerson).
	self should: [(subPersons satisfying: [ :each | each firstName = 'john']) first] raise: Error!

testClassOfProxyOfIndirectMidInstance

	self _testClassOfProxyOfIndirectInstanceOf: MidPerson!

testClassOfProxyOfIndirectSubInstance

	self _testClassOfProxyOfIndirectInstanceOf: SubPerson!

testClassOfProxyOfIndirectSuperInstance

	self _testClassOfProxyOfIndirectInstanceOf: SuperPerson!

testClassOfProxyOfInstanceOf: aClass

	| owner |

	"Just using MidPerson here for its reference to SuperPerson in its midFriend inst var"
	owner := MidPerson new firstName: 'owner'.
	owner midFriend: ((aClass storedInstancesIn: reStore) first).
	owner storeIn: reStore.

	reStore simulateReconnect.

	"Read the owner; at this stage midFriend will just be an unrecovered proxy"
	owner := (MidPerson storedInstancesIn: reStore) detect: [ :each | each firstName = 'owner'].
	self assert: owner midFriend isDBProxy.
	self assert: owner midFriend _proxiedObject isNil.
	self assert: owner midFriend _class equals: SuperPerson. "at this stage - proxied object has not been read"

	"Read via its own class"
	(reStore instancesOf: aClass) asOrderedCollection collect: [ :each | each firstName].
	self deny: owner midFriend isDBProxy.
	self assert: owner midFriend class equals: aClass.
	self assert: (owner midFriend _dbProxyIn: reStore) _class equals: aClass!

testClassOfProxyOfMidInstance

	self _testClassOfProxyOfInstanceOf: MidPerson!

testClassOfProxyOfSubInstance

	self _testClassOfProxyOfInstanceOf: SubPerson!

testClassOfProxyOfSuperInstance

	self _testClassOfProxyOfInstanceOf: SuperPerson! !
!SSWReStoreHierarchyTest categoriesForMethods!
_testClassOfProxyOfIndirectInstanceOf:!private!unit tests! !
_testClassOfProxyOfInstanceOf:!private!unit tests! !
_testClassOfProxyOfInstanceOf:recoveredBy:!private!unit tests! !
addClassesTo:!public!running! !
createTestData!public!running! !
test01VerifySetUp!public!unit tests! !
test02Counts!public!unit tests! !
test03Querying!public!unit tests! !
test04Classes!public!unit tests! !
test05MidFirst!public!unit tests! !
test06SubFirst!public!unit tests! !
testClassOfProxyOfIndirectMidInstance!public!unit tests! !
testClassOfProxyOfIndirectSubInstance!public!unit tests! !
testClassOfProxyOfIndirectSuperInstance!public!unit tests! !
testClassOfProxyOfInstanceOf:!public!unit tests! !
testClassOfProxyOfMidInstance!public!unit tests! !
testClassOfProxyOfSubInstance!public!unit tests! !
testClassOfProxyOfSuperInstance!public!unit tests! !
!


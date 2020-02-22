"Filed out from Dolphin Smalltalk 7"!

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

addClassesTo: aReStore

	aReStore
		addClassWithSubclasses: SuperPerson!

setUp

	super setUp.

	reStore destroyAllClasses; synchronizeAllClasses.

	reStore commitAll: 
		(Array
			with: (SuperPerson new firstName: 'john')
			with: (MidPerson new firstName: 'dave'; middleName: 'davison')
			with: (SubPerson new firstName: 'mike'; middleName: 'michaelson'; age: 22)).

	reStore simulateReconnect!

test01VerifySetUp
	self assert: ((reStore instancesOf: SuperPerson) size = 3)!

test02Counts

	| insts |

	insts := reStore instancesOf: SuperPerson.
	self assert: (insts size = 3).

	insts := (reStore instancesOf: SuperPerson) withoutInheritance.
	self assert: (insts size = 1).

	insts := reStore instancesOf: MidPerson.
	self assert: (insts size = 2).

	insts := (reStore instancesOf: MidPerson) withoutInheritance.
	self assert: (insts size = 1).

	insts := reStore instancesOf: SubPerson.
	self assert: (insts size = 1).

	insts := (reStore instancesOf: SubPerson) withoutInheritance.
	self assert: (insts size = 1)!

test03Querying

	"Querying for actual aspects"

	| persons midPersons subPersons |

	persons := reStore instancesOf: SuperPerson.
	midPersons := reStore instancesOf: MidPerson.
	subPersons := reStore instancesOf: SubPerson.
	
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

	insts := reStore instancesOf: SuperPerson.
	
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

	midPersons := reStore instancesOf: MidPerson.
	self assert: ({MidPerson. SubPerson} includes: midPersons first class).
	self should: [(midPersons satisfying: [ :each | each firstName = 'john']) first] raise: Error!

test06SubFirst

	"Test a previously-erroring case where #first failed for mid and sub class collections (did not filter by class)"

	| subPersons |

	subPersons := reStore instancesOf: SubPerson.

	self assert: (subPersons first class = SubPerson).
	self should: [(subPersons satisfying: [ :each | each firstName = 'john']) first] raise: Error! !
!SSWReStoreHierarchyTest categoriesFor: #addClassesTo:!public!running! !
!SSWReStoreHierarchyTest categoriesFor: #setUp!public!running! !
!SSWReStoreHierarchyTest categoriesFor: #test01VerifySetUp!public!unit tests! !
!SSWReStoreHierarchyTest categoriesFor: #test02Counts!public!unit tests! !
!SSWReStoreHierarchyTest categoriesFor: #test03Querying!public!unit tests! !
!SSWReStoreHierarchyTest categoriesFor: #test04Classes!public!unit tests! !
!SSWReStoreHierarchyTest categoriesFor: #test05MidFirst!public!unit tests! !
!SSWReStoreHierarchyTest categoriesFor: #test06SubFirst!public!unit tests! !


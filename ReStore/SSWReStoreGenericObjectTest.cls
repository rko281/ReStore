﻿"Filed out from Dolphin Smallalk"!

SSWReStoreGenericTest subclass: #SSWReStoreGenericObjectTest
	instanceVariableNames: 'component'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreGenericObjectTest guid: (GUID fromString: '{da7d942d-eb49-462f-9e06-d4e0711fc0a4}')!
SSWReStoreGenericObjectTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreGenericObjectTest categoriesForClass!Unclassified! !
!SSWReStoreGenericObjectTest methodsFor!

_testComponentExistenceOnDependency

	"No dependency at this level so should still exist"

	self assert: (component _dbProxyIn: reStore ifNone: [nil]) notNil.

	reStore simulateReconnect.
	self assert: ((component class storedInstancesIn: reStore) detect: [ :each | each name = component name] ifNone: [nil]) notNil!

fetchTestObjects

	super fetchTestObjects.

	component := testObject component!

templateTestObject

	^GenericTest new
		component: self templateComponent;
		yourself!

testDependencyCascadedDelete

	"Check that inst var contents are or are not deleted when the owning object is deleted, as appropriate for the specified relationship (i.e. delete if dependent, otherwise not)"

	testObject unstore.

	"Verify the delete"
	self assert: (testObject class storedInstancesIn: reStore) isEmpty.

	self _testComponentExistenceOnDependency!

testDependencyDeleteOnReplacement

	"Check that non-dependent inst var contents are or are not deleted when replaced, as appropriate for the specified relationship (i.e. delete if dependent, otherwise not)"

	testObject component: nil.
	testObject store.

	self _testComponentExistenceOnDependency! !
!SSWReStoreGenericObjectTest categoriesForMethods!
_testComponentExistenceOnDependency!helpers!public! !
fetchTestObjects!public! !
templateTestObject!accessing!public! !
testDependencyCascadedDelete!public!unit tests! !
testDependencyDeleteOnReplacement!public!unit tests! !
!

!SSWReStoreGenericObjectTest class methodsFor!

isAbstract

	^self == SSWReStoreGenericObjectTest! !
!SSWReStoreGenericObjectTest class categoriesForMethods!
isAbstract!public! !
!


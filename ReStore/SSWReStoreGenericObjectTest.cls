"Filed out from Dolphin Smalltalk 7"!

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
	self assert: ((reStore instancesOf: component class) detect: [ :each | each name = component name] ifNone: [nil]) notNil!

fetchTestObjects

	super fetchTestObjects.

	component := testObject component!

templateComponent

	"Ensure unique name"
	(Delay forMilliseconds: 1) wait.

	^GenericOwnedTest new name: (self class name, Time millisecondClockValue printString)!

templateTestObject

	^GenericTest new
		component: self templateComponent;
		yourself!

testDependencyCascadedDelete

	"Check that inst var contents are or are not deleted when the owning object is deleted, as appropriate for the specified relationship (i.e. delete if dependent, otherwise not)"

	reStore commit: testObject unstored.

	"Verify the delete"
	self assert: (reStore instancesOf: testObject class) isEmpty.

	self _testComponentExistenceOnDependency!

testDependencyDeleteOnReplacement

	"Check that non-dependent inst var contents are or are not deleted when replaced, as appropriate for the specified relationship (i.e. delete if dependent, otherwise not)"

	testObject component: nil.
	reStore commit: testObject.

	self _testComponentExistenceOnDependency! !
!SSWReStoreGenericObjectTest categoriesFor: #_testComponentExistenceOnDependency!helpers!public! !
!SSWReStoreGenericObjectTest categoriesFor: #fetchTestObjects!public! !
!SSWReStoreGenericObjectTest categoriesFor: #templateComponent!accessing!public! !
!SSWReStoreGenericObjectTest categoriesFor: #templateTestObject!accessing!public! !
!SSWReStoreGenericObjectTest categoriesFor: #testDependencyCascadedDelete!public!unit tests! !
!SSWReStoreGenericObjectTest categoriesFor: #testDependencyDeleteOnReplacement!public!unit tests! !

!SSWReStoreGenericObjectTest class methodsFor!

isAbstract

	^self == SSWReStoreGenericObjectTest! !
!SSWReStoreGenericObjectTest class categoriesFor: #isAbstract!public! !


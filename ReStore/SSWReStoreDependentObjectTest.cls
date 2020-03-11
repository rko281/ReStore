"Filed out from Dolphin Smalltalk 7"!

SSWReStoreRelatedObjectTest subclass: #SSWReStoreDependentObjectTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreDependentObjectTest guid: (GUID fromString: '{b5248749-e60f-4daf-9bb6-5e797b6610ed}')!
SSWReStoreDependentObjectTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreDependentObjectTest categoriesForClass!Unclassified! !
!SSWReStoreDependentObjectTest methodsFor!

_testComponentExistenceOnDependency

	"component is dependent at this level, so should no longer exist"

	self assert: (component _dbProxyIn: reStore ifNone: [nil]) isNil.

	reStore simulateReconnect.
	self assert: ((component class storedInstancesIn: reStore) detect: [ :each | each name = component name] ifNone: [nil]) isNil!

componentDefinition

	^GenericOwnedTest dependent!

testRefreshIfUpdatedRollbackRemovedComponentChange

	"This test is not relevant to dependent relationships"! !
!SSWReStoreDependentObjectTest categoriesFor: #_testComponentExistenceOnDependency!helpers!public! !
!SSWReStoreDependentObjectTest categoriesFor: #componentDefinition!accessing!public! !
!SSWReStoreDependentObjectTest categoriesFor: #testRefreshIfUpdatedRollbackRemovedComponentChange!public!testing! !


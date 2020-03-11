"Filed out from Dolphin Smalltalk 7"!

SSWReStoreNonRelatedObjectTest subclass: #SSWReStoreNonRelatedDependentObjectTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreNonRelatedDependentObjectTest guid: (GUID fromString: '{af614e1d-fa25-48ae-a66e-e237a4ad86ca}')!
SSWReStoreNonRelatedDependentObjectTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreNonRelatedDependentObjectTest categoriesForClass!Unclassified! !
!SSWReStoreNonRelatedDependentObjectTest methodsFor!

_testComponentExistenceOnDependency

	"component is dependent at this level, so should no longer exist"

	self assert: (component _dbProxyIn: reStore ifNone: [nil]) isNil.

	reStore simulateReconnect.
	self assert: ((component class storedInstancesIn: reStore) detect: [ :each | each name = component name] ifNone: [nil]) isNil!

componentDefinition

	^GenericOwnedTest dependent unrelated!

testRefreshIfUpdatedRollbackRemovedComponentChange

	"This test is not relevant to dependent relationships"! !
!SSWReStoreNonRelatedDependentObjectTest categoriesFor: #_testComponentExistenceOnDependency!helpers!public! !
!SSWReStoreNonRelatedDependentObjectTest categoriesFor: #componentDefinition!accessing!public! !
!SSWReStoreNonRelatedDependentObjectTest categoriesFor: #testRefreshIfUpdatedRollbackRemovedComponentChange!public!testing! !


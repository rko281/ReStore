"Filed out from Dolphin Smalltalk 7"!

SSWReStoreNonRelatedOrderedCollectionTest subclass: #SSWReStoreNonRelatedDependentOrderedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreNonRelatedDependentOrderedCollectionTest guid: (GUID fromString: '{2356bf3c-79bc-4e0d-8817-bfc708f74317}')!
SSWReStoreNonRelatedDependentOrderedCollectionTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreNonRelatedDependentOrderedCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreNonRelatedDependentOrderedCollectionTest methodsFor!

_testComponentExistenceOnDependency: component

	"Private - collection is dependent at this level, so replaced/removed/cascade-deleted component should no longer exist"

	self assert: (component _dbProxyIn: reStore ifNone: [nil]) isNil.

	reStore simulateReconnect.
	self assert: ((component class storedInstancesIn: reStore) detect: [ :each | each name = component name] ifNone: [nil]) isNil!

componentDefinition

	^OrderedCollection of: GenericOwnedTest dependent unrelated! !
!SSWReStoreNonRelatedDependentOrderedCollectionTest categoriesFor: #_testComponentExistenceOnDependency:!helpers!private! !
!SSWReStoreNonRelatedDependentOrderedCollectionTest categoriesFor: #componentDefinition!accessing!public! !


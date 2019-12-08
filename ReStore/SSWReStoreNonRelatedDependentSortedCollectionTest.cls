"Filed out from Dolphin Smalltalk 7"!

SSWReStoreNonRelatedSortedCollectionTest subclass: #SSWReStoreNonRelatedDependentSortedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreNonRelatedDependentSortedCollectionTest guid: (GUID fromString: '{ac64ce12-0af1-486c-9749-4f532c69a6a5}')!
SSWReStoreNonRelatedDependentSortedCollectionTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreNonRelatedDependentSortedCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreNonRelatedDependentSortedCollectionTest methodsFor!

_testComponentExistenceOnDependency: component

	"collection is dependent at this level, so replaced/removed/cascade-deleted component should no longer exist"

	self assert: (component _dbProxyIn: reStore ifNone: [nil]) isNil.

	reStore simulateReconnect.
	self assert: ((reStore instancesOf: component class) detect: [ :each | each name = component name] ifNone: [nil]) isNil!

componentDefinition

	^SortedCollection of: GenericOwnedTest dependent unrelated! !
!SSWReStoreNonRelatedDependentSortedCollectionTest categoriesFor: #_testComponentExistenceOnDependency:!helpers!public! !
!SSWReStoreNonRelatedDependentSortedCollectionTest categoriesFor: #componentDefinition!accessing!public! !


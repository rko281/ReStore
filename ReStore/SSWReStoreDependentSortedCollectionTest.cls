"Filed out from Dolphin Smalltalk 7"!

SSWReStoreRelatedSortedCollectionTest subclass: #SSWReStoreDependentSortedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreDependentSortedCollectionTest guid: (GUID fromString: '{28ef6630-b024-4fba-83da-cc637381295c}')!
SSWReStoreDependentSortedCollectionTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreDependentSortedCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreDependentSortedCollectionTest methodsFor!

_testComponentExistenceOnDependency: component

	"collection is dependent at this level, so replaced/removed/cascade-deleted component should no longer exist"

	self assert: (component _dbProxyIn: reStore ifNone: [nil]) isNil.

	reStore simulateReconnect.
	self assert: ((reStore instancesOf: component class) detect: [ :each | each name = component name] ifNone: [nil]) isNil!

componentDefinition

	^SortedCollection of: GenericOwnedTest dependent ! !
!SSWReStoreDependentSortedCollectionTest categoriesFor: #_testComponentExistenceOnDependency:!helpers!public! !
!SSWReStoreDependentSortedCollectionTest categoriesFor: #componentDefinition!accessing!public! !


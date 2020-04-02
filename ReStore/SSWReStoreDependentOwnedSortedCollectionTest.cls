"Filed out from Dolphin Smalltalk 7"!

SSWReStoreRelatedOwnedSortedCollectionTest subclass: #SSWReStoreDependentOwnedSortedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreDependentOwnedSortedCollectionTest guid: (GUID fromString: '{3f608f4c-f605-489f-bb71-5de0f721018b}')!
SSWReStoreDependentOwnedSortedCollectionTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreDependentOwnedSortedCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreDependentOwnedSortedCollectionTest methodsFor!

_testComponentExistenceOnDependency: component

	"Private - collection is dependent at this level, so replaced/removed/cascade-deleted component should no longer exist"

	self assert: (component _dbProxyIn: reStore ifNone: [nil]) isNil.

	reStore simulateReconnect.
	self assert: ((component class storedInstancesIn: reStore) detect: [ :each | each name = component name] ifNone: [nil]) isNil!

componentDefinition

	^SortedCollection of: GenericOwnedTest dependent owner: #owner! !
!SSWReStoreDependentOwnedSortedCollectionTest categoriesFor: #_testComponentExistenceOnDependency:!helpers!private! !
!SSWReStoreDependentOwnedSortedCollectionTest categoriesFor: #componentDefinition!accessing!public! !


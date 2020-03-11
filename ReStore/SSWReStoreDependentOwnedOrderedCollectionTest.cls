"Filed out from Dolphin Smalltalk 7"!

SSWReStoreRelatedOwnedOrderedCollectionTest subclass: #SSWReStoreDependentOwnedOrderedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreDependentOwnedOrderedCollectionTest guid: (GUID fromString: '{f6420f7c-9f39-43ff-9354-856b358a936b}')!
SSWReStoreDependentOwnedOrderedCollectionTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreDependentOwnedOrderedCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreDependentOwnedOrderedCollectionTest methodsFor!

_testComponentExistenceOnDependency: component

	"collection is dependent at this level, so replaced/removed/cascade-deleted component should no longer exist"

	self assert: (component _dbProxyIn: reStore ifNone: [nil]) isNil.

	reStore simulateReconnect.
	self assert: ((component class storedInstancesIn: reStore) detect: [ :each | each name = component name] ifNone: [nil]) isNil!

componentDefinition

	^OrderedCollection of: GenericOwnedTest dependent owner: #owner! !
!SSWReStoreDependentOwnedOrderedCollectionTest categoriesFor: #_testComponentExistenceOnDependency:!helpers!public! !
!SSWReStoreDependentOwnedOrderedCollectionTest categoriesFor: #componentDefinition!accessing!public! !


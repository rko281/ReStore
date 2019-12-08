"Filed out from Dolphin Smalltalk 7"!

SSWReStoreNonRelatedOwnedOrderedCollectionTest subclass: #SSWReStoreNonRelatedDependentOwnedOrderedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreNonRelatedDependentOwnedOrderedCollectionTest guid: (GUID fromString: '{84d1a661-c35c-4eeb-a7f0-88a1208869a4}')!
SSWReStoreNonRelatedDependentOwnedOrderedCollectionTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreNonRelatedDependentOwnedOrderedCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreNonRelatedDependentOwnedOrderedCollectionTest methodsFor!

_testComponentExistenceOnDependency: component

	"collection is dependent at this level, so replaced/removed/cascade-deleted component should no longer exist"

	self assert: (component _dbProxyIn: reStore ifNone: [nil]) isNil.

	reStore simulateReconnect.
	self assert: ((reStore instancesOf: component class) detect: [ :each | each name = component name] ifNone: [nil]) isNil!

componentDefinition

	^OrderedCollection of: GenericOwnedTest dependent unrelated owner: #owner! !
!SSWReStoreNonRelatedDependentOwnedOrderedCollectionTest categoriesFor: #_testComponentExistenceOnDependency:!helpers!public! !
!SSWReStoreNonRelatedDependentOwnedOrderedCollectionTest categoriesFor: #componentDefinition!accessing!public! !


"Filed out from Dolphin Smalltalk"!

SSWReStoreRelatedOrderedCollectionTest subclass: #SSWReStoreDependentOrderedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreDependentOrderedCollectionTest guid: (GUID fromString: '{144fcf11-d363-4996-bdc0-7a0327df2a05}')!
SSWReStoreDependentOrderedCollectionTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreDependentOrderedCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreDependentOrderedCollectionTest methodsFor!

_testComponentExistenceOnDependency: component

	"Private - collection is dependent at this level, so replaced/removed/cascade-deleted component should no longer exist"

	self assert: (component _dbProxyIn: reStore ifNone: [nil]) isNil.

	reStore simulateReconnect.
	self assert: ((component class storedInstancesIn: reStore) detect: [ :each | each name = component name] ifNone: [nil]) isNil!

componentDefinition

	^OrderedCollection of: GenericOwnedTest dependent! !
!SSWReStoreDependentOrderedCollectionTest categoriesForMethods!
_testComponentExistenceOnDependency:!helpers!private! !
componentDefinition!accessing!public! !
!


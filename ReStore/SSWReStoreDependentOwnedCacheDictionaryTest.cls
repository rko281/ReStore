"Filed out from Dolphin Smalltalk 7"!

SSWReStoreRelatedOwnedCacheDictionaryTest subclass: #SSWReStoreDependentOwnedCacheDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreDependentOwnedCacheDictionaryTest guid: (GUID fromString: '{572b3ad1-cb63-47d0-9e7b-6b8e696a7bda}')!
SSWReStoreDependentOwnedCacheDictionaryTest comment: 'ReStore
©2020 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreDependentOwnedCacheDictionaryTest categoriesForClass!Unclassified! !
!SSWReStoreDependentOwnedCacheDictionaryTest methodsFor!

_testComponentExistenceOnDependency: component

	"Private - collection is dependent at this level, so replaced/removed/cascade-deleted component should no longer exist"

	self assert: (component _dbProxyIn: reStore ifNone: [nil]) isNil.

	reStore simulateReconnect.
	self assert: ((component class storedInstancesIn: reStore) detect: [ :each | each name = component name] ifNone: [nil]) isNil!

componentDefinition

	^(Dictionary of: #key -> GenericOwnedTest dependent)! !
!SSWReStoreDependentOwnedCacheDictionaryTest categoriesFor: #_testComponentExistenceOnDependency:!helpers!private! !
!SSWReStoreDependentOwnedCacheDictionaryTest categoriesFor: #componentDefinition!accessing!public! !


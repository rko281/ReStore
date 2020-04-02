"Filed out from Dolphin Smalltalk 7"!

SSWReStoreRelatedCacheDictionaryTest subclass: #SSWReStoreDependentCacheDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreDependentCacheDictionaryTest guid: (GUID fromString: '{86cced67-7cb1-4613-a4d0-cd6f55f3faff}')!
SSWReStoreDependentCacheDictionaryTest comment: 'ReStore
©2020 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreDependentCacheDictionaryTest categoriesForClass!Unclassified! !
!SSWReStoreDependentCacheDictionaryTest methodsFor!

_testComponentExistenceOnDependency: component

	"Private - collection is dependent at this level, so replaced/removed/cascade-deleted component should no longer exist"

	self assert: (component _dbProxyIn: reStore ifNone: [nil]) isNil.

	reStore simulateReconnect.
	self assert: ((component class storedInstancesIn: reStore) detect: [ :each | each name = component name] ifNone: [nil]) isNil!

componentDefinition

	^(Dictionary of: #key -> GenericOwnedTest dependent)! !
!SSWReStoreDependentCacheDictionaryTest categoriesFor: #_testComponentExistenceOnDependency:!helpers!private! !
!SSWReStoreDependentCacheDictionaryTest categoriesFor: #componentDefinition!accessing!public! !


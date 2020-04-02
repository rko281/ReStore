"Filed out from Dolphin Smalltalk 7"!

SSWReStoreRelatedDictionaryTest subclass: #SSWReStoreDependentDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreDependentDictionaryTest guid: (GUID fromString: '{f84b6aea-a510-4b2f-a57d-81cc82f6bfd2}')!
SSWReStoreDependentDictionaryTest comment: 'ReStore
©2020 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreDependentDictionaryTest categoriesForClass!Unclassified! !
!SSWReStoreDependentDictionaryTest methodsFor!

_testComponentExistenceOnDependency: component

	"Private - collection is dependent at this level, so replaced/removed/cascade-deleted component should no longer exist"

	self assert: (component _dbProxyIn: reStore ifNone: [nil]) isNil.

	reStore simulateReconnect.
	self assert: ((component class storedInstancesIn: reStore) detect: [ :each | each name = component name] ifNone: [nil]) isNil!

componentDefinition

	^(Dictionary of: GenericOwnedTest -> GenericOwnedTest dependent)! !
!SSWReStoreDependentDictionaryTest categoriesFor: #_testComponentExistenceOnDependency:!helpers!private! !
!SSWReStoreDependentDictionaryTest categoriesFor: #componentDefinition!accessing!public! !


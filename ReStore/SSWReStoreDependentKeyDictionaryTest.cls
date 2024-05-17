"Filed out from Dolphin Smallalk"!

SSWReStoreRelatedKeyDictionaryTest subclass: #SSWReStoreDependentKeyDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreDependentKeyDictionaryTest guid: (GUID fromString: '{a9820124-fa30-4dd9-a961-3e2c4ef2a22a}')!
SSWReStoreDependentKeyDictionaryTest comment: 'ReStore
©2020 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreDependentKeyDictionaryTest categoriesForClass!Unclassified! !
!SSWReStoreDependentKeyDictionaryTest methodsFor!

_testComponentExistenceOnDependency: value

	"Private - collection is dependent at this level, so replaced/removed/cascade-deleted component should no longer exist"

	| component |

	"value is the removed key"
	component := value.

	self assert: (component _dbProxyIn: reStore ifNone: [nil]) isNil.

	reStore simulateReconnect.
	self assert: ((component class storedInstancesIn: reStore) detect: [ :each | each name = component name] ifNone: [nil]) isNil!

componentDefinition

	^(Dictionary of: GenericOwnedTest dependent -> GenericOwnedTest)! !
!SSWReStoreDependentKeyDictionaryTest categoriesForMethods!
_testComponentExistenceOnDependency:!helpers!private! !
componentDefinition!accessing!public! !
!


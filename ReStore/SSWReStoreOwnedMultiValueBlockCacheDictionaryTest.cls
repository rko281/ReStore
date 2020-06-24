"Filed out from Dolphin Smalltalk 7"!

SSWReStoreOwnedMultiValueCacheDictionaryTest subclass: #SSWReStoreOwnedMultiValueBlockCacheDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreOwnedMultiValueBlockCacheDictionaryTest guid: (GUID fromString: '{52f813fc-37c1-49c0-b39b-352543bdf672}')!
SSWReStoreOwnedMultiValueBlockCacheDictionaryTest comment: 'ReStore
©2020 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreOwnedMultiValueBlockCacheDictionaryTest categoriesForClass!Unclassified! !
!SSWReStoreOwnedMultiValueBlockCacheDictionaryTest methodsFor!

componentDefinition

	^Dictionary of: [ :each | each name first asLowercase asString] -> (OrderedCollection of: GenericOwnedTest dependent) owner: #owner! !
!SSWReStoreOwnedMultiValueBlockCacheDictionaryTest categoriesFor: #componentDefinition!public! !


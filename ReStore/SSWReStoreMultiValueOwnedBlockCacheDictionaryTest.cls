"Filed out from Dolphin Smalltalk 7"!

SSWReStoreMultiValueOwnedCacheDictionaryTest subclass: #SSWReStoreMultiValueOwnedBlockCacheDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreMultiValueOwnedBlockCacheDictionaryTest guid: (GUID fromString: '{52f813fc-37c1-49c0-b39b-352543bdf672}')!
SSWReStoreMultiValueOwnedBlockCacheDictionaryTest comment: ''!
!SSWReStoreMultiValueOwnedBlockCacheDictionaryTest categoriesForClass!Unclassified! !
!SSWReStoreMultiValueOwnedBlockCacheDictionaryTest methodsFor!

componentDefinition

	^Dictionary of: [ :each | String with: each name first asLowercase] -> (OrderedCollection of: GenericOwnedTest) owner: #owner! !
!SSWReStoreMultiValueOwnedBlockCacheDictionaryTest categoriesFor: #componentDefinition!public! !


"Filed out from Dolphin Smalltalk 7"!

SSWReStoreMultiValueCacheDictionaryTest subclass: #SSWReStoreMultiValueBlockCacheDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreMultiValueBlockCacheDictionaryTest guid: (GUID fromString: '{22363349-c05a-4cc9-a065-7d0abdf0cd7e}')!
SSWReStoreMultiValueBlockCacheDictionaryTest comment: 'ReStore
©2020 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreMultiValueBlockCacheDictionaryTest categoriesForClass!Unclassified! !
!SSWReStoreMultiValueBlockCacheDictionaryTest methodsFor!

componentDefinition

	^Dictionary of: [ :each | String with: each name first asLowercase] -> (OrderedCollection of: GenericOwnedTest dependent)! !
!SSWReStoreMultiValueBlockCacheDictionaryTest categoriesFor: #componentDefinition!public! !


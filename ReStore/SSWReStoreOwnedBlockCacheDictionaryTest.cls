"Filed out from Dolphin Smalltalk 7"!

SSWReStoreOwnedCacheDictionaryTest subclass: #SSWReStoreOwnedBlockCacheDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreOwnedBlockCacheDictionaryTest guid: (GUID fromString: '{63a130b9-ed6d-481b-90ec-192407f4536c}')!
SSWReStoreOwnedBlockCacheDictionaryTest comment: 'ReStore
©2020 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreOwnedBlockCacheDictionaryTest categoriesForClass!Unclassified! !
!SSWReStoreOwnedBlockCacheDictionaryTest methodsFor!

componentDefinition

	^Dictionary of: [ :each | each name first asLowercase asString] -> GenericOwnedTest dependent owner: #owner! !
!SSWReStoreOwnedBlockCacheDictionaryTest categoriesFor: #componentDefinition!public! !


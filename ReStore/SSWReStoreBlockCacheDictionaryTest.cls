"Filed out from Dolphin Smalltalk 7"!

SSWReStoreCacheDictionaryTest subclass: #SSWReStoreBlockCacheDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreBlockCacheDictionaryTest guid: (GUID fromString: '{175ce35c-f0bd-49d7-96cb-65004c612b2c}')!
SSWReStoreBlockCacheDictionaryTest comment: 'ReStore
©2020 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreBlockCacheDictionaryTest categoriesForClass!Unclassified! !
!SSWReStoreBlockCacheDictionaryTest methodsFor!

componentDefinition

	^Dictionary of: [ :each | String with: each name first asLowercase] -> GenericOwnedTest dependent! !
!SSWReStoreBlockCacheDictionaryTest categoriesFor: #componentDefinition!public! !


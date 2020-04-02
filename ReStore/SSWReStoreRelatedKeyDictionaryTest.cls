"Filed out from Dolphin Smalltalk 7"!

SSWReStoreRelatedDictionaryTest subclass: #SSWReStoreRelatedKeyDictionaryTest
	instanceVariableNames: 'inverseDictionary'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreRelatedKeyDictionaryTest guid: (GUID fromString: '{ab1e4d3d-f5f2-4712-a399-996dd4d19986}')!
SSWReStoreRelatedKeyDictionaryTest comment: 'ReStore
©2020 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreRelatedKeyDictionaryTest categoriesForClass!Unclassified! !
!SSWReStoreRelatedKeyDictionaryTest methodsFor!

componentDefinition

	^(Dictionary of: GenericOwnedTest related -> GenericOwnedTest)!

fetchTestObjects

	super fetchTestObjects.

	inverseDictionary := IdentityDictionary new.

	testObject component keysAndValuesDo: [ :eachKey :eachValue | inverseDictionary at: eachValue put: eachKey]! !
!SSWReStoreRelatedKeyDictionaryTest categoriesFor: #componentDefinition!accessing!public! !
!SSWReStoreRelatedKeyDictionaryTest categoriesFor: #fetchTestObjects!public! !


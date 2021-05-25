"Filed out from Dolphin Smalltalk 7"!

SSWReStoreNonRelatedDictionaryTest subclass: #SSWReStoreNonRelatedCacheDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreNonRelatedCacheDictionaryTest guid: (GUID fromString: '{9c036e6c-b53a-41e5-94ea-20e483966443}')!
SSWReStoreNonRelatedCacheDictionaryTest comment: 'ReStore
©2020 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreNonRelatedCacheDictionaryTest categoriesForClass!Unclassified! !
!SSWReStoreNonRelatedCacheDictionaryTest methodsFor!

addToCollection: aCollection

	| component |

	component := self templateComponent.

	^aCollection at: component key put: component!

componentDefinition

	^(Dictionary of: #key -> GenericOwnedTest)!

remove: anObject fromCollection: aCollection

	^aCollection removeKey: anObject key!

replaceInCollection: aCollection

	| key old |

	key := aCollection keys anyOne.
	old := aCollection at: key.
	^old -> (aCollection at: key put: (self templateComponent key: key; yourself))!

templateCollection

	| templateCollection |

	templateCollection := Dictionary new.

	5 timesRepeat: 
		[| component |
		component := self templateComponent.
		templateCollection at: component key put: component].

	^templateCollection!

templateComponent

	| component |

	component := super templateComponent.

	component key: component name.

	^component! !
!SSWReStoreNonRelatedCacheDictionaryTest categoriesFor: #addToCollection:!helpers!private! !
!SSWReStoreNonRelatedCacheDictionaryTest categoriesFor: #componentDefinition!accessing!public! !
!SSWReStoreNonRelatedCacheDictionaryTest categoriesFor: #remove:fromCollection:!helpers!private! !
!SSWReStoreNonRelatedCacheDictionaryTest categoriesFor: #replaceInCollection:!public! !
!SSWReStoreNonRelatedCacheDictionaryTest categoriesFor: #templateCollection!accessing!public! !
!SSWReStoreNonRelatedCacheDictionaryTest categoriesFor: #templateComponent!public! !

!SSWReStoreNonRelatedCacheDictionaryTest class methodsFor!

allTestSelectors

	^super allTestSelectors 
		removeAll: self multipleOccurrenceTestSelectors;
		yourself! !
!SSWReStoreNonRelatedCacheDictionaryTest class categoriesFor: #allTestSelectors!accessing!public! !


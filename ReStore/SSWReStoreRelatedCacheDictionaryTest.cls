"Filed out from Dolphin Smalltalk 7"!

SSWReStoreRelatedDictionaryTest subclass: #SSWReStoreRelatedCacheDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreRelatedCacheDictionaryTest guid: (GUID fromString: '{6c47c3d4-dc40-4ee2-9d21-5770f1bbaf69}')!
SSWReStoreRelatedCacheDictionaryTest comment: 'ReStore
©2020 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreRelatedCacheDictionaryTest categoriesForClass!Unclassified! !
!SSWReStoreRelatedCacheDictionaryTest methodsFor!

addToCollection: aCollection

	| component |

	component := self templateComponent.

	^aCollection at: component key put: component!

componentDefinition

	^(Dictionary of: #key -> GenericOwnedTest related)!

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
!SSWReStoreRelatedCacheDictionaryTest categoriesFor: #addToCollection:!helpers!private! !
!SSWReStoreRelatedCacheDictionaryTest categoriesFor: #componentDefinition!accessing!public! !
!SSWReStoreRelatedCacheDictionaryTest categoriesFor: #remove:fromCollection:!helpers!private! !
!SSWReStoreRelatedCacheDictionaryTest categoriesFor: #replaceInCollection:!public! !
!SSWReStoreRelatedCacheDictionaryTest categoriesFor: #templateCollection!accessing!public! !
!SSWReStoreRelatedCacheDictionaryTest categoriesFor: #templateComponent!public! !

!SSWReStoreRelatedCacheDictionaryTest class methodsFor!

allTestSelectors

	^super allTestSelectors 
		removeAll: self multipleOccurrenceTestSelectors;
		yourself! !
!SSWReStoreRelatedCacheDictionaryTest class categoriesFor: #allTestSelectors!accessing!public! !


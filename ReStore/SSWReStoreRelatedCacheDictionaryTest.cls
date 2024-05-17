"Filed out from Dolphin Smallalk"!

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

addToCollectionAnsweringAssociation: aCollection

	| component |

	component := self templateComponent.

	aCollection at: component key put: component.

	^component key -> component!

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
!SSWReStoreRelatedCacheDictionaryTest categoriesForMethods!
addToCollectionAnsweringAssociation:!helpers!private! !
componentDefinition!accessing!public! !
remove:fromCollection:!helpers!private! !
replaceInCollection:!public! !
templateCollection!accessing!public! !
templateComponent!public! !
!

!SSWReStoreRelatedCacheDictionaryTest class methodsFor!

allTestSelectors

	^super allTestSelectors 
		removeAll: self multipleOccurrenceTestSelectors;
		yourself! !
!SSWReStoreRelatedCacheDictionaryTest class categoriesForMethods!
allTestSelectors!accessing!public! !
!


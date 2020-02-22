"Filed out from Dolphin Smalltalk 7"!

SSWReStoreCollectionSubQueryTest subclass: #SSWReStoreGeneralCollectionSubQueryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreGeneralCollectionSubQueryTest guid: (GUID fromString: '{146bf3b1-bb13-433c-abd5-e210ba709554}')!
SSWReStoreGeneralCollectionSubQueryTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreGeneralCollectionSubQueryTest categoriesForClass!Unclassified! !
!SSWReStoreGeneralCollectionSubQueryTest methodsFor!

ordersCollectionDefinition

	"Non-owned collection"

	^(OrderedCollection of: SimpleProductOrder related dependent)! !
!SSWReStoreGeneralCollectionSubQueryTest categoriesFor: #ordersCollectionDefinition!constants!public! !

!SSWReStoreGeneralCollectionSubQueryTest class methodsFor!

testSelectors

	^self myTestSelectors! !
!SSWReStoreGeneralCollectionSubQueryTest class categoriesFor: #testSelectors!public! !


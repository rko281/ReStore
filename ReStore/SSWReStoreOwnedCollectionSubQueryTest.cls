"Filed out from Dolphin Smalltalk 7"!

SSWReStoreCollectionSubQueryTest subclass: #SSWReStoreOwnedCollectionSubQueryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreOwnedCollectionSubQueryTest guid: (GUID fromString: '{fa590368-8e45-40be-9351-df5866ea3f3b}')!
SSWReStoreOwnedCollectionSubQueryTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreOwnedCollectionSubQueryTest categoriesForClass!Unclassified! !
!SSWReStoreOwnedCollectionSubQueryTest methodsFor!

ordersCollectionDefinition

	"Owned collection"

	^(OrderedCollection of: SimpleProductOrder related owner: #customer)! !
!SSWReStoreOwnedCollectionSubQueryTest categoriesFor: #ordersCollectionDefinition!constants!public! !

!SSWReStoreOwnedCollectionSubQueryTest class methodsFor!

testSelectors

	^self myTestSelectors! !
!SSWReStoreOwnedCollectionSubQueryTest class categoriesFor: #testSelectors!public! !


"Filed out from Dolphin Smalltalk 7"!

SSWReStoreReadWithComponentsTest subclass: #SSWReStoreOwnedCollectionReadWithComponentsTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreOwnedCollectionReadWithComponentsTest guid: (GUID fromString: '{2383d6b4-9898-47da-988b-dc5246857626}')!
SSWReStoreOwnedCollectionReadWithComponentsTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreOwnedCollectionReadWithComponentsTest categoriesForClass!Unclassified! !
!SSWReStoreOwnedCollectionReadWithComponentsTest methodsFor!

ordersCollectionDefinition

	"Owned collection"

	^(OrderedCollection of: SimpleProductOrder related owner: #customer)! !
!SSWReStoreOwnedCollectionReadWithComponentsTest categoriesFor: #ordersCollectionDefinition!constants!public! !

!SSWReStoreOwnedCollectionReadWithComponentsTest class methodsFor!

testSelectors

	^self myTestSelectors! !
!SSWReStoreOwnedCollectionReadWithComponentsTest class categoriesFor: #testSelectors!public! !


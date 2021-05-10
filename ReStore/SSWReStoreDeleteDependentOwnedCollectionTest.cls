"Filed out from Dolphin Smalltalk 7"!

SSWReStoreDeleteDependentCollectionTest subclass: #SSWReStoreDeleteDependentOwnedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreDeleteDependentOwnedCollectionTest guid: (GUID fromString: '{18fb7c39-9ef9-4902-a817-475cd4a7a655}')!
SSWReStoreDeleteDependentOwnedCollectionTest comment: ''!
!SSWReStoreDeleteDependentOwnedCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreDeleteDependentOwnedCollectionTest methodsFor!

deleteQueriesCount

	^1!

ordersCollectionDefinition

	"Owned collection"

	^(OrderedCollection of: SimpleProductOrder dependent owner: #customer)! !
!SSWReStoreDeleteDependentOwnedCollectionTest categoriesFor: #deleteQueriesCount!constants!public! !
!SSWReStoreDeleteDependentOwnedCollectionTest categoriesFor: #ordersCollectionDefinition!constants!public! !

!SSWReStoreDeleteDependentOwnedCollectionTest class methodsFor!

testSelectors

	^self myTestSelectors! !
!SSWReStoreDeleteDependentOwnedCollectionTest class categoriesFor: #testSelectors!public! !


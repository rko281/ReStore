"Filed out from Dolphin Smalltalk 7"!

SSWReStoreReadWithComponentsTest subclass: #SSWReStoreGeneralCollectionReadWithComponentsTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreGeneralCollectionReadWithComponentsTest guid: (GUID fromString: '{51677cfe-147e-4207-b336-aa58d72aca6b}')!
SSWReStoreGeneralCollectionReadWithComponentsTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreGeneralCollectionReadWithComponentsTest categoriesForClass!Unclassified! !
!SSWReStoreGeneralCollectionReadWithComponentsTest methodsFor!

ordersCollectionDefinition

	"General (non-owned) collection"

	^(OrderedCollection of: SimpleProductOrder related)! !
!SSWReStoreGeneralCollectionReadWithComponentsTest categoriesFor: #ordersCollectionDefinition!constants!public! !

!SSWReStoreGeneralCollectionReadWithComponentsTest class methodsFor!

testSelectors

	^self myTestSelectors! !
!SSWReStoreGeneralCollectionReadWithComponentsTest class categoriesFor: #testSelectors!public! !


"Filed out from Dolphin Smalltalk 7"!

SSWReStoreGenericNonRelatedCollectionTest subclass: #SSWReStoreNonRelatedOwnedOrderedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreNonRelatedOwnedOrderedCollectionTest guid: (GUID fromString: '{d9eba199-fc05-45a5-8311-dfb96804590e}')!
SSWReStoreNonRelatedOwnedOrderedCollectionTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreNonRelatedOwnedOrderedCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreNonRelatedOwnedOrderedCollectionTest methodsFor!

_testCollectionElementTransferOf: element from: collection1 to: collection2 ownerBy: template2

	collection1 remove: element.
	collection2 add: element.

	"Normally we can rely on the commit mechanics to set the owner link, however when transferring an element we MUST explicitly set the new owner link.
	This allows the previous owner to detect the new ownership and thus not nil out the link during commit"
	element owner: template2.

	{collection1. collection2} storeAll.

	element refresh.
	self assert: element owner equals: template2!

componentDefinition

	^OrderedCollection of: GenericOwnedTest owner: #owner!

replaceInCollection: aCollection

	^(aCollection at: aCollection size) -> (aCollection at: aCollection size put: self templateComponent)!

templateCollection

	^OrderedCollection 
		with: self templateComponent
		with: self templateComponent
		with: self templateComponent!

testCollectionDeletionWithElementTransfer

	"Verify that an element transferred between owner collections retains its new owner link after commit/refresh, even when the original collection is deleted"

	| collection1 element template2 collection2 |

	collection1 := collection.
	element := collection1 anyOne. 

	template2 := self templateTestObject storeIn: reStore; yourself.
	collection2 := template2 component.

	collection1 remove: element.
	collection2 add: element.

	{testObject unstored. collection2} storeAll.

	element refresh.
	self assert: element owner equals: template2!

testCollectionElementTransfer

	"Verify that an element transferred between owner collections retains its new owner link after commit/refresh.
	Previously, depending on the ordering within the transaction (variable, so happened around 50% of the time) the removal could nil out the link after the new link has been established.
	This would leave the element owner-less after commit"

	| collection1 element template2 collection2 |

	collection1 := collection.
	element := collection1 anyOne. 

	template2 := self templateTestObject storeIn: reStore; yourself.
	collection2 := template2 component.

	"Since the error only happened around 50% of the time we run the transfer and test multiple times"
	4 timesRepeat: 
		[self 
			_testCollectionElementTransferOf: element from: collection1 to: collection2 ownerBy: template2;
			_testCollectionElementTransferOf: element from: collection2 to: collection1 ownerBy: testObject]! !
!SSWReStoreNonRelatedOwnedOrderedCollectionTest categoriesFor: #_testCollectionElementTransferOf:from:to:ownerBy:!public! !
!SSWReStoreNonRelatedOwnedOrderedCollectionTest categoriesFor: #componentDefinition!accessing!public! !
!SSWReStoreNonRelatedOwnedOrderedCollectionTest categoriesFor: #replaceInCollection:!public! !
!SSWReStoreNonRelatedOwnedOrderedCollectionTest categoriesFor: #templateCollection!accessing!public! !
!SSWReStoreNonRelatedOwnedOrderedCollectionTest categoriesFor: #testCollectionDeletionWithElementTransfer!public!unit tests! !
!SSWReStoreNonRelatedOwnedOrderedCollectionTest categoriesFor: #testCollectionElementTransfer!public!unit tests! !

!SSWReStoreNonRelatedOwnedOrderedCollectionTest class methodsFor!

allTestSelectors

	^super allTestSelectors 
		removeAll: self multipleOccurrenceTestSelectors;
		yourself! !
!SSWReStoreNonRelatedOwnedOrderedCollectionTest class categoriesFor: #allTestSelectors!accessing!public! !


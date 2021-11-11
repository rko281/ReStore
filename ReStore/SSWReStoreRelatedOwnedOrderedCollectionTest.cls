"Filed out from Dolphin Smallalk"!

SSWReStoreGenericRelatedCollectionTest subclass: #SSWReStoreRelatedOwnedOrderedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreRelatedOwnedOrderedCollectionTest guid: (GUID fromString: '{a700c641-c5c7-405c-9f59-32592d5c16b8}')!
SSWReStoreRelatedOwnedOrderedCollectionTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreRelatedOwnedOrderedCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreRelatedOwnedOrderedCollectionTest methodsFor!

_testCollectionElementTransferOf: element from: collection1 ownedBy: owner1 to: collection2 ownedBy: owner2

	collection1 remove: element.
	collection2 add: element.

	"To help with any debugging"
	owner1 name: 'one'.
	owner2 name: 'two'.

	{owner1. owner2} storeAll.

	element refresh.
	self assert: element owner equals: owner2!

componentDefinition

	^OrderedCollection of: GenericOwnedTest related owner: #owner!

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

	{testObject unstored. template2} storeAll.

	element refresh.
	self assert: element owner equals: template2!

testCollectionElementRemovalWithDirectCollectionStore

	"Verify that an element removed from the collection is stored correctly when the collection (rather than its owner) is stored.
	Tests a previously-erroring case where elements removed from a depenent owned collection were not unstored if the collection owner was not in the transaction"

	| size element id cls |

	size := collection size.
	element := collection anyOne. 
	id := element _id.
	cls := element class.

	collection remove: element.
	collection store.

	reStore simulateReconnect.
	self fetchTestObjects.

	self assert: collection size equals: size - 1.
	((cls storedInstancesIn: reStore) detect: [ :each | each _id = id] ifNone: [nil]) ifNotNil: [ :elem | self deny: (collection includes: elem)].

	self _testComponentExistenceOnDependency: element!

testCollectionElementRemovalWithNilBackpointer

	"Verify that an element removed from the collection is stored correctly even if the backpointer is manually nil'd out"

	| size element id cls |

	size := collection size.
	element := collection anyOne. 
	id := element _id.
	cls := element class.

	collection remove: element.
	element owner: nil.
	testObject store.

	reStore simulateReconnect.
	self fetchTestObjects.

	self assert: collection size equals: size - 1.
	((cls storedInstancesIn: reStore) detect: [ :each | each _id = id] ifNone: [nil]) ifNotNil: [ :elem | self deny: (collection includes: elem)].

	self _testComponentExistenceOnDependency: element!

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
			_testCollectionElementTransferOf: element from: collection1 ownedBy: testObject to: collection2 ownedBy: template2;
			_testCollectionElementTransferOf: element from: collection2 ownedBy: template2 to: collection1 ownedBy: testObject]! !
!SSWReStoreRelatedOwnedOrderedCollectionTest categoriesForMethods!
_testCollectionElementTransferOf:from:ownedBy:to:ownedBy:!helpers!public! !
componentDefinition!accessing!public! !
replaceInCollection:!helpers!public! !
templateCollection!accessing!public! !
testCollectionDeletionWithElementTransfer!public!unit tests! !
testCollectionElementRemovalWithDirectCollectionStore!public!unit tests! !
testCollectionElementRemovalWithNilBackpointer!public!unit tests! !
testCollectionElementTransfer!public!unit tests! !
!

!SSWReStoreRelatedOwnedOrderedCollectionTest class methodsFor!

allTestSelectors

	^super allTestSelectors 
		removeAll: self multipleOccurrenceTestSelectors;
		yourself! !
!SSWReStoreRelatedOwnedOrderedCollectionTest class categoriesForMethods!
allTestSelectors!accessing!public! !
!


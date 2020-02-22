"Filed out from Dolphin Smalltalk 7"!

SSWReStoreGenericRelatedCollectionTest subclass: #SSWReStoreRelatedOrderedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreRelatedOrderedCollectionTest guid: (GUID fromString: '{df471847-dc59-4290-b5eb-6cf1a705a245}')!
SSWReStoreRelatedOrderedCollectionTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreRelatedOrderedCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreRelatedOrderedCollectionTest methodsFor!

componentDefinition

	^OrderedCollection of: GenericOwnedTest related!

replaceInCollection: aCollection

	^(aCollection at: aCollection size) -> (aCollection at: aCollection size put: self templateComponent)!

templateCollection

	^OrderedCollection 
		with: self templateComponent
		with: self templateComponent
		with: self templateComponent!

testCheckHasChangedComponentSwap

	"Only relevant to non-owned"

	| first |

	first := collection first.
	collection 
		at: 1 put: collection last;
		at: collection size put: first.

	"Change of ordering does not mark the owner as changed"
	self assert: (collection _checkHasChangedIn: reStore).
	self deny: (testObject _checkHasChangedIn: reStore).

	"...but does withRelatedComponents"
	self assert: (testObject withRelatedComponents _checkHasChangedIn: reStore)!

testCommitComponentSwap

	"Only relevant to non-owned"

	| first last |

	first := collection first.
	last := collection last.
	collection 
		at: 1 put: last;
		at: collection size put: first.
	reStore commit: testObject.
	self fetchTestObjects.
	self assert: (collection first name = first name).
	self assert: (collection last name = last name).

	first := collection first.
	last := collection last.
	collection 
		at: 1 put: last;
		at: collection size put: first.
	reStore commit: testObject withRelatedComponents.
	self fetchTestObjects.
	self assert: (collection first name = last name).
	self assert: (collection last name = first name).
!

testRollbackComponentSwap

	"Only relevant to non-owned"

	| first last |

	first := collection first.
	last := collection last.
	collection 
		at: 1 put: last;
		at: collection size put: first.

	reStore rollback: testObject.
	self assert: (collection last == first).
	self assert: (collection first == last).

	reStore rollback: testObject withRelatedComponents.
	self assert: (collection first == first).
	self assert: (collection last == last)! !
!SSWReStoreRelatedOrderedCollectionTest categoriesFor: #componentDefinition!accessing!public! !
!SSWReStoreRelatedOrderedCollectionTest categoriesFor: #replaceInCollection:!public! !
!SSWReStoreRelatedOrderedCollectionTest categoriesFor: #templateCollection!accessing!public! !
!SSWReStoreRelatedOrderedCollectionTest categoriesFor: #testCheckHasChangedComponentSwap!public!unit tests! !
!SSWReStoreRelatedOrderedCollectionTest categoriesFor: #testCommitComponentSwap!public!unit tests! !
!SSWReStoreRelatedOrderedCollectionTest categoriesFor: #testRollbackComponentSwap!public!unit tests! !


"Filed out from Dolphin Smalltalk 7"!

SSWReStoreGenericNonRelatedCollectionTest subclass: #SSWReStoreNonRelatedOrderedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreNonRelatedOrderedCollectionTest guid: (GUID fromString: '{3d19aa1a-c2b1-40bb-b305-806713c4fcb7}')!
SSWReStoreNonRelatedOrderedCollectionTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreNonRelatedOrderedCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreNonRelatedOrderedCollectionTest methodsFor!

componentDefinition

	^OrderedCollection of: GenericOwnedTest!

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

	"...but does withRelatedComponents, even when the collection elements are not related"
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

	"Change is applied withRelatedComponents, even when the collection elements are not related"
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

	"Rollback applies withRelatedComponents, even when the collection elements are not related"
	reStore rollback: testObject withRelatedComponents.
	self assert: (collection first == first).
	self assert: (collection last == last).! !
!SSWReStoreNonRelatedOrderedCollectionTest categoriesFor: #componentDefinition!accessing!public! !
!SSWReStoreNonRelatedOrderedCollectionTest categoriesFor: #replaceInCollection:!public! !
!SSWReStoreNonRelatedOrderedCollectionTest categoriesFor: #templateCollection!accessing!public! !
!SSWReStoreNonRelatedOrderedCollectionTest categoriesFor: #testCheckHasChangedComponentSwap!public!unit tests! !
!SSWReStoreNonRelatedOrderedCollectionTest categoriesFor: #testCommitComponentSwap!public!unit tests! !
!SSWReStoreNonRelatedOrderedCollectionTest categoriesFor: #testRollbackComponentSwap!public!unit tests! !


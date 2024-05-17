"Filed out from Dolphin Smalltalk"!

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

duplicateInCollection: aCollection

	^aCollection at: 1 put: aCollection last!

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

testDuplicateEntries

	"Ensure duplicate entries are handled correctly"

	self duplicateInCollection.

	"This should just involve an update of the value of the entry to which the duplicate has been assigned.
	Previously this would update the duplicated entry's key, add a new entry for the original and delete the original entry"
	self assert: (self countQueriesDuring: [testObject store]) equals: (1 "for the update" + (self componentDefinition isValueDependent ifTrue: [1] ifFalse: [0]) "1 for the deletion of the overwritten item (if dependent)")!

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
!SSWReStoreNonRelatedOrderedCollectionTest categoriesForMethods!
componentDefinition!accessing!public! !
duplicateInCollection:!private! !
replaceInCollection:!public! !
templateCollection!accessing!public! !
testCheckHasChangedComponentSwap!public!unit tests! !
testCommitComponentSwap!public!unit tests! !
testDuplicateEntries!public!unit tests! !
testRollbackComponentSwap!public!unit tests! !
!


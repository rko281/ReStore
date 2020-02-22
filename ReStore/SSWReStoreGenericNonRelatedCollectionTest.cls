"Filed out from Dolphin Smalltalk 7"!

SSWReStoreGenericCollectionTest subclass: #SSWReStoreGenericNonRelatedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreGenericNonRelatedCollectionTest guid: (GUID fromString: '{a8f4b883-7485-4521-9918-df599bfa5330}')!
SSWReStoreGenericNonRelatedCollectionTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreGenericNonRelatedCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreGenericNonRelatedCollectionTest methodsFor!

testCheckHasChangedComponentAddition

	self addToCollection.

	"Addition to a collection does not mark the owner as changed"
	self assert: (collection _checkHasChangedIn: reStore).
	self deny: (testObject _checkHasChangedIn: reStore).

	"...but does withRelatedComponents, even when the collection elements are not related"
	self assert: (testObject withRelatedComponents _checkHasChangedIn: reStore)!

testCheckHasChangedComponentChange

	| component originalName changedName |

	component := collection anyOne.
	originalName := component name.
	changedName := originalName, '_changed'.
	component name: changedName.

	"A change to a collection's component does not mark the owner or collection as changed"
	self assert: (component _checkHasChangedIn: reStore).
	self deny: (collection _checkHasChangedIn: reStore).
	self deny: (testObject _checkHasChangedIn: reStore).

	"...even withRelatedComponents"
	self deny: (testObject withRelatedComponents _checkHasChangedIn: reStore)!

testCheckHasChangedComponentRemoval

	self removeFromCollection.

	"Removal from a collection does not mark the owner as changed"
	self assert: (collection _checkHasChangedIn: reStore).
	self deny: (testObject _checkHasChangedIn: reStore).

	"...but does withRelatedComponents, even when the collection elements are not related"
	self assert: (testObject withRelatedComponents _checkHasChangedIn: reStore)!

testCheckHasChangedComponentReplace

	self replaceInCollection.

	"Replacing an element of a collection does not mark the owner as changed"
	self assert: (collection _checkHasChangedIn: reStore).
	self deny: (testObject _checkHasChangedIn: reStore).

	"...but does withRelatedComponents, even when the collection elements are not related"
	self assert: (testObject withRelatedComponents _checkHasChangedIn: reStore)!

testCollectionRefreshComponentChange

	| component originalName changedName |

	component := collection anyOne.
	originalName := component name.
	changedName := originalName, '_changed'.

	self setUpReStore2.
	reStore2 evaluateAsTransaction: [((reStore2 instancesOf: component class) detect: [ :each | each name = originalName]) name: changedName].
	self refreshDelay.

	reStore refresh: collection.
	self assert: (component name = originalName).

	reStore refresh: collection withComponents.
	self assert: (component name = changedName)!

testCollectionRefreshComponentChangeIfUpdated

	| component originalName changedName |

	component := collection anyOne.
	originalName := component name.
	changedName := originalName, '_changed'.

	self setUpReStore2.
	reStore2 evaluateAsTransaction: [((reStore2 instancesOf: component class) detect: [ :each | each name = originalName]) name: changedName].
	self refreshDelay.

	reStore refreshIfUpdated: collection.
	self assert: (component name = originalName).

	reStore refreshIfUpdated: collection withComponents.
	self assert: (component name = changedName)!

testCommitComponentAddition

	| original added |

	"Commit of just the owner does not commit the addition to the collection"
	original := collection copy.
	added := self addToCollection.
	reStore commit: testObject.
	self fetchTestObjects.
	self deny: (collection includes: added).
	self assert: (collection = original).

	"...but does withRelatedComponents, even when the collection elements are not related"
	original := collection copy.
	added := self addToCollection.
	reStore commit: testObject withRelatedComponents.
	self fetchTestObjects.
	self assert: (collection includes: added).
	self deny: (collection = original).
!

testCommitComponentChange

	| component originalName changedName |

	"Commit of just the owner does not commit the change to the component of the collection"
	component := collection anyOne.
	originalName := component name.
	changedName := originalName, '_changed'.
	component name: changedName.
	reStore commit: testObject.
	self fetchTestObjects.
	component := collection detect: [ :each | each name = originalName].
	self assert: (component name = originalName).

	"...even withRelatedComponents"
	component name: changedName.
	reStore commit: testObject withRelatedComponents.
	self fetchTestObjects.
	component := collection detect: [ :each | each name = originalName].
	self assert: (component name = originalName).!

testCommitComponentRemoval

	| removed |

	"Commit of just the owner does not commit the removal from the collection"
	removed := self removeFromCollection.
	reStore commit: testObject.
	self fetchTestObjects.
	self assert: (collection includes: removed).

	"...but does withRelatedComponents, even when the collection elements are not related"
	removed := self removeFromCollection.
	reStore commit: testObject withRelatedComponents.
	self fetchTestObjects.
	self deny: (collection includes: removed).
!

testCommitComponentReplace

	| originalAndReplacement |

	"Commit of just the owner does not commit the replacement to the collection"
	originalAndReplacement := self replaceInCollection.
	reStore commit: testObject.
	self fetchTestObjects.
	self assert: (collection includes: originalAndReplacement key).
	self deny: (collection includes: originalAndReplacement value).

	"...but does withRelatedComponents, even when the collection elements are not related"
	originalAndReplacement := self replaceInCollection.
	reStore commit: testObject withRelatedComponents.
	self fetchTestObjects.
	self deny: (collection includes: originalAndReplacement key).
	self assert: (collection includes: originalAndReplacement value).
!

testRefreshComponentAddition

	| originalSize added | 

	originalSize := collection size.

	self setUpReStore2.
	added := self templateComponent.
	reStore2 evaluateAsTransaction: [(reStore2 instancesOf: testObject class) first component add: added].
	self refreshDelay.

	reStore refresh: testObject.
	self assert: collection size = originalSize.

	reStore refresh: testObject withComponents.
	self assert: (collection size = (originalSize + 1)).
	self assert: ((collection select: [ :each | each name = added name]) size = 1)!

testRefreshComponentChange

	| component originalName changedName |

	component := collection anyOne.
	originalName := component name.
	changedName := originalName, '_changed'.

	self setUpReStore2.
	reStore2 evaluateAsTransaction: [((reStore2 instancesOf: component class) detect: [ :each | each name = originalName]) name: changedName].
	self refreshDelay.

	reStore refresh: testObject.
	self assert: (component name = originalName).

	reStore refresh: testObject withComponents.
	self assert: (component name = changedName)!

testRefreshComponentChangeIfUpdated

	| component originalName changedName |

	component := collection anyOne.
	originalName := component name.
	changedName := originalName, '_changed'.

	self setUpReStore2.
	reStore2 evaluateAsTransaction: [((reStore2 instancesOf: component class) detect: [ :each | each name = originalName]) name: changedName].
	self refreshDelay.

	reStore refreshIfUpdated: testObject.
	self assert: (component name = originalName).

	reStore refreshIfUpdated: testObject withComponents.
	self assert: (component name = changedName)!

testRefreshComponentRemoval

	| component originalSize removed | 

	component := collection anyOne.
	originalSize := collection size.

	self setUpReStore2.
	self assert: (reStore2 evaluateAsTransaction: [removed := (reStore2 instancesOf: testObject class) first component remove: ((reStore2 instancesOf: component class) detect: [ :each | each name = component name])]).
	self refreshDelay.

	reStore refresh: testObject.
	self assert: collection size = originalSize.
	self assert: (collection includes: component).

	reStore refresh: testObject withComponents.
	self assert: (collection size = (originalSize - 1)).
	self assert: (collection allSatisfy: [ :each | each name ~= removed name]).
	self deny: (collection includes: component)!

testRefreshComponentReplace

	| originalSize originalAndReplacement original replacement | 

	originalSize := collection size.

	self setUpReStore2.
	reStore2 evaluateAsTransaction: [originalAndReplacement := self replaceInCollection: (reStore2 instancesOf: testObject class) first component].
	self refreshDelay.

	original := originalAndReplacement key.
	replacement := originalAndReplacement value.

	reStore refresh: testObject.
	self assert: (collection size = originalSize).
	self assert: (collection select: [ :each | each name = original name]) size = 1.
	self assert: (collection select: [ :each | each name = replacement name]) size = 0.

	reStore refresh: testObject withComponents.
	self assert: (collection size = originalSize).
	self assert: (collection select: [ :each | each name = original name]) size = 0.
	self assert: (collection select: [ :each | each name = replacement name]) size = 1.
!

testRollbackComponentAddition

	| original added |

	original := collection copy.
	added := self addToCollection.

	"Rollback of just the owner does not revert the change to the collection"
	reStore rollback: testObject.
	self assert: (collection includes: added).
	self assert: (collection size = (original size + 1)).

	"...but does withRelatedComponents, even when the collection elements are not related"
	reStore rollback: testObject withRelatedComponents.
	self deny: (collection includes: added).
	self assert: (collection size = original size)!

testRollbackComponentChange

	| component originalName changedName |

	component := collection anyOne.
	originalName := component name.
	changedName := originalName, '_changed'.
	component name: changedName.

	"Rollback of just the owner does not revert the change to the collection"
	reStore rollback: testObject.
	self assert: (component name = changedName).

	"...even withRelatedComponents"
	reStore rollback: testObject withRelatedComponents.
	self assert: (component name = changedName)
!

testRollbackComponentRemoval

	| original removed |

	original := collection copy.
	removed := self removeFromCollection.

	"Rollback of just the owner does not revert the change to the collection"
	reStore rollback: testObject.
	self deny: (collection includes: removed).
	self assert: (collection size = (original size - 1)).

	"...but does withRelatedComponents, even when the collection elements are not related"
	reStore rollback: testObject withRelatedComponents.
	self assert: (collection includes: removed).
	self assert: (collection size = original size)!

testRollbackComponentReplace

	| originalAndReplacement |

	originalAndReplacement := self replaceInCollection.

	"Rollback of just the owner does not revert the change to the collection"
	reStore rollback: testObject.
	self deny: (collection includes: originalAndReplacement key).
	self assert: (collection includes: originalAndReplacement value).

	"...but does withRelatedComponents, even when the collection elements are not related"
	reStore rollback: testObject withRelatedComponents.
	self assert: (collection includes: originalAndReplacement key).
	self deny: (collection includes: originalAndReplacement value)! !
!SSWReStoreGenericNonRelatedCollectionTest categoriesFor: #testCheckHasChangedComponentAddition!public!unit tests! !
!SSWReStoreGenericNonRelatedCollectionTest categoriesFor: #testCheckHasChangedComponentChange!public!unit tests! !
!SSWReStoreGenericNonRelatedCollectionTest categoriesFor: #testCheckHasChangedComponentRemoval!public!unit tests! !
!SSWReStoreGenericNonRelatedCollectionTest categoriesFor: #testCheckHasChangedComponentReplace!public!unit tests! !
!SSWReStoreGenericNonRelatedCollectionTest categoriesFor: #testCollectionRefreshComponentChange!public!unit tests! !
!SSWReStoreGenericNonRelatedCollectionTest categoriesFor: #testCollectionRefreshComponentChangeIfUpdated!public!unit tests! !
!SSWReStoreGenericNonRelatedCollectionTest categoriesFor: #testCommitComponentAddition!public!unit tests! !
!SSWReStoreGenericNonRelatedCollectionTest categoriesFor: #testCommitComponentChange!public!unit tests! !
!SSWReStoreGenericNonRelatedCollectionTest categoriesFor: #testCommitComponentRemoval!public!unit tests! !
!SSWReStoreGenericNonRelatedCollectionTest categoriesFor: #testCommitComponentReplace!public!unit tests! !
!SSWReStoreGenericNonRelatedCollectionTest categoriesFor: #testRefreshComponentAddition!public! !
!SSWReStoreGenericNonRelatedCollectionTest categoriesFor: #testRefreshComponentChange!public! !
!SSWReStoreGenericNonRelatedCollectionTest categoriesFor: #testRefreshComponentChangeIfUpdated!public! !
!SSWReStoreGenericNonRelatedCollectionTest categoriesFor: #testRefreshComponentRemoval!public! !
!SSWReStoreGenericNonRelatedCollectionTest categoriesFor: #testRefreshComponentReplace!public! !
!SSWReStoreGenericNonRelatedCollectionTest categoriesFor: #testRollbackComponentAddition!public!unit tests! !
!SSWReStoreGenericNonRelatedCollectionTest categoriesFor: #testRollbackComponentChange!public!unit tests! !
!SSWReStoreGenericNonRelatedCollectionTest categoriesFor: #testRollbackComponentRemoval!public!unit tests! !
!SSWReStoreGenericNonRelatedCollectionTest categoriesFor: #testRollbackComponentReplace!public!unit tests! !

!SSWReStoreGenericNonRelatedCollectionTest class methodsFor!

isAbstract

	^self == SSWReStoreGenericNonRelatedCollectionTest! !
!SSWReStoreGenericNonRelatedCollectionTest class categoriesFor: #isAbstract!public! !


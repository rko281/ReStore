"Filed out from Dolphin Smalltalk 7"!

SSWReStoreGenericCollectionTest subclass: #SSWReStoreGenericRelatedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreGenericRelatedCollectionTest guid: (GUID fromString: '{db4fe6da-c96b-41bb-acb1-9701fd2cec1b}')!
SSWReStoreGenericRelatedCollectionTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreGenericRelatedCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreGenericRelatedCollectionTest methodsFor!

_testCheckHasChangedComponentChangeDeeplyFrom: anObject

	| component originalName changedName |

	component := collection anyOne.
	originalName := 'deep test'.
	changedName := originalName, '_changed'.
	reStore evaluateAsTransaction: [component deepTest: (Test new name: originalName; yourself)].

	"A change to a collection's component's component does not mark the owner or collection as changed"
	component deepTest name: changedName.
	self assert: (component deepTest _checkHasChangedIn: reStore).
	self deny: (component _checkHasChangedIn: reStore).
	self deny: (anObject _checkHasChangedIn: reStore).

	"...but does withRelated/DependentComponents"
	self assert: (anObject withRelatedComponents _checkHasChangedIn: reStore)!

_testCheckHasChangedComponentChangeFrom: anObject

	| component originalName changedName |

	component := collection anyOne.
	originalName := component name.
	changedName := originalName, '_changed'.
	component name: changedName.

	"A change to a collection's component does not mark the owner or collection as changed"
	self assert: (component _checkHasChangedIn: reStore).
	self deny: (anObject _checkHasChangedIn: reStore).

	"...but does withDependent/RelatedComponents"
	self assert: (testObject withRelatedComponents _checkHasChangedIn: reStore)!

_testCommitComponentChangeDeeplyFrom: anObject

	| component originalName changedName oldTestObject anObject2 |

	component := collection anyOne.
	originalName := 'deep test'.
	changedName := originalName, '_changed'.
	reStore evaluateAsTransaction: [component deepTest: (Test new name: originalName; yourself)].

	"Commit of just the owner does not commit the change to the component of the component collection"
	component deepTest name: changedName.
	reStore commit: anObject.

	oldTestObject := testObject.
	self fetchTestObjects.
	anObject == oldTestObject
		ifTrue: [anObject2 := testObject]
		ifFalse: [anObject2 := collection].

	component := collection detect: [ :each | each deepTest name = originalName] ifNone: [nil].
	self assert: component notNil.

	"...but does withRelated/DependentComponents"
	component deepTest name: changedName.
	reStore commit: anObject2 withRelatedComponents.
	self fetchTestObjects.
	self assert: (collection anySatisfy: [ :each | each deepTest ifNil: [false] ifNotNil: [ :dt | dt name = changedName]]).
	self deny: (collection anySatisfy: [ :each | each deepTest ifNil: [false] ifNotNil: [ :dt | dt name = originalName]])!

_testCommitComponentChangeFrom: anObject

	| component originalName changedName oldTestObject anObject2 |

	"Commit of just the owner does not commit the change to the component of the collection"
	component := collection anyOne.
	originalName := component name.
	changedName := originalName, '_changed'.
	component name: changedName.
	reStore commit: anObject.

	oldTestObject := testObject.
	self fetchTestObjects.
	anObject == oldTestObject
		ifTrue: [anObject2 := testObject]
		ifFalse: [anObject2 := collection].

	component := collection detect: [ :each | each name = originalName].
	self assert: (component name = originalName).

	"...but does withRelated/DependentComponents"
	component name: changedName.
	reStore commit: anObject2 withRelatedComponents.
	self fetchTestObjects.
	self assert: (collection anySatisfy: [ :each | each name = changedName]).
	self deny: (collection anySatisfy: [ :each | each name = originalName]).

!

_testRefreshComponentChangeDeeplyFrom: anObject

	| component originalName changedName |

	component := collection anyOne.
	originalName := 'deep test'.
	changedName := originalName, '_changed'.
	reStore evaluateAsTransaction: [component deepTest: (Test new name: originalName; yourself)].

	self setUpReStore2.
	reStore2 evaluateAsTransaction: [((reStore2 instancesOf: Test) detect: [ :each | each name = originalName]) name: changedName].
	self refreshDelay.

	reStore refresh: anObject.
	self assert: (component deepTest name = originalName).

	reStore refresh: anObject withRelatedComponents.
	self assert: (component deepTest name = changedName)!

_testRefreshComponentChangeFrom: anObject

	| component originalName changedName |

	component := collection anyOne.
	originalName := component name.
	changedName := originalName, '_changed'.

	self setUpReStore2.
	reStore2 evaluateAsTransaction: [((reStore2 instancesOf: component class) detect: [ :each | each name = originalName]) name: changedName].
	self refreshDelay.

	reStore refresh: anObject.
	self assert: (component name = originalName).

	reStore refresh: anObject withRelatedComponents.
	self assert: (component name = changedName)!

_testRefreshComponentChangeIfUpdatedDeeplyFrom: anObject

	| component originalName changedName |

	component := collection anyOne.
	originalName := 'deep test'.
	changedName := originalName, '_changed'.
	reStore evaluateAsTransaction: [component deepTest: (Test new name: originalName; yourself)].

	self setUpReStore2.
	reStore2 evaluateAsTransaction: [((reStore2 instancesOf: Test) detect: [ :each | each name = originalName]) name: changedName].
	self refreshDelay.

	reStore refreshIfUpdated: anObject.
	self assert: (component deepTest name = originalName).

	reStore refreshIfUpdated: anObject withRelatedComponents.
	self assert: (component deepTest name = changedName)!

_testRefreshComponentChangeIfUpdatedFrom: anObject

	| component originalName changedName |

	component := collection anyOne.
	originalName := component name.
	changedName := originalName, '_changed'.

	self setUpReStore2.
	reStore2 evaluateAsTransaction: [((reStore2 instancesOf: component class) detect: [ :each | each name = originalName]) name: changedName].
	self refreshDelay.

	reStore refreshIfUpdated: anObject.
	self assert: (component name = originalName).

	reStore refreshIfUpdated: anObject withRelatedComponents.
	self assert: (component name = changedName)!

_testRefreshComponentChangeWithExclusionFrom: anObject

	| component originalName changedName |

	component := collection anyOne.
	originalName := component name.
	changedName := originalName, '_changed'.

	self setUpReStore2.
	reStore2 evaluateAsTransaction: [((reStore2 instancesOf: component class) detect: [ :each | each name = originalName]) name: changedName].
	self refreshDelay.

	reStore refresh: (anObject withRelatedComponents without: collection).
	self assert: (component name = originalName).

	"Exclusion mechanism does not (currently) apply to components of collections"
	reStore refresh: (anObject withRelatedComponents without: component).
	self assert: (component name = changedName)!

_testRefreshRollbackComponentChangeDeeplyFrom: anObject

	| component originalName changedName |

	component := collection anyOne.
	originalName := 'deep test'.
	changedName := originalName, '_changed'.
	reStore evaluateAsTransaction: [component deepTest: (Test new name: originalName; yourself)].

	"Refresh of just the owner does not revert the change to the collection"
	component deepTest name: changedName.
	reStore refresh: testObject.
	self assert: (component deepTest name = changedName).

	"...but does withRelatedComponents"
	reStore refresh: testObject withRelatedComponents.
	self assert: (component deepTest name = originalName)!

_testRefreshRollbackComponentChangeDeeplyIfUpdatedFrom: anObject

	| component originalName changedName |

	component := collection anyOne.
	originalName := 'deep test'.
	changedName := originalName, '_changed'.
	reStore evaluateAsTransaction: [component deepTest: (Test new name: originalName; yourself)].

	"Refresh of just the owner does not revert the change to the collection"
	component deepTest name: changedName.
	reStore refreshIfUpdated: testObject.
	self assert: (component deepTest name = changedName).

	"...but does withRelatedComponents"
	reStore refreshIfUpdated: testObject withRelatedComponents.
	self assert: (component deepTest name = originalName)!

_testRefreshRollbackComponentChangeFrom: anObject

	| component originalName changedName |

	component := collection anyOne.
	originalName := component name.
	changedName := originalName, '_changed'.
	component name: changedName.

	"Refresh of just the owner does not revert the change to the collection"
	reStore refresh: anObject.
	self assert: (component name = changedName).

	"...but does withRelated/DependentComponents"
	reStore refresh: anObject withRelatedComponents.
	self assert: (component name = originalName)
!

_testRefreshRollbackComponentChangeIfUpdatedFrom: anObject

	| component originalName changedName |

	component := collection anyOne.
	originalName := component name.
	changedName := originalName, '_changed'.
	component name: changedName.

	"Refresh of just the owner does not revert the change to the collection"
	reStore refreshIfUpdated: anObject.
	self assert: (component name = changedName).

	"...but does withRelated/DependentComponents"
	reStore refreshIfUpdated: anObject withRelatedComponents.
	self assert: (component name = originalName)
!

_testRollbackComponentChangeDeeplyFrom: anObject

	| component originalName changedName |

	component := collection anyOne.
	originalName := 'deep test'.
	changedName := originalName, '_changed'.
	reStore evaluateAsTransaction: [component deepTest: (Test new name: originalName; yourself)].

	"Rollback of just the owner does not revert the change to the collection"
	component deepTest name: changedName.
	reStore rollback: testObject.
	self assert: (component deepTest name = changedName).

	"...but does withRelatedComponents"
	reStore rollback: testObject withRelatedComponents.
	self assert: (component deepTest name = originalName)!

_testRollbackComponentChangeFrom: anObject

	| component originalName changedName |

	component := collection anyOne.
	originalName := component name.
	changedName := originalName, '_changed'.
	component name: changedName.

	"Rollback of just the owner does not revert the change to the collection"
	reStore rollback: anObject.
	self assert: (component name = changedName).

	"...but does withRelatedComponents"
	reStore rollback: testObject withRelatedComponents.
	self assert: (component name = originalName)
!

testCheckHasChangedComponentAddition

	self addToCollection.

	"Addition to a collection does not mark the owner as changed"
	self assert: (collection _checkHasChangedIn: reStore).
	self deny: (testObject _checkHasChangedIn: reStore).

	"...but does withRelatedComponents"
	self assert: (testObject withRelatedComponents _checkHasChangedIn: reStore)!

testCheckHasChangedComponentChange

	self _testCheckHasChangedComponentChangeFrom: testObject!

testCheckHasChangedComponentChangeDeeply

	self _testCheckHasChangedComponentChangeDeeplyFrom: testObject!

testCheckHasChangedComponentRemoval

	self removeFromCollection.

	"Removal from a collection does not mark the owner as changed"
	self assert: (collection _checkHasChangedIn: reStore).
	self deny: (testObject _checkHasChangedIn: reStore).

	"...but does withRelatedComponents"
	self assert: (testObject withRelatedComponents _checkHasChangedIn: reStore)!

testCheckHasChangedComponentReplace

	self replaceInCollection.

	"Replacing an element of a collection does not mark the owner as changed"
	self assert: (collection _checkHasChangedIn: reStore).
	self deny: (testObject _checkHasChangedIn: reStore).

	"...but does withRelatedComponents"
	self assert: (testObject withRelatedComponents _checkHasChangedIn: reStore)!

testCollectionCheckHasChangedComponentChange

	self _testCheckHasChangedComponentChangeFrom: collection!

testCollectionCheckHasChangedComponentChangeDeeply

	self _testCheckHasChangedComponentChangeDeeplyFrom: collection!

testCollectionCommitComponentChange

	self _testCommitComponentChangeFrom: collection!

testCollectionCommitComponentChangeDeeply

	self _testCommitComponentChangeDeeplyFrom: collection!

testCollectionRefreshComponentChange

	self _testRefreshComponentChangeFrom: collection!

testCollectionRefreshComponentChangeDeeply

	self _testRefreshComponentChangeDeeplyFrom: collection!

testCollectionRefreshComponentChangeIfUpdated

	self _testRefreshComponentChangeIfUpdatedFrom: collection!

testCollectionRefreshComponentChangeIfUpdatedDeeply

	self _testRefreshComponentChangeIfUpdatedDeeplyFrom: collection!

testCollectionRefreshComponentChangeWithExclusion

	self _testRefreshComponentChangeWithExclusionFrom: collection!

testCollectionRefreshRollbackComponentChange

	self _testRefreshRollbackComponentChangeFrom: collection!

testCollectionRefreshRollbackComponentChangeDeeply

	self _testRefreshRollbackComponentChangeDeeplyFrom: collection!

testCollectionRollbackComponentChange

	self _testRollbackComponentChangeFrom: collection!

testCollectionRollbackComponentChangeDeeply

	self _testRollbackComponentChangeDeeplyFrom: collection!

testCommitComponentAddition

	| original added |

	"Commit of just the owner does not commit the change to the collection"
	original := collection copy.
	added := self addToCollection.
	reStore commit: testObject.
	self fetchTestObjects.
	self deny: (collection includes: added).
	self assert: (collection = original).

	"...but does withRelatedComponents"
	original := collection copy.
	added := self addToCollection.
	reStore commit: testObject withRelatedComponents.
	self fetchTestObjects.
	self assert: (collection includes: added)
!

testCommitComponentChange

	self _testCommitComponentChangeFrom: testObject!

testCommitComponentChangeDeeply

	self _testCommitComponentChangeDeeplyFrom: testObject!

testCommitComponentRemoval

	| originalAndReplacement |

	"Commit of just the owner does not commit the change to the collection"
	originalAndReplacement := self replaceInCollection.
	reStore commit: testObject.
	self fetchTestObjects.
	self assert: (collection includes: originalAndReplacement key).
	self deny: (collection includes: originalAndReplacement value).

	"...but does withRelatedComponents"
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

	reStore refresh: testObject withRelatedComponents.
	self assert: (collection size = (originalSize + 1)).
	self assert: ((collection select: [ :each | each name = added name]) size = 1)!

testRefreshComponentChange

	self _testRefreshComponentChangeFrom: testObject!

testRefreshComponentChangeAndRemoval

	| component originalSize originalName changedName removed | 

	component := collection anyOne.
	originalSize := collection size.
	originalName := component name.

	self setUpReStore2.
	reStore2 evaluateAsTransaction: 
		[removed := (reStore2 instancesOf: testObject class) first component remove: ((reStore2 instancesOf: component class) detect: [ :each | each name = originalName]).
		changedName := originalName, '_changed'.
		removed name: changedName].

	self refreshDelay.

	"No change without withRelatedComponents"
	reStore refresh: testObject.
	self assert: collection size = originalSize.
	self assert: (collection includes: component).
	self assert: (component name = originalName).

	"Now withRelatedComponents"
	reStore refresh: testObject withRelatedComponents.
	self assert: (collection size = (originalSize - 1)).
	self assert: (collection allSatisfy: [ :each | each name ~= removed name]).
	self deny: (collection includes: component).
	self componentDefinition isValueDependent 
		ifTrue: [self assert: component isDBDeleted]
		ifFalse: [self assert: (component name = changedName)]!

testRefreshComponentChangeDeeply

	self _testRefreshComponentChangeDeeplyFrom: testObject!

testRefreshComponentChangeIfUpdated

	self _testRefreshComponentChangeIfUpdatedFrom: testObject!

testRefreshComponentChangeIfUpdatedDeeply

	self _testRefreshComponentChangeIfUpdatedDeeplyFrom: testObject!

testRefreshComponentChangeWithExclusion

	self _testRefreshComponentChangeWithExclusionFrom: testObject!

testRefreshComponentRemoval

	| component originalSize originalName changedName removed | 

	component := collection anyOne.
	originalSize := collection size.
	originalName := component name.

	self setUpReStore2.
	reStore2 evaluateAsTransaction: [removed := (reStore2 instancesOf: testObject class) first component remove: ((reStore2 instancesOf: component class) detect: [ :each | each name = originalName])].
	self refreshDelay.

	changedName := component name, '_changed'.
	component name: changedName.

	"No change without withRelatedComponents"
	reStore refresh: testObject.
	self assert: collection size = originalSize.
	self assert: (collection includes: component).
	self assert: (component name = changedName).

	"Now withRelatedComponents"
	reStore refresh: testObject withRelatedComponents.
	self assert: (collection size = (originalSize - 1)).
	self assert: (collection allSatisfy: [ :each | each name ~= removed name]).
	self deny: (collection includes: component).
	self componentDefinition isValueDependent 
		ifTrue: [self assert: component isDBDeleted]
		ifFalse: [self assert: (component name = originalName)]!

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

	reStore refresh: testObject withRelatedComponents.
	self assert: (collection size = originalSize).
	self assert: (collection select: [ :each | each name = original name]) size = 0.
	self assert: (collection select: [ :each | each name = replacement name]) size = 1.
!

testRefreshIfUpdatedComponentChangeAndRemoval

	| component originalSize originalName changedName removed | 

	component := collection anyOne.
	originalSize := collection size.
	originalName := component name.

	self setUpReStore2.
	reStore2 evaluateAsTransaction: 
		[removed := (reStore2 instancesOf: testObject class) first component remove: ((reStore2 instancesOf: component class) detect: [ :each | each name = originalName]).
		changedName := originalName, '_changed'.
		removed name: changedName].

	self refreshDelay.
	
	"No change without withRelatedComponents"
	reStore refreshIfUpdated: testObject.
	self assert: collection size = originalSize.
	self assert: (collection includes: component).
	self assert: (component name = originalName).

	"Now withRelatedComponents"
	reStore refreshIfUpdated: testObject withRelatedComponents.
	self assert: (collection size = (originalSize - 1)).
	self assert: (collection allSatisfy: [ :each | each name ~= removed name]).
	self deny: (collection includes: component).
	self componentDefinition isValueDependent ifFalse: [self assert: (component name = changedName)]!

testRefreshRefreshesComponentChange

	| added originalName |

	added := self addToCollection.
	reStore commit: added.

	originalName := added name.
	added name: originalName, '_changed'.

	reStore refresh: testObject withRelatedComponents.

	self deny: (collection includes: added).
	self assert: (added name = originalName)!

testRefreshRollbackComponentAddition

	| original added |

	original := collection copy.
	added := self addToCollection.

	"Refresh of just the owner does not revert the change to the collection"
	reStore refresh: testObject.
	self assert: (collection includes: added).
	self assert: (collection size = (original size + 1)).

	"...but does withRelatedComponents"
	reStore refresh: testObject withRelatedComponents.
	self deny: (collection includes: added).
	self assert: (collection size = original size).
!

testRefreshRollbackComponentChange

	self _testRefreshRollbackComponentChangeFrom: testObject!

testRefreshRollbackComponentChangeDeeply

	self _testRefreshRollbackComponentChangeDeeplyFrom: testObject!

testRefreshRollbackComponentChangeIfUpdated

	self _testRefreshComponentChangeIfUpdatedFrom: testObject!

testRefreshRollbackComponentChangeIfUpdatedDeeply

	self _testRefreshComponentChangeIfUpdatedDeeplyFrom: testObject!

testRefreshRollbackComponentRemoval

	| original removed |

	original := collection copy.
	removed := self removeFromCollection.

	"Refresh of just the owner does not revert the change to the collection"
	reStore refresh: testObject.
	self deny: (collection includes: removed).
	self assert: (collection size = (original size - 1)).

	"...but does withRelatedComponents"
	reStore refresh: testObject withRelatedComponents.
	self assert: (collection includes: removed).
	self assert: (collection size = original size)!

testRefreshRollbackComponentReplace

	| originalAndReplacement |

	originalAndReplacement := self replaceInCollection.

	"Refresh of just the owner does not revert the change to the collection"
	reStore refresh: testObject.
	self deny: (collection includes: originalAndReplacement key).
	self assert: (collection includes: originalAndReplacement value).

	"...but does withRelatedComponents"
	reStore refresh: testObject withRelatedComponents.
	self assert: (collection includes: originalAndReplacement key).
	self deny: (collection includes: originalAndReplacement value)!

testRollbackComponentAddition

	| original added |

	original := collection copy.
	added := self addToCollection.

	"Rollback of just the owner does not revert the change to the collection"
	reStore rollback: testObject.
	self assert: (collection includes: added).
	self assert: (collection size = (original size + 1)).

	"...but does withRelatedComponents"
	reStore rollback: testObject withRelatedComponents.
	self deny: (collection includes: added).
	self assert: (collection size = original size).
!

testRollbackComponentChange

	self _testRollbackComponentChangeFrom: testObject!

testRollbackComponentChangeDeeply

	self _testRollbackComponentChangeDeeplyFrom: testObject!

testRollbackComponentRemoval

	| original removed |

	original := collection copy.
	removed := self removeFromCollection.

	"Rollback of just the owner does not revert the change to the collection"
	reStore rollback: testObject.
	self deny: (collection includes: removed).
	self assert: (collection size = (original size - 1)).

	"...but does withRelatedComponents"
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

	"...but does withRelatedComponents"
	reStore rollback: testObject withRelatedComponents.
	self assert: (collection includes: originalAndReplacement key).
	self deny: (collection includes: originalAndReplacement value)! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #_testCheckHasChangedComponentChangeDeeplyFrom:!private! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #_testCheckHasChangedComponentChangeFrom:!private! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #_testCommitComponentChangeDeeplyFrom:!private! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #_testCommitComponentChangeFrom:!private! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #_testRefreshComponentChangeDeeplyFrom:!private! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #_testRefreshComponentChangeFrom:!private! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #_testRefreshComponentChangeIfUpdatedDeeplyFrom:!private! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #_testRefreshComponentChangeIfUpdatedFrom:!private! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #_testRefreshComponentChangeWithExclusionFrom:!private! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #_testRefreshRollbackComponentChangeDeeplyFrom:!private! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #_testRefreshRollbackComponentChangeDeeplyIfUpdatedFrom:!private! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #_testRefreshRollbackComponentChangeFrom:!private! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #_testRefreshRollbackComponentChangeIfUpdatedFrom:!private! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #_testRollbackComponentChangeDeeplyFrom:!private! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #_testRollbackComponentChangeFrom:!private! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testCheckHasChangedComponentAddition!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testCheckHasChangedComponentChange!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testCheckHasChangedComponentChangeDeeply!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testCheckHasChangedComponentRemoval!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testCheckHasChangedComponentReplace!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testCollectionCheckHasChangedComponentChange!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testCollectionCheckHasChangedComponentChangeDeeply!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testCollectionCommitComponentChange!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testCollectionCommitComponentChangeDeeply!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testCollectionRefreshComponentChange!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testCollectionRefreshComponentChangeDeeply!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testCollectionRefreshComponentChangeIfUpdated!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testCollectionRefreshComponentChangeIfUpdatedDeeply!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testCollectionRefreshComponentChangeWithExclusion!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testCollectionRefreshRollbackComponentChange!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testCollectionRefreshRollbackComponentChangeDeeply!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testCollectionRollbackComponentChange!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testCollectionRollbackComponentChangeDeeply!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testCommitComponentAddition!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testCommitComponentChange!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testCommitComponentChangeDeeply!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testCommitComponentRemoval!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testRefreshComponentAddition!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testRefreshComponentChange!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testRefreshComponentChangeAndRemoval!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testRefreshComponentChangeDeeply!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testRefreshComponentChangeIfUpdated!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testRefreshComponentChangeIfUpdatedDeeply!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testRefreshComponentChangeWithExclusion!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testRefreshComponentRemoval!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testRefreshComponentReplace!public! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testRefreshIfUpdatedComponentChangeAndRemoval!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testRefreshRefreshesComponentChange!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testRefreshRollbackComponentAddition!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testRefreshRollbackComponentChange!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testRefreshRollbackComponentChangeDeeply!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testRefreshRollbackComponentChangeIfUpdated!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testRefreshRollbackComponentChangeIfUpdatedDeeply!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testRefreshRollbackComponentRemoval!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testRefreshRollbackComponentReplace!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testRollbackComponentAddition!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testRollbackComponentChange!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testRollbackComponentChangeDeeply!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testRollbackComponentRemoval!public!unit tests! !
!SSWReStoreGenericRelatedCollectionTest categoriesFor: #testRollbackComponentReplace!public!unit tests! !

!SSWReStoreGenericRelatedCollectionTest class methodsFor!

isAbstract

	^self == SSWReStoreGenericRelatedCollectionTest! !
!SSWReStoreGenericRelatedCollectionTest class categoriesFor: #isAbstract!public! !


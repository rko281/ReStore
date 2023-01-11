"Filed out from Dolphin Smalltalk"!

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

	component := self anyOne.
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

	component := self anyOne.
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

	component := self anyOne.
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

	component := self detect: [ :each | each deepTest name = originalName] ifNone: [nil].
	self assert: component notNil.

	"...but does withRelated/DependentComponents"
	component deepTest name: changedName.
	reStore commit: anObject2 withRelatedComponents.
	self fetchTestObjects.
	self assert: (self anySatisfy: [ :each | each deepTest ifNil: [false] ifNotNil: [ :dt | dt name = changedName]]).
	self deny: (self anySatisfy: [ :each | each deepTest ifNil: [false] ifNotNil: [ :dt | dt name = originalName]])!

_testCommitComponentChangeFrom: anObject

	| component originalName changedName oldTestObject anObject2 |

	"Commit of just the owner does not commit the change to the component of the collection"
	component := self anyOne.
	originalName := component name.
	changedName := originalName, '_changed'.
	component name: changedName.
	reStore commit: anObject.

	oldTestObject := testObject.
	self fetchTestObjects.
	anObject == oldTestObject
		ifTrue: [anObject2 := testObject]
		ifFalse: [anObject2 := collection].

	component := self detect: [ :each | each name = originalName].
	self assert: (component name = originalName).

	"...but does withRelated/DependentComponents"
	component name: changedName.
	reStore commit: anObject2 withRelatedComponents.
	self fetchTestObjects.
	self assert: (self anySatisfy: [ :each | each name = changedName]).
	self deny: (self anySatisfy: [ :each | each name = originalName]).

!

_testRefreshComponentChangeDeeplyFrom: anObject

	| component originalName changedName |

	component := self anyOne.
	originalName := 'deep test'.
	changedName := originalName, '_changed'.
	reStore evaluateAsTransaction: [component deepTest: (Test new name: originalName; yourself)].

	reStore2 evaluateAsTransaction: [((Test storedInstancesIn: reStore2) detect: [ :each | each name = originalName]) name: changedName].
	self refreshDelay.

	reStore refresh: anObject.
	self assert: (component deepTest name = originalName).

	reStore refresh: anObject withRelatedComponents.
	self assert: (component deepTest name = changedName)!

_testRefreshComponentChangeFrom: anObject

	| component originalName changedName |

	component := self anyOne.
	originalName := component name.
	changedName := originalName, '_changed'.

	reStore2 evaluateAsTransaction: [((component class storedInstancesIn: reStore2) detect: [ :each | each name = originalName]) name: changedName].
	self refreshDelay.

	reStore refresh: anObject.
	self assert: (component name = originalName).

	reStore refresh: anObject withRelatedComponents.
	self assert: (component name = changedName)!

_testRefreshComponentChangeIfUpdatedDeeplyFrom: anObject

	| component originalName changedName |

	component := self anyOne.
	originalName := 'deep test'.
	changedName := originalName, '_changed'.
	reStore evaluateAsTransaction: [component deepTest: (Test new name: originalName; yourself)].

	reStore2 evaluateAsTransaction: [((Test storedInstancesIn: reStore2) detect: [ :each | each name = originalName]) name: changedName].
	self refreshDelay.

	reStore refreshIfUpdated: anObject.
	self assert: (component deepTest name = originalName).

	reStore refreshIfUpdated: anObject withRelatedComponents.
	self assert: (component deepTest name = changedName)!

_testRefreshComponentChangeIfUpdatedFrom: anObject

	| component originalName changedName |

	component := self anyOne.
	originalName := component name.
	changedName := originalName, '_changed'.

	reStore2 evaluateAsTransaction: [((component class storedInstancesIn: reStore2) detect: [ :each | each name = originalName]) name: changedName].
	self refreshDelay.

	reStore refreshIfUpdated: anObject.
	self assert: (component name = originalName).

	reStore refreshIfUpdated: anObject withRelatedComponents.
	self assert: (component name = changedName)!

_testRefreshComponentChangeWithExclusionFrom: anObject

	| component originalName changedName |

	component := self anyOne.
	originalName := component name.
	changedName := originalName, '_changed'.

	reStore2 evaluateAsTransaction: [((component class storedInstancesIn: reStore2) detect: [ :each | each name = originalName]) name: changedName].
	self refreshDelay.

	reStore refresh: (anObject withRelatedComponents without: collection).
	self assert: (component name = originalName).

	"Exclusion mechanism does not (currently) apply to components of collections"
	reStore refresh: (anObject withRelatedComponents without: component).
	self assert: (component name = changedName)!

_testRefreshRollbackComponentChangeDeeplyFrom: anObject

	| component originalName changedName |

	component := self anyOne.
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

	component := self anyOne.
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

	component := self anyOne.
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

	component := self anyOne.
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

	component := self anyOne.
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

	component := self anyOne.
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
	self assert: (self includes: added)
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
	self assert: (self includes: originalAndReplacement key).
	self deny: (self includes: originalAndReplacement value).

	"...but does withRelatedComponents"
	originalAndReplacement := self replaceInCollection.
	reStore commit: testObject withRelatedComponents.
	self fetchTestObjects.
	self deny: (self includes: originalAndReplacement key).
	self assert: (self includes: originalAndReplacement value).
!

testRefreshComponentAddition

	| originalSize added | 

	originalSize := collection size.

	added := self addToCollection: testObject2 component.
	self assert: testObject2 store.
	self refreshDelay.

	reStore refresh: testObject.
	self assert: collection size = originalSize.

	reStore refresh: testObject withRelatedComponents.
	self assert: collection size equals: (originalSize + 1).
	self assert: (self select: [ :each | each name = added name]) size equals: 1!

testRefreshComponentChange

	self _testRefreshComponentChangeFrom: testObject!

testRefreshComponentChangeAndRemoval

	| component originalSize originalName changedName removed | 

	component := self anyOne.
	originalSize := collection size.
	originalName := component name.

	reStore2 evaluateAsTransaction: 
		[removed := self remove: ((component class storedInstancesIn: reStore2) detect: [ :each | each name = originalName]) fromCollection: testObject2 component.
		changedName := originalName, '_changed'.
		removed name: changedName].

	self refreshDelay.

	"No change without withRelatedComponents"
	reStore refresh: testObject.
	self assert: collection size equals: originalSize.
	self assert: (self includes: component).
	self assert: component name equals: originalName.

	"Now withRelatedComponents"
	reStore refresh: testObject withRelatedComponents.
	self assert: collection size equals: (originalSize - 1).
	self assert: (self allSatisfy: [ :each | each name ~= removed name]).
	self deny: (self includes: component).
	self componentDefinitionIsDependent 
		ifTrue: [self assert: component isDBDeleted]
		ifFalse: [self assert: component name equals: changedName]!

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

	component := self anyOne.
	originalSize := collection size.
	originalName := component name.

	reStore2 evaluateAsTransaction: [removed := self remove: ((component class storedInstancesIn: reStore2) detect: [ :each | each name = originalName]) fromCollection: testObject2 component].
	self refreshDelay.

	changedName := component name, '_changed'.
	component name: changedName.

	"No change without withRelatedComponents"
	reStore refresh: testObject.
	self assert: collection size equals: originalSize.
	self assert: (self includes: component).
	self assert: component name equals: changedName.

	"Now withRelatedComponents"
	reStore refresh: testObject withRelatedComponents.
	self assert: collection size equals: (originalSize - 1).
	self assert: (self allSatisfy: [ :each | each name ~= removed name]).
	self deny: (self includes: component).
	self componentDefinitionIsDependent
		ifTrue: [self assert: component isDBDeleted]
		ifFalse: [self assert: component name equals: originalName]!

testRefreshComponentReplace

	| originalSize originalAndReplacement original replacement | 

	originalSize := collection size.

	reStore2 evaluateAsTransaction: [originalAndReplacement := self replaceInCollection: (reStore2 instancesOf: testObject class) first component].
	self refreshDelay.

	original := originalAndReplacement key.
	replacement := originalAndReplacement value.

	reStore refresh: testObject.
	self assert: (collection size = originalSize).
	self assert: (self select: [ :each | each name = original name]) size = 1.
	self assert: (self select: [ :each | each name = replacement name]) size = 0.

	reStore refresh: testObject withRelatedComponents.
	self assert: (collection size = originalSize).
	self assert: (self select: [ :each | each name = original name]) size = 0.
	self assert: (self select: [ :each | each name = replacement name]) size = 1.
!

testRefreshIfUpdatedComponentChangeAndRemoval

	| component originalSize originalName changedName removed | 

	component := self anyOne.
	originalSize := collection size.
	originalName := component name.

	reStore2 evaluateAsTransaction: 
		[removed := self remove: ((component class storedInstancesIn: reStore2) detect: [ :each | each name = originalName]) fromCollection: testObject2 component.
		changedName := originalName, '_changed'.
		removed name: changedName].

	self refreshDelay.
	
	"No change without withRelatedComponents"
	reStore refreshIfUpdated: testObject.
	self assert: collection size equals: originalSize.
	self assert: (self includes: component).
	self assert: component name equals: originalName.

	"Now withRelatedComponents"
	reStore refreshIfUpdated: testObject withRelatedComponents.
	self assert: collection size equals: (originalSize - 1).
	self assert: (self allSatisfy: [ :each | each name ~= removed name]).
	self deny: (self includes: component).
	self componentDefinitionIsDependent ifFalse: [self assert: component name equals: changedName]!

testRefreshRefreshesComponentChange

	| added originalName |

	added := self addToCollection.
	added storeIn: reStore.

	originalName := added name.
	added name: originalName, '_changed'.

	testObject refresh.

	self deny: (self includes: added).
	self assert: (added name = originalName)!

testRefreshRollbackComponentAddition

	| original added |

	original := collection copy.
	added := self addToCollection.

	"Refresh of just the owner does not revert the change to the collection"
	reStore refresh: testObject.
	self assert: (self includes: added).
	self assert: (collection size = (original size + 1)).

	"...but does withRelatedComponents"
	reStore refresh: testObject withRelatedComponents.
	self deny: (self includes: added).
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
	self deny: (self includes: removed).
	self assert: (collection size = (original size - 1)).

	"...but does withRelatedComponents"
	reStore refresh: testObject withRelatedComponents.
	self assert: (self includes: removed).
	self assert: (collection size = original size)!

testRefreshRollbackComponentReplace

	| originalAndReplacement |

	originalAndReplacement := self replaceInCollection.

	"Refresh of just the owner does not revert the change to the collection"
	reStore refresh: testObject.
	self deny: (self includes: originalAndReplacement key).
	self assert: (self includes: originalAndReplacement value).

	"...but does withRelatedComponents"
	reStore refresh: testObject withRelatedComponents.
	self assert: (self includes: originalAndReplacement key).
	self deny: (self includes: originalAndReplacement value)!

testRollbackComponentAddition

	| original added |

	original := collection copy.
	added := self addToCollection.

	"Rollback of just the owner does not revert the change to the collection"
	reStore rollback: testObject.
	self assert: (self includes: added).
	self assert: (collection size = (original size + 1)).

	"...but does withRelatedComponents"
	reStore rollback: testObject withRelatedComponents.
	self deny: (self includes: added).
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
	self deny: (self includes: removed).
	self assert: (collection size = (original size - 1)).

	"...but does withRelatedComponents"
	reStore rollback: testObject withRelatedComponents.
	self assert: (self includes: removed).
	self assert: (collection size = original size)!

testRollbackComponentReplace

	| originalAndReplacement |

	originalAndReplacement := self replaceInCollection.

	"Rollback of just the owner does not revert the change to the collection"
	reStore rollback: testObject.
	self deny: (self includes: originalAndReplacement key).
	self assert: (self includes: originalAndReplacement value).

	"...but does withRelatedComponents"
	reStore rollback: testObject withRelatedComponents.
	self assert: (self includes: originalAndReplacement key).
	self deny: (self includes: originalAndReplacement value)! !
!SSWReStoreGenericRelatedCollectionTest categoriesForMethods!
_testCheckHasChangedComponentChangeDeeplyFrom:!private! !
_testCheckHasChangedComponentChangeFrom:!private! !
_testCommitComponentChangeDeeplyFrom:!private! !
_testCommitComponentChangeFrom:!private! !
_testRefreshComponentChangeDeeplyFrom:!private! !
_testRefreshComponentChangeFrom:!private! !
_testRefreshComponentChangeIfUpdatedDeeplyFrom:!private! !
_testRefreshComponentChangeIfUpdatedFrom:!private! !
_testRefreshComponentChangeWithExclusionFrom:!private! !
_testRefreshRollbackComponentChangeDeeplyFrom:!private! !
_testRefreshRollbackComponentChangeDeeplyIfUpdatedFrom:!private! !
_testRefreshRollbackComponentChangeFrom:!private! !
_testRefreshRollbackComponentChangeIfUpdatedFrom:!private! !
_testRollbackComponentChangeDeeplyFrom:!private! !
_testRollbackComponentChangeFrom:!private! !
testCheckHasChangedComponentAddition!public!unit tests! !
testCheckHasChangedComponentChange!public!unit tests! !
testCheckHasChangedComponentChangeDeeply!public!unit tests! !
testCheckHasChangedComponentRemoval!public!unit tests! !
testCheckHasChangedComponentReplace!public!unit tests! !
testCollectionCheckHasChangedComponentChange!public!unit tests! !
testCollectionCheckHasChangedComponentChangeDeeply!public!unit tests! !
testCollectionCommitComponentChange!public!unit tests! !
testCollectionCommitComponentChangeDeeply!public!unit tests! !
testCollectionRefreshComponentChange!public!unit tests! !
testCollectionRefreshComponentChangeDeeply!public!unit tests! !
testCollectionRefreshComponentChangeIfUpdated!public!unit tests! !
testCollectionRefreshComponentChangeIfUpdatedDeeply!public!unit tests! !
testCollectionRefreshComponentChangeWithExclusion!public!unit tests! !
testCollectionRefreshRollbackComponentChange!public!unit tests! !
testCollectionRefreshRollbackComponentChangeDeeply!public!unit tests! !
testCollectionRollbackComponentChange!public!unit tests! !
testCollectionRollbackComponentChangeDeeply!public!unit tests! !
testCommitComponentAddition!public!unit tests! !
testCommitComponentChange!public!unit tests! !
testCommitComponentChangeDeeply!public!unit tests! !
testCommitComponentRemoval!public!unit tests! !
testRefreshComponentAddition!public!unit tests! !
testRefreshComponentChange!public!unit tests! !
testRefreshComponentChangeAndRemoval!public!unit tests! !
testRefreshComponentChangeDeeply!public!unit tests! !
testRefreshComponentChangeIfUpdated!public!unit tests! !
testRefreshComponentChangeIfUpdatedDeeply!public!unit tests! !
testRefreshComponentChangeWithExclusion!public!unit tests! !
testRefreshComponentRemoval!public!unit tests! !
testRefreshComponentReplace!public! !
testRefreshIfUpdatedComponentChangeAndRemoval!public!unit tests! !
testRefreshRefreshesComponentChange!public!unit tests! !
testRefreshRollbackComponentAddition!public!unit tests! !
testRefreshRollbackComponentChange!public!unit tests! !
testRefreshRollbackComponentChangeDeeply!public!unit tests! !
testRefreshRollbackComponentChangeIfUpdated!public!unit tests! !
testRefreshRollbackComponentChangeIfUpdatedDeeply!public!unit tests! !
testRefreshRollbackComponentRemoval!public!unit tests! !
testRefreshRollbackComponentReplace!public!unit tests! !
testRollbackComponentAddition!public!unit tests! !
testRollbackComponentChange!public!unit tests! !
testRollbackComponentChangeDeeply!public!unit tests! !
testRollbackComponentRemoval!public!unit tests! !
testRollbackComponentReplace!public!unit tests! !
!

!SSWReStoreGenericRelatedCollectionTest class methodsFor!

isAbstract

	^self == SSWReStoreGenericRelatedCollectionTest! !
!SSWReStoreGenericRelatedCollectionTest class categoriesForMethods!
isAbstract!public! !
!


"Filed out from Dolphin Smalltalk 7"!

SSWReStoreGenericRelatedCollectionTest subclass: #SSWReStoreRelatedSortedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreRelatedSortedCollectionTest guid: (GUID fromString: '{9772ced4-2aed-4c78-b62d-e1038d2baae2}')!
SSWReStoreRelatedSortedCollectionTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreRelatedSortedCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreRelatedSortedCollectionTest methodsFor!

componentDefinition

	^SortedCollection of: GenericOwnedTest related!

replaceInCollection: aCollection

	^(aCollection remove: aCollection last) -> (aCollection add: self templateComponent)!

templateCollection

	^SortedCollection 
		with: self templateComponent
		with: self templateComponent
		with: self templateComponent!

testCollectionRefreshComponentChange

	| component originalName changedName changedName2 |

	component := collection anyOne.
	originalName := component name.
	changedName := originalName, '_changed'.

	self setUpReStore2.
	reStore2 evaluateAsTransaction: [((reStore2 instancesOf: component class) detect: [ :each | each name = originalName]) name: changedName].
	self refreshDelay.

	"The need to sort on the target class means we do a full recover instead of just refreshing the collection itself, i.e. no difference between refresh and refresh with components"
	reStore refresh: collection.
	self assert: (component name = changedName).

	changedName2 := originalName, '_changed2'.
	reStore2 evaluateAsTransaction: [((reStore2 instancesOf: component class) detect: [ :each | each name = changedName]) name: changedName2].
	self refreshDelay.

	reStore refresh: collection withRelatedComponents.
	self assert: (component name = changedName2)!

testCollectionRefreshComponentChangeIfUpdated

	| component originalName changedName changedName2 |

	component := collection anyOne.
	originalName := component name.
	changedName := originalName, '_changed'.

	self setUpReStore2.
	reStore2 evaluateAsTransaction: [((reStore2 instancesOf: component class) detect: [ :each | each name = originalName]) name: changedName].
	self refreshDelay.

	"The need to sort on the target class means we do a full recover instead of just refreshing the collection itself, i.e. no difference between refresh and refresh with components"
	reStore refreshIfUpdated: collection.
	self assert: (component name = changedName).

	changedName2 := originalName, '_changed2'.
	reStore2 evaluateAsTransaction: [((reStore2 instancesOf: component class) detect: [ :each | each name = changedName]) name: changedName2].
	self refreshDelay.

	reStore refreshIfUpdated: collection withRelatedComponents.
	self assert: (component name = changedName2)!

testCollectionRefreshRollbackComponentChange

	| component originalName changedName |

	component := collection anyOne.
	originalName := component name.
	changedName := originalName, '_changed'.
	component name: changedName.

	"The need to sort on the target class means we do a full recover instead of just refreshing the collection itself, i.e. no difference between refresh and refresh with components"
	reStore refresh: collection.
	self assert: (component name = originalName).

	"Should be identical withRelatedComponents"
	component name: changedName.
	reStore refresh: collection withRelatedComponents.
	self assert: (component name = originalName)
! !
!SSWReStoreRelatedSortedCollectionTest categoriesFor: #componentDefinition!accessing!public! !
!SSWReStoreRelatedSortedCollectionTest categoriesFor: #replaceInCollection:!public! !
!SSWReStoreRelatedSortedCollectionTest categoriesFor: #templateCollection!accessing!public! !
!SSWReStoreRelatedSortedCollectionTest categoriesFor: #testCollectionRefreshComponentChange!public!unit tests! !
!SSWReStoreRelatedSortedCollectionTest categoriesFor: #testCollectionRefreshComponentChangeIfUpdated!public!unit tests! !
!SSWReStoreRelatedSortedCollectionTest categoriesFor: #testCollectionRefreshRollbackComponentChange!public!unit tests! !


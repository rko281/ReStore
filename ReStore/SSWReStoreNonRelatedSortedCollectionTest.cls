"Filed out from Dolphin Smalltalk 7"!

SSWReStoreGenericNonRelatedCollectionTest subclass: #SSWReStoreNonRelatedSortedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreNonRelatedSortedCollectionTest guid: (GUID fromString: '{ccbabe31-d39c-4f6b-993a-072cfac026db}')!
SSWReStoreNonRelatedSortedCollectionTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreNonRelatedSortedCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreNonRelatedSortedCollectionTest methodsFor!

componentDefinition

	^SortedCollection of: GenericOwnedTest!

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

	reStore refresh: collection withComponents.
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

	reStore refreshIfUpdated: collection withComponents.
	self assert: (component name = changedName2)! !
!SSWReStoreNonRelatedSortedCollectionTest categoriesFor: #componentDefinition!accessing!public! !
!SSWReStoreNonRelatedSortedCollectionTest categoriesFor: #replaceInCollection:!public! !
!SSWReStoreNonRelatedSortedCollectionTest categoriesFor: #templateCollection!accessing!public! !
!SSWReStoreNonRelatedSortedCollectionTest categoriesFor: #testCollectionRefreshComponentChange!public!unit tests! !
!SSWReStoreNonRelatedSortedCollectionTest categoriesFor: #testCollectionRefreshComponentChangeIfUpdated!public!unit tests! !


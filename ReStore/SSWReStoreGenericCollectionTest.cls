﻿"Filed out from Dolphin Smalltalk 7"!

SSWReStoreGenericTest subclass: #SSWReStoreGenericCollectionTest
	instanceVariableNames: 'collection'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreGenericCollectionTest guid: (GUID fromString: '{e220f207-0203-4d1f-bdbe-ea498962bc97}')!
SSWReStoreGenericCollectionTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreGenericCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreGenericCollectionTest methodsFor!

_testComponentExistenceOnDependency: component

	"Private - No dependency at this level so should still exist"

	self assert: (component _dbProxyIn: reStore ifNone: [nil]) notNil.

	reStore simulateReconnect.
	self assert: ((component class storedInstancesIn: reStore) anySatisfy: [ :each | each name = component name])!

addToCollection

	^self addToCollection: collection!

addToCollection: aCollection

	^aCollection add: self templateComponent!

fetchTestObjects

	super fetchTestObjects.

	collection := testObject component!

remove: anObject fromCollection: aCollection

	^aCollection remove: anObject!

removeFromCollection

	^self removeFromCollection: collection!

removeFromCollection: aCollection

	^self remove: aCollection anyOne fromCollection: aCollection!

replaceInCollection

	^self replaceInCollection: collection!

replaceInCollection: aCollection

	self subclassResponsibility!

templateCollection

	^self subclassResponsibility!

templateTestObject

	^GenericTest new
		component: self templateCollection;
		yourself!

testCollectionRefreshComponentAddition

	| originalSize added | 

	originalSize := collection size.

	added := self addToCollection: testObject2 component.
	self assert: testObject2 store.
	self refreshDelay.

	collection refresh.
	self assert: collection size equals: (originalSize + 1).
	self assert: (collection select: [ :each | each name = added name]) size equals: 1!

testCollectionRefreshComponentRemoval

	| component originalSize removed | 

	component := collection anyOne.
	originalSize := collection size.

	removed := self remove: ((component class storedInstancesIn: reStore2) detect: [ :each | each name = component name]) fromCollection: testObject2 component.
	self assert: testObject2 store.
	self refreshDelay.

	collection refresh.
	self assert: collection size equals: (originalSize - 1).
	self assert: (collection allSatisfy: [ :each | each name ~= removed name]).
	self deny: (collection includes: component)!

testCollectionRefreshComponentReplace

	| originalSize originalAndReplacement original replacement | 

	originalSize := collection size.

	originalAndReplacement := self replaceInCollection: testObject2 component.
	self assert: testObject2 store.
	self refreshDelay.

	original := originalAndReplacement key.
	replacement := originalAndReplacement value.

	collection refresh.
	self assert: collection size equals: originalSize.
	self assert: (collection select: [ :each | each name = original name]) size equals: 0.
	self assert: (collection select: [ :each | each name = replacement name]) size equals: 1
!

testDependencyCascadedDelete

	"Check that collection contents are or are not deleted when the owning object is deleted, as appropriate for the specified relationship (i.e. delete if dependent, otherwise not)"

	| component |

	component := collection anyOne.
	testObject unstore.

	"Verify the delete"
	self assert: (testObject class storedInstancesIn: reStore) isEmpty.

	self _testComponentExistenceOnDependency: component!

testDependencyDeleteOnRemoval

	"Check that non-dependent collection contents are or are not deleted when removed, as appropriate for the specified relationship (i.e. delete if dependent, otherwise not)"

	| component |

	component := collection anyOne.
	self remove: component fromCollection: collection.

	testObject store.

	self _testComponentExistenceOnDependency: component!

testDependencyDeleteOnRepeatedRemoval

	"Check that non-dependent collection contents are or are not deleted when removed, as appropriate for the specified relationship (i.e. delete if dependent, otherwise not)"

	| component id cls |

	component := collection anyOne.
	id := component _id.
	cls := component class.

	"Add a second occurrence of component"
	collection add: component.
	testObject store.

	reStore simulateReconnect.
	self fetchTestObjects.
	component := (cls storedInstancesIn: reStore) detect: [ :each | each _id = id] ifNone: [nil].
	self assert: component notNil.
	self assert: (collection occurrencesOf: component) equals: 2.

	"Remove one occurrence of component"
	self remove: component fromCollection: collection.
	testObject store.

	reStore simulateReconnect.
	self fetchTestObjects.

	"Whether we're dealing with a dependent relationship or not, component should still exist since it is still in the collection"
	component := (cls storedInstancesIn: reStore) detect: [ :each | each _id = id] ifNone: [nil].
	self assert: component notNil.
	self assert: (collection occurrencesOf: component) equals: 1.

	"Remove the remaining occcurrence and test existence depending on dependency"
	self remove: component fromCollection: collection.
	testObject store.

	self _testComponentExistenceOnDependency: component!

testDependencyDeleteOnReplacement

	"Check that non-dependent collection contents are or are not deleted when replaced, as appropriate for the specified relationship (i.e. delete if dependent, otherwise not)"

	| originalAndReplacement |

	reStore evaluateAsTransaction: [originalAndReplacement := self replaceInCollection].

	self componentDefinition isValueDependent ifTrue: [self _testComponentExistenceOnDependency: originalAndReplacement key]!

testIncludes

	| instances existing template matches |

	instances := GenericTest storedInstancesIn: reStore.
	existing := testObject component anyOne.
	template := self addToCollection.
	self assert: (instances anySatisfy: [ :each | each component includes: existing]).
	self deny: (instances anySatisfy: [ :each | each component includes: template]).

	self remove: existing fromCollection: testObject component.
	testObject store.

	self deny: (instances anySatisfy: [ :each | each component includes: existing]).
	self assert: (instances anySatisfy: [ :each | each component includes: template]).

	matches := instances select: [ :each | each component includes: template].
	self assert: matches size equals: 1.
	self assert: matches first == testObject! !
!SSWReStoreGenericCollectionTest categoriesFor: #_testComponentExistenceOnDependency:!helpers!private! !
!SSWReStoreGenericCollectionTest categoriesFor: #addToCollection!helpers!public! !
!SSWReStoreGenericCollectionTest categoriesFor: #addToCollection:!helpers!private! !
!SSWReStoreGenericCollectionTest categoriesFor: #fetchTestObjects!public! !
!SSWReStoreGenericCollectionTest categoriesFor: #remove:fromCollection:!helpers!private! !
!SSWReStoreGenericCollectionTest categoriesFor: #removeFromCollection!helpers!public! !
!SSWReStoreGenericCollectionTest categoriesFor: #removeFromCollection:!helpers!private! !
!SSWReStoreGenericCollectionTest categoriesFor: #replaceInCollection!helpers!public! !
!SSWReStoreGenericCollectionTest categoriesFor: #replaceInCollection:!public! !
!SSWReStoreGenericCollectionTest categoriesFor: #templateCollection!accessing!public! !
!SSWReStoreGenericCollectionTest categoriesFor: #templateTestObject!accessing!public! !
!SSWReStoreGenericCollectionTest categoriesFor: #testCollectionRefreshComponentAddition!public!unit tests! !
!SSWReStoreGenericCollectionTest categoriesFor: #testCollectionRefreshComponentRemoval!public!unit tests! !
!SSWReStoreGenericCollectionTest categoriesFor: #testCollectionRefreshComponentReplace!public! !
!SSWReStoreGenericCollectionTest categoriesFor: #testDependencyCascadedDelete!public!unit tests! !
!SSWReStoreGenericCollectionTest categoriesFor: #testDependencyDeleteOnRemoval!public!unit tests! !
!SSWReStoreGenericCollectionTest categoriesFor: #testDependencyDeleteOnRepeatedRemoval!public!unit tests! !
!SSWReStoreGenericCollectionTest categoriesFor: #testDependencyDeleteOnReplacement!public!unit tests! !
!SSWReStoreGenericCollectionTest categoriesFor: #testIncludes!public! !

!SSWReStoreGenericCollectionTest class methodsFor!

isAbstract

	^self == SSWReStoreGenericCollectionTest!

multipleOccurrenceTestSelectors

	"Return the selectors of any tests that depend on the ability to support multiple occurrences of an object in the collection tested by this class"
	^#(#testDependencyDeleteOnRepeatedRemoval)! !
!SSWReStoreGenericCollectionTest class categoriesFor: #isAbstract!public!testing! !
!SSWReStoreGenericCollectionTest class categoriesFor: #multipleOccurrenceTestSelectors!accessing!public! !


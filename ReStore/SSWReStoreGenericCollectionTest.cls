"Filed out from Dolphin Smalltalk"!

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

allSatisfy: aBlock

	^collection allSatisfy: aBlock!

anyOne

	^collection anyOne!

anySatisfy: aBlock

	^collection anySatisfy: aBlock!

componentDefinitionIsDependent 

	^self componentDefinition isValueDependent!

detect: aBlock

	^collection detect: aBlock!

detect: aBlock ifNone: absentBlock

	^collection detect: aBlock ifNone: absentBlock!

duplicateInCollection

	^self duplicateInCollection: collection!

duplicateInCollection: aCollection

	"optional - implement where necessary" !

fetchTestObjects

	super fetchTestObjects.

	collection := testObject component!

includes: anObject

	^collection includes: anObject!

remove: anObject fromCollection: aCollection

	^aCollection remove: anObject!

removeFromCollection

	^self removeFromCollection: collection!

removeFromCollection: aCollection

	^self remove: self anyOne fromCollection: aCollection!

replaceInCollection

	^self replaceInCollection: collection!

replaceInCollection: aCollection

	self subclassResponsibility!

select: aBlock

	^collection select: aBlock!

templateCollection

	^self subclassResponsibility!

templateTestObject

	^GenericTest new
		component: self templateCollection;
		yourself!

testCollectionMultiAssignmentFailure

	"Ensure an attemp to assign a collection to more than one persistent object will fail."

	| object1 object2 |

	object1 := self templateTestObject.
	object1 storeIn: reStore.

	object2 := self templateTestObject.
	object2 component: object1 component.

	self should: [object2 storeIn: reStore] raise: Error!

testCollectionRefreshComponentAddition

	| originalSize added | 

	originalSize := collection size.

	added := self addToCollection: testObject2 component.
	self assert: testObject2 store.
	self refreshDelay.

	collection refresh.
	self assert: collection size equals: (originalSize + 1).
	self assert: (self select: [ :each | each name = added name]) size equals: 1!

testCollectionRefreshComponentRemoval

	| component originalSize removed | 

	component := self anyOne.
	originalSize := collection size.

	removed := self remove: ((component class storedInstancesIn: reStore2) detect: [ :each | each name = component name]) fromCollection: testObject2 component.
	self assert: testObject2 store.
	self refreshDelay.

	collection refresh.
	self assert: collection size equals: (originalSize - 1).
	self assert: (self allSatisfy: [ :each | each name ~= removed name]).
	self deny: (self includes: component)!

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
	self assert: (self select: [ :each | each name = original name]) size equals: 0.
	self assert: (self select: [ :each | each name = replacement name]) size equals: 1
!

testCollectionUninitializedOnRollback

	"Ensure a collection that was created when storing an object with a collection definition (i.e. the collection inst var was nil prior to the store) is reset to nil on rollback"

	| object |

	object := self templateTestObject.

	reStore beginTransaction.
	object component: nil; storeIn: reStore.
	reStore rollbackTransaction.

	self assert: object component isNil!

testDependencyCascadedDelete

	"Check that collection contents are or are not deleted when the owning object is deleted, as appropriate for the specified relationship (i.e. delete if dependent, otherwise not)"

	| component |

	component := self anyOne.
	testObject unstore.

	"Verify the delete"
	self assert: (testObject class storedInstancesIn: reStore) isEmpty.

	self _testComponentExistenceOnDependency: component!

testDependencyDeleteOnRemoval

	"Check that non-dependent collection contents are or are not deleted when removed, as appropriate for the specified relationship (i.e. delete if dependent, otherwise not)"

	| component |

	component := self anyOne.
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

	self componentDefinitionIsDependent ifTrue: [self _testComponentExistenceOnDependency: originalAndReplacement key]!

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
	self assert: matches first == testObject!

testNewEmptyCollectionRollback

	"Ensure a collection that is stored when empty can be subsequently rolled back without error (previously gave an error for non-owned collections)"

	| object |

	object := self templateTestObject.
	object component removeAll.
	object storeIn: reStore.

	reStore beginTransaction.
	self addToCollection: object component.
	self assert: object component size equals: 1.
	self shouldnt: [reStore rollbackTransaction] raise: Error.
	self assert: object component size equals: 0! !
!SSWReStoreGenericCollectionTest categoriesForMethods!
_testComponentExistenceOnDependency:!helpers!private! !
addToCollection!helpers!public! !
addToCollection:!helpers!private! !
allSatisfy:!collection behavior!private! !
anyOne!collection behavior!private! !
anySatisfy:!collection behavior!private! !
componentDefinitionIsDependent!private!testing! !
detect:!collection behavior!private! !
detect:ifNone:!collection behavior!private! !
duplicateInCollection!helpers!public! !
duplicateInCollection:!private! !
fetchTestObjects!public! !
includes:!collection behavior!private! !
remove:fromCollection:!helpers!private! !
removeFromCollection!helpers!public! !
removeFromCollection:!helpers!private! !
replaceInCollection!helpers!public! !
replaceInCollection:!public! !
select:!collection behavior!private! !
templateCollection!accessing!public! !
templateTestObject!accessing!public! !
testCollectionMultiAssignmentFailure!public!unit tests! !
testCollectionRefreshComponentAddition!public!unit tests! !
testCollectionRefreshComponentRemoval!public!unit tests! !
testCollectionRefreshComponentReplace!public!unit tests! !
testCollectionUninitializedOnRollback!public!unit tests! !
testDependencyCascadedDelete!public!unit tests! !
testDependencyDeleteOnRemoval!public!unit tests! !
testDependencyDeleteOnRepeatedRemoval!public!unit tests! !
testDependencyDeleteOnReplacement!public!unit tests! !
testIncludes!public!unit tests! !
testNewEmptyCollectionRollback!public!unit tests! !
!

!SSWReStoreGenericCollectionTest class methodsFor!

isAbstract

	^self == SSWReStoreGenericCollectionTest!

multipleOccurrenceTestSelectors

	"Return the selectors of any tests that depend on the ability to support multiple occurrences of an object in the collection tested by this class"
	^#(#testDependencyDeleteOnRepeatedRemoval)! !
!SSWReStoreGenericCollectionTest class categoriesForMethods!
isAbstract!public!testing! !
multipleOccurrenceTestSelectors!accessing!public! !
!


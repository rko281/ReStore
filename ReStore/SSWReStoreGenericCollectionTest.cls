"Filed out from Dolphin Smalltalk 7"!

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

	"No dependency at this level so should still exist"

	self assert: (component _dbProxyIn: reStore ifNone: [nil]) notNil.

	reStore simulateReconnect.
	self assert: ((reStore instancesOf: component class) detect: [ :each | each name = component name] ifNone: [nil]) notNil!

addToCollection

	^collection add: self templateComponent!

fetchTestObjects

	super fetchTestObjects.

	collection := testObject component!

removeFromCollection

	^collection remove: collection anyOne!

replaceInCollection

	^self replaceInCollection: collection!

replaceInCollection: aCollection

	self subclassResponsibility!

templateCollection

	^self subclassResponsibility!

templateComponent

	"Ensure unique name"
	(Delay forMicroseconds: 10) wait.

	^GenericOwnedTest new name: (self class name, Time microsecondClockValue printString)!

templateTestObject

	^GenericTest new
		component: self templateCollection;
		yourself!

testCollectionRefreshComponentAddition

	| originalSize added | 

	originalSize := collection size.

	self setUpReStore2.
	added := self templateComponent.
	reStore2 evaluateAsTransaction: [(reStore2 instancesOf: testObject class) first component add: added].
	self refreshDelay.

	reStore refresh: collection.
	self assert: (collection size = (originalSize + 1)).
	self assert: ((collection select: [ :each | each name = added name]) size = 1)!

testCollectionRefreshComponentRemoval

	| component originalSize removed | 

	component := collection anyOne.
	originalSize := collection size.

	self setUpReStore2.
	reStore2 evaluateAsTransaction: [removed := (reStore2 instancesOf: testObject class) first component remove: ((reStore2 instancesOf: component class) detect: [ :each | each name = component name])].
	self refreshDelay.

	reStore refresh: collection.
	self assert: (collection size = (originalSize - 1)).
	self assert: (collection allSatisfy: [ :each | each name ~= removed name]).
	self deny: (collection includes: component)!

testCollectionRefreshComponentReplace

	| originalSize originalAndReplacement original replacement | 

	originalSize := collection size.

	self setUpReStore2.
	reStore2 evaluateAsTransaction: [originalAndReplacement := self replaceInCollection: (reStore2 instancesOf: testObject class) first component].
	self refreshDelay.

	original := originalAndReplacement key.
	replacement := originalAndReplacement value.

	reStore refresh: collection.
	self assert: (collection size = originalSize).
	self assert: (collection select: [ :each | each name = original name]) size = 0.
	self assert: (collection select: [ :each | each name = replacement name]) size = 1.
!

testDependencyCascadedDelete

	"Check that collection contents are or are not deleted when the owning object is deleted, as appropriate for the specified relationship (i.e. delete if dependent, otherwise not)"

	| component |

	component := collection anyOne.
	reStore commit: testObject unstored.

	"Verify the delete"
	self assert: (reStore instancesOf: testObject class) isEmpty.

	self _testComponentExistenceOnDependency: component!

testDependencyDeleteOnRemoval

	"Check that non-dependent collection contents are or are not deleted when removed, as appropriate for the specified relationship (i.e. delete if dependent, otherwise not)"

	| component |

	component := collection anyOne.
	collection remove: component.
	reStore commit: testObject withComponents.

	self _testComponentExistenceOnDependency: component!

testDependencyDeleteOnReplacement

	"Check that non-dependent collection contents are or are not deleted when replaced, as appropriate for the specified relationship (i.e. delete if dependent, otherwise not)"

	| originalAndReplacement |

	reStore evaluateAsTransaction: [originalAndReplacement := self replaceInCollection: (reStore instancesOf: testObject class) first component].

	self _testComponentExistenceOnDependency: originalAndReplacement key! !
!SSWReStoreGenericCollectionTest categoriesFor: #_testComponentExistenceOnDependency:!helpers!public! !
!SSWReStoreGenericCollectionTest categoriesFor: #addToCollection!helpers!public! !
!SSWReStoreGenericCollectionTest categoriesFor: #fetchTestObjects!public! !
!SSWReStoreGenericCollectionTest categoriesFor: #removeFromCollection!helpers!public! !
!SSWReStoreGenericCollectionTest categoriesFor: #replaceInCollection!helpers!public! !
!SSWReStoreGenericCollectionTest categoriesFor: #replaceInCollection:!public! !
!SSWReStoreGenericCollectionTest categoriesFor: #templateCollection!accessing!public! !
!SSWReStoreGenericCollectionTest categoriesFor: #templateComponent!accessing!public! !
!SSWReStoreGenericCollectionTest categoriesFor: #templateTestObject!accessing!public! !
!SSWReStoreGenericCollectionTest categoriesFor: #testCollectionRefreshComponentAddition!public!unit tests! !
!SSWReStoreGenericCollectionTest categoriesFor: #testCollectionRefreshComponentRemoval!public!unit tests! !
!SSWReStoreGenericCollectionTest categoriesFor: #testCollectionRefreshComponentReplace!public! !
!SSWReStoreGenericCollectionTest categoriesFor: #testDependencyCascadedDelete!public!unit tests! !
!SSWReStoreGenericCollectionTest categoriesFor: #testDependencyDeleteOnRemoval!public!unit tests! !
!SSWReStoreGenericCollectionTest categoriesFor: #testDependencyDeleteOnReplacement!public!unit tests! !

!SSWReStoreGenericCollectionTest class methodsFor!

isAbstract

	^self == SSWReStoreGenericCollectionTest! !
!SSWReStoreGenericCollectionTest class categoriesFor: #isAbstract!public! !


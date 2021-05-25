"Filed out from Dolphin Smalltalk 7"!

SSWReStoreGenericNonRelatedCollectionTest subclass: #SSWReStoreNonRelatedDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreNonRelatedDictionaryTest guid: (GUID fromString: '{6b1484b3-f3b4-4662-8187-3564d40dd7d9}')!
SSWReStoreNonRelatedDictionaryTest comment: 'ReStore
©2020 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreNonRelatedDictionaryTest categoriesForClass!Unclassified! !
!SSWReStoreNonRelatedDictionaryTest methodsFor!

addToCollection: aCollection

	^aCollection at: self templateComponent put: self templateComponent!

componentDefinition

	^(Dictionary of: GenericOwnedTest -> GenericOwnedTest)!

remove: anObject fromCollection: aCollection

	^aCollection removeKey: (aCollection keyAtValue: anObject)!

removeFromCollection: aCollection

	^aCollection removeKey: collection keys anyOne!

replaceInCollection: aCollection

	| key old |

	key := aCollection keys anyOne.
	old := aCollection at: key.
	^old -> (aCollection at: key put: self templateComponent)!

templateCollection

	^Dictionary new
		at: self templateComponent put: self templateComponent;
		at: self templateComponent put: self templateComponent;
		at: self templateComponent put: self templateComponent;
		at: self templateComponent put: self templateComponent;
		at: self templateComponent put: self templateComponent;
		yourself!

testDependencyDeleteOnRepeatedRemoval

	"Check that non-dependent collection contents are or are not deleted when removed, as appropriate for the specified relationship (i.e. delete if dependent, otherwise not).
	Reimplemented here since we need to deal with the keys"

	| component id cls oldKey newKey |

	component := collection anyOne.
	id := component _id.
	cls := component class.

	"Add a second occurrence of component"
	oldKey := collection keyAtValue: component.
	newKey := self templateComponent.
	collection at: newKey put: component.
	testObject store.

	reStore simulateReconnect.
	self fetchTestObjects.
	component := (cls storedInstancesIn: reStore) detect: [ :each | each _id = id] ifNone: [nil].
	self assert: component notNil.
	self assert: (collection occurrencesOf: component) equals: 2.

	"Remove one occurrence of component"
	collection removeKey: oldKey.
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

testIncludesAssociation

	| instances existingAssoc template templateKey matches |

	instances := GenericTest storedInstancesIn: reStore.
	existingAssoc := testObject component associations anyOne.
	template := self addToCollection.
	templateKey := testObject component keyAtValue: template.
	self assert: (instances anySatisfy: [ :each | each component includesAssociation: existingAssoc]).
	self deny: (instances anySatisfy: [ :each | each component includesAssociation: (existingAssoc key -> template)]).
	self deny: (instances anySatisfy: [ :each | each component includesAssociation: (templateKey -> existingAssoc value)]).
	self deny: (instances anySatisfy: [ :each | each component includesAssociation: (templateKey -> template)]).

	testObject component removeKey: existingAssoc key.
	testObject store.

	self deny: (instances anySatisfy: [ :each | each component includesAssociation: existingAssoc]).
	self deny: (instances anySatisfy: [ :each | each component includesAssociation: (existingAssoc key -> template)]).
	self deny: (instances anySatisfy: [ :each | each component includesAssociation: (templateKey -> existingAssoc value)]).
	self assert: (instances anySatisfy: [ :each | each component includesAssociation: (templateKey -> template)]).

	matches := instances select: [ :each | each component includesAssociation: (templateKey -> template)].
	self assert: matches size equals: 1.
	self assert: matches first == testObject!

testIncludesKey

	| instances existingKey template templateKey matches |

	instances := GenericTest storedInstancesIn: reStore.
	existingKey := testObject component keys anyOne.
	template := self addToCollection.
	templateKey := testObject component keyAtValue: template.
	self assert: (instances anySatisfy: [ :each | each component includesKey: existingKey]).
	self deny: (instances anySatisfy: [ :each | each component includesKey: templateKey]).

	testObject component removeKey: existingKey.
	testObject store.

	self deny: (instances anySatisfy: [ :each | each component includesKey: existingKey]).
	self assert: (instances anySatisfy: [ :each | each component includesKey: templateKey]).

	matches := instances select: [ :each | each component includesKey: templateKey].
	self assert: matches size equals: 1.
	self assert: matches first == testObject! !
!SSWReStoreNonRelatedDictionaryTest categoriesFor: #addToCollection:!helpers!public! !
!SSWReStoreNonRelatedDictionaryTest categoriesFor: #componentDefinition!accessing!public! !
!SSWReStoreNonRelatedDictionaryTest categoriesFor: #remove:fromCollection:!helpers!private! !
!SSWReStoreNonRelatedDictionaryTest categoriesFor: #removeFromCollection:!helpers!private! !
!SSWReStoreNonRelatedDictionaryTest categoriesFor: #replaceInCollection:!public! !
!SSWReStoreNonRelatedDictionaryTest categoriesFor: #templateCollection!accessing!public! !
!SSWReStoreNonRelatedDictionaryTest categoriesFor: #testDependencyDeleteOnRepeatedRemoval!public! !
!SSWReStoreNonRelatedDictionaryTest categoriesFor: #testIncludesAssociation!public!unit tests! !
!SSWReStoreNonRelatedDictionaryTest categoriesFor: #testIncludesKey!public!unit tests! !


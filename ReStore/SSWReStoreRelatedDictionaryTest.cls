"Filed out from Dolphin Smalltalk 7"!

SSWReStoreGenericRelatedCollectionTest subclass: #SSWReStoreRelatedDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreRelatedDictionaryTest guid: (GUID fromString: '{ae275dac-fa24-402e-9385-4f817aef3ef6}')!
SSWReStoreRelatedDictionaryTest comment: 'ReStore
©2020 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreRelatedDictionaryTest categoriesForClass!Unclassified! !
!SSWReStoreRelatedDictionaryTest methodsFor!

addToCollection: aCollection

	^aCollection at: self templateComponent put: self templateComponent!

componentDefinition

	^(Dictionary of: GenericOwnedTest -> GenericOwnedTest related)!

remove: anObject fromCollection: aCollection

	^aCollection removeKey: (aCollection keyAtValue: anObject)!

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
!SSWReStoreRelatedDictionaryTest categoriesFor: #addToCollection:!helpers!public! !
!SSWReStoreRelatedDictionaryTest categoriesFor: #componentDefinition!accessing!public! !
!SSWReStoreRelatedDictionaryTest categoriesFor: #remove:fromCollection:!helpers!private! !
!SSWReStoreRelatedDictionaryTest categoriesFor: #replaceInCollection:!public! !
!SSWReStoreRelatedDictionaryTest categoriesFor: #templateCollection!accessing!public! !
!SSWReStoreRelatedDictionaryTest categoriesFor: #testDependencyDeleteOnRepeatedRemoval!public! !
!SSWReStoreRelatedDictionaryTest categoriesFor: #testIncludesAssociation!public!unit tests! !
!SSWReStoreRelatedDictionaryTest categoriesFor: #testIncludesKey!public!unit tests! !


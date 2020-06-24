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
!SSWReStoreRelatedDictionaryTest categoriesFor: #addToCollection:!helpers!private! !
!SSWReStoreRelatedDictionaryTest categoriesFor: #componentDefinition!accessing!public! !
!SSWReStoreRelatedDictionaryTest categoriesFor: #remove:fromCollection:!helpers!private! !
!SSWReStoreRelatedDictionaryTest categoriesFor: #replaceInCollection:!public! !
!SSWReStoreRelatedDictionaryTest categoriesFor: #templateCollection!accessing!public! !
!SSWReStoreRelatedDictionaryTest categoriesFor: #testIncludesAssociation!public!unit tests! !
!SSWReStoreRelatedDictionaryTest categoriesFor: #testIncludesKey!public!unit tests! !


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
!SSWReStoreNonRelatedDictionaryTest categoriesFor: #addToCollection:!helpers!private! !
!SSWReStoreNonRelatedDictionaryTest categoriesFor: #componentDefinition!accessing!public! !
!SSWReStoreNonRelatedDictionaryTest categoriesFor: #remove:fromCollection:!helpers!private! !
!SSWReStoreNonRelatedDictionaryTest categoriesFor: #removeFromCollection:!helpers!private! !
!SSWReStoreNonRelatedDictionaryTest categoriesFor: #replaceInCollection:!public! !
!SSWReStoreNonRelatedDictionaryTest categoriesFor: #templateCollection!accessing!public! !
!SSWReStoreNonRelatedDictionaryTest categoriesFor: #testIncludesAssociation!public!unit tests! !
!SSWReStoreNonRelatedDictionaryTest categoriesFor: #testIncludesKey!public!unit tests! !


"Filed out from Dolphin Smallalk"!

SSWReStoreRelatedDictionaryTest subclass: #SSWReStoreRelatedKeyDictionaryTest
	instanceVariableNames: 'inverseDictionary'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreRelatedKeyDictionaryTest guid: (GUID fromString: '{ab1e4d3d-f5f2-4712-a399-996dd4d19986}')!
SSWReStoreRelatedKeyDictionaryTest comment: 'ReStore
©2020 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreRelatedKeyDictionaryTest categoriesForClass!Unclassified! !
!SSWReStoreRelatedKeyDictionaryTest methodsFor!

addToCollection: aCollection

	"We're interested in the key"

	^(self addToCollectionAnsweringAssociation: aCollection) key!

allSatisfy: aBlock

	collection keysDo: [ :each | (aBlock value: each) ifFalse: [^false]].

	^true!

anyOne

	^collection keysDo: [ :key | ^key]!

anySatisfy: aBlock

	collection keysDo: [ :each | (aBlock value: each) ifTrue: [^true]].

	^false!

componentDefinition

	^(Dictionary of: GenericOwnedTest related -> GenericOwnedTest)!

componentDefinitionIsDependent

	"We're interested in the key"

	^self componentDefinition isKeyDependent!

detect: aBlock

	^self detect: aBlock ifNone: [self error: 'not found']
!

detect: aBlock ifNone: absentBlock

	collection keysDo: [ :each | (aBlock value: each) ifTrue: [^each]].

	^absentBlock value!

fetchTestObjects

	super fetchTestObjects.

	inverseDictionary := IdentityDictionary new.

	testObject component keysAndValuesDo: [ :eachKey :eachValue | inverseDictionary at: eachValue put: eachKey]!

includes: anObject

	^(collection includesKey: anObject) or: 
		"For the benefit of tests which change anObject such that its hash changes"
		[collection keysDo: [ :each | each == anObject ifTrue: [^true]].
		false]!

remove: anObject fromCollection: aCollection

	aCollection removeKey: anObject.
	^anObject!

replaceInCollection: aCollection

	"We need to replace a key, not a value"

	| oldKey newKey |

	oldKey := aCollection keys anyOne.
	newKey := self templateComponent.
	aCollection at: newKey put: (aCollection removeKey: oldKey).
	^oldKey -> newKey!

select: aBlock

	^collection keys select: aBlock!

testDependencyDeleteOnRepeatedRemoval

	"Check that non-dependent collection contents are or are not deleted when removed, as appropriate for the specified relationship (i.e. delete if dependent, otherwise not)."

	"Not an appropriate test here since each key can only exist in the collection once"!

testIncludes

	| instances existing template matches |

	instances := GenericTest storedInstancesIn: reStore.
	existing := self anyOne.
	template := self addToCollection.
	self assert: (instances anySatisfy: [ :each | each component includesKey: existing]).
	self deny: (instances anySatisfy: [ :each | each component includesKey: template]).

	self remove: existing fromCollection: testObject component.
	testObject store.

	self deny: (instances anySatisfy: [ :each | each component includesKey: existing]).
	self assert: (instances anySatisfy: [ :each | each component includesKey: template]).

	matches := instances select: [ :each | each component includesKey: template].
	self assert: matches size equals: 1.
	self assert: matches first == testObject! !
!SSWReStoreRelatedKeyDictionaryTest categoriesForMethods!
addToCollection:!helpers!private! !
allSatisfy:!collection behavior!private! !
anyOne!collection behavior!private! !
anySatisfy:!collection behavior!private! !
componentDefinition!accessing!public! !
componentDefinitionIsDependent!private!testing! !
detect:!collection behavior!private! !
detect:ifNone:!collection behavior!private! !
fetchTestObjects!public! !
includes:!collection behavior!private! !
remove:fromCollection:!helpers!private! !
replaceInCollection:!helpers!private! !
select:!collection behavior!private! !
testDependencyDeleteOnRepeatedRemoval!public!unit tests! !
testIncludes!public!unit tests! !
!


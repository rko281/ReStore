"Filed out from Dolphin Smalltalk"!

SSWDBStaticCollectionSpec subclass: #SSWDBHashedStaticCollectionSpec
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBHashedStaticCollectionSpec guid: (GUID fromString: '{de3c7377-1752-44cc-b5bc-de20393a120d}')!
SSWDBHashedStaticCollectionSpec comment: ''!
!SSWDBHashedStaticCollectionSpec categoriesForClass!Unclassified! !
!SSWDBHashedStaticCollectionSpec methodsFor!

changesTo: aCollection from: aCollectionOfEntries

	"Return the changes made to aCollection compared to aCollectionOf(Collection)Entries"

	^self shouldCompareChangesByEquality
		ifTrue: [self equalityChangesTo: aCollection from: aCollectionOfEntries]
		ifFalse: [self identityChangesTo: aCollection from: aCollectionOfEntries]!

equalityChangesTo: aCollection from: aCollectionOfEntries

	"Return the changes made to aCollection compared to aCollectionOf(Collection)Entries, comparing via equality (=)"

	| changes previous |

	changes := OrderedCollection new.
	previous := aCollectionOfEntries collect: [ :entry | entry target].

	aCollection do: [ :each | (previous includes: each) ifFalse: [changes add: (SSWDBCollectionAddition added: each)]].
	aCollectionOfEntries do: [ :entry | (aCollection includes: entry target) ifFalse: [changes add: (SSWDBCollectionRemoval newWithEntry: entry)]].

	^changes!

identityChangesTo: aCollection from: aCollectionOfEntries

	"Return the changes made to aCollection compared to aCollectionOf(Collection)Entries, comparing via identity (==)"

	| changes previous |

	changes := OrderedCollection new.
	previous := aCollectionOfEntries collect: [ :entry | entry target].

	aCollection do: [ :each | (previous identityIncludes: each) ifFalse: [changes add: (SSWDBCollectionAddition added: each)]].
	aCollectionOfEntries do: [ :entry | (aCollection identityIncludes: entry target) ifFalse: [changes add: (SSWDBCollectionRemoval newWithEntry: entry)]].

	^changes! !
!SSWDBHashedStaticCollectionSpec categoriesForMethods!
changesTo:from:!change detection!public! !
equalityChangesTo:from:!change detection!private! !
identityChangesTo:from:!change detection!private! !
!


"Filed out from Dolphin Smallalk"!

SSWDBOrderedStaticCollectionSpec subclass: #SSWDBArrayedStaticCollectionSpec
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBArrayedStaticCollectionSpec guid: (GUID fromString: '{9461d4ef-ebd4-442a-a688-1692954e5588}')!
SSWDBArrayedStaticCollectionSpec comment: ''!
!SSWDBArrayedStaticCollectionSpec categoriesForClass!Unclassified! !
!SSWDBArrayedStaticCollectionSpec methodsFor!

equalityChangesTo: aCollection from: aCollectionOfEntries

	"Return the changes made to aCollection compared to aCollectionOf(Collection)Entries, comparing via equality (=).
	For an array, there are no additions or removals - just updates"

	| entriesSize changes |

	entriesSize := aCollectionOfEntries size. 
	changes := OrderedCollection new: (aCollection size // 10).

	aCollection keysAndValuesDo:
		[ :index :each || entry |
		index > entriesSize
		ifTrue:
			[each isNil ifFalse: [changes add: (SSWDBCollectionAddition added: each at: index)]]
		ifFalse:
			[entry := aCollectionOfEntries at: index.
			entry target = each ifFalse: [changes add: (SSWDBCollectionUpdate entry: entry newTarget: each)]]].

	^changes!

identityChangesTo: aCollection from: aCollectionOfEntries

	"Return the changes made to aCollection compared to aCollectionOf(Collection)Entries, comparing via identity (==).
	For an array, there are no additions or removals - just updates"

	| entriesSize changes |

	entriesSize := aCollectionOfEntries size. 
	changes := OrderedCollection new: (aCollection size // 10).

	aCollection keysAndValuesDo:
		[ :index :each || entry |
		index > entriesSize
		ifTrue:
			[each isNil ifFalse: [changes add: (SSWDBCollectionAddition added: each at: index)]]
		ifFalse:
			[entry := aCollectionOfEntries at: index.
			entry target == each ifFalse: [changes add: (SSWDBCollectionUpdate entry: entry newTarget: each)]]].

	^changes! !
!SSWDBArrayedStaticCollectionSpec categoriesForMethods!
equalityChangesTo:from:!change detection!private! !
identityChangesTo:from:!change detection!private! !
!


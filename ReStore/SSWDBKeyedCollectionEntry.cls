"Filed out from Dolphin Smalltalk"!

SSWDBCollectionEntry subclass: #SSWDBKeyedCollectionEntry
	instanceVariableNames: 'index'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBKeyedCollectionEntry guid: (GUID fromString: '{5a3e3dca-3990-11d5-b1df-444553540000}')!
SSWDBKeyedCollectionEntry comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBKeyedCollectionEntry categoriesForClass!Unclassified! !
!SSWDBKeyedCollectionEntry methodsFor!

addTargetTo: aCollection

	aCollection _dbAdd: self target suggestedIndex: self index!

copyTargetTo: aCollection

	self hasMutableIndex 
	ifTrue: 
		[self hasMutableTarget
			ifTrue: [aCollection _dbAdd: self target copy suggestedIndex: self index copy]
			ifFalse: [aCollection _dbAdd: self target suggestedIndex: self index copy]]
	ifFalse:
		[aCollection _dbAdd: self target copy suggestedIndex: self index]!

hasMutableIndex

	^self index class isMutableDirectlyPersistedNonBaseClass!

index

	"index stores the index (key) of the target object in the collection"
	
	^index!

index: anInteger

	"index stores the index (key) of the target object in the collection"
	
	index := anInteger!

prepareToCommitFor: anSSWDBCachingCollectionProxy

	^self index _ensureActiveIn: anSSWDBCachingCollectionProxy _reStore
! !
!SSWDBKeyedCollectionEntry categoriesForMethods!
addTargetTo:!actions!public! !
copyTargetTo:!actions!public! !
hasMutableIndex!public!testing! !
index!accessing!public! !
index:!accessing!public! !
prepareToCommitFor:!actions!public! !
!

!SSWDBKeyedCollectionEntry class methodsFor!

dbTableNamed: aString in: anSSWReStore

	| table |

	table := super dbTableNamed: aString in: anSSWReStore.
	
	(table define: #index as: Integer) name: (anSSWReStore sqlDialect transformInstVarName: #index_).
		
	^table! !
!SSWDBKeyedCollectionEntry class categoriesForMethods!
dbTableNamed:in:!persistence!public! !
!


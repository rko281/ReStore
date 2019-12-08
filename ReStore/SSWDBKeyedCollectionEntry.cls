"Filed out from Dolphin Smalltalk 7"!

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

	aCollection directAdd: self target suggestedIndex: self index!

index

	"index stores the index (key) of the target object in the collection"
	
	^index!

index: anInteger

	"index stores the index (key) of the target object in the collection"
	
	index := anInteger!

prepareToCommitFor: anSSWDBCachingCollectionProxy

	^self index _ensureActiveIn: anSSWDBCachingCollectionProxy _reStore
! !
!SSWDBKeyedCollectionEntry categoriesFor: #addTargetTo:!actions!public! !
!SSWDBKeyedCollectionEntry categoriesFor: #index!accessing!public! !
!SSWDBKeyedCollectionEntry categoriesFor: #index:!accessing!public! !
!SSWDBKeyedCollectionEntry categoriesFor: #prepareToCommitFor:!actions!public! !

!SSWDBKeyedCollectionEntry class methodsFor!

dbTableNamed: aString in: anSSWReStore

	| table |

	table := super dbTableNamed: aString in: anSSWReStore.
	
	(table define: #index as: Integer) name: (anSSWReStore sqlDialect transformInstVarName: #index_).
		
	^table! !
!SSWDBKeyedCollectionEntry class categoriesFor: #dbTableNamed:in:!persistence!public! !


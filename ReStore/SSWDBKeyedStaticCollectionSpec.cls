"Filed out from Dolphin Smalltalk 7"!

SSWDBStaticCollectionSpec subclass: #SSWDBKeyedStaticCollectionSpec
	instanceVariableNames: 'indexField updateIndexStatement'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBKeyedStaticCollectionSpec guid: (GUID fromString: '{4648dc63-a6b1-11d5-b1e0-444553540000}')!
SSWDBKeyedStaticCollectionSpec comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBKeyedStaticCollectionSpec categoriesForClass!Unclassified! !
!SSWDBKeyedStaticCollectionSpec methodsFor!

entryClass

	"Return the class of collection entry appropriate for the receiver"
	
	^SSWDBKeyedCollectionEntry!

freePreparedStatements

	updateIndexStatement notNil ifTrue: 
		[updateIndexStatement free.
		updateIndexStatement := nil].

	super freePreparedStatements!

indexField

	"indexField stores the SSWDBField in the receiver's collectionTable
	that holds the index of the elements"
	
	indexField == nil ifTrue: [indexField := self collectionTable fieldAccessing: #index].
	
	^indexField!

indexField: anSSWDBField

	"indexField stores the SSWDBField in the receiver's collectionTable
	that holds the index of the elements"
	
	indexField := anSSWDBField!

updateEntry: anSSWDBCollectionEntry withIndex: anInteger in: anSSWReStore 

	| query |

	query := SSWSQLUpdateObjectQuery 
			forObject: anSSWDBCollectionEntry
			withUpdates: 
				(SSWSQLFieldAssignmentCollection with:
					(SSWSQLFieldAssignment 
						field: self indexField
						value: anInteger)).

	(updateIndexStatement ifNil: [updateIndexStatement := anSSWReStore prepareStatementForQuery: query])
		values: query values;
		exec! !
!SSWDBKeyedStaticCollectionSpec categoriesFor: #entryClass!constants!public! !
!SSWDBKeyedStaticCollectionSpec categoriesFor: #freePreparedStatements!initialize/release!public! !
!SSWDBKeyedStaticCollectionSpec categoriesFor: #indexField!accessing!public! !
!SSWDBKeyedStaticCollectionSpec categoriesFor: #indexField:!accessing!public! !
!SSWDBKeyedStaticCollectionSpec categoriesFor: #updateEntry:withIndex:in:!actions - api!public! !


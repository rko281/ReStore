"Filed out from Dolphin Smalltalk 7"!

SSWDBKeyedStaticCollectionSpec subclass: #SSWDBOrderedStaticCollectionSpec
	instanceVariableNames: 'updateTargetStatement'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBOrderedStaticCollectionSpec guid: (GUID fromString: '{266e4dd4-398e-11d5-b1df-444553540000}')!
SSWDBOrderedStaticCollectionSpec comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBOrderedStaticCollectionSpec categoriesForClass!Unclassified! !
!SSWDBOrderedStaticCollectionSpec methodsFor!

dbInstancesFor: aCollectionProxy

	"Add the ordering"

	| instances |

	instances := super dbInstancesFor: aCollectionProxy.
	instances parser orderingSpecs: (Array with: (SSWDBOrderingSpec ascending: (self collectionTable fieldAccessing: #index))).

	^instances!

freePreparedStatements

	updateTargetStatement notNil ifTrue: 
		[updateTargetStatement free.
		updateTargetStatement := nil].

	super freePreparedStatements!

queryClass

	"Return the class of select query appropriate for the receiver"
	
	^SSWSQLOrderedSelectQuery!

selectQueryIn: anSSWReStore

	"Always SELECT in ascending order"
	
	^(super selectQueryIn: anSSWReStore)
		orderAscendingBy: (self collectionTable fieldAccessing: #index);
		yourself!

updateEntry: anSSWDBCollectionEntry withTarget: aProxy in: anSSWReStore 

	| query |

	query := SSWSQLUpdateObjectQuery 
			forObject: anSSWDBCollectionEntry
			withUpdates: 
				(SSWSQLFieldAssignmentCollection with:
					(SSWSQLFieldAssignment 
						field: self targetField
						value: aProxy)).

	(updateTargetStatement ifNil: [updateTargetStatement := anSSWReStore prepareStatementForQuery: query])
		values: query values;
		exec! !
!SSWDBOrderedStaticCollectionSpec categoriesFor: #dbInstancesFor:!accessing:derived!public! !
!SSWDBOrderedStaticCollectionSpec categoriesFor: #freePreparedStatements!initialize/release!public! !
!SSWDBOrderedStaticCollectionSpec categoriesFor: #queryClass!constants!public! !
!SSWDBOrderedStaticCollectionSpec categoriesFor: #selectQueryIn:!accessing:derived!public! !
!SSWDBOrderedStaticCollectionSpec categoriesFor: #updateEntry:withTarget:in:!actions - api!public! !


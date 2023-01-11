"Filed out from Dolphin Smalltalk"!

SSWDBKeyedStaticCollectionSpec subclass: #SSWDBOrderedStaticCollectionSpec
	instanceVariableNames: ''
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

queryClass

	"Return the class of select query appropriate for the receiver"
	
	^SSWSQLOrderedSelectQuery!

selectQueryIn: anSSWReStore

	"Always SELECT in ascending order"
	
	^(super selectQueryIn: anSSWReStore)
		orderAscendingBy: (self collectionTable fieldAccessing: #index);
		yourself! !
!SSWDBOrderedStaticCollectionSpec categoriesForMethods!
dbInstancesFor:!accessing:derived!public! !
queryClass!constants!public! !
selectQueryIn:!accessing:derived!public! !
!


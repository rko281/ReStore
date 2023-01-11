"Filed out from Dolphin Smalltalk"!

SSWSQLObjectQuery subclass: #SSWSQLUpdateObjectQuery
	instanceVariableNames: 'fieldUpdates'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLUpdateObjectQuery guid: (GUID fromString: '{6266c930-3983-11d5-b1df-444553540000}')!
SSWSQLUpdateObjectQuery comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLUpdateObjectQuery categoriesForClass!Unclassified! !
!SSWSQLUpdateObjectQuery methodsFor!

fieldUpdates

	"fieldUpdates stores an SSWSQLFieldCollection of SSWSQLConditions that
	define the updates to be written by the receiver"
	
	^fieldUpdates!

fieldUpdates: anSSWSQLFieldCollection 

	"fieldUpdates stores an SSWSQLFieldCollection of SSWSQLConditions that
	define the updates to be written by the receiver"
	
	fieldUpdates := anSSWSQLFieldCollection !

parameterisedFields

	"UPDATE table SET updatedFields TO updatedValues WHERE objectIDCondition AND objectControlConditions"

	^self updatedFields
		add: self table idField;
		addAll: (self table controlFields reject: [ :each | (each accessor valueIn: self object) isNil]);
		yourself!

updatedFields

	| updatedFields |

	updatedFields := SSWSQLFieldCollection new: (self fieldUpdates size + 2).

	self fieldUpdates do: [ :each | updatedFields add: each field].

	^updatedFields!

updatedValues

	| updatedValues |

	updatedValues := SSWSQLFieldCollection new: (self fieldUpdates size + 2).

	self fieldUpdates do: [ :each | updatedValues add: each value].

	^updatedValues!

values

	"UPDATE table SET updatedFields TO updatedValues WHERE objectIDCondition AND objectControlConditions"

	| parameterisedValues |

	parameterisedValues := self updatedValues.

	parameterisedValues add: self object _id.
	self objectControlConditions do: [ :each | each value ifNotNil: [ :value | parameterisedValues add: value]].

	^parameterisedValues!

writeSQLOn: aStream

	aStream nextPutAll: 'UPDATE '.
	self table writeSQLOn: aStream.
	
	aStream nextPutAll: ' SET '.
	self fieldUpdates writeSQLOn: aStream.
	
	aStream nextPutAll: ' WHERE '.
	(self objectIDCondition sqlAnd: self objectControlConditions) writeSQLOn: aStream! !
!SSWSQLUpdateObjectQuery categoriesForMethods!
fieldUpdates!accessing!public! !
fieldUpdates:!accessing!public! !
parameterisedFields!accessing!public! !
updatedFields!accessing!public! !
updatedValues!accessing!public! !
values!accessing!public! !
writeSQLOn:!output!public! !
!

!SSWSQLUpdateObjectQuery class methodsFor!

forObject: aProxydObject withUpdates: anSSWSQLCollection

	^(super forObject: aProxydObject)
		fieldUpdates: anSSWSQLCollection;
		yourself! !
!SSWSQLUpdateObjectQuery class categoriesForMethods!
forObject:withUpdates:!instance creation!public! !
!


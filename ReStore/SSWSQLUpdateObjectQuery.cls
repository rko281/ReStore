"Filed out from Dolphin Smalltalk 7"!

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
		addAll: self table controlFields;
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
	self objectControlConditions do: [ :each | parameterisedValues add: each value].

	^parameterisedValues!

writeSQLOn: aStream

	aStream nextPutAll: 'UPDATE '.
	self table writeSQLOn: aStream.
	
	aStream nextPutAll: ' SET '.
	self fieldUpdates writeSQLOn: aStream.
	
	aStream nextPutAll: ' WHERE '.
	(self objectIDCondition sqlAnd: self objectControlConditions) writeSQLOn: aStream! !
!SSWSQLUpdateObjectQuery categoriesFor: #fieldUpdates!accessing!public! !
!SSWSQLUpdateObjectQuery categoriesFor: #fieldUpdates:!accessing!public! !
!SSWSQLUpdateObjectQuery categoriesFor: #parameterisedFields!accessing!public! !
!SSWSQLUpdateObjectQuery categoriesFor: #updatedFields!accessing!public! !
!SSWSQLUpdateObjectQuery categoriesFor: #updatedValues!accessing!public! !
!SSWSQLUpdateObjectQuery categoriesFor: #values!accessing!public! !
!SSWSQLUpdateObjectQuery categoriesFor: #writeSQLOn:!output!public! !

!SSWSQLUpdateObjectQuery class methodsFor!

forObject: aProxydObject withUpdates: anSSWSQLCollection

	^(super forObject: aProxydObject)
		fieldUpdates: anSSWSQLCollection;
		yourself! !
!SSWSQLUpdateObjectQuery class categoriesFor: #forObject:withUpdates:!instance creation!public! !


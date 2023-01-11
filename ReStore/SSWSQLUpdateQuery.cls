"Filed out from Dolphin Smalltalk"!

SSWSQLConditionalQuery subclass: #SSWSQLUpdateQuery
	instanceVariableNames: 'fieldUpdates'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLUpdateQuery guid: (GUID fromString: '{6266c936-3983-11d5-b1df-444553540000}')!
SSWSQLUpdateQuery comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLUpdateQuery categoriesForClass!Unclassified! !
!SSWSQLUpdateQuery methodsFor!

fieldUpdates

	"fieldUpdates stores an SSWSQLFieldCollection of SSWSQLConditions that
	define the updates to be written by the receiver"
	
	^fieldUpdates!

fieldUpdates: anSSWSQLFieldCollection 

	"fieldUpdates stores an SSWSQLFieldCollection of SSWSQLConditions that
	define the updates to be written by the receiver"
	
	fieldUpdates := anSSWSQLFieldCollection !

isWriteQuery

	^true!

parameterisedFields

	| parameterisedFields |

	parameterisedFields := OrderedCollection new.

	self fieldUpdates do:
		[ :fieldUpdate |
		fieldUpdate value == SSWSQLQueryParameter ifTrue: [parameterisedFields add: fieldUpdate field]].

	^parameterisedFields, super parameterisedFields!

writeSQLOn: aStream

	aStream nextPutAll: 'UPDATE '.
	self table writeSQLOn: aStream.
	
	aStream nextPutAll: ' SET '.
	self fieldUpdates writeSQLOn: aStream.
	
	self writeWhereClauseOn: aStream! !
!SSWSQLUpdateQuery categoriesForMethods!
fieldUpdates!accessing!public! !
fieldUpdates:!accessing!public! !
isWriteQuery!public!testing! !
parameterisedFields!evaluating!public! !
writeSQLOn:!output!public! !
!


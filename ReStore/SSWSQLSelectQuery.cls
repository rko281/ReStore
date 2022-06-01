"Filed out from Dolphin Smallalk"!

SSWSQLConditionalQuery subclass: #SSWSQLSelectQuery
	instanceVariableNames: 'fields fieldAliases'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLSelectQuery guid: (GUID fromString: '{6266c934-3983-11d5-b1df-444553540000}')!
SSWSQLSelectQuery comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLSelectQuery categoriesForClass!Unclassified! !
!SSWSQLSelectQuery methodsFor!

actualFields

	"If the receiver represents the selection of all fields from multiple tables, 
	then special fields must be used"

	^(self fields isAll and: [self tables size > 1])
		ifTrue: [self tables inject: (SSWSQLFieldCollection new: 16) into: [ :allFields :table | allFields addAll: table allFields; yourself]]
		ifFalse: [self fields]!

asAggregatedQuery

	| aggregated |

	aggregated := SSWSQLAggregatedOrderedSelectQuery new.

	1 to: self class instSize do: [ :index | aggregated instVarAt: index put: (self instVarAt: index)].

	^aggregated!

field: anSSWDBField

	"Set a single field as the result field for the receiver"

	^self fields: (SSWSQLFieldCollection with: anSSWDBField)!

fieldAliases

	"fieldAliases stores an IdentityDictionary mapping SSWSQLFields to an aliased name
	assigned to that field by the receiver"

	^fieldAliases!

fieldAliases: anIdentityDictionary

	"fieldAliases stores an IdentityDictionary mapping SSWSQLFields to an aliased name
	assigned to that field by the receiver"

	fieldAliases := anIdentityDictionary!

fieldNamed: aString

	"Return the field with the given name (which must be an alias if the receiver has fieldAliases)"

	^self fieldAliases isNil
		ifTrue: [self actualFields fieldNamed: aString]
		ifFalse: [self fieldWithAlias: aString]!

fields

	"fields stores the collection of SSWSQLFields read by the receiver.
	This is stored as an SSWSQLFieldCollection"
	
	^fields!

fields: anSSWSQLFieldCollection

	"fields stores the collection of SSWSQLFields read by the receiver.
	This is stored as an SSWSQLFieldCollection"
	
	fields := anSSWSQLFieldCollection!

fieldWithAlias: aString

	"Return the field with the given name (which must be an alias if the receiver has fieldAliases)"

	self fieldAliases keysAndValuesDo: [ :field :alias | alias = aString ifTrue: [^field]].

	^nil!

hasOrdering

	^false!

isReadQuery

	^true!

preExecIn: anSSWReStore

	"The receiver is about to be executed in anSSWReStore.
	Carry out pre-exec validation"

	"If querying for generalised all fields in one table, replace with the true 'all fields in table' object"
	(self tables size = 1 and: [self fields isAll]) ifTrue:
		[self fields: (SSWSQLTableAllFields forTable: self table)].

	"Ensure that the tables used are the correct 'full' versions for querying"
	self tables: 
		(self tables collect: 
			[ :queryTable|| fullTable |
			fullTable := queryTable withAllFields.
			(self fields isAllInTable and: [self fields table == queryTable]) ifTrue: [self fields table: fullTable].
			fullTable])!

writeSQLOn: aStream

	aStream nextPutAll: 'SELECT '.

	(self tables size > 1 or: [self fields requiresAliasing])
	ifTrue: 
		[self actualFields writeAliasedSQLOn: aStream.
		aStream fieldAliases isEmpty ifFalse: [self fieldAliases: aStream fieldAliases]]
	ifFalse: 
		[self actualFields writeSQLOn: aStream.
		self fieldAliases: nil].
	
	aStream nextPutAll: ' FROM '.
	self tables writeSQLOn: aStream.

	self writeWhereClauseOn: aStream! !
!SSWSQLSelectQuery categoriesForMethods!
actualFields!accessing - derived!public! !
asAggregatedQuery!converting!public! !
field:!accessing - derived!public! !
fieldAliases!accessing!public! !
fieldAliases:!accessing!public! !
fieldNamed:!accessing - derived!public! !
fields!accessing!public! !
fields:!accessing!public! !
fieldWithAlias:!accessing - derived!private! !
hasOrdering!public!testing! !
isReadQuery!public!testing! !
preExecIn:!operations!public! !
writeSQLOn:!output!public! !
!

!SSWSQLSelectQuery class methodsFor!

new

	^super new
		fields: SSWSQLFieldCollection new;
		yourself! !
!SSWSQLSelectQuery class categoriesForMethods!
new!instance creation!public! !
!


"Filed out from Dolphin Smalltalk"!

Object subclass: #SSWDBQueryTable
	instanceVariableNames: 'table repetitionIndex allFields'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBQueryTable guid: (GUID fromString: '{266e4dcb-398e-11d5-b1df-444553540000}')!
SSWDBQueryTable comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBQueryTable categoriesForClass!Unclassified! !
!SSWDBQueryTable methodsFor!

= anSSWDBTable

	^self == anSSWDBTable or: [self species == anSSWDBTable species and: [self name = anSSWDBTable name and: [self repetitionIndex = anSSWDBTable repetitionIndex]]]!

allFields

	^allFields ifNil: [allFields := self table allFields collect: [ :each | SSWDBQueryTableField forField: each in: self]]!

allFieldsDetect: aBlock ifNone: noneBlock

	^self allFields detect: aBlock ifNone: noneBlock!

allFieldsDo: aBlock

	^self allFields do: aBlock!

collectionAccessing: aSymbol

	"Forward to the real table"
	
	^self table collectionAccessing: aSymbol!

fieldAccessing: aSymbol

	^self allFieldsDetect: [ :field | field accesses: aSymbol] ifNone: [nil]!

fieldNamed: aString

	^self allFieldsDetect: [ :field | field name = aString] ifNone: [nil]!

hash

	^self name hash bitXor: self repetitionIndex!

hasNamespace

	^self table hasNamespace!

hasStaticConditions

	"Forward to the real table"
	
	^self table hasStaticConditions!

idField

	^self allFields detect: [ :each | each field == self table idField]!

instanceClass

	^self table instanceClass!

instanceClassFromRow: aRow

	"isKindOf: test to avoid aliasing the row if not needed"
	^(self table isKindOf: SSWDBInheritedTable)
		ifTrue: [self instanceClass]
		ifFalse: [self table instanceClassFromRow: (aRow copy deAliasQueryFieldsFor: self)]!

name

	^self table name!

originalTable

	"Return the original table wrapped by the receiver.
	This may be == self table, however where the receiver wraps a withAllFields table it will be different"

	^self reStore tableForClass: self instanceClass!

recoverInstanceFromRow: aRow into: aDBProxy

	^self originalTable recoverInstanceFromRow: (aRow copy deAliasQueryFieldsFor: self) into: aDBProxy!

refreshProxy: aDBProxy whereChangedFromRow: aRow

	^self originalTable refreshProxy: aDBProxy whereChangedFromRow: (aRow copy deAliasQueryFieldsFor: self)!

repetitionIndex

	"repetitionIndex specifies which repetition of the receiver's table the receiver replaces.
	e.g. the first repetition (second occurrence) has a repetitionIndex of 1"
	
	^repetitionIndex!

repetitionIndex: anInteger

	"repetitionIndex specifies which repetition of the receiver's table the receiver replaces.
	e.g. the first repetition (second occurrence) has a repetitionIndex of 1"
	
	repetitionIndex := anInteger!

reStore

	^self table reStore!

sqlAndStaticConditionsWith: anSQLConditionCollection

	"Created for issue 120-015

	Return the receiver's staticConditions ANDed with anSQLConditionCollection"
	
	"The receiver's staticConditions are redundant if there is a unique ID condition"
	^(anSQLConditionCollection anySatisfy: [ :cond | cond field = self idField and: [cond operator isEquality and: [cond value notNil]]]) 
		ifTrue: [anSQLConditionCollection]
		ifFalse: [self staticConditions sqlAnd: anSQLConditionCollection]!

sqlDialect

	^self table sqlDialect!

staticConditions

	"Created for issue 120-015

	Copy from the table"

	^self table staticConditions copyForQueryTable: self!

table

	"The receiver is created to stand in place of a regular SSWDBTable when 
	that table is referenced more than once in a query (in different roles).
	The second (third, fourth...) occurrences are replaced by instances of the receiver's class.
	
	table stores the original table which the receiver is standing in place of"
	
	^table!

table: anSSWDBTable

	"The receiver is created to stand in place of a regular SSWDBTable when 
	that table is referenced more than once in a query (in different roles).
	The second (third, fourth...) occurrences are replaced by instances of the receiver's class.
	
	table stores the original table which the receiver is standing in place of"
	
	table := anSSWDBTable!

versionControlField

	| versionControlField |

	versionControlField := self table versionControlField.

	^self allFields detect: [ :each | each field == versionControlField]!

withAllFields

	self table: self table withAllFields.
	^self
!

writeSQLNameOn: aStream

	"Append to aStream a name for the receiver based on the repetitionIndex.
	This should be unique within any query the receiver is involved in"
	
	aStream nextPutAliasedTable: self!

writeSQLOn: aStream

	"Alias the actual table name if necessary"
		
	self table writeSQLNameOn: aStream.

	self repetitionIndex > 0 ifTrue:
		[aStream nextPutAll: ' AS '.
		self writeSQLNameOn: aStream]! !
!SSWDBQueryTable categoriesForMethods!
=!comparing!public! !
allFields!accessing!public! !
allFieldsDetect:ifNone:!enumerating!public! !
allFieldsDo:!enumerating!public! !
collectionAccessing:!evaluating!public! !
fieldAccessing:!evaluating!public! !
fieldNamed:!accessing!public! !
hash!comparing!public! !
hasNamespace!public!testing! !
hasStaticConditions!public!testing! !
idField!accessing!public! !
instanceClass!accessing!public! !
instanceClassFromRow:!accessing!public! !
name!accessing!public! !
originalTable!accessing!public! !
recoverInstanceFromRow:into:!operations!public! !
refreshProxy:whereChangedFromRow:!operations!public! !
repetitionIndex!accessing!public! !
repetitionIndex:!accessing!public! !
reStore!accessing!public! !
sqlAndStaticConditionsWith:!accessing!public! !
sqlDialect!accessing!public! !
staticConditions!accessing!public! !
table!accessing!public! !
table:!accessing!public! !
versionControlField!accessing!public! !
withAllFields!accessing!public! !
writeSQLNameOn:!output!public! !
writeSQLOn:!output!public! !
!

!SSWDBQueryTable class methodsFor!

forRepetition: anInteger of: anSSWDBTable

	^self new
		table: anSSWDBTable;
		repetitionIndex: anInteger;
		yourself! !
!SSWDBQueryTable class categoriesForMethods!
forRepetition:of:!instance creation!public! !
!


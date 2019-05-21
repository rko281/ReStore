"Filed out from Dolphin Smalltalk 7"!

SSWSQLDialect subclass: #SSWSQLiteDialect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLiteDialect guid: (GUID fromString: '{d86fd87d-a409-4be4-84bf-0fdcf5dfd249}')!
SSWSQLiteDialect comment: ''!
!SSWSQLiteDialect categoriesForClass!Unclassified! !
!SSWSQLiteDialect methodsFor!

decimal

	^'NUMERIC'!

defaultDateTimeResolution

	^3!

dialectSpecificFunctions

	^##(Dictionary new
		at: #size put: 'LENGTH(%1)';
		at: #midString:from: put: 'SUBSTR(%1,%3,%2)';
		yourself)!

dropColumnNamed: colString fromTable: anSSWDBTable in: anSSWReStore

	"No explicit drop column support"

	| otherFields tempTable |

	tempTable := anSSWDBTable copy.
	tempTable name: 'tmp_'.

	(tempTable dataFields detect: [ :field | field name = colString] ifNone: [nil]) ifNotNil: [ :field | tempTable dataFields: (tempTable dataFields copyWithout: field)].
	(tempTable controlFields detect: [ :field | field name = colString] ifNone: [nil]) ifNotNil: [ :field | tempTable controlFields: (tempTable controlFields copyWithout: field)].

	otherFields := anSSWDBTable allFields reject: [ :field | field name = colString].

	"ID field should always comes first"
	otherFields remove: anSSWDBTable idField ifAbsent: [].
	otherFields addFirst: anSSWDBTable idField.

	anSSWReStore
		executeSQL: tempTable sqlDefinition;
		executeSQL: ('INSERT INTO %1 SELECT %2 FROM %3' formatWith: tempTable name with: (otherFields sqlStringIn: anSSWReStore) with: anSSWDBTable name);
		executeSQL: ('DROP TABLE %1' formatWith: anSSWDBTable name);
		executeSQL: ('ALTER TABLE %1 RENAME TO %2' formatWith: tempTable name with: anSSWDBTable name)!

shouldMaskSuccessWithInfo

	^true!

shouldRollbackOnQuery

	"Seems to be required to avoid locking issues"

	^true!

shouldUseColumnsStatement

	"Under the SQLite ODBC driver DBColumnsStatement returns the character length for wide string columns, rather than the buffer length.
	Column details returned from a SELECT * query report the buffer length correctly"

	^false! !
!SSWSQLiteDialect categoriesFor: #decimal!datatypes!public! !
!SSWSQLiteDialect categoriesFor: #defaultDateTimeResolution!constants!public! !
!SSWSQLiteDialect categoriesFor: #dialectSpecificFunctions!constants!public! !
!SSWSQLiteDialect categoriesFor: #dropColumnNamed:fromTable:in:!maintenance!public! !
!SSWSQLiteDialect categoriesFor: #shouldMaskSuccessWithInfo!public!testing! !
!SSWSQLiteDialect categoriesFor: #shouldRollbackOnQuery!public!testing! !
!SSWSQLiteDialect categoriesFor: #shouldUseColumnsStatement!public!testing! !

!SSWSQLiteDialect class methodsFor!

dbmsName

	^'SQLITE'! !
!SSWSQLiteDialect class categoriesFor: #dbmsName!constants!public! !


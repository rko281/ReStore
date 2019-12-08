"Filed out from Dolphin Smalltalk 7"!

SSWSQLDialect subclass: #SSWSQLiteDialect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLiteDialect guid: (GUID fromString: '{d86fd87d-a409-4be4-84bf-0fdcf5dfd249}')!
SSWSQLiteDialect comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLiteDialect categoriesForClass!Unclassified! !
!SSWSQLiteDialect methodsFor!

alterField: aField table: aTable in: aReStore

	"No direct support in SQLite - workaround:
		CREATE TEMPORARY TABLE t1_backup(a,b);
		INSERT INTO t1_backup SELECT a,b FROM t1;
		DROP TABLE t1;
		CREATE TABLE t1(a,b);
		INSERT INTO t1 SELECT a,b FROM t1_backup;
		DROP TABLE t1_backup;"

	| fieldNamesStream tempTable tempTableDefinition |

	fieldNamesStream := self sqlWriteStream.
	aTable allFields do: [ :each | fieldNamesStream nextPutIdentifier: each name] separatedBy: [fieldNamesStream nextPut: $,].

	tempTable := aTable copy.
	tempTable name: (tempTable name, '_tmp_').
	tempTableDefinition := tempTable sqlDefinition.
	tempTableDefinition := 'CREATE TEMPORARY TABLE', (tempTableDefinition allButFirst: 'CREATE TABLE' size).

	aReStore 
		executeSQL: tempTableDefinition;
		executeSQL: ('INSERT INTO <1s> SELECT <2s> FROM <3s>' expandMacrosWith: (self asIdentifier: tempTable name) with: fieldNamesStream contents with: (self asIdentifier: aTable name));
		executeSQL: ('DROP TABLE ', aTable name);
		executeSQL: aTable sqlDefinition;
		executeSQL: ('INSERT INTO <1s> SELECT <2s> FROM <3s>' expandMacrosWith: (self asIdentifier: aTable name) with: fieldNamesStream contents with: (self asIdentifier: tempTable name));
		executeSQL: ('DROP TABLE ', (self asIdentifier: tempTable name))!

decimal

	^'NUMERIC'!

defaultDateTimeResolution

	^3!

defaultMaxColumnNameLength

	^255!

defaultMaxTableNameLength

	^255!

dialectSpecificFunctions

	^Dictionary new
		at: #size put: 'LENGTH(%1)' asSQLFunctionIntegerResult;
		at: #midString:from: put: 'SUBSTR(%1,%3,%2)' asSQLFunction;
		yourself!

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
		executeSQLFrom: [ :stream | stream nextPutAll: 'INSERT INTO '; nextPutIdentifier: tempTable name; nextPutAll: ' SELECT '. otherFields writeSQLOn: stream. stream nextPutAll: ' FROM '; nextPutIdentifier: anSSWDBTable name];
		executeSQLFrom: [ :stream | stream nextPutAll: 'DROP TABLE '; nextPutIdentifier: anSSWDBTable name];
		executeSQLFrom: [ :stream | stream nextPutAll: 'ALTER TABLE '; nextPutIdentifier: tempTable name; nextPutAll: ' RENAME TO '; nextPutIdentifier: anSSWDBTable name]!

shouldMaskSuccessWithInfo

	^true!

shouldRollbackOnQuery

	"Seems to be required to avoid locking issues"

	^true!

shouldUseColumnsStatement

	"Under the SQLite ODBC driver DBColumnsStatement returns the character length for wide string columns, rather than the buffer length.
	Column details returned from a SELECT * query report the buffer length correctly"

	^false! !
!SSWSQLiteDialect categoriesFor: #alterField:table:in:!maintenance!public! !
!SSWSQLiteDialect categoriesFor: #decimal!datatypes!public! !
!SSWSQLiteDialect categoriesFor: #defaultDateTimeResolution!constants!public! !
!SSWSQLiteDialect categoriesFor: #defaultMaxColumnNameLength!constants!public! !
!SSWSQLiteDialect categoriesFor: #defaultMaxTableNameLength!constants!public! !
!SSWSQLiteDialect categoriesFor: #dialectSpecificFunctions!constants!public! !
!SSWSQLiteDialect categoriesFor: #dropColumnNamed:fromTable:in:!maintenance!public! !
!SSWSQLiteDialect categoriesFor: #shouldMaskSuccessWithInfo!public!testing! !
!SSWSQLiteDialect categoriesFor: #shouldRollbackOnQuery!public!testing! !
!SSWSQLiteDialect categoriesFor: #shouldUseColumnsStatement!public!testing! !

!SSWSQLiteDialect class methodsFor!

dbmsName

	^'SQLITE'! !
!SSWSQLiteDialect class categoriesFor: #dbmsName!constants!public! !


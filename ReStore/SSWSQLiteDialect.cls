﻿"Filed out from Dolphin Smalltalk"!

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
	tempTable namespace: nil.
	tempTable name: (tempTable name, '_tmp_').
	tempTableDefinition := tempTable sqlDefinition.
	tempTableDefinition := 'CREATE TEMPORARY TABLE', (tempTableDefinition allButFirst: 'CREATE TABLE' size).

	aReStore 
		executeSQL: tempTableDefinition;
		executeSQL: ('INSERT INTO <1s> SELECT <2s> FROM <3s>' expandMacrosWith: (tempTable sqlStringIn: self) with: fieldNamesStream contents with: (aTable sqlStringIn: self));
		executeSQL: ('DROP TABLE ', (aTable sqlStringIn: self));
		executeSQL: aTable sqlDefinition;
		executeSQL: ('INSERT INTO <1s> SELECT <2s> FROM <3s>' expandMacrosWith: (aTable sqlStringIn: self) with: fieldNamesStream contents with: (tempTable sqlStringIn: self));
		executeSQL: ('DROP TABLE ', (tempTable sqlStringIn: self))!

decimal

	^'NUMERIC'!

defaultDateTimeResolution

	"0 = seconds, 3 = milliseconds etc."

	^0!

defaultMaxColumnNameLength

	^255!

defaultMaxTableNameLength

	^255!

defaultTimeResolution

	"0 = seconds, 3 = milliseconds etc."

	^3!

dialectSpecificFunctions

	^Dictionary new
		"String functions"
		at: #size put: 'LENGTH(%1)' asSQLFunctionIntegerResult;
		at: #midString:from: put: 'SUBSTR(%1,%3,%2)' asSQLFunction;

		"Date functions"
		at: #dayOfMonth put: 'CAST(STRFTIME(''%%d'',%1) AS INTEGER)' asSQLFunctionIntegerResult;
		at: #monthIndex put: 'CAST(STRFTIME(''%%m'',%1) AS INTEGER)' asSQLFunctionIntegerResult;
		at: #year put: 'CAST(STRFTIME(''%%Y'',%1) AS INTEGER)' asSQLFunctionIntegerResult;
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
		executeSQLFrom: [ :stream | stream nextPutAll: 'INSERT INTO '; writeSQLFor: tempTable ; nextPutAll: ' SELECT '. otherFields writeSQLOn: stream. stream nextPutAll: ' FROM '; writeSQLFor: anSSWDBTable];
		executeSQLFrom: [ :stream | stream nextPutAll: 'DROP TABLE '; writeSQLFor: anSSWDBTable];
		executeSQLFrom: [ :stream | stream nextPutAll: 'ALTER TABLE '; writeSQLFor: tempTable; nextPutAll: ' RENAME TO '; nextPutIdentifier: anSSWDBTable name]!

shouldExpandNamespacedAllFields

	"SQLite gives error with namespace.table_name.* in SELECT query"

	^true! !

!SSWSQLiteDialect categoriesForMethods!
alterField:table:in:!maintenance!public! !
decimal!datatypes!public! !
defaultDateTimeResolution!constants!public! !
defaultMaxColumnNameLength!constants!public! !
defaultMaxTableNameLength!constants!public! !
defaultTimeResolution!constants!public! !
dialectSpecificFunctions!constants!public! !
dropColumnNamed:fromTable:in:!maintenance!public! !
shouldExpandNamespacedAllFields!public!testing! !
!

!SSWSQLiteDialect class methodsFor!

dbmsName

	^'SQLITE'! !

!SSWSQLiteDialect class categoriesForMethods!
dbmsName!constants!public! !
!


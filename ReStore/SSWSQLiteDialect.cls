"Filed out from Dolphin Smalltalk"!

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

	^0!

defaultMaxColumnNameLength

	^255!

defaultMaxTableNameLength

	^255!

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

maxDateTimeResolution

	^0!

renameField: oldField to: newField in: aReStore

	aReStore executeSQLFrom: 
		[ :stream | 
		stream 
			nextPutAll: 'ALTER TABLE ';
			writeSQLFor: newField table;
			nextPutAll: ' RENAME ';
			nextPutIdentifier: oldField name;
			nextPutAll: ' TO ';
			nextPutIdentifier: newField name]!

shouldExpandNamespacedAllFields

	"SQLite gives error with namespace.table_name.* in SELECT query"

	^true! !

!SSWSQLiteDialect categoriesForMethods!
alterField:table:in:!maintenance!public! !
decimal!datatypes!public! !
defaultDateTimeResolution!constants!public! !
defaultMaxColumnNameLength!constants!public! !
defaultMaxTableNameLength!constants!public! !
dialectSpecificFunctions!constants!public! !
maxDateTimeResolution!constants!public! !
renameField:to:in:!maintenance!public! !
shouldExpandNamespacedAllFields!public!testing! !
!


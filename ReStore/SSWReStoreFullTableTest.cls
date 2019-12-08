"Filed out from Dolphin Smalltalk 7"!

SSWReStoreTableTest subclass: #SSWReStoreFullTableTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreFullTableTest guid: (GUID fromString: '{02671606-cff1-4134-a6ec-df0edbfa911c}')!
SSWReStoreFullTableTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreFullTableTest categoriesForClass!Unclassified! !
!SSWReStoreFullTableTest methodsFor!

createTestData

	reStore destroyAllClasses.

	reStore enableFullTableRecords.
	reStore sqlDialect maxTableNameLength: 9.
	
	^super createTestData !

renamedTableName

	"SIMPLE_PERSON and SIMPLE_ADDRESS use us SIMPL_0 and SIMPL_1"

	^'SIMPL_2'! !
!SSWReStoreFullTableTest categoriesFor: #createTestData!helpers!public! !
!SSWReStoreFullTableTest categoriesFor: #renamedTableName!constants!public! !


"Filed out from Dolphin Smallalk"!

SSWReStore2Test subclass: #SSWReStoreGenericTest
	instanceVariableNames: 'testObject testObject2'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreGenericTest guid: (GUID fromString: '{23440e28-e554-4fea-bb1c-04044a6111ca}')!
SSWReStoreGenericTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreGenericTest categoriesForClass!Unclassified! !
!SSWReStoreGenericTest methodsFor!

addClassesTo: aReStore

	super addClassesTo: aReStore.

	GenericTest componentDefinition: self componentDefinition.
	aReStore addClass: GenericTest!

componentDefinition

	^self subclassResponsibility!

createTestData

	self createTestObject.

	self fetchTestObjects!

createTestObject

	reStore evaluateAsTransaction: [self templateTestObject storeIn: reStore]!

destroyAllData

	"GenericTest>>component can change definition; ReStore doesn't check for this so drop any contained tables"
	((reStore tableForClass: GenericTest) collectionAccessing: #component) ifNotNil: 
		[ :collection | 
		collection containedTables isEmpty ifFalse: 
			[collection containedTables do: [ :table | reStore executeSQLAsTxn: {'drop table if exists ', table name. 'delete from next_id where table_name = <1p>' << table name}]]].

	super destroyAllData!

fetchTestObjects

	(Delay forMilliseconds: 10) wait.
	reStore simulateReconnect.

	testObject := (GenericTest storedInstancesIn: reStore) first!

setUp

	super setUp.

	testObject2 := (GenericTest storedInstancesIn: reStore2) first!

templateComponent

	"Ensure unique name"
	(Delay forMicroseconds: 10) wait.

	^GenericOwnedTest new name: (self class name, Time microsecondClockValue printString)!

templateTestObject

	^self subclassResponsibility!

testReadAllStatementNilled

	"Verify the cached readAllStatement is nilled when necessary (previously omitted for non-collections)"

	| persons table |

	persons := (GenericTest storedInstancesIn: reStore) asOrderedCollection.
	persons fetchAll: #(#component).

	reStore reconnect.

	table := reStore tableForClass: GenericTest.
	self assert: (table componentAccessing: #component) _readAllStatement isNil! !
!SSWReStoreGenericTest categoriesForMethods!
addClassesTo:!public!running! !
componentDefinition!accessing!public! !
createTestData!public!running! !
createTestObject!public!running! !
destroyAllData!public!running! !
fetchTestObjects!public!running! !
setUp!public!running! !
templateComponent!accessing!public! !
templateTestObject!accessing!public! !
testReadAllStatementNilled!public!unit tests! !
!

!SSWReStoreGenericTest class methodsFor!

isAbstract

	^self == SSWReStoreGenericTest! !
!SSWReStoreGenericTest class categoriesForMethods!
isAbstract!public! !
!


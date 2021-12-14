"Filed out from Dolphin Smallalk"!

SSWReStoreDataIDTest subclass: #SSWReStoreDataIDHierarchyTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreDataIDHierarchyTest guid: (GUID fromString: '{cf3f1c92-1da9-4e2c-85e8-302b53eb4afd}')!
SSWReStoreDataIDHierarchyTest comment: ''!
!SSWReStoreDataIDHierarchyTest categoriesForClass!Unclassified! !
!SSWReStoreDataIDHierarchyTest methodsFor!

addClassesTo: aReStore

	aReStore addClassWithSubclasses: ReStoreTestWithIDOnly!

testClass

	^ReStoreTestWithIDSubclass!

testClassWithIDOnly

	"Test a previous failure case where the table for a class containing only a data ID field was regarded as undefined"

	| inst |

	self assert: (reStore tableForClass: ReStoreTestWithIDOnly) notNil.

	(ReStoreTestWithIDOnly new nmbr: 987654321) storeIn: reStore.

	reStore simulateReconnect.

	inst := (ReStoreTestWithIDOnly storedInstancesIn: reStore) detect: [ :each | each nmbr = 987654321].
	self assert: inst notNil.
	self assert: inst class equals: ReStoreTestWithIDOnly.
	self assert: inst nmbr = 987654321.

	self assert: ((ReStoreTestWithIDOnly storedInstancesIn: reStore) detect: [ :each | each nmbr = 123456789] ifNone: [nil]) isNil! !
!SSWReStoreDataIDHierarchyTest categoriesForMethods!
addClassesTo:!public!running! !
testClass!constants!public! !
testClassWithIDOnly!public!unit tests! !
!


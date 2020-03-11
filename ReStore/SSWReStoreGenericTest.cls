"Filed out from Dolphin Smalltalk 7"!

SSWReStore2Test subclass: #SSWReStoreGenericTest
	instanceVariableNames: 'testObject'
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

fetchTestObjects

	(Delay forMilliseconds: 10) wait.
	reStore simulateReconnect.

	testObject := (GenericTest storedInstancesIn: reStore) first!

templateTestObject

	^self subclassResponsibility! !
!SSWReStoreGenericTest categoriesFor: #addClassesTo:!public!running! !
!SSWReStoreGenericTest categoriesFor: #componentDefinition!accessing!public! !
!SSWReStoreGenericTest categoriesFor: #createTestData!public!running! !
!SSWReStoreGenericTest categoriesFor: #createTestObject!public!running! !
!SSWReStoreGenericTest categoriesFor: #fetchTestObjects!public!running! !
!SSWReStoreGenericTest categoriesFor: #templateTestObject!accessing!public! !

!SSWReStoreGenericTest class methodsFor!

isAbstract

	^self == SSWReStoreGenericTest! !
!SSWReStoreGenericTest class categoriesFor: #isAbstract!public! !


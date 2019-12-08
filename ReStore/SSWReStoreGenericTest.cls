"Filed out from Dolphin Smalltalk 7"!

SSWReStoreTest subclass: #SSWReStoreGenericTest
	instanceVariableNames: 'testObject reStore2'
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

createTestObject

	reStore evaluateAsTransaction: [self templateTestObject storeIn: reStore]!

fetchTestObjects

	(Delay forMilliseconds: 10) wait.
	reStore simulateReconnect.

	testObject := (reStore instancesOf: GenericTest) first!

setUp

	super setUp.

	reStore destroyAllClasses; synchronizeAllClasses.

	self createTestObject.

	self fetchTestObjects!

setUpReStore2

	reStore2 := SSWReStore new.
	self initReStore: reStore2.
	reStore2 connect.
	self addClassesTo: reStore2!

tearDown

	super tearDown.
	reStore2 isNil ifFalse: 
		[reStore2 disconnect. 
		reStore2 := nil]!

templateTestObject

	^self subclassResponsibility! !
!SSWReStoreGenericTest categoriesFor: #addClassesTo:!public!running! !
!SSWReStoreGenericTest categoriesFor: #componentDefinition!accessing!public! !
!SSWReStoreGenericTest categoriesFor: #createTestObject!public!running! !
!SSWReStoreGenericTest categoriesFor: #fetchTestObjects!public!running! !
!SSWReStoreGenericTest categoriesFor: #setUp!public!running! !
!SSWReStoreGenericTest categoriesFor: #setUpReStore2!public!running! !
!SSWReStoreGenericTest categoriesFor: #tearDown!public!running! !
!SSWReStoreGenericTest categoriesFor: #templateTestObject!accessing!public! !

!SSWReStoreGenericTest class methodsFor!

isAbstract

	^self == SSWReStoreGenericTest! !
!SSWReStoreGenericTest class categoriesFor: #isAbstract!public! !


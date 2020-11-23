"Filed out from Dolphin Smalltalk 7"!

SSWReStoreTableTest subclass: #SSWReStoreTableWithNamespaceTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreTableWithNamespaceTest guid: (GUID fromString: '{f75d3945-b542-4c21-9bc0-bab0847e1ace}')!
SSWReStoreTableWithNamespaceTest comment: ''!
!SSWReStoreTableWithNamespaceTest categoriesForClass!Unclassified! !
!SSWReStoreTableWithNamespaceTest methodsFor!

_test31CrossNamespaceSetup

	| tables namespaceTables persons |

	tables := reStore connection tables.
	namespaceTables := reStore connection tablesInNamespace: self namespace.
	self deny: (tables includes: 'simple_person').
	self assert: (tables includes: 'simple_address').

	self assert: (namespaceTables includes: 'simple_person').
	self deny: (namespaceTables includes: 'simple_address').

	persons := (SimplePerson storedInstancesIn: reStore) asOrderedCollection.
	persons do: [ :each | each address: (SimpleAddress new line1: 'p', each _id displayString)].
	persons storeAll.

	reStore simulateReconnect!

addClassesTo: aReStore

	super addClassesTo: aReStore.

	reStore connection createNamespace: self namespace!

namespace

	^self class namespace!

releaseReStore: aReStore

	reStore connection dropNamespace: self namespace.
	super releaseReStore: aReStore!

setUp

	{SimplePerson. SimplePerson2. SuperPerson} do: [ :cls | self addMethod: self class class>>#addDatabaseNameTo: withSelector: #addClassDefinitionTo: toClass: cls class].

	super setUp!

tearDown

	{SimplePerson. SimplePerson2. SuperPerson} do: [ :cls | self removeSelector: #addClassDefinitionTo: fromClass: cls class].

	"Error trap superclass implementation primarily for SQLite which drops attached database on reconnect, leading to 'table not found' errors in destroyAllClasses"
	[super tearDown] on: reStore connection dbErrorClass do: [ :exc | ('*no such table*' match: exc description) ifTrue: [exc return] ifFalse: [exc pass]]!

test00VerifyNamespace

	| tables namespaceTables |

	tables := reStore connection tables.
	namespaceTables := reStore connection tablesInNamespace: self namespace.
	self deny: (tables includes: 'simple_person').
	self deny: (tables includes: 'super_person').
	self assert: (tables includes: 'simple_address').

	self assert: (namespaceTables includes: 'simple_person').
	self assert: (namespaceTables includes: 'super_person').
	self deny: (namespaceTables includes: 'simple_address')!

test02RenameClass

	"Ensure the renamed class doesn't exist in the standard namespace - various attempts to accomodate different dialects"
	[reStore connection exec: 'drop table if exists simple_person2'] on: reStore connection dbErrorClass do: [ :exc | [reStore connection exec: 'drop table simple_person2'] on: reStore connection dbErrorClass do: [ :exc2 | exc2 return]].

	super test02RenameClass.

	"Verify renamed table is in the correct namespace"
	self deny: (reStore connection tables includes: 'simple_person2').
	self assert: ((reStore connection tablesInNamespace: self namespace) includes: 'simple_person2')!

test31CrossNamespaceLinking

	| persons |

	self _test31CrossNamespaceSetup.

	persons := (SimplePerson storedInstancesIn: reStore) asOrderedCollection.
	self assert: (persons allSatisfy: [ :each | each address line1 = ('p', each _id displayString)])!

test32CrossNamespaceQuerying

	| persons |

	self _test31CrossNamespaceSetup.

	persons := SimplePerson storedInstancesIn: reStore.
	self assert: (persons detect: [ :each | each _id = 5]) address line1 equals: 'p5'.
	self assert: (persons detect: [ :each | each address line1 = 'p2']) _id = 2.! !
!SSWReStoreTableWithNamespaceTest categoriesFor: #_test31CrossNamespaceSetup!private!running! !
!SSWReStoreTableWithNamespaceTest categoriesFor: #addClassesTo:!public!running! !
!SSWReStoreTableWithNamespaceTest categoriesFor: #namespace!constants!public! !
!SSWReStoreTableWithNamespaceTest categoriesFor: #releaseReStore:!private!running! !
!SSWReStoreTableWithNamespaceTest categoriesFor: #setUp!public!running! !
!SSWReStoreTableWithNamespaceTest categoriesFor: #tearDown!public!running! !
!SSWReStoreTableWithNamespaceTest categoriesFor: #test00VerifyNamespace!public!unit tests! !
!SSWReStoreTableWithNamespaceTest categoriesFor: #test02RenameClass!public!unit tests! !
!SSWReStoreTableWithNamespaceTest categoriesFor: #test31CrossNamespaceLinking!public!unit tests! !
!SSWReStoreTableWithNamespaceTest categoriesFor: #test32CrossNamespaceQuerying!public!unit tests! !

!SSWReStoreTableWithNamespaceTest class methodsFor!

addDatabaseNameTo: aClassDef

	aClassDef namespace: SSWReStoreTableWithNamespaceTest namespace!

namespace

	^'test_namespace'! !
!SSWReStoreTableWithNamespaceTest class categoriesFor: #addDatabaseNameTo:!public! !
!SSWReStoreTableWithNamespaceTest class categoriesFor: #namespace!public! !


"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SSWDBClassDefinition
	instanceVariableNames: 'definedClass instVarDefinitions tableName idInstVar namespace'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBClassDefinition guid: (GUID fromString: '{0be1d2d5-2bb0-4ac3-959a-a758bb4dee08}')!
SSWDBClassDefinition comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBClassDefinition categoriesForClass!Kernel-Objects! !
!SSWDBClassDefinition methodsFor!

addDefinitionToTable: aDBTable

	self instVarDefinitions do: [ :assoc | aDBTable define: assoc key as: assoc value].

	self tableName isNil ifFalse: [aDBTable name: self tableName].
	self idInstVar isNil ifFalse: [aDBTable defineAsID: self idInstVar].
	self namespace isNil ifFalse: [aDBTable namespace: self namespace]!

asTableIn: aReStore

	| table |

	table := self definedClass reStoreTableClass forClass: self definedClass in: aReStore.

	self addDefinitionToTable: table.
		
	^table isDefined
		ifTrue: [table]
		ifFalse: [nil]!

define: aSymbol as: aClass

	"Define the inst var named aSymbol as holding instances of aClass.	 
	aClass could be an actual Class, a ClassWithInfo or a CollectionSpec (defining a Collection).
	Example usage of each type:
		define: #notes as: String;
		define: #name as: (String maxSize: 200);	
		define: #children as: (Collection of: Person owner: #parent)"

	self instVarDefinitions add: (aSymbol -> aClass)!

defineAsID: aSymbol

	"OPTIONAL:

	Define the receiver's unique ID as the inst var named aSymbol.
	Use of this method enables persistent objects to store their unique ID within themselves (normally the ID is only stored in ReStore's internal structures)"

	self idInstVar: aSymbol!

definedClass
	^definedClass!

definedClass: anObject
	definedClass := anObject!

idInstVar
	^idInstVar!

idInstVar: anObject
	idInstVar := anObject!

instVarDefinitions
	^instVarDefinitions!

instVarDefinitions: anObject
	instVarDefinitions := anObject!

isEmpty

	^self instVarDefinitions isEmpty and: [self idInstVar isNil]!

name: aString

	"Polymorphic with SSWDBTable"

	self tableName: aString!

namespace
	^namespace!

namespace: anObject

	"OPTIONAL:

	Define the namespace in which instances of definedClass will be stored.
	Normally this is nil, meaning the default namespace for the connection.
	Set to the name of another namespace on the same connection to store there instead (effectively the table's name becomes namespace.tableName)"

	namespace := anObject!

tableName
	^tableName!

tableName: aString

	"OPTIONAL:

	Define the name of the table in which instances of definedClass will be stored.
	Normally this is automatically generated based on the class's name."

	tableName := aString! !
!SSWDBClassDefinition categoriesFor: #addDefinitionToTable:!defining!private! !
!SSWDBClassDefinition categoriesFor: #asTableIn:!converting!public! !
!SSWDBClassDefinition categoriesFor: #define:as:!defining!public! !
!SSWDBClassDefinition categoriesFor: #defineAsID:!accessing!defining!public! !
!SSWDBClassDefinition categoriesFor: #definedClass!accessing!private! !
!SSWDBClassDefinition categoriesFor: #definedClass:!accessing!private! !
!SSWDBClassDefinition categoriesFor: #idInstVar!accessing!private! !
!SSWDBClassDefinition categoriesFor: #idInstVar:!accessing!private! !
!SSWDBClassDefinition categoriesFor: #instVarDefinitions!accessing!private! !
!SSWDBClassDefinition categoriesFor: #instVarDefinitions:!accessing!private! !
!SSWDBClassDefinition categoriesFor: #isEmpty!public!testing! !
!SSWDBClassDefinition categoriesFor: #name:!accessing!defining!public! !
!SSWDBClassDefinition categoriesFor: #namespace!accessing!private! !
!SSWDBClassDefinition categoriesFor: #namespace:!accessing!public! !
!SSWDBClassDefinition categoriesFor: #tableName!accessing!private! !
!SSWDBClassDefinition categoriesFor: #tableName:!accessing!defining!public! !

!SSWDBClassDefinition class methodsFor!

forClass: aClass

	^super new
		definedClass: aClass;
		instVarDefinitions: OrderedCollection new;
		yourself! !
!SSWDBClassDefinition class categoriesFor: #forClass:!instance creation!public! !


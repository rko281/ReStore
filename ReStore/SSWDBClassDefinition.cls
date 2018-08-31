"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SSWDBClassDefinition
	instanceVariableNames: 'definedClass instVarDefinitions tableName idInstVar idCacheSize'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBClassDefinition guid: (GUID fromString: '{0be1d2d5-2bb0-4ac3-959a-a758bb4dee08}')!
SSWDBClassDefinition comment: ''!
!SSWDBClassDefinition categoriesForClass!Kernel-Objects! !
!SSWDBClassDefinition methodsFor!

asTableIn: aReStore

	| table |

	table := self definedClass reStoreTableClass forClass: self definedClass in: aReStore.

	self instVarDefinitions do: [ :assoc | table define: assoc key as: assoc value].

	self tableName isNil ifFalse: [table name: self tableName].
	self idInstVar isNil ifFalse: [table defineAsID: self idInstVar].
	self idCacheSize isNil ifFalse: [table idCacheSize: self idCacheSize].
		
	^table!

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

idCacheSize
	^idCacheSize!

idCacheSize: anInteger

	"OPTIONAL:

	Define the number of unique IDs that should be cached by ReStore when persisting instances of definedClass.
	Caching IDs reduces querying when creating storing instances of the instanceClass but can lead to ID wastage if not all cached IDs have been used on logout.

	Default is 10 (defined in SSWDBTable). 
	Use a higher cache size for tables creating many instances.
	Use a value of 1 where a continuous range is required"

	idCacheSize := anInteger!

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

tableName
	^tableName!

tableName: aString

	"OPTIONAL:

	Define the name of the table in which instances of definedClass will be stored.
	Normally this is automatically generated based on the class's name."

	tableName := aString! !
!SSWDBClassDefinition categoriesFor: #asTableIn:!converting!public! !
!SSWDBClassDefinition categoriesFor: #define:as:!defining!public! !
!SSWDBClassDefinition categoriesFor: #defineAsID:!accessing!defining!public! !
!SSWDBClassDefinition categoriesFor: #definedClass!accessing!private! !
!SSWDBClassDefinition categoriesFor: #definedClass:!accessing!private! !
!SSWDBClassDefinition categoriesFor: #idCacheSize!accessing!private! !
!SSWDBClassDefinition categoriesFor: #idCacheSize:!accessing!defining!public! !
!SSWDBClassDefinition categoriesFor: #idInstVar!accessing!private! !
!SSWDBClassDefinition categoriesFor: #idInstVar:!accessing!private! !
!SSWDBClassDefinition categoriesFor: #instVarDefinitions!accessing!private! !
!SSWDBClassDefinition categoriesFor: #instVarDefinitions:!accessing!private! !
!SSWDBClassDefinition categoriesFor: #isEmpty!public!testing! !
!SSWDBClassDefinition categoriesFor: #name:!accessing!defining!public! !
!SSWDBClassDefinition categoriesFor: #tableName!accessing!private! !
!SSWDBClassDefinition categoriesFor: #tableName:!accessing!defining!public! !

!SSWDBClassDefinition class methodsFor!

forClass: aClass

	^super new
		definedClass: aClass;
		instVarDefinitions: OrderedCollection new;
		yourself! !
!SSWDBClassDefinition class categoriesFor: #forClass:!instance creation!public! !


"Filed out from Dolphin Smalltalk 7"!

SSWDBTable subclass: #SSWDBInheritedTable
	instanceVariableNames: 'classField'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBInheritedTable guid: (GUID fromString: '{266e4dcd-398e-11d5-b1df-444553540000}')!
SSWDBInheritedTable comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBInheritedTable categoriesForClass!Unclassified! !
!SSWDBInheritedTable methodsFor!

classField

	"classField stores the DBField which defines which class of object a row represents.
	Note this is also a member of the receiver's controlFields (see setDefaultClassField) but is additionally held here
	a) for efficient access
	b) as a non-parameterizable field - class conditions are statically written into the receiver's SQL"
	
	^classField!

classField: anSSWDBField

	"classField stores the SSWDBField which defines which class of object a row represents.
	Note this is also a member of the receiver's controlFields (see setDefaultClassField)
	but is additionally held in this instance variable for efficient access"
	
	classField := anSSWDBField!

initializeClassField: aDBField
	
	^aDBField
		table: self;
		accessor: SSWDBClassAccessor new;
		name: (self sqlDialect transformInstVarName: aDBField accessor nameInDB);
		targetClass: Metaclass;
		yourself!

initializeIn: anSSWReStore

	"Overriden to setup the classField"

	super initializeIn: anSSWReStore.
	self setDefaultClassField!

instanceClassFromRow: aDBRow

	"Private - Determine the class to use from the row"
	
	^self classField convertValue: (aDBRow atField: self classField)!

setDefaultClassField
	
	self controlFields add: (self initializeClassField: SSWDBStaticField new).
	self classField: (self initializeClassField: SSWDBNonParameterizedStaticField new)!

withAllFields

	"Return a table equivalent to the receiver but containing all possible fields.	
	For an inherited table, need to include fields from table-sharing subclasses"

	| withAllFields |

	withAllFields := self copy.
	withAllFields dataFields: self dataFields copy.

	self instanceClass subclassesInheritingPersistency do:
		[ :cls || table |
		table := self reStore tableForClass: cls.
		table dataFields do: 
			[ :field | 
			(withAllFields hasFieldAccessing: field accessor name) ifFalse: 
				[withAllFields dataFields add: field]]].
	
	^withAllFields! !
!SSWDBInheritedTable categoriesFor: #classField!accessing!public! !
!SSWDBInheritedTable categoriesFor: #classField:!accessing!public! !
!SSWDBInheritedTable categoriesFor: #initializeClassField:!defining!private! !
!SSWDBInheritedTable categoriesFor: #initializeIn:!initializing!public! !
!SSWDBInheritedTable categoriesFor: #instanceClassFromRow:!instance creation!private! !
!SSWDBInheritedTable categoriesFor: #setDefaultClassField!defining!public! !
!SSWDBInheritedTable categoriesFor: #withAllFields!evaluating!public! !


"Filed out from Dolphin Smalltalk 7"!

SSWDBTableComponent subclass: #SSWDBField
	instanceVariableNames: 'name isDependent isRelated'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBField guid: (GUID fromString: '{266e4dd6-398e-11d5-b1df-444553540000}')!
SSWDBField comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBField categoriesForClass!Unclassified! !
!SSWDBField methodsFor!

= anSSWDBField

	^self == anSSWDBField 
		or: [anSSWDBField notNil and: [self table = anSSWDBField table and: [self name = anSSWDBField name]]]!

aboutToBeUnstored: anObject

	"Delete the component of anObject referenced by the receiver, if dependent"

	self isDependent ifTrue: [(self accessor valueIn: anObject) unstore]
!

accessorPath

	"The path of accessors from some originating table to this field. 
	SSWDBFields are always first-level"

	^#()!

beDependent

	isDependent := true!

beRelated

	isRelated := true!

beUnrelated

	isRelated := false!

canBeParameterized

	^true!

fieldNamed: aString

	"Polymorphic with field collections"

	^self name = aString 
		ifTrue: [self]
		ifFalse: [nil]!

hash

	^self table hash bitXor: self name hash!

initialize

	super initialize.

	isDependent := false.
	isRelated := false!

isAll

	"The receiver is not the all fields (*) pseudo field"

	^false!

isDependent

	"isDependent indicates whether the receiver is marked as 'dependent', 
	i.e. whether the target object of the receiver depends on its source row for its existence, such that it will be deleted when it is no longer referenced by the source/source is deleted"
	
	^isDependent!

isFieldCollection

	"Just a single field"

	^false!

isInlined

	^self accessor isInlined!

isRelated

	"isRelated indicates whether the receiver field represents an object which is related to the owning/source object such that it will be commited/rolled-back with that object when withRelatedComponents is used"
	
	^isRelated!

name

	"name stores the name of this field"
	
	^name!

name: aString

	"name stores the name of this field"
	
	name := aString!

printOn: aStream

	super printOn: aStream.

	aStream
		nextPutAll: '>>';
		nextPutAll: self name!

relatedComponentsOf: anObject do: aBlock

	self isRelated ifTrue: [self componentsOf: anObject do: aBlock ]!

requiresAliasing

	"Return whether this field always requires aliasing"
	^false!

sqlCanBeParameterized

	"When expressing this field as a value, can its SQL be parameterized?
	Different to canBeParameterized!!"

	^false!

withFunction: aString

	"Return an SSWDBFunctionField base on the receiver with the given function String"
	
	^self withFunction: aString arguments: #()!

withFunction: aString arguments: aCollection

	"Return an SSWDBFunctionField base on the receiver with the given function String and arguments"
	
	^SSWDBFunctionField new
		field: self;
		function: aString;
		arguments: aCollection;
		yourself!

writeAliasedSQLOn: aStream

	"For situations where duplicate field names are anticipated
	- write the SQL of the receiver on aStream, but use aliased names to force uniqueness"
	
	aStream nextPutAliasedField: self!

writeSQLDefinitionOn: aStream

	aStream nextPutIdentifier: self name!

writeSQLForUpdateOn: aStream

	"Write the receiver field to aStream, specifically as part of an Update query.
	At present, ReStore only supports updates against one table (i.e. no joins).
	Hence the <table name>. prefix is unnecessary in update queries - in fact it is specifically disallowed in some DBs"

	^aStream nextPutIdentifier: self name!

writeSQLOn: aStream

	"Use <table name>.<field name> notation to avoid ambiguity"

	self table writeSQLNameOn: aStream.

	aStream 
		nextPut: $.;
		nextPutIdentifier: self name! !
!SSWDBField categoriesFor: #=!comparing!public! !
!SSWDBField categoriesFor: #aboutToBeUnstored:!actions!public! !
!SSWDBField categoriesFor: #accessorPath!accessing!public! !
!SSWDBField categoriesFor: #beDependent!defining!public! !
!SSWDBField categoriesFor: #beRelated!defining!public! !
!SSWDBField categoriesFor: #beUnrelated!defining!public! !
!SSWDBField categoriesFor: #canBeParameterized!public!testing! !
!SSWDBField categoriesFor: #fieldNamed:!accessing!public! !
!SSWDBField categoriesFor: #hash!comparing!public! !
!SSWDBField categoriesFor: #initialize!initialize/release!public! !
!SSWDBField categoriesFor: #isAll!public!testing! !
!SSWDBField categoriesFor: #isDependent!public!testing! !
!SSWDBField categoriesFor: #isFieldCollection!public!testing! !
!SSWDBField categoriesFor: #isInlined!public!testing! !
!SSWDBField categoriesFor: #isRelated!public!testing! !
!SSWDBField categoriesFor: #name!accessing!public! !
!SSWDBField categoriesFor: #name:!accessing!public! !
!SSWDBField categoriesFor: #printOn:!printing!public! !
!SSWDBField categoriesFor: #relatedComponentsOf:do:!evaluating!public! !
!SSWDBField categoriesFor: #requiresAliasing!public!testing! !
!SSWDBField categoriesFor: #sqlCanBeParameterized!public!testing! !
!SSWDBField categoriesFor: #withFunction:!evaluating!public! !
!SSWDBField categoriesFor: #withFunction:arguments:!evaluating!public! !
!SSWDBField categoriesFor: #writeAliasedSQLOn:!output!public! !
!SSWDBField categoriesFor: #writeSQLDefinitionOn:!output!public! !
!SSWDBField categoriesFor: #writeSQLForUpdateOn:!printing!public! !
!SSWDBField categoriesFor: #writeSQLOn:!output!public! !


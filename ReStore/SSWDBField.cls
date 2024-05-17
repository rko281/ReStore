"Filed out from Dolphin Smallalk"!

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

aboutToBeUnstored: anSSWDBProxy

	"Delete the components of anSSWDBProxy referenced by the receiver, if dependent"

	self isDependent ifTrue: [(anSSWDBProxy _valuesForAccessor: self accessor) do: [ :each | each unstore]]
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

hasAggregateFunction

	^false!

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

withFunction: aSQLFunction

	"Return an SSWDBFunctionField base on the receiver with the given function"
	
	^self withFunction: aSQLFunction arguments: #()!

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
!SSWDBField categoriesForMethods!
=!comparing!public! !
aboutToBeUnstored:!actions!public! !
accessorPath!accessing!public! !
beDependent!defining!public! !
beRelated!defining!public! !
beUnrelated!defining!public! !
canBeParameterized!public!testing! !
fieldNamed:!accessing!public! !
hasAggregateFunction!public!testing! !
hash!comparing!public! !
initialize!initialize/release!public! !
isAll!public!testing! !
isDependent!public!testing! !
isFieldCollection!public!testing! !
isInlined!public!testing! !
isRelated!public!testing! !
name!accessing!public! !
name:!accessing!public! !
printOn:!printing!public! !
relatedComponentsOf:do:!evaluating!public! !
requiresAliasing!public!testing! !
sqlCanBeParameterized!public!testing! !
withFunction:!evaluating!public! !
withFunction:arguments:!evaluating!public! !
writeAliasedSQLOn:!output!public! !
writeSQLDefinitionOn:!output!public! !
writeSQLForUpdateOn:!printing!public! !
writeSQLOn:!output!public! !
!


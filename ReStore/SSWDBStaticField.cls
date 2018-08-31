"Filed out from Dolphin Smalltalk 7"!

SSWDBField subclass: #SSWDBStaticField
	instanceVariableNames: 'targetClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBStaticField guid: (GUID fromString: '{266e4dd7-398e-11d5-b1df-444553540000}')!
SSWDBStaticField comment: 'Copyright 2000/2001 Solutions Software Limited'!
!SSWDBStaticField categoriesForClass!Unclassified! !
!SSWDBStaticField methodsFor!

applyValueFromRow: aDBRow to: anObject

	"6/8/2000"
	
	| dbValue |
	
	dbValue := aDBRow atField: self ifAbsent: [nil].
	
	self accessor value: (self convertValue: dbValue) in: anObject!

applyValueIfChangedFromRow: aDBRow to: anObject

	"Return whether a change was applied"

	| dbValue |
	
	dbValue := aDBRow atField: self ifAbsent: [nil].
	
	^self accessor valueIfChanged: (self convertValue: dbValue) in: anObject!

convertValue: aValue

	"23/3/2001
	
	Convert the given DB value object to the receiver's targetClass.
	Return the converted object"
	
	^(aValue isKindOf: self targetClass)
		ifTrue: [aValue]
		ifFalse: [self targetClass instanceFromDBValue: aValue in: self reStore]!

readAllFor: aCollection

	| ids stream allResults |

	ids := aCollection inject: Set new into: [ :all :each | (self accessor valueIn: each) ifNotNil: [ :proxy | proxy _isRecovered ifFalse: [all add: proxy _id]]. all].
	ids size <= 1 ifTrue: [^self].

	stream := ReadStream on: ids asArray.

	"We don't actually use the results (they will be put into the appropriate proxy) but the fetch method requires a collection"
	allResults := OrderedCollection new: ids size.
	[stream atEnd] whileFalse: 
		[self readAllStatement readValuesFrom: stream.
		self reStore fetchObjectsOfClass: self targetClass withStatement: self readAllStatement into: allResults]!

readAllQuery

	| params |

	params := self newReadAllParameters.
	params atAllPut: SSWSQLQueryParameter.

	^ SSWSQLSelectQuery new
		table: self targetTable;
		conditions: (SSWSQLCondition field: self targetTable idField is: (SSWSQLOperator messageSelector: #includedIn:) to: params);
		yourself!

targetClass

	"6/8/2000
	
	targetClass stores the Class of object stored in this field.
	This can be a base class with an SQL equivalent (String, Number, Date...), or a persistent class"
	
	^targetClass!

targetClass: aClass

	"6/8/2000
	
	targetClass stores the Class of object stored in this field.
	This can be a base class with an SQL equivalent (String, Number, Date...), or a persistent class"
	
	targetClass := aClass!

targetTable

	"ASSERT: targetClass is not a base class"

	^self reStore tableForClass: self targetClass!

writeSQLDefinitionOn: aStream

	"9/3/01"
	
	super writeSQLDefinitionOn: aStream.
	aStream space.
	self targetClass writeSQLTypeOn: aStream using: self sqlDialect! !
!SSWDBStaticField categoriesFor: #applyValueFromRow:to:!actions!public! !
!SSWDBStaticField categoriesFor: #applyValueIfChangedFromRow:to:!actions!public! !
!SSWDBStaticField categoriesFor: #convertValue:!actions!public! !
!SSWDBStaticField categoriesFor: #readAllFor:!actions!public! !
!SSWDBStaticField categoriesFor: #readAllQuery!accessing!public! !
!SSWDBStaticField categoriesFor: #targetClass!accessing!public! !
!SSWDBStaticField categoriesFor: #targetClass:!accessing!public! !
!SSWDBStaticField categoriesFor: #targetTable!accessing!public! !
!SSWDBStaticField categoriesFor: #writeSQLDefinitionOn:!output!public! !


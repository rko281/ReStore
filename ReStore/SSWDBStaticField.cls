"Filed out from Dolphin Smalltalk"!

SSWDBField subclass: #SSWDBStaticField
	instanceVariableNames: 'targetClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWDBStaticField guid: (GUID fromString: '{266e4dd7-398e-11d5-b1df-444553540000}')!

SSWDBStaticField comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!

!SSWDBStaticField categoriesForClass!Unclassified! !

!SSWDBStaticField methodsFor!

applyValueFromRow: aDBRow to: anObject

	self accessor value: (self convertValue: (self lookupIn: aDBRow)) in: anObject!

applyValueIfChangedFromRow: aDBRow to: anObject

	"Return whether a change was applied"

	^self accessor valueIfChanged: (self convertValue: (self lookupIn: aDBRow)) in: anObject!

convertValue: aValue

	"Convert the given DB value object to the receiver's targetClass.
	Return the converted object"
	
	^self targetClass instanceFromDBValue: aValue in: self reStore!

isValidForPersistence

	^true!

populateObject: anObject with: aValue

	"Populate the aspect of anObject related to this field with aValue"

	self subclassResponsibility!

populateObject: anObject with: aValue from: anSSWDBTable

	"Populate the aspect of anObject related to this field with aValue sourced from anSSWDBTable"

	(self table == anSSWDBTable or: [self table = anSSWDBTable]) ifTrue: [self populateObject: anObject with: aValue]!

readAllFor: aCollection

	| ids stream allResults |

	ids := aCollection inject: Set new into: [ :all :each | (self accessor valueIn: each) ifNotNil: [ :proxy | proxy isDBProxy ifTrue: [all add: proxy _id]]. all].
	ids isEmpty ifTrue: [^self].

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

	"targetClass stores the Class of object stored in this field.
	This can be a base class with an SQL equivalent (String, Number, Date...), or a persistent class"
	
	^targetClass!

targetClass: aClass

	"targetClass stores the Class of object stored in this field.
	This can be a base class with an SQL equivalent (String, Number, Date...), or a persistent class"
	
	targetClass := aClass!

targetTable

	"ASSERT: targetClass is not a base class"

	^self reStore tableForClass: self targetClass!

writeSQLDefinitionOn: aStream
	
	super writeSQLDefinitionOn: aStream.
	aStream space.
	self targetClass writeSQLTypeOn: aStream using: self sqlDialect! !

!SSWDBStaticField categoriesForMethods!
applyValueFromRow:to:!actions!public! !
applyValueIfChangedFromRow:to:!actions!public! !
convertValue:!actions!public! !
isValidForPersistence!public! !
populateObject:with:!actions!private! !
populateObject:with:from:!actions!private! !
readAllFor:!actions!public! !
readAllQuery!accessing!public! !
targetClass!accessing!public! !
targetClass:!accessing!public! !
targetTable!accessing!public! !
writeSQLDefinitionOn:!output!public! !
!


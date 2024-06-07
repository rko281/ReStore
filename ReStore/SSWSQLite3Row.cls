"Filed out from Dolphin Smalltalk"!

SQLite3Row subclass: #SSWSQLite3Row
	instanceVariableNames: 'columns'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLite3Row guid: (GUID fromString: '{35b12246-cadd-4829-a233-07b0cf83b37e}')!
SSWSQLite3Row comment: ''!
!SSWSQLite3Row categoriesForClass!SQLite3-Core-Database! !
!SSWSQLite3Row methodsFor!

at: aKey put: anObject	^values at: aKey put: anObject!

atIndex: anInteger

	^values at: anInteger!

columns

	^columns!

columns: aCollection

	columns := aCollection!

contents

	^self!

data

	^values!

data: aCollection

	values := aCollection!

deAliasQueryFieldsFor: aDBQueryTable

	"The receiver is derived from a query containing the given SSWDBQueryTable as an alias for an actual SSWDBTable.
	To allow field lookup by the original SSWDBTable, initialize the field map based on the original, non-aliased, fields"

	columns := 
		columns collect: 
			[ :each |
			each field 
				ifNil: [each] 
				ifNotNil: [ :field | field table == aDBQueryTable ifTrue: [each copy field: field field] ifFalse: [each copy field: nil]]]!

lookupField: aField

	"Optimised method: 
		Use the columnIndex where available;
		In the common case fields will be identical; check for this first. 
		Use to:do: to maximize inlining and avoid full blocks. "

	aField columnIndex ifNotNil: 
		[ :index |
		(columns at: index ifAbsent: [nil]) ifNotNil: 
			[ :column |
			(column field == aField or: [column field = aField]) ifTrue: [^values at: index]]].

	1 to: columns size do: [ :index | (columns at: index) field == aField ifTrue: [^values at: index]].
	1 to: columns size do: [ :index | (columns at: index) field = aField ifTrue: [^values at: index]].

	^nil!

lookupIDField: aField

	"Optimised lookup for ID fields which are usually first"

	^(columns at: 1) field == aField 
		ifTrue: [values at: 1]
		ifFalse: [self lookupField: aField]!

populateObject: anObject from: anSSWDBTable

	1 to: columns size do: 
		[ :index | 
		(columns at: index) field ifNotNil: 
			[ :field |  
			(field table == anSSWDBTable or: [field table = anSSWDBTable]) ifTrue: 
				[field populateObject: anObject with: (values at: index)]]]!

values

	^values! !
!SSWSQLite3Row categoriesForMethods!
at:put:!accessing!public! !
atIndex:!accessing!public! !
columns!accessing!public! !
columns:!accessing!public! !
contents!accessing!public! !
data!accessing!public! !
data:!accessing!public! !
deAliasQueryFieldsFor:!initializing!public! !
lookupField:!accessing!public! !
lookupIDField:!accessing!public! !
populateObject:from:!accessing!public! !
values!accessing!public! !
!


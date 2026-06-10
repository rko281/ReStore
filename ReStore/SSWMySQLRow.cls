"Filed out from Dolphin Smalltalk"!

MySQLBinaryRowData subclass: #SSWMySQLRow
	instanceVariableNames: 'columns'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWMySQLRow guid: (GUID fromString: '{563ae98b-79ad-4299-8c7b-1449e5a19dd8}')!

SSWMySQLRow comment: ''!

!SSWMySQLRow categoriesForClass!SSW ReStore MySQL! !

!SSWMySQLRow methodsFor!

columnNames

	^columnDescriptors collect: [ :each | each name ]!

columns

	^columns!

columns: aCollection

	columns := aCollection!

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
			(column field == aField or: [column field = aField]) ifTrue: [^columnValues at: index]]].

	1 to: columns size do: [ :index | (columns at: index) field == aField ifTrue: [^columnValues at: index]].
	1 to: columns size do: [ :index | (columns at: index) field = aField ifTrue: [^columnValues at: index]].

	^nil!

lookupIDField: aField

	"Optimised lookup for ID fields which are usually first"

	^(columns at: 1) field == aField 
		ifTrue: [columnValues at: 1]
		ifFalse: [self lookupField: aField]!

populateObject: anObject from: anSSWDBTable

	1 to: columns size do: 
		[ :index | 
		(columns at: index) field ifNotNil: 
			[ :field |  
			field populateObject: anObject with: (columnValues at: index) from: anSSWDBTable]]! !

!SSWMySQLRow categoriesForMethods!
columnNames!accessing!public! !
columns!accessing!public! !
columns:!accessing!public! !
deAliasQueryFieldsFor:!initializing!public! !
lookupField:!accessing!public! !
lookupIDField:!accessing!public! !
populateObject:from:!accessing!public! !
!


"Filed out from Dolphin Smalltalk"!

DBRow subclass: #SSWODBCRow
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWODBCRow guid: (GUID fromString: '{a08f875a-3b6c-4962-9633-730ff9ab89b2}')!

SSWODBCRow comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!

!SSWODBCRow categoriesForClass!Kernel-Objects! !

!SSWODBCRow methodsFor!

deAliasQueryFieldsFor: aDBQueryTable

	"The receiver is derived from a query containing the given SSWDBQueryTable as an alias for an actual SSWDBTable.
	To allow field lookup by the original SSWDBTable, initialize the field map based on the original, non-aliased, fields"

	columns := 
		columns collect: 
			[ :each |
			each field 
				ifNil: [each] 
				ifNotNil: [ :field | field table == aDBQueryTable ifTrue: [each copy field: field field] ifFalse: [each copy field: nil]]]!

initializeFromBuffer: anSSWODBCBuffer

	columns := anSSWODBCBuffer columns.
	contents := anSSWODBCBuffer objects.
	status := anSSWODBCBuffer status!

lookupField: aField

	"Optimised method: 
		Use the columnIndex where available;
		In the common case fields will be identical; check for this first. 
		Use to:do: to maximize inlining and avoid full blocks. "

	aField columnIndex ifNotNil: 
		[ :index |
		(columns at: index ifAbsent: [nil]) ifNotNil: 
			[ :column |
			(column field == aField or: [column field = aField]) ifTrue: [^contents at: index]]].

	1 to: columns size do: [ :index | (columns at: index) field == aField ifTrue: [^contents at: index]].
	1 to: columns size do: [ :index | (columns at: index) field = aField ifTrue: [^contents at: index]].

	^nil!

lookupIDField: aField

	"Optimised lookup for ID fields which are usually first"

	^(columns at: 1) field == aField 
		ifTrue: [contents at: 1]
		ifFalse: [self lookupField: aField]!

populateObject: anObject from: anSSWDBTable

	1 to: columns size do: 
		[ :index | 
		(columns at: index) field ifNotNil: 
			[ :field |  
			(field equivalentIn: anSSWDBTable) ifNotNil: 
				[ :actualField | 
				actualField populateObject: anObject with: (contents at: index)]]]! !

!SSWODBCRow categoriesForMethods!
deAliasQueryFieldsFor:!initializing!public! !
initializeFromBuffer:!initializing!public! !
lookupField:!accessing!public! !
lookupIDField:!accessing!public! !
populateObject:from:!initializing!private! !
!


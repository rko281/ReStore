"Filed out from Dolphin Smalltalk 7"!

DBRow subclass: #SSWODBCRow
	instanceVariableNames: 'fieldMap'
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

	fieldMap := LookupTable new: columns size.
	1 to: columns size do: [ :index | (columns at: index) field ifNotNil: [ :field | field table == aDBQueryTable ifTrue: [fieldMap at: field field put: (contents at: index)]]]!

initializeFromBuffer: anSSWODBCBuffer

	columns := anSSWODBCBuffer columns.
	contents := anSSWODBCBuffer objects.
	status := anSSWODBCBuffer status.

	"For smaller numbers of columns (<=12, arrived at experimentally) it's more efficient to avoid the fieldMap creation (see atField:ifAbsent:)"
	columns size > 12 ifTrue: 
		[fieldMap := LookupTable new: columns size.
		1 to: columns size do: [ :index | (columns at: index) field ifNotNil: [ :field | fieldMap at: field put: (contents at: index)]]]!

lookupField: aField

	^fieldMap isNil 
		ifTrue: [1 to: columns size do: [ :index | (columns at: index) field = aField ifTrue: [^contents at: index]]. nil]
		ifFalse: [fieldMap lookup: aField]! !
!SSWODBCRow categoriesFor: #deAliasQueryFieldsFor:!initializing!public! !
!SSWODBCRow categoriesFor: #initializeFromBuffer:!initializing!public! !
!SSWODBCRow categoriesFor: #lookupField:!accessing!public! !


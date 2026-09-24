"Filed out from Dolphin Smalltalk"!

Object subclass: #SSWP3Row
	instanceVariableNames: 'columns columnNames data'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWP3Row guid: (GUID fromString: '{1a055365-c6d2-455a-93dd-147788648518}')!

SSWP3Row comment: ''!

!SSWP3Row categoriesForClass!Kernel-Objects! !

!SSWP3Row methodsFor!

atIndex: anInteger

	^self data at: anInteger!

columnNames

	^columnNames!

columns

	^columns!

columns: aCollection

	columns := aCollection!

contents

	^data!

data
	^data!

data: anObject
	data := anObject!

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
			(column field == aField or: [column field = aField]) ifTrue: [^data at: index]]].

	1 to: columns size do: [ :index | (columns at: index) field == aField ifTrue: [^data at: index]].
	1 to: columns size do: [ :index | (columns at: index) field = aField ifTrue: [^data at: index]].

	^nil!

lookupIDField: aField

	"Optimised lookup for ID fields which are usually first"

	^(columns at: 1) field == aField 
		ifTrue: [data at: 1]
		ifFalse: [self lookupField: aField]!

populateObject: anObject from: anSSWDBTable

	1 to: columns size do: 
		[ :index | 
		(columns at: index) field ifNotNil: 
			[ :field |  
			field populateObject: anObject with: (data at: index) from: anSSWDBTable]]! !

!SSWP3Row categoriesForMethods!
atIndex:!accessing!public! !
columnNames!accessing!public! !
columns!accessing!public! !
columns:!accessing!public! !
contents!accessing!public! !
data!accessing!private! !
data:!accessing!private! !
deAliasQueryFieldsFor:!initializing!public! !
lookupField:!accessing!public! !
lookupIDField:!accessing!public! !
populateObject:from:!accessing!public! !
!


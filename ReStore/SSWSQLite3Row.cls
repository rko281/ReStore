"Filed out from Dolphin Smallalk"!

SQLite3Row subclass: #SSWSQLite3Row
	instanceVariableNames: 'columns fieldMap'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLite3Row guid: (GUID fromString: '{35b12246-cadd-4829-a233-07b0cf83b37e}')!
SSWSQLite3Row comment: ''!
!SSWSQLite3Row categoriesForClass!SQLite3-Core-Database! !
!SSWSQLite3Row methodsFor!

atIndex: anInteger

	^self data at: anInteger!

columns

	^columns ifNil: [columns := self columnNames collect: [ :each | SSWDBColAttr new name: each; yourself ]]!

columns: aCollection

	columns := aCollection!

columns: colsCollection data: dataCollection query: aDBQuery

	self 
		columns: colsCollection;
		data: dataCollection.
		
	aDBQuery isNil ifFalse: [ self createFieldMapFrom: aDBQuery ]!

contents

	^self!

createFieldMapFrom: aDBQuery

	fieldMap := Dictionary new.
	self columns with: self data do: 
		[ :column :value |
		(aDBQuery fieldNamed: column fieldName) ifNotNil: 
			 [ :field |
			column field: field.
			fieldMap at: field put: value ]]!

data

	^values!

data: aCollection

	values := aCollection!

deAliasQueryFieldsFor: aDBQueryTable

	"The receiver is derived from a query containing the given SSWDBQueryTable as an alias for an actual SSWDBTable.
	To allow field lookup by the original SSWDBTable, initialize the field map based on the original, non-aliased, fields"

	| cols |
	
	cols := self columns.

	fieldMap := Dictionary new: cols size.
	1 to: cols size do: [ :index | (cols at: index) field ifNotNil: [ :field | field table == aDBQueryTable ifTrue: [fieldMap at: field field put: (values at: index)]]]!

fieldMap
	^ fieldMap!

fieldMap: anObject
	fieldMap := anObject!

lookupField: aField

	^fieldMap at: aField ifAbsent: [ nil ]!

values

	^values! !
!SSWSQLite3Row categoriesForMethods!
atIndex:!accessing!public! !
columns!accessing!public! !
columns:!accessing!public! !
columns:data:query:!initializing!public! !
contents!accessing!public! !
createFieldMapFrom:!initializing!public! !
data!accessing!public! !
data:!accessing!public! !
deAliasQueryFieldsFor:!initializing!public! !
fieldMap!accessing!public! !
fieldMap:!accessing!public! !
lookupField:!accessing!public! !
values!accessing!public! !
!

!SSWSQLite3Row class methodsFor!

newWithColumns: colsCollection data: dataCollection query: aDBQuery

	^self new
		columns: colsCollection data: dataCollection query: aDBQuery;
		yourself! !
!SSWSQLite3Row class categoriesForMethods!
newWithColumns:data:query:!instance creation!public! !
!


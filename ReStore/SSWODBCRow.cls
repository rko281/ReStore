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

initializeFromBuffer: anSSWODBCBuffer

	columns := anSSWODBCBuffer columns.
	contents := anSSWODBCBuffer objects.
	status := anSSWODBCBuffer status.

	"For smaller numbers of columns (<=5, arrived at experimentally) it's more efficient to avoid the fieldMap creation (see atField:ifAbsent:)"
	columns size > 5 ifTrue: 
		[fieldMap := LookupTable new: columns size.
		columns with: contents do: [ :col :obj | col field ifNotNil: [ :field | fieldMap at: field put: obj]]]!

lookupField: aField

	^fieldMap isNil 
		ifTrue: [1 to: columns size do: [ :index | (columns at: index) field = aField ifTrue: [^contents at: index]]. nil]
		ifFalse: [fieldMap lookup: aField]! !
!SSWODBCRow categoriesFor: #initializeFromBuffer:!initializing!public! !
!SSWODBCRow categoriesFor: #lookupField:!accessing!public! !


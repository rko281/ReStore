"Filed out from Dolphin Smalltalk"!

DBBoundField subclass: #SSWODBCField
	instanceVariableNames: 'statement needsRebinding previousScale scaleDivisor'
	classVariableNames: ''
	poolDictionaries: 'ODBCConstants'
	classInstanceVariableNames: ''!

SSWODBCField guid: (GUID fromString: '{4031cf23-9276-11d5-b1e0-0010a70883e2}')!

SSWODBCField comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!

!SSWODBCField categoriesForClass!Unclassified! !

!SSWODBCField methodsFor!

initializeForColumn: aDBColAttr
	"Private - Initialize the receiver to represent a value from
	the database column described by the <DBColAttr> argument.
	Answer the receiver."

	needsRebinding := false.
	^super initializeForColumn: aDBColAttr!

lengthBuf

	^lengthBuf!

needsRebinding
	^needsRebinding!

needsRebinding: anObject
	needsRebinding := anObject!

sqlDialect

	"Derive from the statement"

	^self statement sqlDialect!

statement

	"statement stores the SSWODBC...Statement to which this field relates"

	^statement!

statement: anSSWODBCStatement

	"statement stores the SSWODBC...Statement to which this field relates"

	statement := anSSWODBCStatement!

value: anObject

	"Special handling for function parameters: 
	Depending on the database type and function, the database may report an incorrect parameter type for a parameter field based on a function.
	e.g. YEAR(DATE_FIELD) may report DATE rather than INT type, or CONCAT(FIELD1, FIELD2) may have an insufficient buffer size for the parameter.
	Where this happens and causes an error, reconfigure the column based on the supplier parameter value, retry and mark the receiver for rebinding by its statement"

	[super value: anObject] on: Error do: 
		[ :exc |
		self column isFunctionParameter ifFalse: [exc pass].
		"Transcript cr; show: ('reconfigured <1s> size <2p>' expandMacrosWith: (ODBCTypes keyAtValue: column type) with: column length)."
		column configureToHold: anObject.
		self needsRebinding: true.
		buffer := self allocateBuffer.
		"Transcript show: (' to <1s> size <2p>' expandMacrosWith: (ODBCTypes keyAtValue: column type) with: column length)."
		exc return: (super value: anObject)]! !

!SSWODBCField categoriesForMethods!
initializeForColumn:!accessing!initializing!private! !
lengthBuf!accessing!public! !
needsRebinding!accessing!public! !
needsRebinding:!accessing!private! !
sqlDialect!accessing!public! !
statement!accessing!public! !
statement:!accessing!public! !
value:!accessing!public! !
!

!SSWODBCField class methodsFor!

newForCol: aColAttr statement: anSSWODBCStatement

	^(self newForCol: aColAttr)
		statement: anSSWODBCStatement;
		yourself! !

!SSWODBCField class categoriesForMethods!
newForCol:statement:!instance creation!public! !
!


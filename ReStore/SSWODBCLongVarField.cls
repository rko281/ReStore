"Filed out from Dolphin Smalltalk"!

DBLongVarField subclass: #SSWODBCLongVarField
	instanceVariableNames: 'statement needsRebinding'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWODBCLongVarField guid: (GUID fromString: '{6c393dc8-c2d4-4ed9-b761-7e459bbdba7f}')!

SSWODBCLongVarField comment: ''!

!SSWODBCLongVarField categoriesForClass!ODBC Interface! !

!SSWODBCLongVarField methodsFor!

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

	(anObject isNil or: [self column isFunctionParameter not or: [(anObject isKindOf: buffer valueClass) or: [anObject isString and: [buffer valueClass includesBehavior: String]]]]) ifTrue: [^super value: anObject].

	"Transcript cr; show: ('reconfigured <1s> size <2p>' expandMacrosWith: (ODBCTypes keyAtValue: column type) with: column length)."
	column configureToHold: anObject.
	self needsRebinding: true.
	buffer := self allocateBuffer.
	"Transcript show: (' to <1s> size <2p>' expandMacrosWith: (ODBCTypes keyAtValue: column type) with: column length)."

	buffer dbMarshal: anObject into: self! !

!SSWODBCLongVarField categoriesForMethods!
initializeForColumn:!accessing!initializing!private! !
lengthBuf!accessing!public! !
needsRebinding!accessing!public! !
needsRebinding:!accessing!private! !
sqlDialect!accessing!public! !
statement!accessing!public! !
statement:!accessing!public! !
value:!accessing!public! !
!

!SSWODBCLongVarField class methodsFor!

newForCol: aColAttr statement: anSSWODBCStatement

	^(self newForCol: aColAttr)
		statement: anSSWODBCStatement;
		yourself! !

!SSWODBCLongVarField class categoriesForMethods!
newForCol:statement:!instance creation!public! !
!


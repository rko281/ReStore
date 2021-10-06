"Filed out from Dolphin Smallalk"!

DBField subclass: #SSWODBCField
	instanceVariableNames: 'statement needsRebinding'
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

	lengthBuf := SDWORD fromInteger: SQL_NULL_DATA.
	column := aDBColAttr.
	buffer := ByteArray new: aDBColAttr lengthC.
	needsRebinding := false.
	^self!

needsRebinding
	^needsRebinding!

needsRebinding: anObject
	needsRebinding := anObject!

numberToNumeric: aNumberOrBoolean

	"Overridden to allow Numeric-based Booleans"

	(aNumberOrBoolean isKindOf: Boolean) 
	ifTrue: 
		["self assert: [self sqlDialect trueObject isKindOf: Integer]"
		aNumberOrBoolean 
			ifTrue: [super numberToNumeric: self sqlDialect trueObject]
			ifFalse: [super numberToNumeric: self sqlDialect falseObject]]
	ifFalse:
		[super numberToNumeric: aNumberOrBoolean]!

setAnsiString: aStringOrObject

	"Overridden to:
	 - automatically truncate oversize Strings
	 - allow String-based objects (Date, Boolean etc.)"

	aStringOrObject isString
	ifTrue: 
		[(column isFunctionParameter not and: [aStringOrObject  size > (buffer size - 1) "for null terminator"])
		ifTrue: 
			[Notification signal: 'ReStore: oversized String truncated'. 
			super setAnsiString: (aStringOrObject  copyFrom: 1 to: (buffer size - 1))]
		ifFalse: 
			[super setAnsiString: aStringOrObject ]]
	ifFalse: 
		[super setAnsiString: (aStringOrObject sqlStringIn: self sqlDialect)]!

setByte: aNumberOrBoolean

	"Overridden to allow Integer-based Booleans"

	(aNumberOrBoolean isKindOf: Boolean) 
	ifTrue: 
		["self assert: [self sqlDialect trueObject isKindOf: Integer]"
		aNumberOrBoolean 
			ifTrue: [super setByte: self sqlDialect trueObject]
			ifFalse: [super setByte: self sqlDialect falseObject]]
	ifFalse:
		[super setByte: aNumberOrBoolean]
!

setByteArray: aByteArrayOrOtherObject

	"Coerce other classes (principally GUID/UUID)"

	aByteArrayOrOtherObject class = ByteArray
		ifTrue: [super setByteArray: aByteArrayOrOtherObject]
		ifFalse: [self setByteArray: aByteArrayOrOtherObject asByteArray]!

setDateAndTime: aDateAndTime

	"Overridden to allow Date or Time (or another object implementing asDateAndTime) to be used"

	(aDateAndTime isKindOf: DateAndTime) 
		ifTrue: [super setDateAndTime: aDateAndTime]
		ifFalse: [super setDateAndTime: aDateAndTime asDateAndTime]!

setLong: aNumberOrBoolean

	"Overridden to allow Integer-based Booleans"

	(aNumberOrBoolean isKindOf: Boolean) 
	ifTrue: 
		["self assert: [self sqlDialect trueObject isKindOf: Integer]"
		aNumberOrBoolean 
			ifTrue: [super setLong: self sqlDialect trueObject]
			ifFalse: [super setLong: self sqlDialect falseObject]]
	ifFalse:
		[super setLong: aNumberOrBoolean]
!

setShort: aNumberOrBoolean

	"Overridden to allow Integer-based Booleans"

	(aNumberOrBoolean isKindOf: Boolean) 
	ifTrue: 
		["self assert: [self sqlDialect trueObject isKindOf: Integer]"
		aNumberOrBoolean 
			ifTrue: [super setShort: self sqlDialect trueObject]
			ifFalse: [super setShort: self sqlDialect falseObject]]
	ifFalse:
		[super setShort: aNumberOrBoolean]
!

setUtf16String: aStringOrObject

	"Overridden to:
	 - automatically truncate oversize Strings
	 - allow String-based objects (Date, Boolean etc.)"

	aStringOrObject isString
	ifTrue: 
		[(column isFunctionParameter not and: [aStringOrObject byteSize > (buffer size - 1) "for null terminator"])
		ifTrue: 
			[Notification signal: 'ReStore: oversized String truncated'. 
			super setUtf16String: (aStringOrObject copyFrom: 1 to: ((buffer size - 2) // 2))]
		ifFalse: 
			[super setUtf16String: aStringOrObject]]
	ifFalse: 
		[super setUtf16String: (aStringOrObject asSQLStringIn: self sqlDialect) asUtf16String]!

shouldTranslate: anObject class: aClass

	"Override the superclass implementation to allow Booleans to masquerade as other classes
	 (some DBs do not offer direct BOOLEAN support)"

	(anObject class = SSWDBAllocatedID and: [aClass = Number]) ifTrue: [^true].

	^((anObject isKindOf: Boolean) and: [self sqlDialect trueObject class isKindOf: aClass])
		or: [super shouldTranslate: anObject class: aClass]!

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
		column lengthC > buffer size ifTrue: [buffer := ByteArray newFixed: (##(2 raisedTo: 16) min: column lengthC)].
		"Transcript show: (' to <1s> size <2p>' expandMacrosWith: (ODBCTypes keyAtValue: column type) with: column length)."
		exc return: (super value: anObject)]! !
!SSWODBCField categoriesForMethods!
initializeForColumn:!accessing!private! !
needsRebinding!accessing!public! !
needsRebinding:!accessing!private! !
numberToNumeric:!converting!private! !
setAnsiString:!converting!private! !
setByte:!converting!private! !
setByteArray:!converting!private! !
setDateAndTime:!converting!private! !
setLong:!converting!private! !
setShort:!converting!private! !
setUtf16String:!converting!private! !
shouldTranslate:class:!accessing!private! !
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


"Filed out from Dolphin Smalltalk 7"!

DBField subclass: #SSWODBCField
	instanceVariableNames: 'statement'
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
	^self!

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
		[aStringOrObject  size > (buffer size - 1) "for null terminator"
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
		[aStringOrObject byteSize > (buffer size - 1) "for null terminator"
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

	statement := anSSWODBCStatement! !
!SSWODBCField categoriesFor: #initializeForColumn:!accessing!private! !
!SSWODBCField categoriesFor: #numberToNumeric:!converting!private! !
!SSWODBCField categoriesFor: #setAnsiString:!converting!private! !
!SSWODBCField categoriesFor: #setByte:!converting!private! !
!SSWODBCField categoriesFor: #setDateAndTime:!converting!private! !
!SSWODBCField categoriesFor: #setLong:!converting!private! !
!SSWODBCField categoriesFor: #setShort:!converting!private! !
!SSWODBCField categoriesFor: #setUtf16String:!converting!private! !
!SSWODBCField categoriesFor: #shouldTranslate:class:!accessing!private! !
!SSWODBCField categoriesFor: #sqlDialect!accessing!public! !
!SSWODBCField categoriesFor: #statement!accessing!public! !
!SSWODBCField categoriesFor: #statement:!accessing!public! !

!SSWODBCField class methodsFor!

newForCol: aColAttr statement: anSSWODBCStatement

	^(self newForCol: aColAttr)
		statement: anSSWODBCStatement;
		yourself! !
!SSWODBCField class categoriesFor: #newForCol:statement:!instance creation!public! !


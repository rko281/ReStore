"Filed out from Dolphin Smalltalk 7"!

DBColAttr subclass: #SSWODBCColAttr
	instanceVariableNames: 'field maxBoundBufferSize isFunctionParameter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWODBCColAttr guid: (GUID fromString: '{40397b21-5946-11d6-87e7-0010a70883e2}')!
SSWODBCColAttr comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWODBCColAttr categoriesForClass!Unclassified! !
!SSWODBCColAttr methodsFor!

configureToHold: anObject

	(anObject isKindOf: String) ifTrue: [^self configureToHoldString: anObject].
	anObject class = ByteArray ifTrue: [^self configureToHoldByteArray: anObject].

	"Set length to a value long enough to handle any remaining type"
	length := 256.

	(anObject isKindOf: Number) ifTrue: [^self configureToHoldNumber: anObject].
	(anObject == true or: [anObject == false]) ifTrue: [^sqlType := SQL_BIT].
	anObject class = Date ifTrue: [^sqlType := SQL_TYPE_DATE].
	anObject class = Time ifTrue: [^sqlType := SQL_TYPE_TIME].
	(anObject class = DateAndTime or: [anObject class name = #TimeStamp "avoid dependency on deprecated package"]) ifTrue: [^sqlType := SQL_TYPE_TIMESTAMP].
	anObject class = GUID ifTrue: [^sqlType := SQL_GUID].

	self error: 'unsupported class'!

configureToHoldByteArray: aByteArray

	sqlType := SQL_LONGVARBINARY.
	length := aByteArray size!

configureToHoldNumber: aNumber

	aNumber isInteger ifTrue:
		[^aNumber byteSize = 4
			ifTrue: [sqlType := SQL_SMALLINT]
			ifFalse: [sqlType := SQL_BIGINT]].

	(aNumber isFloat or: [aNumber isFraction]) ifTrue: [^sqlType := SQL_DOUBLE].

	aNumber class = ScaledDecimal ifTrue: 
		[precision := 64.
		scale := aNumber scale.
		^sqlType := SQL_DECIMAL].

	self error: 'unsupported numeric class'!

configureToHoldString: aString

	sqlType := SQL_WLONGVARCHAR.
	length := aString size * 2

	!

field

	"field stores the SSWSQLField from a SELECT query 
	that gave rise to this column in the resut set"

	^field!

field: anSSWSQLField

	"field stores the SSWSQLField from a SELECT query 
	that gave rise to this column in the resut set"

	field := anSSWSQLField!

initialize

	super initialize.
	self isFunctionParameter: false!

isFunctionParameter
	^isFunctionParameter!

isFunctionParameter: anObject
	isFunctionParameter := anObject!

lengthC

	"Override to utilise metadata from the field if available"

	| lengthC |

	"Workaround primarily for PostgreSQL which returns negative value for length of SQL_LONGVARBINARY columns"
	length negative
		ifTrue: [lengthC := self maxBoundBufferSize]
		ifFalse: [lengthC := super lengthC min: self maxBoundBufferSize].

	(self field isNil or: [self isFunctionParameter]) ifTrue: [^lengthC].

	(sqlType = SQL_LONGVARCHAR or: [sqlType = SQL_LONGVARBINARY]) ifTrue: 
		[lengthC = 0 ifTrue: [lengthC := self maxBoundBufferSize].
		^self field targetClass dbMaxFieldSize
			ifNil: [lengthC]
			ifNotNil: [ :maxFieldSize | lengthC min: (maxFieldSize + (CTypesExtraBytes at: sqlType+TypeOffset))]].

	sqlType = SQL_WLONGVARCHAR ifTrue: 
		[lengthC = 0 ifTrue: [lengthC := self maxBoundBufferSize].
		^self field targetClass dbMaxFieldSize
			ifNil: [lengthC]
			ifNotNil: [ :maxFieldSize | lengthC min: ((maxFieldSize * 2) + (CTypesExtraBytes at: sqlType+TypeOffset))]].

	^lengthC!

maxBoundBufferSize
	^maxBoundBufferSize!

maxBoundBufferSize: anObject
	maxBoundBufferSize := anObject!

postCreate

	"Workaround primarily for SQLite which reports BLOB columns as SQL_BINARY - this is defined as
		'Binary data of fixed length n'
	...which is incorrect and gives a max length of 255.

	Since ReStore doesn't support a SQL_BINARY type we convert this to SQL_LONGVARBINARY and increase the length accordingly"
	sqlType = SQL_BINARY ifFalse: [^self].

	self 
		type: SQL_LONGVARBINARY;
		length: self maxBoundBufferSize!

writeSQLOn: aStream

	aStream nextPutAll: self name! !
!SSWODBCColAttr categoriesFor: #configureToHold:!accessing!initializing!public! !
!SSWODBCColAttr categoriesFor: #configureToHoldByteArray:!accessing!initializing!private! !
!SSWODBCColAttr categoriesFor: #configureToHoldNumber:!accessing!initializing!private! !
!SSWODBCColAttr categoriesFor: #configureToHoldString:!accessing!initializing!private! !
!SSWODBCColAttr categoriesFor: #field!accessing!public! !
!SSWODBCColAttr categoriesFor: #field:!accessing!public! !
!SSWODBCColAttr categoriesFor: #initialize!initializing!public! !
!SSWODBCColAttr categoriesFor: #isFunctionParameter!accessing!public!testing! !
!SSWODBCColAttr categoriesFor: #isFunctionParameter:!accessing!private! !
!SSWODBCColAttr categoriesFor: #lengthC!accessing!private! !
!SSWODBCColAttr categoriesFor: #maxBoundBufferSize!accessing!private! !
!SSWODBCColAttr categoriesFor: #maxBoundBufferSize:!accessing!private! !
!SSWODBCColAttr categoriesFor: #postCreate!accessing!private! !
!SSWODBCColAttr categoriesFor: #writeSQLOn:!printing!public! !

!SSWODBCColAttr class methodsFor!

forString: aString

	"Create an instance of the receiver which describes a column capable of holding aString"

	^self new
		length: aString size;
		precision: aString size;
		maxBoundBufferSize: aString byteSize;
		type: SQL_VARCHAR;
		yourself! !
!SSWODBCColAttr class categoriesFor: #forString:!instance creation!public! !


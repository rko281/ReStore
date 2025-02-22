"Filed out from Dolphin Smalltalk"!

DBColAttr subclass: #SSWODBCColAttr
	instanceVariableNames: 'field maxBoundBufferSize isFunctionParameter'
	classVariableNames: 'SSWODBCBufferClasses'
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

	self type: SQL_LONGVARBINARY.
	length := aByteArray size!

configureToHoldNumber: aNumber

	aNumber isInteger ifTrue:
		[^aNumber byteSize = 4
			ifTrue: [self type: SQL_SMALLINT]
			ifFalse: [self type: SQL_BIGINT]].

	(aNumber isFloat or: [aNumber isFraction]) ifTrue: [self type: SQL_DOUBLE].

	aNumber class = ScaledDecimal ifTrue: 
		[precision := 64.
		scale := aNumber scale.
		self type: SQL_DECIMAL].

	self error: 'unsupported numeric class'!

configureToHoldString: aString

	self type: SQL_WLONGVARCHAR.
	length := aString size * 2

	!

copyForFunction

	^self copy
		resetType;
		yourself!

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
		resetType;
		type: SQL_LONGVARBINARY;
		length: self maxBoundBufferSize!

precision

	^super precision ifNil: [0]!

resetType

	sqlType := nil!

type: anInteger
	"Private - Set the sqlType instance variable to anInteger."

	sqlType notNil ifTrue: [self error: 'attempt to reconfigure column type'].
	sqlType := anInteger.
	self bufferClass: (SSWODBCBufferClasses at: anInteger
				ifAbsent: [self error: 'Unmarshallable column: ' , self printString])!

writeSQLOn: aStream

	aStream nextPutAll: self name! !

!SSWODBCColAttr categoriesForMethods!
configureToHold:!accessing!initializing!public! !
configureToHoldByteArray:!accessing!initializing!private! !
configureToHoldNumber:!accessing!initializing!private! !
configureToHoldString:!accessing!initializing!private! !
copyForFunction!copying!public! !
field!accessing!public! !
field:!accessing!public! !
initialize!initializing!public! !
isFunctionParameter!accessing!public!testing! !
isFunctionParameter:!accessing!private! !
maxBoundBufferSize!accessing!private! !
maxBoundBufferSize:!accessing!private! !
postCreate!accessing!private! !
precision!public! !
resetType!initializing!public! !
type:!initializing!public! !
writeSQLOn:!printing!public! !
!

!SSWODBCColAttr class methodsFor!

forString: aString

	"Create an instance of the receiver which describes a column capable of holding aString"

	^self new
		length: aString size;
		precision: aString size;
		maxBoundBufferSize: aString byteSize;
		type: SQL_VARCHAR;
		yourself!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	SSWODBCBufferClasses := BufferClasses copy.
	SSWODBCBufferClasses keysAndValuesDo: 
		[ :key :cls |
		cls = DBCharBuffer ifTrue: [SSWODBCBufferClasses at: key put: SSWODBCCharBuffer].
		cls = DBWCharBuffer ifTrue: [SSWODBCBufferClasses at: key put: SSWODBCWCharBuffer].
		cls = DBVarCharBuffer ifTrue: [SSWODBCBufferClasses at: key put: SSWODBCVarCharBuffer].
		cls = DBBinaryBuffer ifTrue: [SSWODBCBufferClasses at: key put: SSWODBCBinaryBuffer].
		cls = DBVarBinaryBuffer ifTrue: [SSWODBCBufferClasses at: key put: SSWODBCVarBinaryBuffer]]! !

!SSWODBCColAttr class categoriesForMethods!
forString:!instance creation!public! !
initialize!must not strip!public! !
!


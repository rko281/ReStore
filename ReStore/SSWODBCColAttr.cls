"Filed out from Dolphin Smalltalk 7"!

DBColAttr subclass: #SSWODBCColAttr
	instanceVariableNames: 'field maxBoundBufferSize'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWODBCColAttr guid: (GUID fromString: '{40397b21-5946-11d6-87e7-0010a70883e2}')!
SSWODBCColAttr comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWODBCColAttr categoriesForClass!Unclassified! !
!SSWODBCColAttr methodsFor!

field

	"field stores the SSWSQLField from a SELECT query 
	that gave rise to this column in the resut set"

	^field!

field: anSSWSQLField

	"field stores the SSWSQLField from a SELECT query 
	that gave rise to this column in the resut set"

	field := anSSWSQLField!

lengthC

	"Override to utilise metadata from the field if available"

	| lengthC |

	"Workaround primarily for PostgreSQL which returns negative value for length of SQL_LONGVARBINARY columns"
	length negative
		ifTrue: [lengthC := self maxBoundBufferSize]
		ifFalse: [lengthC := super lengthC min: self maxBoundBufferSize].

	self field isNil ifTrue: [^lengthC].

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
!SSWODBCColAttr categoriesFor: #field!accessing!public! !
!SSWODBCColAttr categoriesFor: #field:!accessing!public! !
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


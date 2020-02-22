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

	lengthC := super lengthC min: self maxBoundBufferSize.
	self field isNil ifTrue: [^lengthC].

	sqlType = SQL_LONGVARCHAR ifTrue: 
		[lengthC = 0 ifTrue: [lengthC := self maxBoundBufferSize].
		^self field targetClass dbMaxFieldSize
			ifNil: [lengthC]
			ifNotNil: [ :maxFieldSize | lengthC min: (maxFieldSize + (#(0 2 2 2 0 0 0 0 0 0 1 0 1 1 1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) at: sqlType+TypeOffset))]].

	sqlType = SQL_WLONGVARCHAR ifTrue: 
		[lengthC = 0 ifTrue: [lengthC := self maxBoundBufferSize].
		^self field targetClass dbMaxFieldSize
			ifNil: [lengthC]
			ifNotNil: [ :maxFieldSize | lengthC min: ((maxFieldSize * 2) + (#(0 2 2 2 0 0 0 0 0 0 1 0 1 1 1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) at: sqlType+TypeOffset))]].

	^lengthC!

maxBoundBufferSize
	^maxBoundBufferSize!

maxBoundBufferSize: anObject
	maxBoundBufferSize := anObject!

writeSQLOn: aStream

	aStream nextPutAll: self name! !
!SSWODBCColAttr categoriesFor: #field!accessing!public! !
!SSWODBCColAttr categoriesFor: #field:!accessing!public! !
!SSWODBCColAttr categoriesFor: #lengthC!accessing!private! !
!SSWODBCColAttr categoriesFor: #maxBoundBufferSize!accessing!private! !
!SSWODBCColAttr categoriesFor: #maxBoundBufferSize:!accessing!private! !
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


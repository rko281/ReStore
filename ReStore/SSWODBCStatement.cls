"Filed out from Dolphin Smalltalk 7"!

DBParameterizedStatement subclass: #SSWODBCStatement
	instanceVariableNames: 'query'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWODBCStatement guid: (GUID fromString: '{fe2079c2-ac50-11d5-b1e0-444553540000}')!
SSWODBCStatement comment: ''!
!SSWODBCStatement categoriesForClass!Unclassified! !
!SSWODBCStatement methodsFor!

close

	super close.
	self parent shouldFreeStatementsOnClose ifTrue: [self free]!

closeAfter: aBlock

	^[aBlock value: self] ensure: [self close]!

dbCheckException: anIntegerRetCode

	"19/8/2001

	Overriden to revector to parent connection, which may mask certain 'errors' "
	
	^self parent dbCheckException: anIntegerRetCode from: self!

describeCols: columnNumbers 

	"Intercept to set the fields used in the query"

	^SSWDBLookupArray 
		lookup:
			((super describeCols: columnNumbers) collect: 
				[ :colAttr |
				SSWODBCColAttr new
					columnNumber: colAttr columnNumber;
					name: colAttr name;
					type: colAttr type;
					length: colAttr length;
					precision: colAttr precision;
					scale: colAttr scale;
					field: (self query ifNotNil: [ :q | q fieldNamed: colAttr name]);
					maxBoundBufferSize: self sqlDialect maxColumnBytes;
					yourself]) 
		with: 
			[ :each | each field]!

describeParam: anInteger

	"Return an ODBCColAttr describing the parameter number anInteger in this query. 
	May not be supported by all DBs, in which case return nil"

	| parameterSize dataType decimalDigits nullable hStmt ret |

	self sqlDialect canDescribeParameters ifFalse: [^nil].

	isPrepared ifFalse: [self prepare].

	dataType := SWORD new.
	parameterSize := DWORD new.
	decimalDigits := SWORD new.
	nullable := SWORD new.
	hStmt := self allocatedHandle.
	ret := ODBCLibrary default
				sqlDescribeParam: hStmt
				parameterNumber: anInteger
				dataTypePtr: dataType
				parameterSizePtr: parameterSize
				decimalDigitsPtr: decimalDigits
				nullablePtr: nullable.
	self dbCheckException: ret.

	^SSWODBCColAttr new
		type: dataType value;
		length: parameterSize value;
		maxBoundBufferSize: parameterSize value;
		precision: parameterSize value;
		scale: decimalDigits value;
		yourself!

exec

	"Private - Inline as much as possible for speed"
	parent debugStream ifNotNil: [ :stream | self writeDebugInfoOn: stream].

	^super exec!

exec: aString

	"Immediate execution of raw SQL"

	self 
		paramCols: nil;
		prepare: aString.

	self exec!

execQuery: anSQLQuery

	| stream |

	self query: anSQLQuery.

	stream := SSWSQLWriteStream newIn: self sqlDialect.
	anSQLQuery writeSQLOn: stream.
	self sqlString: stream contents.

	stream hasParameterizedFields ifTrue: 
		[paramCols := stream parameterizedColumnsFor: self.
		self values: (stream parameterizedValues collect: [ :each | each odbcObject])].

	self exec!

parameters

	"18/9/2001

	Overriden to use SSWDBODBCFields; see superclass implementation for comment"

	parameters == nil ifTrue: 
		[parameters := (paramCols collect: [:col | SSWODBCField newForCol: col statement: self]) asArray.
		self setParams].

	^parameters!

query

	"25/4/2002 

	query stores the SSWSQLQuery which the statement is prepared to execute"

	^query!

query: anSSWSQLQuery

	"25/4/2002 

	query stores the SSWSQLQuery which the statement is prepared to execute"

	query := anSSWSQLQuery!

readValuesFrom: aStream

	| size index |

	size := self paramCols size.
	self values: (Array new: size).
	index := 1.

	[aStream atEnd or: [index > size]] whileFalse: 
		[values at: index put: aStream next.
		index := index + 1]!

results
	"Answer a <DBResultSet> that manages the results for the receiver.
	The result set will cause the receiver to be lazily executed when
	any attempt is made to access its contents."

	^(self cursorType == #forwardOnly 
		ifTrue: [SSWODBCForwardOnlyResultSet]
		ifFalse: [SSWODBCResultSet]) statement: self!

setParams

	"Created for issue 120-002

	Reimplemented to force use of SQL_PARAM_INPUT parameter type
	(default/input-output type causing errors with SQLServer)"

	"Private - Bind parameter columns for a prepared SQL statement so that when we 
	subsequently fill the buffer fields the statement is ready to exec. Normally only done 
	just before first exec (from #parameters)."

	1 to: paramCols size
		do: 
			[:each | 
			| buf col field |
			col := paramCols at: each.
			field := parameters at: each.
			buf := field fieldBuf.
			self dbCheckException: (ODBCLibrary default 
						sqlBindParameter: self allocatedHandle
						parameterNumber: each
						inputOutputType: SQL_PARAM_INPUT
						valueType: SQL_C_DEFAULT
						parameterType: col type
						columnSize: col precision
						decimalDigits: col scale
						parameterValuePtr: buf
						bufferLength: buf byteSize
						strLenOrIndPtr: field lengthBuf)]
!

sqlDialect

	"18/9/2001 

	Derive from the parent connection"

	^self parent sqlDialect!

writeDebugInfoOn: aStream

	| readStream valuesStream |

	paramCols isNil ifTrue: [^aStream nextPutAll: self sqlString; cr].

	readStream := ReadStream on: self sqlString.
	valuesStream := ReadStream on: self values.

	[aStream nextPutAll: (readStream upTo: $?).
	readStream atEnd] whileFalse: 
		[aStream nextPut: $[.
		valuesStream nextOrNil printOn: aStream.
		aStream nextPut: $]].

	self sqlString last = $? ifTrue: 
		[aStream nextPut: $[.
		valuesStream nextOrNil printOn: aStream.
		aStream nextPut: $]].

	aStream cr! !
!SSWODBCStatement categoriesFor: #close!operations!public! !
!SSWODBCStatement categoriesFor: #closeAfter:!operations!public! !
!SSWODBCStatement categoriesFor: #dbCheckException:!exceptions!private! !
!SSWODBCStatement categoriesFor: #describeCols:!accessing!public! !
!SSWODBCStatement categoriesFor: #describeParam:!accessing!public! !
!SSWODBCStatement categoriesFor: #exec!operations!private! !
!SSWODBCStatement categoriesFor: #exec:!operations!public! !
!SSWODBCStatement categoriesFor: #execQuery:!operations!public! !
!SSWODBCStatement categoriesFor: #parameters!accessing!private! !
!SSWODBCStatement categoriesFor: #query!accessing!public! !
!SSWODBCStatement categoriesFor: #query:!accessing!public! !
!SSWODBCStatement categoriesFor: #readValuesFrom:!operations!public! !
!SSWODBCStatement categoriesFor: #results!accessing!public! !
!SSWODBCStatement categoriesFor: #setParams!accessing!public! !
!SSWODBCStatement categoriesFor: #sqlDialect!accessing!public! !
!SSWODBCStatement categoriesFor: #writeDebugInfoOn:!operations!public! !


"Filed out from Dolphin Smalltalk 7"!

DBParameterizedStatement subclass: #SSWODBCStatement
	instanceVariableNames: 'query'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWODBCStatement guid: (GUID fromString: '{fe2079c2-ac50-11d5-b1e0-444553540000}')!
SSWODBCStatement comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWODBCStatement categoriesForClass!Unclassified! !
!SSWODBCStatement methodsFor!

bindParams
	"Private - Bind parameter columns for a prepared SQL statement so that when we 
	subsequently fill the buffer fields the statement is ready to exec. Normally only done 
	just before first exec (from #parameters)."

	| odbc hstmt |
	odbc := ODBCLibrary default.
	hstmt := self allocatedHandle.
	parameters keysAndValuesDo: 
			[:i :eachField |
			| buf column |
			buf := eachField fieldBuf.
			column := eachField column.
			self dbCheckException: (odbc
						sqlBindParameter: hstmt
						parameterNumber: i
						inputOutputType: column parameterType
						valueType: column cType
						parameterType: column type
						columnSize: column precision
						decimalDigits: column scale
						parameterValuePtr: buf
						bufferLength: buf byteSize
						strLenOrIndPtr: eachField lengthBuf)]!

close

	super close.
	self parent shouldFreeStatementsOnClose ifTrue: [self free]!

closeAfter: aBlock

	^[aBlock value: self] ensure: [self close]!

dbCheckException: anIntegerRetCode

	"Overriden to revector to parent connection, which may mask certain 'errors' "
	
	^self parent dbCheckException: anIntegerRetCode from: self!

describeCols: columnNumbers 

	"Intercept to set the fields used in the query"

	^(super describeCols: columnNumbers) collect: 
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
			yourself]!

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
		paramCols: #();
		prepare: aString.

	self exec!

execQuery: anSQLQuery

	| stream |

	self query: anSQLQuery.

	stream := self sqlDialect sqlWriteStream.
	anSQLQuery writeSQLOn: stream.
	self sqlString: stream contents.

	stream hasParameterizedFields ifTrue: 
		[paramCols := stream parameterizedColumnsFor: self.
		self values: stream parameterizedValues].

	self exec!

parameters

	"Overriden to use SSWDBODBCFields; see superclass implementation for comment"

	^parameters ifNil: 
		[parameters := (paramCols collect: [:col | SSWODBCField newForCol: col statement: self]) asArray.
		self bindParams.
		parameters]!

query

	"query stores the SSWSQLQuery which the statement is prepared to execute"

	^query!

query: anSSWSQLQuery

	"query stores the SSWSQLQuery which the statement is prepared to execute"

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

rowsAffected

	"Return the number of rows affected by this statement.
	Assume this represents the end of interaction by this statement so also close the receiver"

	^self closeAfter: [ :stmt | stmt numRows]!

sqlDialect

	"Derive from the parent connection"

	^self parent sqlDialect!

values: aCollection

	super values: (aCollection collect: [ :each | each reStoreValue])!

writeDebugInfoOn: aStream

	| readStream valuesStream sqlStream |

	(paramCols ifNil: [#()]) isEmpty ifTrue: [^aStream nextPutAll: self sqlString; nextPut: $;; cr].

	readStream := ReadStream on: self sqlString.
	valuesStream := ReadStream on: self values.
	sqlStream := self sqlDialect sqlWriteStream.

	[| nextChunk |
	nextChunk := self parent upToParameterPlaceholderOn: readStream.
	nextChunk isEmpty ifFalse: 
		[sqlStream nextPutAll: nextChunk.
		valuesStream atEnd ifFalse: [valuesStream nextOrNil printOn: sqlStream]].
	readStream atEnd] whileFalse.

	aStream nextPutAll: sqlStream contents; nextPut: $;; cr! !
!SSWODBCStatement categoriesFor: #bindParams!operations!public! !
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
!SSWODBCStatement categoriesFor: #rowsAffected!accessing!public! !
!SSWODBCStatement categoriesFor: #sqlDialect!accessing!public! !
!SSWODBCStatement categoriesFor: #values:!public! !
!SSWODBCStatement categoriesFor: #writeDebugInfoOn:!operations!public! !


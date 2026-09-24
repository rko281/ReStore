"Filed out from Dolphin Smalltalk"!

SQLite3PreparedStatement subclass: #SSWSQLite3Statement
	instanceVariableNames: 'query sqlString parametersCount results values'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWSQLite3Statement guid: (GUID fromString: '{bfe54def-92fb-4d02-a20a-4eeba9ecc6e9}')!

SSWSQLite3Statement comment: ''!

!SSWSQLite3Statement categoriesForClass!SQLite3-Core-Database! !

!SSWSQLite3Statement methodsFor!

at: aColumn putTimeStamp: aTimeStamp

	^self at: aColumn putDateTime: aTimeStamp asDateAndTime!

bindParameters: bindings	bindings keysAndValuesDo: [ :index :value | value sqliteBindTo: self at: index]!

close

	"In Dolphin this closes the result set, leaving the statement open"
	
	self results ifNotNil: [ :res | res close ]!

closeAfter: aBlock

	^[ aBlock value: self ] ensure: [ self close ]!

cursoredFetch: aBoolean

	"Always enabled"!

cursorType: aSymbol!

exec

	self logQueryExecution.
	self results: self execute!

execute
	^self execute: self values!

execute: bindings 

	^(super execute: bindings) asSSWSQLite3ResultSet!

free

	handle isNil ifFalse: [self finalize]!

isFreed

	^handle isNil!

logQueryExecution

	self parent logStatementExecution: self!

numRows

	^self results numRows!

parametersCount
	^ parametersCount!

parametersCount: anObject
	parametersCount := anObject!

parent

	^connection!

prepare: aString

	self sqlString: aString.
	^super prepare: aString!

query

	^query!

readValuesFrom: aStream

	| size index |

	size := self parametersCount.
	self values: (Array new: size).
	index := 1.

	[aStream atEnd or: [index > size]] whileFalse: 
		[self valueAt: index put: aStream next.
		index := index + 1]!

results
	^ results!

results: anObject
	results := anObject!

rowsAffected

	^self closeAfter: [ :stmt | stmt numRows]!

setQuery: anSSWSQLQuery
	query := anSSWSQLQuery !

sqlDialect

	^self parent sqlDialect!

sqlString
	^ sqlString!

sqlString: anObject
	sqlString := anObject!

valueAt: anIndex put: anObject

	self values at: anIndex put: anObject!

valueOfColumn: aColumn

	| type |
	
	type := self library apiColumnType: handle atColumn: aColumn.

	type = SQLITE_NULL ifTrue: [^nil].
	type = SQLITE_INTEGER ifTrue: [^self integerAt: aColumn].
	type = SQLITE_TEXT ifTrue: [^self stringAt: aColumn].
	type = SQLITE_FLOAT ifTrue: [^self floatAt: aColumn].
	type = SQLITE_BLOB ifTrue: [^self byteArrayAt: aColumn].
	
	self error: 'unknown type'!

values
	^ values ifNil: [ #() ]!

values: anObject
	values := anObject collect: [  :each | each reStoreValue ]!

writeDebugInfoOn: aStream

	| readStream valuesStream sqlStream |

	self parametersCount = 0 ifTrue: [^aStream nextPutAll: self sqlString; nextPut: $;; cr].

	readStream := ReadStream on: self sqlString.
	valuesStream := ReadStream on: self values.
	sqlStream := self sqlDialect sqlWriteStream.

	[| nextChunk |
	nextChunk := readStream upTo: $?.
	nextChunk isEmpty ifFalse: 
		[sqlStream nextPutAll: nextChunk.
		valuesStream atEnd ifFalse: [valuesStream nextAvailable printOn: sqlStream]].
	readStream atEnd] whileFalse.

	aStream nextPutAll: sqlStream contents; nextPut: $;; cr! !

!SSWSQLite3Statement categoriesForMethods!
at:putTimeStamp:!bindings!public! !
bindParameters:!bindings!public! !
close!initialize/release!public! !
closeAfter:!initialize/release!public! !
cursoredFetch:!initialize/release!public! !
cursorType:!initialize/release!public! !
exec!public!querying! !
execute!execution!public! !
execute:!execution!public! !
free!connection open/close!initialize/release!public! !
isFreed!public!testing! !
logQueryExecution!public! !
numRows!accessing!public! !
parametersCount!accessing!public! !
parametersCount:!accessing!public! !
parent!accessing!public! !
prepare:!execution!public! !
query!accessing!public! !
readValuesFrom:!initialize/release!public! !
results!accessing!public! !
results:!accessing!public! !
rowsAffected!accessing!public! !
setQuery:!accessing!public! !
sqlDialect!accessing!public! !
sqlString!accessing!public! !
sqlString:!accessing!public! !
valueAt:put:!accessing!public! !
valueOfColumn:!fetching!public! !
values!accessing!public! !
values:!accessing!public! !
writeDebugInfoOn:!accessing!public! !
!


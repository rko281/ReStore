"Filed out from Dolphin Smalltalk"!

MySQLDriverStatement subclass: #SSWMySQLStatement
	instanceVariableNames: 'query sqlString parametersCount results'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWMySQLStatement guid: (GUID fromString: '{c7ce58c6-303e-4bac-b822-0a9302298e52}')!

SSWMySQLStatement comment: ''!

!SSWMySQLStatement categoriesForClass!SSW ReStore MySQL! !

!SSWMySQLStatement methodsFor!

adoptResultSet: anSSWMySQLResultSet

	rsContext := anSSWMySQLResultSet !

close

	"In Dolphin this closes the result set, leaving the statement open"
	
	self results ifNotNil: [ :res | res close ]!

closeAfter: aBlock

	^[ aBlock value: self ] ensure: [ self close ]!

cursoredFetch: aBoolean 

	"Set a default fetchSize"
	(aBoolean and: [ fetchSize isNil ]) ifTrue: [ 	fetchSize := 10 ].

	super cursoredFetch: aBoolean!

cursorType: aSymbol

	self cursoredFetch: aSymbol notNil!

describeParam: anInteger

	^nil!

exec

	self logQueryExecution.
	self results: self execute!

executeCommandClass
	^SSWMySQLCommandExecute!

fetchCommandClass
	^SSWMySQLCommandFetch!

free

	stmtId isNil ifFalse: 
		[super close.
		stmtId := nil]!

logQueryExecution

	self parent logStatementExecution: self!

numRows

	^self results numRows!

parametersCount
	^ parametersCount!

parametersCount: anObject
	parametersCount := anObject!

parent

	^driver!

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
	(params at: anIndex) bindValue: anObject reStoreValue!

values
	^ params ifNil: [ #()] ifNotNil: [ params collect: [ :each | each value ] ]!

values: aCollection

	params := OrderedCollection new: aCollection size.
	aCollection do: [ :each | self addBinding: each reStoreValue]!

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

!SSWMySQLStatement categoriesForMethods!
adoptResultSet:!initialize/release!public! !
close!initialize/release!public! !
closeAfter:!initialize/release!public! !
cursoredFetch:!initialize/release!public! !
cursorType:!initialize/release!public! !
describeParam:!accessing!public! !
exec!public!querying! !
executeCommandClass!accessing!public! !
fetchCommandClass!accessing!public! !
free!initialize/release!public! !
logQueryExecution!public! !
numRows!accessing!public! !
parametersCount!accessing!public! !
parametersCount:!accessing!public! !
parent!accessing!public! !
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
values!accessing!public! !
values:!accessing!public! !
writeDebugInfoOn:!public! !
!


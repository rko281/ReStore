"Filed out from Dolphin Smalltalk"!

P3PreparedStatement subclass: #SSWP3Statement
	instanceVariableNames: 'query sqlString parametersCount results values'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWP3Statement guid: (GUID fromString: '{b03e959f-120b-4918-a649-95df0701798a}')!

SSWP3Statement comment: ''!

!SSWP3Statement categoriesForClass!P3-Core! !

!SSWP3Statement methodsFor!

client: aP3Connection

	client := aP3Connection !

client: aClient name: aString paramDescriptions: pCollection fieldDescriptions: fCollection

	client := aClient.
	name := aString.
	paramDescriptions := pCollection.
	fieldDescriptions := fCollection!

close

	"In Dolphin this closes the result set, leaving the statement open"
	
	self results ifNotNil: [ :res | res close ]!

closeAfter: aBlock

	^[ aBlock value: self ] ensure: [ self close ]!

cursorType: aSymbol!

describeParam: anInteger

	^nil!

exec

	self logQueryExecution.
	self results: self execute!

execute

	^(self query: self values) 
		query: self query; 
		yourself
!

free

	[super close] on: Error do: [  :exc | exc return: nil ]!

isFreed 
	^client isNil!

logQueryExecution

	self parent logStatementExecution: self!

numRows

	^self results numRows!

parametersCount
	^ parametersCount!

parametersCount: anObject
	parametersCount := anObject!

parent

	^client!

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

results: anSSWP3ResultSet
	results := anSSWP3ResultSet.
	anSSWP3ResultSet statement: self!

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
	nextChunk := readStream upTo: $$.
	nextChunk isEmpty ifFalse: 
		[sqlStream nextPutAll: nextChunk.
		valuesStream atEnd ifFalse: [valuesStream nextAvailable printOn: sqlStream]].
	readStream peek notNil ifTrue: [readStream next].
	readStream atEnd] whileFalse.

	aStream nextPutAll: sqlStream contents; nextPut: $;; cr! !

!SSWP3Statement categoriesForMethods!
client:!accessing!public! !
client:name:paramDescriptions:fieldDescriptions:!accessing!public! !
close!initialize/release!public! !
closeAfter:!initialize/release!public! !
cursorType:!accessing!public! !
describeParam:!accessing!public! !
exec!public!querying! !
execute!execution!public! !
free!initialize/release!public! !
isFreed!public!testing! !
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
writeDebugInfoOn:!helpers!public! !
!


"Filed out from Dolphin Smalltalk"!

P3Result subclass: #SSWP3ResultSet
	instanceVariableNames: 'query dataStream columns statement'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWP3ResultSet guid: (GUID fromString: '{1394a23a-6dfd-4d4a-b3ea-25a94cb062a7}')!

SSWP3ResultSet comment: ''!

!SSWP3ResultSet categoriesForClass!P3-Core! !

!SSWP3ResultSet methodsFor!

close

	"In Dolphin this closes the result set, leaving the statement open.
	Nothing to do here"!

columns

	^columns!

cursorType
	^#forwardOnly!

dataStream

	^dataStream ifNil: [ dataStream := self data readStream ]!

do: aBlock

	data do: [ :vals | aBlock value: (self rowWith: vals)]!

first

	^data isEmpty 
		ifTrue: [nil] 
		ifFalse: [self rowWith: data first]!

free

	statement free!

keysAndValuesDo: aBlock

	data keysAndValuesDo: [ :index :vals | aBlock value: index value: (self rowWith: vals)]!

last

	^data isEmpty 
		ifTrue: [nil] 
		ifFalse: [self rowWith: data last]!

next

	^self dataStream next ifNotNil: [ :rowData | self rowWith: rowData ]!

numRows

	| stream |
	
	stream := results readStream.
	[ stream atEnd or: [ stream peek isDigit ] ] whileFalse: [ stream next ].

	^stream atEnd 
		ifTrue: [ 0 ]
		ifFalse: [ Integer readFrom: stream ]!

position: anInteger
	
	self dataStream position: anInteger!

query
	^query!

query: anObject
	query := anObject.
	columns :=  descriptions collect: 
		[ :each | 
		SSWDBColAttr new 
			name: each fieldName; 
			field:  (query fieldNamed: each fieldName);
			yourself].!

readStream

	^SSWDBReadStream on: self!

resetAndFetchFirst

	self dataStream reset.
	^self next!

results 
	^self!

results: rCollection descriptions: dCollection data: dtCollection

	results := rCollection.
	descriptions := dCollection.
	data := dtCollection!

rowWith: someData

	^SSWP3Row new
		columns: self columns;
		data: someData;
		yourself!

size

	^self numberOfRecords!

species

	^OrderedCollection!

statement
	^statement!

statement: anObject
	statement := anObject! !

!SSWP3ResultSet categoriesForMethods!
close!initialize/release!public! !
columns!accessing!public! !
cursorType!public! !
dataStream!accessing!public! !
do:!enumerating!public! !
first!accessing!public! !
free!initialize/release!public! !
keysAndValuesDo:!enumerating!public! !
last!accessing!public! !
next!enumerating!public! !
numRows!accessing!public! !
position:!accessing!public! !
query!accessing!public! !
query:!accessing!public! !
readStream!accessing!public! !
resetAndFetchFirst!accessing!public! !
results!accessing!public! !
results:descriptions:data:!initialize/release!public! !
rowWith:!accessing!public! !
size!accessing!public! !
species!accessing!public! !
statement!accessing!private! !
statement:!accessing!private! !
!


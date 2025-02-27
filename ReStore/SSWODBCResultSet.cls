"Filed out from Dolphin Smalltalk"!

DBResultSet subclass: #SSWODBCResultSet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWODBCResultSet guid: (GUID fromString: '{63906dc1-74e4-4a2f-9c30-abf926240a0f}')!

SSWODBCResultSet comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!

!SSWODBCResultSet categoriesForClass!ODBC Interface! !

!SSWODBCResultSet methodsFor!

bufferClass
	"Private - Answer the buffer class to use for DBResultSets (e.g. DBBoundRow for bound buffers 
	where memory is allocated and bound using SQLBindCol, or DBUnboundRow for unbound buffers 
	which are retrieved individually)."

	^SSWODBCBoundBuffer!

cursorType

	^statement cursorType!

position: anInteger

	self moveTo: anInteger!

readStream

	^SSWDBReadStream on: self!

resetAndFetchFirst

	^self first!

size

	"Return nil if not known"

	| numRows |

	numRows := self numRows.

	"Normally -1 (or sometimes less) indicates unknown. However SQLite (at least) returns zero, so err on the side of caution"
	^numRows <= 0
		ifTrue: [nil]
		ifFalse: [numRows]! !

!SSWODBCResultSet categoriesForMethods!
bufferClass!constants!private! !
cursorType!accessing!public! !
position:!accessing!public! !
readStream!accessing!public! !
resetAndFetchFirst!accessing!public! !
size!public! !
!


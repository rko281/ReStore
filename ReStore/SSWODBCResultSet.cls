"Filed out from Dolphin Smalltalk 7"!

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
!SSWODBCResultSet categoriesFor: #bufferClass!constants!private! !
!SSWODBCResultSet categoriesFor: #position:!accessing!public! !
!SSWODBCResultSet categoriesFor: #readStream!accessing!public! !
!SSWODBCResultSet categoriesFor: #resetAndFetchFirst!accessing!public! !
!SSWODBCResultSet categoriesFor: #size!public! !


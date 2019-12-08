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

	^SSWODBCBoundBuffer! !
!SSWODBCResultSet categoriesFor: #bufferClass!constants!private! !


"Filed out from Dolphin Smalltalk 7"!

DBForwardOnlyResultSet subclass: #SSWODBCForwardOnlyResultSet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWODBCForwardOnlyResultSet guid: (GUID fromString: '{91952fb5-bbfd-4e69-a36d-268a26de19c7}')!
SSWODBCForwardOnlyResultSet comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWODBCForwardOnlyResultSet categoriesForClass!ODBC Interface! !
!SSWODBCForwardOnlyResultSet methodsFor!

bufferClass
	"Private - Answer the buffer class to use for DBResultSets (e.g. DBBoundRow for bound buffers 
	where memory is allocated and bound using SQLBindCol, or DBUnboundRow for unbound buffers 
	which are retrieved individually)."

	^SSWODBCBoundBuffer! !
!SSWODBCForwardOnlyResultSet categoriesFor: #bufferClass!constants!private! !


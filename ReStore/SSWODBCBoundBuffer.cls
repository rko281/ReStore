"Filed out from Dolphin Smalltalk 7"!

DBBoundBuffer subclass: #SSWODBCBoundBuffer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWODBCBoundBuffer guid: (GUID fromString: '{10b26832-9f19-457f-9cf0-c8840ce1a415}')!
SSWODBCBoundBuffer comment: ''!
!SSWODBCBoundBuffer categoriesForClass!ODBC Interface! !
!SSWODBCBoundBuffer methodsFor!

bind: aDBStatement
	"Private - Bind the receiver's field buffers to columns in the result table."

	| hStmt |
	hStmt := super bind: aDBStatement.
	self contents with: columns
		do: 
			[:eachField :eachColumn | 
			aDBStatement dbCheckException: (ODBCLibrary default 
						sqlBindCol: hStmt
						columnNumber: eachColumn columnNumber
						targetType: eachColumn cType
						targetValuePtr: eachField fieldBuf
						bufferLength: eachField fieldSize
						strLenOrInd: eachField lengthBuf)].
	^hStmt!

contents
	"Answer the contents instance variable."

	contents isNil
		ifTrue: [contents := columns collect: [:colAttr | SSWODBCField newForCol: colAttr]].
	^contents.! !
!SSWODBCBoundBuffer categoriesFor: #bind:!operations!private! !
!SSWODBCBoundBuffer categoriesFor: #contents!public! !


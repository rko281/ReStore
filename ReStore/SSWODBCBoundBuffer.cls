"Filed out from Dolphin Smalltalk"!

DBBoundBuffer subclass: #SSWODBCBoundBuffer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWODBCBoundBuffer guid: (GUID fromString: '{10b26832-9f19-457f-9cf0-c8840ce1a415}')!
SSWODBCBoundBuffer comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWODBCBoundBuffer categoriesForClass!ODBC Interface! !
!SSWODBCBoundBuffer methodsFor!

asObject
	"Private - Answer the receiver as an instance of DBRow containing the receiver's values."

	^SSWODBCRow fromBuffer: self!

bind: aDBStatement
	"Overridden to set the field's rowIndex"

	| hStmt odbc |
	hStmt := super bind: aDBStatement.
	odbc := ODBCLibrary default.
	self contents do: 
			[:eachField |
			| dataBuffer column |
			column := eachField column.
			column field ifNotNil: [ :field | field columnIndex: column columnNumber].
			dataBuffer := eachField fieldBuf.
			aDBStatement dbCheckException: (odbc
						sqlBindCol: hStmt
						columnNumber: column columnNumber
						targetType: column cType
						targetValuePtr: dataBuffer
						bufferLength: dataBuffer size
						strLenOrInd: eachField lengthBuf)].
	^hStmt!

contents
	"Answer the contents instance variable."

	contents isNil
		ifTrue: [contents := columns collect: [:colAttr | SSWODBCField newForCol: colAttr]].
	^contents.! !
!SSWODBCBoundBuffer categoriesForMethods!
asObject!converting!private! !
bind:!operations!private! !
contents!accessing!public! !
!


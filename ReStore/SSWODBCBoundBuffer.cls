"Filed out from Dolphin Smalltalk 7"!

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

contents
	"Answer the contents instance variable."

	contents isNil
		ifTrue: [contents := columns collect: [:colAttr | SSWODBCField newForCol: colAttr]].
	^contents.! !
!SSWODBCBoundBuffer categoriesFor: #asObject!converting!private! !
!SSWODBCBoundBuffer categoriesFor: #contents!accessing!public! !


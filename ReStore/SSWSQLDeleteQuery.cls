"Filed out from Dolphin Smalltalk 7"!

SSWSQLConditionalQuery subclass: #SSWSQLDeleteQuery
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLDeleteQuery guid: (GUID fromString: '{6266c933-3983-11d5-b1df-444553540000}')!
SSWSQLDeleteQuery comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLDeleteQuery categoriesForClass!Unclassified! !
!SSWSQLDeleteQuery methodsFor!

isWriteQuery

	^true!

writeSQLOn: aStream

	aStream nextPutAll: 'DELETE FROM '.
	self table writeSQLOn: aStream.

	self writeWhereClauseOn: aStream! !
!SSWSQLDeleteQuery categoriesFor: #isWriteQuery!public!testing! !
!SSWSQLDeleteQuery categoriesFor: #writeSQLOn:!output!public! !


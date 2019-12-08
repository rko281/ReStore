"Filed out from Dolphin Smalltalk 7"!

SSWSQLObjectQuery subclass: #SSWSQLDeleteObjectQuery
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLDeleteObjectQuery guid: (GUID fromString: '{6266c92e-3983-11d5-b1df-444553540000}')!
SSWSQLDeleteObjectQuery comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLDeleteObjectQuery categoriesForClass!Unclassified! !
!SSWSQLDeleteObjectQuery methodsFor!

parameterisedFields

	^{self table idField}!

values

	^{self object _id}!

writeSQLOn: aStream

	aStream nextPutAll: 'DELETE FROM '.
	self table writeSQLOn: aStream.
	
	aStream nextPutAll: ' WHERE '.
	self objectIDCondition writeSQLOn: aStream! !
!SSWSQLDeleteObjectQuery categoriesFor: #parameterisedFields!accessing!public! !
!SSWSQLDeleteObjectQuery categoriesFor: #values!accessing!public! !
!SSWSQLDeleteObjectQuery categoriesFor: #writeSQLOn:!output!public! !


"Filed out from Dolphin Smalltalk 7"!

SSWSQLObjectQuery subclass: #SSWSQLInsertQuery
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLInsertQuery guid: (GUID fromString: '{6266c92f-3983-11d5-b1df-444553540000}')!
SSWSQLInsertQuery comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLInsertQuery categoriesForClass!Unclassified! !
!SSWSQLInsertQuery methodsFor!

fields

	"Return the fields involved in this insert, as an SSWSQLFieldCollection"
	
	^self table allFields!

parameterisedFields

	"In the receiver, all fields are parameterised"

	^self fields!

values

	"Return the values to be inserted by the receiver, as an SSWSQLFieldCollection"	

	^self fields collect: [ :field | field accessor valueIn: self object]!

writeSQLOn: aStream

	aStream nextPutAll: 'INSERT INTO '.
	self table writeSQLOn: aStream.
	
	aStream space; nextPut: $(.
	self fields do: [ :field | aStream nextPutIdentifier: field name] separatedBy: [aStream nextPutAll: ', '].

	aStream nextPutAll: ') VALUES ('.
	self values with: self fields do: [ :value :field | value writeSQLOn: aStream forField: field. aStream nextPutAll: ', '].
	aStream 
		position: (aStream position - 2); 
		nextPut: $)
! !
!SSWSQLInsertQuery categoriesFor: #fields!output!public! !
!SSWSQLInsertQuery categoriesFor: #parameterisedFields!output!public! !
!SSWSQLInsertQuery categoriesFor: #values!output!public! !
!SSWSQLInsertQuery categoriesFor: #writeSQLOn:!output!public! !


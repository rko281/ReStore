"Filed out from Dolphin Smalltalk 7"!

SSWSQLInsertQuery subclass: #SSWSQLParameterisedInsertQuery
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLParameterisedInsertQuery guid: (GUID fromString: '{253913e1-3ff6-11d5-b1df-0010a70883e2}')!
SSWSQLParameterisedInsertQuery comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStoreForDolphin
https://github.com/rko281/ReStoreForPharo'!
!SSWSQLParameterisedInsertQuery categoriesForClass!Unclassified! !
!SSWSQLParameterisedInsertQuery methodsFor!

objectValues

	"Return the actual values to be inserted, as specified by the object"		

	^super values!

parameterisedFields

	"In the receiver, all fields are parameterised"

	^self fields!

values

	"Return the values to be inserted by the receiver, as an SSWSQLFieldCollection.
	For a parameterised query, these are all parameters"		

	^self fields collect: [ :field | SSWSQLQueryParameter]! !
!SSWSQLParameterisedInsertQuery categoriesFor: #objectValues!output!public! !
!SSWSQLParameterisedInsertQuery categoriesFor: #parameterisedFields!output!public! !
!SSWSQLParameterisedInsertQuery categoriesFor: #values!output!public! !


"Filed out from Dolphin Smalltalk 7"!

SSWSQLCollection variableSubclass: #SSWSQLTableCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLTableCollection guid: (GUID fromString: '{6266c925-3983-11d5-b1df-444553540000}')!
SSWSQLTableCollection comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLTableCollection categoriesForClass!Unclassified! !
!SSWSQLTableCollection methodsFor!

allFields

	"Return an SSWLSQLFieldCollection which represents all fields in each of the receiver's tables"
	
	| allFields |
	
	allFields := SSWSQLFieldCollection new: self size.

	self do: [ :table | allFields add: (SSWSQLField allFieldsInTable: table)].
	
	^allFields!

soleTable

	"Return the single member of the receiver.
	Error if there is not exactly one member"
	
	^self size = 1
		ifTrue: [self first]
		ifFalse: [self error: 'Should be only one table']!

soleTable: anSSWDBTable

	"Set the single member of the receiver to anSSWDBTable"
	
	self 
		removeAll: self copy;
		add: anSSWDBTable!

sqlConcatenator

	"A comma is used to separate a list of tables in SQL"
	
	^', '! !
!SSWSQLTableCollection categoriesFor: #allFields!output!public! !
!SSWSQLTableCollection categoriesFor: #soleTable!accessing!public! !
!SSWSQLTableCollection categoriesFor: #soleTable:!accessing!public! !
!SSWSQLTableCollection categoriesFor: #sqlConcatenator!output!public! !


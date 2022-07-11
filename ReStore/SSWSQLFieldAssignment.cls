"Filed out from Dolphin Smallalk"!

SSWSQLFieldValueConjunction subclass: #SSWSQLFieldAssignment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLFieldAssignment guid: (GUID fromString: '{6266c92a-3983-11d5-b1df-444553540000}')!
SSWSQLFieldAssignment comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLFieldAssignment categoriesForClass!Unclassified! !
!SSWSQLFieldAssignment methodsFor!

, anSSWSQLFieldAssignment

	^SSWSQLFieldAssignmentCollection with: self with: anSSWSQLFieldAssignment!

applyTo: anObject

	"The receiver relates a field (which relates to an instance var) to a value (Smalltalk object).
	'Apply' the receiver assignment to anObject by assigning its value to its field's inst var
	
	ASSERT: anObject class = self field table instanceClass"
	
	self field accessor value: self value in: anObject!

copyTo: anObject

	"The receiver relates a field (which relates to an instance var) to a value (Smalltalk object).
	Copy the receiver assignment to anObject by assigning its value to its field's inst var.
	This may necessiate a copy of anObject, as determined by the accessor.
	
	ASSERT: anObject class = self field table instanceClass"

	self field accessor copyValue: self value in: anObject!

writeConjunctionSQLOn: aStream

	"The conjunction for assignment is simply '=' "
	
	aStream nextPut: $=!

writeFieldSQLOn: aStream

	"Ensure that the 'update' variant of the field is used"
	
	self field writeSQLForUpdateOn: aStream
! !
!SSWSQLFieldAssignment categoriesForMethods!
,!actions!public! !
applyTo:!actions!public! !
copyTo:!actions!public! !
writeConjunctionSQLOn:!output!private! !
writeFieldSQLOn:!output!private! !
!


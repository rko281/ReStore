"Filed out from Dolphin Smallalk"!

SSWSQLCollection variableSubclass: #SSWSQLFieldAssignmentCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLFieldAssignmentCollection guid: (GUID fromString: '{6266c923-3983-11d5-b1df-444553540000}')!
SSWSQLFieldAssignmentCollection comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLFieldAssignmentCollection categoriesForClass!Unclassified! !
!SSWSQLFieldAssignmentCollection methodsFor!

applyTo: anObject

	self do: [ :fieldAssignment | fieldAssignment applyTo: anObject]!

copyTo: anObject

	self do: [ :fieldAssignment | fieldAssignment copyTo: anObject]!

sqlConcatenator

	"A comma is used to separate a list of field assignments 
	in an SQL UPDATE query"
	
	^', '! !
!SSWSQLFieldAssignmentCollection categoriesForMethods!
applyTo:!actions!public! !
copyTo:!actions!public! !
sqlConcatenator!output!public! !
!


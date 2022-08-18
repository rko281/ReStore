"Filed out from Dolphin Smallalk"!

SSWSQLConditionalQuery subclass: #SSWSQLDeleteQuery
	instanceVariableNames: 'isMultiTableDelete'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLDeleteQuery guid: (GUID fromString: '{6266c933-3983-11d5-b1df-444553540000}')!
SSWSQLDeleteQuery comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLDeleteQuery categoriesForClass!Unclassified! !
!SSWSQLDeleteQuery methodsFor!

isMultiTableDelete

	"Answer true if the receiver should delete from all its tables or false if just from the primary (first) table.
	Default is false"

	^isMultiTableDelete!

isMultiTableDelete: anObject
	isMultiTableDelete := anObject!

isWriteQuery

	^true!

writeDeletionTablesOn: aStream

	self isMultiTableDelete
		ifTrue: [self tables do: [ :table | table writeSQLNameOn: aStream] separatedBy: [aStream nextPut: $,]]
		ifFalse: [self tables first writeSQLNameOn: aStream]!

writeSQLOn: aStream

	self tables size = 1 
	ifTrue:
		[aStream nextPutAll: 'DELETE FROM '.
		self table writeSQLOn: aStream]
	ifFalse: 
		[aStream dialect supportsDeleteWithJoin 
		ifTrue: 
			[aStream nextPutAll: 'DELETE '.
			self writeDeletionTablesOn: aStream.
			aStream nextPutAll: ' FROM '.
			self tables writeSQLOn: aStream]
		ifFalse: 
			[self error: 'not supported in ', aStream dialect dbmsName]].

	self writeWhereClauseOn: aStream! !
!SSWSQLDeleteQuery categoriesForMethods!
isMultiTableDelete!accessing!public!testing! !
isMultiTableDelete:!accessing!public! !
isWriteQuery!public!testing! !
writeDeletionTablesOn:!output!private! !
writeSQLOn:!output!public! !
!

!SSWSQLDeleteQuery class methodsFor!

new

	^super new
		isMultiTableDelete: false;
		yourself! !
!SSWSQLDeleteQuery class categoriesForMethods!
new!instance creation!public! !
!


﻿"Filed out from Dolphin Smalltalk 7"!

SSWSQLJoinedTableCollection variableSubclass: #SSWSQLLeftJoinedTableCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLLeftJoinedTableCollection guid: (GUID fromString: '{6266c927-3983-11d5-b1df-444553540000}')!
SSWSQLLeftJoinedTableCollection comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLLeftJoinedTableCollection categoriesForClass!Unclassified! !
!SSWSQLLeftJoinedTableCollection methodsFor!

writeSQLOn: aStream

	self size = 1 ifTrue: [^super writeSQLOn: aStream].
	
	(self size - 1) timesRepeat: [aStream nextPut: $(].
	
	self first writeSQLOn: aStream.
	
	2 to: self size do:
		[ :index || nextTable join |
		nextTable := self at: index.
		join := self joinConditions at: (index - 1).
		aStream nextPutAll: ' LEFT JOIN '.
		nextTable writeSQLOn: aStream.
		aStream nextPutAll: ' ON '.
		join writeSQLOn: aStream.
		aStream nextPut: $)]
			! !
!SSWSQLLeftJoinedTableCollection categoriesFor: #writeSQLOn:!output!public! !


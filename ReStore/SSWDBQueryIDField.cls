"Filed out from Dolphin Smalltalk 7"!

SSWDBQueryTableField subclass: #SSWDBQueryIDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBQueryIDField guid: (GUID fromString: '{e0a20d08-a937-4c77-9bb7-e39c78770d2d}')!
SSWDBQueryIDField comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBQueryIDField categoriesForClass!Unclassified! !
!SSWDBQueryIDField methodsFor!

convertValue: aValue

	"Lookup/create the persistent object with this ID"

	^aValue isNil 
		ifTrue: [nil]
		ifFalse: [self table reStore deferredObjectOfClass: self table instanceClass withID: aValue]! !
!SSWDBQueryIDField categoriesFor: #convertValue:!evaluating!public! !

!SSWDBQueryIDField class methodsFor!

forTable: aDBTable

	^self forField: aDBTable idField in: aDBTable! !
!SSWDBQueryIDField class categoriesFor: #forTable:!instance creation!public! !


"Filed out from Dolphin Smalltalk"!

Object subclass: #SSWSQLQuery
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLQuery guid: (GUID fromString: '{6266c92c-3983-11d5-b1df-444553540000}')!
SSWSQLQuery comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLQuery categoriesForClass!Unclassified! !
!SSWSQLQuery methodsFor!

asSubQuery

	^SSWSQLSubQuery new
		query: self;
		yourself!

isReadQuery

	"Subclasses should override if they read data"
	
	^false!

isWriteQuery

	"Subclasses should override if they write data"
	
	^false!

preExecIn: anSSWReStore!

sqlCanBeParameterized

	^false! !
!SSWSQLQuery categoriesForMethods!
asSubQuery!converting!public! !
isReadQuery!public!testing! !
isWriteQuery!public!testing! !
preExecIn:!operations!public! !
sqlCanBeParameterized!public!testing! !
!


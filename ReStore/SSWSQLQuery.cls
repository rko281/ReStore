"Filed out from Dolphin Smalltalk 7"!

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
!SSWSQLQuery categoriesFor: #asSubQuery!converting!public! !
!SSWSQLQuery categoriesFor: #isReadQuery!public!testing! !
!SSWSQLQuery categoriesFor: #isWriteQuery!public!testing! !
!SSWSQLQuery categoriesFor: #preExecIn:!operations!public! !
!SSWSQLQuery categoriesFor: #sqlCanBeParameterized!public!testing! !


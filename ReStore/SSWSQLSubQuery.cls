"Filed out from Dolphin Smalltalk 7"!

SSWSQLQuery subclass: #SSWSQLSubQuery
	instanceVariableNames: 'query'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLSubQuery guid: (GUID fromString: '{0f2149cd-5dfa-413d-903b-854fa3a10dfa}')!
SSWSQLSubQuery comment: ''!
!SSWSQLSubQuery categoriesForClass!Kernel-Objects! !
!SSWSQLSubQuery methodsFor!

isReadQuery
	
	^self query isReadQuery!

isWriteQuery
	
	^self query isWriteQuery!

preExecIn: anSSWReStore

	self query preExecIn: anSSWReStore!

query
	^query!

query: anObject
	query := anObject!

writeSQLOn: aStream

	"SubQueries should we wrapped in parentheses"

	aStream nextPut: $(.
	self query writeSQLOn: aStream.
	aStream nextPut: $)
! !
!SSWSQLSubQuery categoriesFor: #isReadQuery!public!testing! !
!SSWSQLSubQuery categoriesFor: #isWriteQuery!public!testing! !
!SSWSQLSubQuery categoriesFor: #preExecIn:!operations!public! !
!SSWSQLSubQuery categoriesFor: #query!accessing!private! !
!SSWSQLSubQuery categoriesFor: #query:!accessing!private! !
!SSWSQLSubQuery categoriesFor: #writeSQLOn:!output!public! !


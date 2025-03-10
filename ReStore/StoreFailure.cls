"Filed out from Dolphin Smalltalk"!

Notification subclass: #StoreFailure
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StoreFailure guid: (GUID fromString: '{65d52ae7-5f95-495e-aa9a-da9ee9241815}')!

StoreFailure comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!

!StoreFailure categoriesForClass!Kernel-Exception Handling! !

!StoreFailure methodsFor!

abandon

	self reStore abandonTransaction!

commit

	"Returns success"

	^self reStore commitTransaction!

defaultAction

	"Default is to abandon the active (failed) transaction"

	self reStore storeFailureHandler
		ifNil: [self abandon]
		ifNotNil: [ :handler | handler value: self]!

failedObjects

	^self reStore transactionCommitFailures!

refreshAndRollforward

	self reStore refreshAndRollforwardTransaction!

reStore

	^self tag!

rollback

	self reStore rollbackTransaction!

rollbackAndRefresh

	self reStore rollbackAndRefreshTransaction! !

!StoreFailure categoriesForMethods!
abandon!operations!public! !
commit!operations!public! !
defaultAction!operations!private! !
failedObjects!accessing!public! !
refreshAndRollforward!operations!public! !
reStore!accessing!public! !
rollback!operations!public! !
rollbackAndRefresh!operations!public! !
!


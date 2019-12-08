"Filed out from Dolphin Smalltalk 7"!

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

	self abandon!

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
!StoreFailure categoriesFor: #abandon!operations!public! !
!StoreFailure categoriesFor: #commit!operations!public! !
!StoreFailure categoriesFor: #defaultAction!operations!private! !
!StoreFailure categoriesFor: #failedObjects!accessing!public! !
!StoreFailure categoriesFor: #refreshAndRollforward!operations!public! !
!StoreFailure categoriesFor: #reStore!accessing!public! !
!StoreFailure categoriesFor: #rollback!operations!public! !
!StoreFailure categoriesFor: #rollbackAndRefresh!operations!public! !


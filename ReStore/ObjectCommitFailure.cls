"Filed out from Dolphin Smalltalk 7"!

Notification subclass: #ObjectCommitFailure
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ObjectCommitFailure guid: (GUID fromString: '{3e467cb2-b2ca-472f-8893-1dfab8066500}')!
ObjectCommitFailure comment: ''!
!ObjectCommitFailure categoriesForClass!Kernel-Exception Handling! !
!ObjectCommitFailure methodsFor!

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
!ObjectCommitFailure categoriesFor: #abandon!operations!public! !
!ObjectCommitFailure categoriesFor: #commit!operations!public! !
!ObjectCommitFailure categoriesFor: #defaultAction!operations!private! !
!ObjectCommitFailure categoriesFor: #failedObjects!accessing!public! !
!ObjectCommitFailure categoriesFor: #refreshAndRollforward!operations!public! !
!ObjectCommitFailure categoriesFor: #reStore!accessing!public! !
!ObjectCommitFailure categoriesFor: #rollback!operations!public! !
!ObjectCommitFailure categoriesFor: #rollbackAndRefresh!operations!public! !


"Filed out from Dolphin Smallalk"!

SSWDBTransactionError subclass: #SSWDBTransactionCommitError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBTransactionCommitError guid: (GUID fromString: '{e3ba525c-ebd9-4b80-b54f-4e738c348ba6}')!
SSWDBTransactionCommitError comment: ''!
!SSWDBTransactionCommitError categoriesForClass!Kernel-Exception Handling! !
!SSWDBTransactionCommitError methodsFor!

_autoRecover

	[reStore connection rollbackTxn] on: Error do: [ :txnExc | txnExc return].
	self transaction autoRecoverCommitIn: self!

stage

	^'commit'! !
!SSWDBTransactionCommitError categoriesForMethods!
_autoRecover!handling!private! !
stage!constants!public! !
!


"Filed out from Dolphin Smallalk"!

SSWDBTransactionError subclass: #SSWDBTransactionPreCommitError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBTransactionPreCommitError guid: (GUID fromString: '{c0496350-a07c-4891-bc38-e1ba2179cd55}')!
SSWDBTransactionPreCommitError comment: ''!
!SSWDBTransactionPreCommitError categoriesForClass!Kernel-Exception Handling! !
!SSWDBTransactionPreCommitError methodsFor!

_autoRecover

	self transaction autoRecoverPreCommitIn: self!

stage

	^'pre-commit'! !
!SSWDBTransactionPreCommitError categoriesForMethods!
_autoRecover!handling!private! !
stage!constants!public! !
!


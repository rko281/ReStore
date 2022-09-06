"Filed out from Dolphin Smallalk"!

Error subclass: #SSWDBTransactionError
	instanceVariableNames: 'reStore isRecovered'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBTransactionError guid: (GUID fromString: '{49dcfd1f-766e-4eec-85c6-fed951955ddc}')!
SSWDBTransactionError comment: ''!
!SSWDBTransactionError categoriesForClass!Kernel-Exception Handling! !
!SSWDBTransactionError methodsFor!

_autoRecover

	self subclassResponsibility!

autoRecover

	isRecovered ifFalse: 
		[self _autoRecover.
		isRecovered := true]!

defaultAction

	^self sessionManager onUnhandledTransactionError: self!

isRecovered

	^isRecovered!

signalWith: anException in: aReStore

	reStore := aReStore.
	isRecovered := false.
	
	[aReStore isDebugging 
		ifTrue: [anException pass]
		ifFalse: [self signal: 'An error occurred during <1s>: <2s>' << {self stage. anException description} with: anException]] ensure: [self autoRecover]!

stage

	^self subclassResponsibility!

transaction

	^reStore transaction! !
!SSWDBTransactionError categoriesForMethods!
_autoRecover!handling!private! !
autoRecover!handling!public! !
defaultAction!handling!public! !
isRecovered!public!testing! !
signalWith:in:!public!signalling! !
stage!constants!public! !
transaction!accessing!public! !
!

!SSWDBTransactionError class methodsFor!

signalWith: anException in: aReStore

	^self new signalWith: anException in: aReStore! !
!SSWDBTransactionError class categoriesForMethods!
signalWith:in:!instance creation!public! !
!


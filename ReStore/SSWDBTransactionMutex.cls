"Filed out from Dolphin Smallalk"!

Mutex subclass: #SSWDBTransactionMutex
	instanceVariableNames: 'debugClasses reStore'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBTransactionMutex guid: (GUID fromString: '{f48d2eaf-d747-4b0f-9e91-6578c01ae32a}')!
SSWDBTransactionMutex comment: ''!
!SSWDBTransactionMutex categoriesForClass!Unclassified! !
!SSWDBTransactionMutex methodsFor!

critical: aNiladicBlock

	reStore isDebugging ifFalse: [^super critical: aNiladicBlock].

	^self critical: aNiladicBlock ifLocked: 
		[self isInDebugCallStack 
			ifTrue: [aNiladicBlock value]
			ifFalse: [super critical: aNiladicBlock]]!

debugClasses
	^debugClasses!

debugClasses: anObject
	debugClasses := anObject!

initialize

	super initialize.
	debugClasses := IdentitySet withAll: self defaultDebugClasses!

reStore
	^reStore!

reStore: anObject
	reStore := anObject! !
!SSWDBTransactionMutex categoriesForMethods!
critical:!operations!public! !
debugClasses!accessing!private! !
debugClasses:!accessing!private! !
initialize!initialize/release!public! !
reStore!accessing!private! !
reStore:!accessing!private! !
!

!SSWDBTransactionMutex class methodsFor!

newFor: anSSWReStore

	^self new
		reStore: anSSWReStore;
		yourself! !
!SSWDBTransactionMutex class categoriesForMethods!
newFor:!instance creation!public! !
!


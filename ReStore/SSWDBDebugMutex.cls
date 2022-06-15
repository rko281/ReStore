"Filed out from Dolphin Smallalk"!

Mutex subclass: #SSWDBDebugMutex
	instanceVariableNames: 'debugClasses'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBDebugMutex guid: (GUID fromString: '{f48d2eaf-d747-4b0f-9e91-6578c01ae32a}')!
SSWDBDebugMutex comment: ''!
!SSWDBDebugMutex categoriesForClass!Unclassified! !
!SSWDBDebugMutex methodsFor!

critical: aNiladicBlock

	^self shouldBypassMutexForDebug
		ifTrue: [aNiladicBlock value]
		ifFalse: [super critical: aNiladicBlock]!

critical: aNiladicBlock ifLocked: exceptionHandler

	^self shouldBypassMutexForDebug
		ifTrue: [aNiladicBlock value]
		ifFalse: [super critical: aNiladicBlock ifLocked: exceptionHandler]!

debugClasses
	^debugClasses!

debugClasses: anObject
	debugClasses := anObject!

initialize

	super initialize.
	debugClasses := IdentitySet withAll: self defaultDebugClasses! !
!SSWDBDebugMutex categoriesForMethods!
critical:!operations!public! !
critical:ifLocked:!operations!public! !
debugClasses!accessing!private! !
debugClasses:!accessing!private! !
initialize!initialize/release!public! !
!


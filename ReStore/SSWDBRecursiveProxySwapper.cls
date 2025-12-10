"Filed out from Dolphin Smalltalk"!

SSWDBProxySwapper subclass: #SSWDBRecursiveProxySwapper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWDBRecursiveProxySwapper guid: (GUID fromString: '{636f9ada-9194-4410-ac7c-1ef0c7fbcfa7}')!

SSWDBRecursiveProxySwapper comment: ''!

!SSWDBRecursiveProxySwapper categoriesForClass!Kernel-Objects! !

!SSWDBRecursiveProxySwapper methodsFor!

addProxy: aProxy forObject: anObject 

	(proxiesMap includesKey: aProxy) ifTrue: [ ^ self ].
	super addProxy: aProxy forObject: anObject.
	aProxy _addPersistentComponentsTo: self.
	^ aProxy! !

!SSWDBRecursiveProxySwapper categoriesForMethods!
addProxy:forObject:!public! !
!


"Filed out from Dolphin Smalltalk"!

SSWDBProxySwapper subclass: #SSWDBCollectionProxySwapper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWDBCollectionProxySwapper guid: (GUID fromString: '{d2b5d2e9-31e8-438e-b6d9-ef485e34e7da}')!

SSWDBCollectionProxySwapper comment: ''!

!SSWDBCollectionProxySwapper categoriesForClass!Kernel-Objects! !

!SSWDBCollectionProxySwapper methodsFor!

addProxy: aProxy forObject: anObject 

	super addProxy: aProxy forObject: anObject.
	aProxy isDBCollectionProxy ifTrue: [
		aProxy _addPersistentComponentsTo: self ]! !

!SSWDBCollectionProxySwapper categoriesForMethods!
addProxy:forObject:!public! !
!


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

_swapProxy: aDBProxy
	"Private - Should only be called inside transactionCritical:"

	self
		initialize: aDBProxy _proxiedObject size + 1;
		addProxy: aDBProxy forObject: aDBProxy _proxiedObject.
	aDBProxy _addPersistentComponentsTo: self.
	self _swap!

addProxy: aProxy forObject: anObject 

	super addProxy: aProxy forObject: anObject.
	"aProxy isDBCollectionProxy ifTrue: [self halt.
		aProxy _addPersistentComponentsTo: self ]"! !

!SSWDBCollectionProxySwapper categoriesForMethods!
_swapProxy:!public! !
addProxy:forObject:!public! !
!


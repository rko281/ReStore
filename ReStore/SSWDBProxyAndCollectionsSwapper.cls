"Filed out from Dolphin Smalltalk"!

SSWDBProxySwapper subclass: #SSWDBProxyAndCollectionsSwapper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWDBProxyAndCollectionsSwapper guid: (GUID fromString: '{315437bb-8481-4466-bccd-d0dcedc643d4}')!

SSWDBProxyAndCollectionsSwapper comment: ''!

!SSWDBProxyAndCollectionsSwapper categoriesForClass!Kernel-Objects! !

!SSWDBProxyAndCollectionsSwapper methodsFor!

addProxy: aProxy forObject: anObject

	super addProxy: aProxy forObject: anObject.

	aProxy isDBObjectProxy ifTrue: 
		[aProxy _collectionProxies do: 
			[ :each | 
			each _proxiedObject ifNotNil: 
				[ :collection |
				super addProxy: each forObject: collection]]].

	^aProxy! !

!SSWDBProxyAndCollectionsSwapper categoriesForMethods!
addProxy:forObject:!adding!private! !
!


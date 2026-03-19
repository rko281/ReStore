"Filed out from Dolphin Smalltalk"!

SSWDBProxySwapper subclass: #SSWDBTransactionProxySwapper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWDBTransactionProxySwapper guid: (GUID fromString: '{b04bc863-e08d-4753-8d54-59cba671a2f0}')!

SSWDBTransactionProxySwapper comment: ''!

!SSWDBTransactionProxySwapper categoriesForClass!Kernel-Objects! !

!SSWDBTransactionProxySwapper methodsFor!

_abandon

	self 
		swapAllWhere: [ :proxy | proxy _isPersistent ifTrue: [proxy _preUnswap. true] ifFalse: [false]]
		postAction: [ :proxy | "ASSERT: We are removing everything from #currentReferencedObjects, so we don't need to remove one by one"
			 ].!

_swap
	"Override to not skip proxies already in the desired state--this should never happen in the transaction mechanism."

	self
		swapAllWhere: [ :proxy | proxy _preSwap. true ]
		postAction: [ :proxy | proxy _reStore addToTransaction: proxy ].!

_unswap
	"Override to not skip proxies already in the desired state--this should never happen in the transaction mechanism."

	self
		swapAllWhere: [ :proxy | proxy _preUnswap. true ]
		postAction: [ :proxy | "ASSERT: We are removing everything from #currentReferencedObjects, so we don't need to remove one by one"
			 ].!

abandon: aCollection

	aCollection isEmpty ifFalse: 
		[self reStore: aCollection anyOne _reStore.
		self 
			initialize: aCollection size;
			addAll: aCollection;
			_abandon]!

addProxy: aProxy

	self assert: aProxy _isRecovered.
	"We are used internal to the transaction mechanism,
	so must be willing to swap proxies that are not yet persistent, i.e. about to be stored."
	^ self addProxy: aProxy forObject: aProxy _proxiedObject! !

!SSWDBTransactionProxySwapper categoriesForMethods!
_abandon!operations!private! !
_swap!operations!public! !
_unswap!operations!public! !
abandon:!operations!public! !
addProxy:!public! !
!

!SSWDBTransactionProxySwapper class methodsFor!

swapAll: aCollection

	"Equivalent to
		aCollection collect: [ :each | each _swap] 
	"

	^aCollection isEmpty 
		ifTrue: [aCollection]
		ifFalse: [(self newFor: aCollection anyOne _reStore) swapAll: aCollection]!

unswapAll: aCollection

	"Equivalent to
		aCollection collect: [ :each | each _unswap] 
	"

	^aCollection isEmpty 
		ifTrue: [aCollection]
		ifFalse: [(self newFor: aCollection anyOne _reStore) unswapAll: aCollection]! !

!SSWDBTransactionProxySwapper class categoriesForMethods!
swapAll:!operations!public! !
unswapAll:!operations!public! !
!


"Filed out from Dolphin Smalltalk"!

Object subclass: #SSWDBProxySwapper
	instanceVariableNames: 'reStore proxiesMap isUnswap'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWDBProxySwapper guid: (GUID fromString: '{f60208f5-6dd9-4905-967f-c6e67fac4210}')!

SSWDBProxySwapper comment: ''!

!SSWDBProxySwapper categoriesForClass!Kernel-Objects! !

!SSWDBProxySwapper methodsFor!

_swap

	self 
		swapAllWhere: [ :proxy | proxy _isSwapped ifTrue: [false] ifFalse: [proxy _preSwap. true]]
		postAction: [ :proxy | proxy _reStore addToTransaction: proxy]!

_swapProxy: aDBProxy

	"Private - Should only be called inside transactionCritical:"

	self 
		initialize: 3;
		addProxy: aDBProxy forObject: aDBProxy _proxiedObject;
		_swap!

_unswap

	self 
		swapAllWhere: [ :proxy | proxy _isSwapped ifTrue: [proxy _preUnswap. true] ifFalse: [false]]
		postAction: [ :proxy | proxy _reStore removeFromTransaction: proxy]!

abandon: aCollection

	aCollection isEmpty ifFalse: 
		[self reStore: aCollection anyOne _reStore.
		self unswapAll: aCollection]!

add: aProxyOrObject

	^aProxyOrObject isDBProxy 
		ifTrue: [self addProxy: aProxyOrObject]
		ifFalse: [self addObject: aProxyOrObject]!

addAll: aCollection

	proxiesMap isNil ifTrue: [self initialize: aCollection size].

	^aCollection do: [ :each | self add: each]!

addObject: anObject

	^(anObject _dbProxyIn: reStore ifNone: [nil]) ifNotNil: [ :proxy | self addProxy: proxy forObject: anObject]!

addProxy: aDBProxy

	^aDBProxy _isPersistent ifTrue: 
		[aDBProxy _proxiedObject ifNotNil: 
			[ :object |
			self addProxy: aDBProxy forObject: object]]!

addProxy: aProxy forObject: anObject

	proxiesMap at: aProxy put: anObject.
	^aProxy!

assert: aBoolean

	aBoolean ifFalse: [self error: 'assertion failed']!

initialize: anInteger

	self initialize.
		
	proxiesMap := IdentityDictionary new: anInteger!

isEmpty

	^proxiesMap isEmpty!

proxiesDo: aBlock

	^proxiesMap keysDo: aBlock!

proxiesMap

	^proxiesMap!

reStore
	^reStore!

reStore: anObject
	reStore := anObject!

reswap

	"ASSERT: the transaction in which the receiver was created has been rolled back.
	Reverse the map to reflect that a swap has previously occurred then reswap objects back into place"

	| reversedMap |

	reversedMap := IdentityDictionary new: proxiesMap size.
	proxiesMap do: 
		[ :proxy |
		proxy isDBProxy ifTrue:  "<- filter out locally deleted objects"
			[proxy _proxiedObject ifNotNil: [ :object | reversedMap at: proxy put: object]]].
	proxiesMap := reversedMap.

	^reStore ensureHasTransactionCritical: [self _swap]!

swap

	reStore ensureHasTransactionCritical: [self _swap]!

swapAll: aCollection

	reStore ensureHasTransactionCritical: 
		[self 
			initialize: aCollection size;
			addAll: aCollection;
			_swap]!

swapAllWhere: preBlock postAction: postBlock

	| proxies objects |

	proxies := OrderedCollection new: proxiesMap size.
	objects := proxies copy.

	proxiesMap keysAndValuesDo: [ :proxy :object |
		(preBlock value: proxy) ifTrue: [
			proxy _preSwapReferences.
			proxies add: proxy.
			objects add: object ] ].

	proxies asArray elementsExchangeIdentityWith: objects asArray.

	proxies
		with: objects
		do: [ :object :proxy | "<- arguments reversed following the swap"
			proxy
				_setProxiedObject: object;
				_postSwapReferences.
			postBlock value: proxy]!

unswap

	reStore transactionCritical: [self _unswap]!

unswapAll: aCollection

	reStore transactionCritical: 
		[self 
			initialize: aCollection size;
			addAll: aCollection;
			_unswap]! !

!SSWDBProxySwapper categoriesForMethods!
_swap!operations!private! !
_swapProxy:!operations!private! !
_unswap!operations!private! !
abandon:!operations!public! !
add:!adding!private! !
addAll:!adding!private! !
addObject:!adding!private! !
addProxy:!adding!private! !
addProxy:forObject:!adding!private! !
assert:!helpers!public! !
initialize:!initialize/release!public! !
isEmpty!public!testing! !
proxiesDo:!enumerating!public! !
proxiesMap!accessing!public! !
reStore!accessing!private! !
reStore:!accessing!private! !
reswap!operations!private! !
swap!operations!public! !
swapAll:!helpers!public! !
swapAllWhere:postAction:!helpers!private! !
unswap!operations!public! !
unswapAll:!operations!public! !
!

!SSWDBProxySwapper class methodsFor!

newFor: aReStore

	^self new
		reStore: aReStore;
		yourself! !

!SSWDBProxySwapper class categoriesForMethods!
newFor:!instance creation!public! !
!


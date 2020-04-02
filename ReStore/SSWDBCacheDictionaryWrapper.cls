"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SSWDBCacheDictionaryWrapper
	instanceVariableNames: 'dictionary keyAccessor'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBCacheDictionaryWrapper guid: (GUID fromString: '{84da480d-41e9-4d4b-a313-55b762275de3}')!
SSWDBCacheDictionaryWrapper comment: ''!
!SSWDBCacheDictionaryWrapper categoriesForClass!Kernel-Objects! !
!SSWDBCacheDictionaryWrapper methodsFor!

_dbAdd: targetObject

	"Add the targetObject to the dictionary at the key derived by the keyAccessor"

	^self dictionary at: (self keyAccessor value: targetObject) put: targetObject!

_dbAdd: targetObject suggestedIndex: ignore

	^self _dbAdd: targetObject!

_proxifyIn: aCollectionProxy

	aCollectionProxy _proxiedObject: self dictionary.
	^self dictionary!

dictionary
	^dictionary!

dictionary: anObject
	dictionary := anObject!

keyAccessor
	^keyAccessor!

keyAccessor: anObject
	keyAccessor := anObject! !
!SSWDBCacheDictionaryWrapper categoriesFor: #_dbAdd:!adding!public! !
!SSWDBCacheDictionaryWrapper categoriesFor: #_dbAdd:suggestedIndex:!adding!public! !
!SSWDBCacheDictionaryWrapper categoriesFor: #_proxifyIn:!private!restore-internal! !
!SSWDBCacheDictionaryWrapper categoriesFor: #dictionary!accessing!private! !
!SSWDBCacheDictionaryWrapper categoriesFor: #dictionary:!accessing!private! !
!SSWDBCacheDictionaryWrapper categoriesFor: #keyAccessor!accessing!private! !
!SSWDBCacheDictionaryWrapper categoriesFor: #keyAccessor:!accessing!private! !


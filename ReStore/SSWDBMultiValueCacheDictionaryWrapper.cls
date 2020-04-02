"Filed out from Dolphin Smalltalk 7"!

SSWDBCacheDictionaryWrapper subclass: #SSWDBMultiValueCacheDictionaryWrapper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBMultiValueCacheDictionaryWrapper guid: (GUID fromString: '{b5e470d1-816c-4890-b68e-ca532c6642dd}')!
SSWDBMultiValueCacheDictionaryWrapper comment: ''!
!SSWDBMultiValueCacheDictionaryWrapper categoriesForClass!Kernel-Objects! !
!SSWDBMultiValueCacheDictionaryWrapper methodsFor!

_dbAdd: targetObject

	"Add the targetObject to the dictionary at the key derived by the keyAccessor"

	^(self dictionary at: (self keyAccessor value: targetObject) ifAbsentPut: [OrderedCollection new]) add: targetObject! !
!SSWDBMultiValueCacheDictionaryWrapper categoriesFor: #_dbAdd:!adding!public! !


"Filed out from Dolphin Smallalk"!

SSWDBCollectionEntry subclass: #SSWDBCacheDictionaryEntry
	instanceVariableNames: 'keyAccessor'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBCacheDictionaryEntry guid: (GUID fromString: '{fb382c12-7c2e-11d5-b1df-0010a70883e2}')!
SSWDBCacheDictionaryEntry comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBCacheDictionaryEntry categoriesForClass!Unclassified! !
!SSWDBCacheDictionaryEntry methodsFor!

_cacheDictionaryKey_

	"Special selector allowing interception by the block parser"

	^self key!

addTargetTo: aCollection

	aCollection at: self key put: self target!

index

	^self _cacheDictionaryKey_!

key

	^self keyAccessor value: self target!

keyAccessor

	"keyAccessor stores an a 1-arg block that is evaluated with a targetObject to determine the key at which that object should be stored in the dictionary"

	^keyAccessor!

keyAccessor: anSSWInstVarAccessor

	"keyAccessor stores an a 1-arg block that is evaluated with a targetObject to determine the key at which that object should be stored in the dictionary"

	keyAccessor := anSSWInstVarAccessor! !
!SSWDBCacheDictionaryEntry categoriesForMethods!
_cacheDictionaryKey_!private! !
addTargetTo:!actions!public! !
index!public! !
key!accessing!public! !
keyAccessor!accessing!private! !
keyAccessor:!accessing!private! !
!


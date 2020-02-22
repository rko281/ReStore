"Filed out from Dolphin Smalltalk 7"!

SSWDBCollectionEntry subclass: #SSWDBDictionaryEntry
	instanceVariableNames: 'keyAccessor'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBDictionaryEntry guid: (GUID fromString: '{fb382c12-7c2e-11d5-b1df-0010a70883e2}')!
SSWDBDictionaryEntry comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBDictionaryEntry categoriesForClass!Unclassified! !
!SSWDBDictionaryEntry methodsFor!

addTargetTo: aCollection

	aCollection directAt: self key put: self target!

key

	^self keyAccessor valueIn: self target!

keyAccessor

	"keyAccessor stores an SSWInstVarAccessor that accesses the attribute of targetObject
	that is the key at which that object should be stored in the dictionary"

	^keyAccessor!

keyAccessor: anSSWInstVarAccessor

	"keyAccessor stores an SSWInstVarAccessor that accesses the attribute of targetObject
	that is the key at which that object should be stored in the dictionary"

	keyAccessor := anSSWInstVarAccessor! !
!SSWDBDictionaryEntry categoriesFor: #addTargetTo:!actions!public! !
!SSWDBDictionaryEntry categoriesFor: #key!accessing!public! !
!SSWDBDictionaryEntry categoriesFor: #keyAccessor!accessing!private! !
!SSWDBDictionaryEntry categoriesFor: #keyAccessor:!accessing!private! !


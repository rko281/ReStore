"Filed out from Dolphin Smalltalk 7"!

SSWDBStaticCollectionSpec subclass: #SSWDBStaticCacheDictionarySpec
	instanceVariableNames: 'keyAccessor'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBStaticCacheDictionarySpec guid: (GUID fromString: '{fb382c11-7c2e-11d5-b1df-0010a70883e2}')!
SSWDBStaticCacheDictionarySpec comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBStaticCacheDictionarySpec categoriesForClass!Unclassified! !
!SSWDBStaticCacheDictionarySpec methodsFor!

createNonProxiedInstanceFromRow: aDBRow

	"Overridden to set keyAccessor (issue#0001)"

	^(super createNonProxiedInstanceFromRow: aDBRow)
		keyAccessor: self keyAccessor;
		yourself!

entryClass

	"Return the class of collection entry appropriate for the receiver"
	
	^SSWDBDictionaryEntry!

keyAccessor

	"keyAccessor stores an SSWInstVarAccessor that accesses the attribute of an object
	that is the key at which that object should be stored in the dictionary"

	^keyAccessor!

keyAccessor: anSSWInstVarAccessor

	"keyAccessor stores an SSWInstVarAccessor that accesses the attribute of an object
	that is the key at which that object should be stored in the dictionary"

	keyAccessor := anSSWInstVarAccessor!

keyedOn: aSymbol

	self keyAccessor: (SSWInstVarAccessor toAccess: aSymbol in: self targetClass)! !
!SSWDBStaticCacheDictionarySpec categoriesFor: #createNonProxiedInstanceFromRow:!actions!public! !
!SSWDBStaticCacheDictionarySpec categoriesFor: #entryClass!constants!public! !
!SSWDBStaticCacheDictionarySpec categoriesFor: #keyAccessor!accessing!public! !
!SSWDBStaticCacheDictionarySpec categoriesFor: #keyAccessor:!accessing!public! !
!SSWDBStaticCacheDictionarySpec categoriesFor: #keyedOn:!accessing!public! !


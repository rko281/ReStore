"Filed out from Dolphin Smalltalk 7"!

SSWDBOwnedCollectionSpec subclass: #SSWDBOwnedCacheDictionarySpec
	instanceVariableNames: 'keyAccessor'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBOwnedCacheDictionarySpec guid: (GUID fromString: '{3f94758a-af1e-44e1-b508-066aeb06b259}')!
SSWDBOwnedCacheDictionarySpec comment: 'ReStore
©2020 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBOwnedCacheDictionarySpec categoriesForClass!Unclassified! !
!SSWDBOwnedCacheDictionarySpec methodsFor!

keyAccessor

	"keyAccessor stores an a 1-arg block that is evaluated with a targetObject to determine the key at which that object should be stored in the dictionary"

	^keyAccessor!

keyAccessor: anSSWInstVarAccessor

	"keyAccessor stores an a 1-arg block that is evaluated with a targetObject to determine the key at which that object should be stored in the dictionary"

	keyAccessor := anSSWInstVarAccessor!

keyedOn: aSymbolOrBlock

	"If aSymbolOrBlock is aSymbol it should be an inst var name"

	aSymbolOrBlock isSymbol 
		ifTrue: [self keyAccessor: (SSWInstVarAccessor toAccess: aSymbolOrBlock in: self targetClass)]
		ifFalse: [self keyAccessor: aSymbolOrBlock]!

newCollection

	^self newCollectionWrapper
		keyAccessor: self keyAccessor;
		dictionary: super newCollection;
		yourself!

newCollectionWrapper

	^SSWDBCacheDictionaryWrapper new! !
!SSWDBOwnedCacheDictionarySpec categoriesFor: #keyAccessor!accessing!public! !
!SSWDBOwnedCacheDictionarySpec categoriesFor: #keyAccessor:!accessing!public! !
!SSWDBOwnedCacheDictionarySpec categoriesFor: #keyedOn:!accessing!public! !
!SSWDBOwnedCacheDictionarySpec categoriesFor: #newCollection!helpers!public! !
!SSWDBOwnedCacheDictionarySpec categoriesFor: #newCollectionWrapper!helpers!private! !


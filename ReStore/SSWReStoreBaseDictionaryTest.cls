"Filed out from Dolphin Smallalk"!

SSWReStoreBaseCollectionTest subclass: #SSWReStoreBaseDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreBaseDictionaryTest guid: (GUID fromString: '{7daa0c27-4843-4ea2-ae6d-58dce3da23a8}')!
SSWReStoreBaseDictionaryTest comment: ''!
!SSWReStoreBaseDictionaryTest categoriesForClass!Unclassified! !
!SSWReStoreBaseDictionaryTest methodsFor!

addToCollection: anObject at: anInteger

	testObject component at: anInteger put: anObject.

	^anInteger!

collectionClass

	^Dictionary!

componentDefinition

	^Dictionary of: Integer -> (String maxSize: 64)!

removeFromCollection: anObject

	^self removeFromCollection: anObject at: (testObject component keyAtEqualValue: anObject ifAbsent: [])!

removeFromCollection: anObject at: aKey

	testObject component removeKey: aKey.
	^aKey! !
!SSWReStoreBaseDictionaryTest categoriesForMethods!
addToCollection:at:!helpers!private! !
collectionClass!accessing!public! !
componentDefinition!accessing!public! !
removeFromCollection:!helpers!private!unit tests! !
removeFromCollection:at:!helpers!private!unit tests! !
!


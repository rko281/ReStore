"Filed out from Dolphin Smalltalk 7"!

SSWDBCacheDictionaryEntry subclass: #SSWDBMultiValueCacheDictionaryEntry
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBMultiValueCacheDictionaryEntry guid: (GUID fromString: '{05a7f795-d24c-4c2c-9613-9077432ced9f}')!
SSWDBMultiValueCacheDictionaryEntry comment: 'ReStore
©2020 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBMultiValueCacheDictionaryEntry categoriesForClass!Unclassified! !
!SSWDBMultiValueCacheDictionaryEntry methodsFor!

addTargetTo: aCollection

	(aCollection at: self key ifAbsentPut: [OrderedCollection new]) add: self target! !
!SSWDBMultiValueCacheDictionaryEntry categoriesFor: #addTargetTo:!actions!public! !


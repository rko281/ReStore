"Filed out from Dolphin Smalltalk 7"!

SSWReStoreGenericTest subclass: #SSWReStoreStringDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreStringDictionaryTest guid: (GUID fromString: '{de41b743-eaa9-4220-aa42-1c21a33977ed}')!
SSWReStoreStringDictionaryTest comment: ''!
!SSWReStoreStringDictionaryTest categoriesForClass!Unclassified! !
!SSWReStoreStringDictionaryTest methodsFor!

componentDefinition

	^Dictionary of: (String maxSize: 50) -> (String maxSize: 50)!

templateTestObject

	| template |

	template := GenericTest new.
	template component: Dictionary new.

	1 to: 5 do: [ :index | template component at: ('key', index displayString) put: ('value', index displayString)].

	^template
	!

testTemplateObject

	self assert: testObject component size = 5.

	1 to: 5 do: 
		[ :index |
		self assert: (testObject component at: ('key', index displayString)) equals: ('value', index displayString)]! !
!SSWReStoreStringDictionaryTest categoriesFor: #componentDefinition!accessing!public! !
!SSWReStoreStringDictionaryTest categoriesFor: #templateTestObject!accessing!public! !
!SSWReStoreStringDictionaryTest categoriesFor: #testTemplateObject!public!unit tests! !


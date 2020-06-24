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

createCheckObjects

	{GenericTest new name: 'check'; component: 
		(Dictionary new 
			at: 'checkKey' put: 'checkValue'; 
			at: 'checkValue' put: 'dummyValue';
			at: 'sharedKey' put: 'checkValue';
			at: 'sharedValueKey' put: 'sharedValue';
			at: 'sharedAssocKey' put: 'sharedAssocValue';
			yourself).
	GenericTest new name: 'unCheck'; component: 
		(Dictionary new 
			at: 'unCheckKey' put: 'unCheckValue'; 
			at: 'unCheckValue' put: 'dummyValue';
			at: 'sharedKey' put: 'unCheckValue';
			at: 'sharedValueKey' put: 'sharedValue';
			at: 'sharedAssocKey' put: 'sharedAssocValue';
			yourself)} storeAllIn: reStore!

templateTestObject

	| template |

	template := GenericTest new.
	template component: Dictionary new.

	1 to: 5 do: [ :index | template component at: ('key', index displayString) put: ('value', index displayString)].

	^template
	!

testIncludes

	| checks unChecks shares |

	self createCheckObjects.

	checks := (GenericTest storedInstancesIn: reStore) select: [ :each | each component includes: 'checkValue'].
	unChecks := (GenericTest storedInstancesIn: reStore) select: [ :each | each component includes: 'unCheckValue'].
	shares := (GenericTest storedInstancesIn: reStore) select: [ :each | each component includes: 'sharedValue'].

	self assert: checks size equals: 1.
	self assert: checks first name equals: 'check'.

	self assert: unChecks size equals: 1.
	self assert: unChecks first name equals: 'unCheck'.

	self assert: shares size equals: 2.
	self assert: (shares collect: [ :each | each name]) asSortedCollection asArray equals: #('check' 'unCheck')!

testIncludesAssociation

	| checks unChecks shares |

	self createCheckObjects.

	checks := (GenericTest storedInstancesIn: reStore) select: [ :each | each component includesAssociation: 'checkKey' -> 'checkValue'].
	unChecks := (GenericTest storedInstancesIn: reStore) select: [ :each | each component includesAssociation: 'unCheckKey' -> 'unCheckValue'].
	shares := (GenericTest storedInstancesIn: reStore) select: [ :each | each component includesAssociation: 'sharedAssocKey' -> 'sharedAssocValue'].

	self assert: checks size equals: 1.
	self assert: checks first name equals: 'check'.

	self assert: unChecks size equals: 1.
	self assert: unChecks first name equals: 'unCheck'.

	self assert: shares size equals: 2.
	self assert: (shares collect: [ :each | each name]) asSortedCollection asArray equals: #('check' 'unCheck')!

testIncludesKey

	| checks unChecks shares |

	self createCheckObjects.

	checks := (GenericTest storedInstancesIn: reStore) select: [ :each | each component includesKey: 'checkKey'].
	unChecks := (GenericTest storedInstancesIn: reStore) select: [ :each | each component includesKey: 'unCheckKey'].
	shares := (GenericTest storedInstancesIn: reStore) select: [ :each | each component includesKey: 'sharedKey'].

	self assert: checks size equals: 1.
	self assert: checks first name equals: 'check'.

	self assert: unChecks size equals: 1.
	self assert: unChecks first name equals: 'unCheck'.

	self assert: shares size equals: 2.
	self assert: (shares collect: [ :each | each name]) asSortedCollection asArray equals: #('check' 'unCheck')!

testTemplateObject

	self assert: testObject component size = 5.

	1 to: 5 do: 
		[ :index |
		self assert: (testObject component at: ('key', index displayString)) equals: ('value', index displayString)]! !
!SSWReStoreStringDictionaryTest categoriesFor: #componentDefinition!accessing!public! !
!SSWReStoreStringDictionaryTest categoriesFor: #createCheckObjects!helpers!private! !
!SSWReStoreStringDictionaryTest categoriesFor: #templateTestObject!accessing!public! !
!SSWReStoreStringDictionaryTest categoriesFor: #testIncludes!public!unit tests! !
!SSWReStoreStringDictionaryTest categoriesFor: #testIncludesAssociation!public!unit tests! !
!SSWReStoreStringDictionaryTest categoriesFor: #testIncludesKey!public!unit tests! !
!SSWReStoreStringDictionaryTest categoriesFor: #testTemplateObject!public!unit tests! !


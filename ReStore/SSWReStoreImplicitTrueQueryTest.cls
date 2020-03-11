"Filed out from Dolphin Smalltalk 7"!

SSWReStoreTest subclass: #SSWReStoreImplicitTrueQueryTest
	instanceVariableNames: 'instances'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreImplicitTrueQueryTest guid: (GUID fromString: '{73e1afc9-730e-4ada-8972-809692ce6b19}')!
SSWReStoreImplicitTrueQueryTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreImplicitTrueQueryTest categoriesForClass!Unclassified! !
!SSWReStoreImplicitTrueQueryTest methodsFor!

addClassesTo: aReStore

	super addClassesTo: aReStore.
	aReStore
		addClass: TypeTest!

createTestData

	reStore evaluateAsTransaction: 
		[TypeTest new
			varchar: '1true';
			integer: 1;
			char: 'a';
			trueBoolean: true;
			storeIn: reStore.

		TypeTest new
			varchar: '1false';
			integer: 1;
			char: 'a';
			trueBoolean: false;
			storeIn: reStore.

		TypeTest new
			varchar: '2true';
			integer: 2;
			char: 'b';
			trueBoolean: true;
			storeIn: reStore.

		TypeTest new
			varchar: '2false';
			integer: 2;
			char: 'b';
			trueBoolean: false;
			storeIn: reStore].

	reStore simulateReconnect.

	instances := TypeTest storedInstancesIn: reStore!

testImplicitTrueNotSoleCondition

	| results |

	results := instances select: [ :each | each trueBoolean not].

	self assert: results size = 2.
	self assert: (results collect: [ :each | each varchar]) asSortedCollection asArray = #('1false' '2false')!

testImplicitTrueSoleCondition

	| results |

	results := instances select: [ :each | each trueBoolean].

	self assert: results size = 2.
	self assert: (results collect: [ :each | each varchar]) asSortedCollection asArray = #('1true' '2true')!

testInlinedAndFirst

	| results |

	results := instances select: [ :each | each trueBoolean and: [each integer = 1]].

	self assert: results size = 1.
	self assert: results first varchar = '1true'!

testInlinedAndLast

	| results |

	results := instances select: [ :each | each integer = 1 and: [each trueBoolean]].

	self assert: results size = 1.
	self assert: results first varchar = '1true'!

testInlinedAndMid

	| results |

	results := instances select: [ :each | each integer = 1 and: [each trueBoolean and: [each char = 'a']]].
	self assert: results size = 1.
	self assert: results first varchar = '1true'.

	results := instances select: [ :each | each integer = 2 and: [each trueBoolean and: [each char = 'b']]].
	self assert: results size = 1.
	self assert: results first varchar = '2true'.

	results := instances select: [ :each | each integer = 2 and: [each trueBoolean and: [each char = 'a']]].
	self assert: results isEmpty.

	results := instances select: [ :each | each integer = 1 and: [each trueBoolean and: [each char = 'b']]].
	self assert: results isEmpty!

testInlinedOrFirst

	| results |

	results := instances select: [ :each | each trueBoolean or: [each integer = 1]].

	self assert: results size = 3.
	self assert: (results collect: [ :each | each varchar]) asSortedCollection asArray = #('1false' '1true' '2true')!

testInlinedOrLast

	| results |

	results := instances select: [ :each | each integer = 1 or: [each trueBoolean]].

	self assert: results size = 3.
	self assert: (results collect: [ :each | each varchar]) asSortedCollection asArray = #('1false' '1true' '2true')!

testInlinedOrMid

	| results |

	results := instances select: [ :each | each integer = 1 or: [each trueBoolean or: [each char = 'b']]].
	self assert: results size = 4.
	self assert: (results collect: [ :each | each varchar]) asSortedCollection asArray = #('1false' '1true' '2false' '2true').

	results := instances select: [ :each | each integer = 2 or: [each trueBoolean or: [each char = 'a']]].
	self assert: results size = 4.
	self assert: (results collect: [ :each | each varchar]) asSortedCollection asArray = #('1false' '1true' '2false' '2true').

	results := instances select: [ :each | each integer = 1 or: [each trueBoolean or: [each char = 'a']]].
	self assert: results size = 3.
	self assert: (results collect: [ :each | each varchar]) asSortedCollection asArray = #('1false' '1true' '2true').

	results := instances select: [ :each | each integer = 2 or: [each trueBoolean or: [each char = 'b']]].
	self assert: results size = 3.
	self assert: (results collect: [ :each | each varchar]) asSortedCollection asArray = #('1true' '2false' '2true')!

testNonInlinedAndFirst

	| results |

	results := instances select: [ :each | each trueBoolean & (each integer = 1)].

	self assert: results size = 1.
	self assert: results first varchar = '1true'!

testNonInlinedAndLast

	| results |

	results := instances select: [ :each | (each integer = 1) & each trueBoolean].

	self assert: results size = 1.
	self assert: results first varchar = '1true'!

testNonInlinedAndMid

	| results |

	results := instances select: [ :each | (each integer = 1) & each trueBoolean & (each char = 'a')].
	self assert: results size = 1.
	self assert: results first varchar = '1true'.

	results := instances select: [ :each | (each integer = 2) & each trueBoolean & (each char = 'b')].
	self assert: results size = 1.
	self assert: results first varchar = '2true'.

	results := instances select: [ :each | (each integer = 2) & each trueBoolean & (each char = 'a')].
	self assert: results isEmpty.

	results := instances select: [ :each | (each integer = 1) & each trueBoolean & (each char = 'b')].
	self assert: results isEmpty!

testNonInlinedOrFirst

	| results |

	results := instances select: [ :each | each trueBoolean | (each integer = 1)].

	self assert: results size = 3.
	self assert: (results collect: [ :each | each varchar]) asSortedCollection asArray = #('1false' '1true' '2true')!

testNonInlinedOrLast

	| results |

	results := instances select: [ :each | (each integer = 1) | each trueBoolean].

	self assert: results size = 3.
	self assert: (results collect: [ :each | each varchar]) asSortedCollection asArray = #('1false' '1true' '2true')!

testNonInlinedOrMid

	| results |

	results := instances select: [ :each | (each integer = 1) | each trueBoolean | (each char = 'b')].
	self assert: results size = 4.
	self assert: (results collect: [ :each | each varchar]) asSortedCollection asArray = #('1false' '1true' '2false' '2true').

	results := instances select: [ :each | (each integer = 2) | each trueBoolean | (each char = 'a')].
	self assert: results size = 4.
	self assert: (results collect: [ :each | each varchar]) asSortedCollection asArray = #('1false' '1true' '2false' '2true').

	results := instances select: [ :each | (each integer = 1) | each trueBoolean | (each char = 'a')].
	self assert: results size = 3.
	self assert: (results collect: [ :each | each varchar]) asSortedCollection asArray = #('1false' '1true' '2true').

	results := instances select: [ :each | (each integer = 2) | each trueBoolean | (each char = 'b')].
	self assert: results size = 3.
	self assert: (results collect: [ :each | each varchar]) asSortedCollection asArray = #('1true' '2false' '2true')! !
!SSWReStoreImplicitTrueQueryTest categoriesFor: #addClassesTo:!public! !
!SSWReStoreImplicitTrueQueryTest categoriesFor: #createTestData!public! !
!SSWReStoreImplicitTrueQueryTest categoriesFor: #testImplicitTrueNotSoleCondition!public! !
!SSWReStoreImplicitTrueQueryTest categoriesFor: #testImplicitTrueSoleCondition!public! !
!SSWReStoreImplicitTrueQueryTest categoriesFor: #testInlinedAndFirst!public! !
!SSWReStoreImplicitTrueQueryTest categoriesFor: #testInlinedAndLast!public! !
!SSWReStoreImplicitTrueQueryTest categoriesFor: #testInlinedAndMid!public! !
!SSWReStoreImplicitTrueQueryTest categoriesFor: #testInlinedOrFirst!public! !
!SSWReStoreImplicitTrueQueryTest categoriesFor: #testInlinedOrLast!public! !
!SSWReStoreImplicitTrueQueryTest categoriesFor: #testInlinedOrMid!public! !
!SSWReStoreImplicitTrueQueryTest categoriesFor: #testNonInlinedAndFirst!public! !
!SSWReStoreImplicitTrueQueryTest categoriesFor: #testNonInlinedAndLast!public! !
!SSWReStoreImplicitTrueQueryTest categoriesFor: #testNonInlinedAndMid!public! !
!SSWReStoreImplicitTrueQueryTest categoriesFor: #testNonInlinedOrFirst!public! !
!SSWReStoreImplicitTrueQueryTest categoriesFor: #testNonInlinedOrLast!public! !
!SSWReStoreImplicitTrueQueryTest categoriesFor: #testNonInlinedOrMid!public! !


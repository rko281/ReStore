"Filed out from Dolphin Smalltalk 7"!

SSWReStoreAbstractQueryTest subclass: #SSWReStoreSortTest
	instanceVariableNames: 'simplePersonCompareMethod'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreSortTest guid: (GUID fromString: '{8d5253a9-2eb9-4836-bcb2-265137d61adb}')!
SSWReStoreSortTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreSortTest categoriesForClass!Unclassified! !
!SSWReStoreSortTest methodsFor!

_testClassSortImplementationInverted

	| instances |

	SimplePerson methodDictionary at: #<= put: (SimplePerson>>#<=>).
	instances := (reStore instancesOf: SimplePerson) asSortedCollection.

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' ))!

_testClassSortImplementationWithBlocksInverted

	| instances |

	SimplePerson methodDictionary at: #<= put: (SimplePerson>>#<==>).
	instances := (reStore instancesOf: SimplePerson) asSortedCollection.

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' ))!

_testSortInverted

	| instances |

	self changeDavidToJohn.

	instances := (reStore instancesOf: SimplePerson) asSortedCollection: [ :a :b | (b firstName > a firstName) | (b firstName = a firstName & (b surname >= a surname))].

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'John Smith' 'John Smythe' 'Zoe Brown'))!

_testSortWithBlocksInverted

	| instances |

	self changeDavidToJohn.

	instances := (reStore instancesOf: SimplePerson) asSortedCollection: [ :a :b | b firstName > a firstName or: [b firstName = a firstName and: [b surname >= a surname]]].

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'John Smith' 'John Smythe' 'Zoe Brown'))!

changeDavidToJohn

	| davidToJohn |

	davidToJohn := (reStore instancesOf: SimplePerson) detect: [ :each | each firstName = 'David'].
	davidToJohn firstName: 'John'.
	reStore commit: davidToJohn!

setUp

	super setUp.

	"Cache this since some tests swap it with another method"
	simplePersonCompareMethod := (SimplePerson>>#<=)!

tearDown

	super tearDown.

	SimplePerson methodDictionary at: #<= put: simplePersonCompareMethod!

testClassSortImplementation

	| instances |

	instances := (reStore instancesOf: SimplePerson) asSortedCollection.

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' ))!

testClassSortImplementationOnPersistentObject

	| instances |

	instances := (reStore instancesOf: SimplePerson) asSortedCollection.
	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' )).
	instances with: instances reverse do: [ :person :friend | person friend: friend].
	"Jim Brown	David Smythe	Jim Brown
	Zoe Brown		John Smith	Zoe Brown
	John Smith	Zoe Brown		John Smith
	David Smythe	Jim Brown		David Smythe"

	reStore commitAll: instances.

	SimplePerson methodDictionary at: #<= put: (SimplePerson>>#friendCompare:). "a friend <= b friend"

	instances := (reStore instancesOf: SimplePerson) asSortedCollection.

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('David Smythe' 'John Smith' 'Zoe Brown' 'Jim Brown' ))!

testClassSortImplementationWithBlocks

	| instances |

	SimplePerson methodDictionary at: #<= put: (SimplePerson>>#<==).
	instances := (reStore instancesOf: SimplePerson) asSortedCollection.

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' ))!

testClassSortImplementationWithBlocksOnPersistentObject

	| instances |

	instances := (reStore instancesOf: SimplePerson) asSortedCollection.
	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' )).
	instances with: instances reverse do: [ :person :friend | person friend: friend].
	reStore commitAll: instances.

	SimplePerson methodDictionary at: #<= put: (SimplePerson>>#friendCompareWithBlocks:).
	instances := (reStore instancesOf: SimplePerson) asSortedCollection.

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('David Smythe' 'John Smith' 'Zoe Brown' 'Jim Brown' ))!

testDeepSort

	| instances |

	instances := (reStore instancesOf: SimplePerson) asSortedCollection.
	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' )).
	instances with: instances reverse do: [ :person :friend | person friend: friend].
	reStore commitAll: instances.

	instances := (reStore instancesOf: SimplePerson) asSortedCollection: [ :a :b | (a friend firstName < b friend firstName) | (a friend firstName = b friend firstName & (a friend surname <= b friend surname))].

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'David Smythe' 'Zoe Brown' 'John Smith' ))!

testDeepSortWithBlocks

	| instances |

	instances := (reStore instancesOf: SimplePerson) asSortedCollection.
	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' )).
	instances with: instances reverse do: [ :person :friend | person friend: friend].
	reStore commitAll: instances.

	instances := (reStore instancesOf: SimplePerson) asSortedCollection: [ :a :b | a friend firstName < b friend firstName or: [a friend firstName = b friend firstName and: [a friend surname <= b friend surname]]].

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'David Smythe' 'Zoe Brown' 'John Smith' ))!

testSortImplementation

	| instances |

	instances := (reStore instancesOf: SimplePerson) asSortedCollection: [ :a :b | a <= b].

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' ))!

testSortImplementationOnPersistentObject

	| instances |

	instances := (reStore instancesOf: SimplePerson) asSortedCollection.
	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' )).
	instances with: instances reverse do: [ :person :friend | person friend: friend].
	reStore commitAll: instances.

	instances := (reStore instancesOf: SimplePerson) asSortedCollection: [ :a :b | a friendCompare: b].

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('David Smythe' 'John Smith' 'Zoe Brown' 'Jim Brown' ))!

testSortImplementationOnPersistentObjectWithBlocks

	| instances |

	instances := (reStore instancesOf: SimplePerson) asSortedCollection.
	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' )).
	instances with: instances reverse do: [ :person :friend | person friend: friend].
	reStore commitAll: instances.

	instances := (reStore instancesOf: SimplePerson) asSortedCollection: [ :a :b | a friendCompareWithBlocks: b].

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('David Smythe' 'John Smith' 'Zoe Brown' 'Jim Brown' ))!

testSortImplementationWithBlocks

	| instances |

	instances := (reStore instancesOf: SimplePerson) asSortedCollection: [ :a :b | a <== b].

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' ))!

testStandardSort

	| instances |

	self changeDavidToJohn.

	instances := (reStore instancesOf: SimplePerson) asSortedCollection: [ :a :b | (a firstName < b firstName) | (a firstName = b firstName & (a surname <= b surname))].

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'John Smith' 'John Smythe' 'Zoe Brown'))!

testStandardSortOnPersistentObject

	| instances |

	instances := (reStore instancesOf: SimplePerson) asSortedCollection.
	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' )).
	instances with: instances reverse do: [ :person :friend | person friend: friend].
	reStore commitAll: instances.

	instances := (reStore instancesOf: SimplePerson) asSortedCollection: [ :a :b | a friend <= b friend].

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('David Smythe' 'John Smith' 'Zoe Brown' 'Jim Brown' ))!

testStandardSortOnPersistentObjectWithBlocks

	| instances |

	instances := (reStore instancesOf: SimplePerson) asSortedCollection.
	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' )).
	instances with: instances reverse do: [ :person :friend | person friend: friend].
	reStore commitAll: instances.

	SimplePerson methodDictionary at: #<= put: (SimplePerson>>#<==).
	instances := (reStore instancesOf: SimplePerson) asSortedCollection: [ :a :b | a friend <= b friend].

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('David Smythe' 'John Smith' 'Zoe Brown' 'Jim Brown' ))!

testStandardSortWithBlocks

	| instances |

	self changeDavidToJohn.

	instances := (reStore instancesOf: SimplePerson) asSortedCollection: [ :a :b | a firstName < b firstName or: [a firstName = b firstName and: [a surname <= b surname]]].

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'John Smith' 'John Smythe' 'Zoe Brown'))! !
!SSWReStoreSortTest categoriesFor: #_testClassSortImplementationInverted!inverse!public! !
!SSWReStoreSortTest categoriesFor: #_testClassSortImplementationWithBlocksInverted!inverse!public! !
!SSWReStoreSortTest categoriesFor: #_testSortInverted!inverse!public! !
!SSWReStoreSortTest categoriesFor: #_testSortWithBlocksInverted!inverse!public! !
!SSWReStoreSortTest categoriesFor: #changeDavidToJohn!public!running! !
!SSWReStoreSortTest categoriesFor: #setUp!public!running! !
!SSWReStoreSortTest categoriesFor: #tearDown!public!running! !
!SSWReStoreSortTest categoriesFor: #testClassSortImplementation!public!unit tests! !
!SSWReStoreSortTest categoriesFor: #testClassSortImplementationOnPersistentObject!public!unit tests! !
!SSWReStoreSortTest categoriesFor: #testClassSortImplementationWithBlocks!public!unit tests! !
!SSWReStoreSortTest categoriesFor: #testClassSortImplementationWithBlocksOnPersistentObject!public!unit tests! !
!SSWReStoreSortTest categoriesFor: #testDeepSort!public!unit tests! !
!SSWReStoreSortTest categoriesFor: #testDeepSortWithBlocks!public!unit tests! !
!SSWReStoreSortTest categoriesFor: #testSortImplementation!public!unit tests! !
!SSWReStoreSortTest categoriesFor: #testSortImplementationOnPersistentObject!public!unit tests! !
!SSWReStoreSortTest categoriesFor: #testSortImplementationOnPersistentObjectWithBlocks!public!unit tests! !
!SSWReStoreSortTest categoriesFor: #testSortImplementationWithBlocks!public!unit tests! !
!SSWReStoreSortTest categoriesFor: #testStandardSort!public!unit tests! !
!SSWReStoreSortTest categoriesFor: #testStandardSortOnPersistentObject!public!unit tests! !
!SSWReStoreSortTest categoriesFor: #testStandardSortOnPersistentObjectWithBlocks!public!unit tests! !
!SSWReStoreSortTest categoriesFor: #testStandardSortWithBlocks!public!unit tests! !


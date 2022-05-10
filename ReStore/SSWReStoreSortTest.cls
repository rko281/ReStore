"Filed out from Dolphin Smallalk"!

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

	self addMethod: SimplePerson>>#<=> withSelector: #<= fromClass: SimplePerson.
	instances := (SimplePerson storedInstancesIn: reStore) asSortedCollection.

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' ))!

_testClassSortImplementationWithBlocksInverted

	| instances |

	self addMethod: SimplePerson>>#<==> withSelector: #<= toClass: SimplePerson.
	instances := (SimplePerson storedInstancesIn: reStore) asSortedCollection.

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' ))!

_testSortInverted

	| instances |

	self changeDavidToJohn.

	instances := (SimplePerson storedInstancesIn: reStore) asSortedCollection: [ :a :b | (b firstName > a firstName) | (b firstName = a firstName & (b surname >= a surname))].

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'John Smith' 'John Smythe' 'Zoe Brown'))!

_testSortWithBlocksInverted

	| instances |

	self changeDavidToJohn.

	instances := (SimplePerson storedInstancesIn: reStore) asSortedCollection: [ :a :b | b firstName > a firstName or: [b firstName = a firstName and: [b surname >= a surname]]].

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'John Smith' 'John Smythe' 'Zoe Brown'))!

changeDavidToJohn

	| davidToJohn |

	davidToJohn := (SimplePerson storedInstancesIn: reStore) detect: [ :each | each firstName = 'David'].
	davidToJohn firstName: 'John'.
	davidToJohn store!

setUp

	super setUp.

	"Cache this since some tests swap it with another method"
	simplePersonCompareMethod := (SimplePerson>>#<=)!

tearDown

	super tearDown.

	self addMethod: simplePersonCompareMethod withSelector: #<= toClass: SimplePerson!

testClassSortImplementation

	| instances |

	instances := (SimplePerson storedInstancesIn: reStore) asSortedCollection.

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' ))!

testClassSortImplementationOnPersistentObject

	| instances |

	instances := (SimplePerson storedInstancesIn: reStore) asSortedCollection.
	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' )).
	instances with: instances reverse do: [ :person :friend | person friend: friend].
	"Jim Brown	David Smythe	Jim Brown
	Zoe Brown		John Smith	Zoe Brown
	John Smith	Zoe Brown		John Smith
	David Smythe	Jim Brown		David Smythe"

	instances storeAll.

	self addMethod: SimplePerson>>#friendCompare: withSelector: #<= toClass: SimplePerson. "a friend <= b friend"

	instances := (SimplePerson storedInstancesIn: reStore) asSortedCollection.

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('David Smythe' 'John Smith' 'Zoe Brown' 'Jim Brown' ))!

testClassSortImplementationReversed

	| instances |

	instances := (SimplePerson storedInstancesIn: reStore) beSorted reverse.

	self assert: (instances collect: [ :each | each fullName]) asArray equals: #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' ) reverse!

testClassSortImplementationWithBlocks

	| instances |

	self addMethod: SimplePerson>>#<== withSelector: #<= toClass: SimplePerson.
	instances := (SimplePerson storedInstancesIn: reStore) asSortedCollection.

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' ))!

testClassSortImplementationWithBlocksOnPersistentObject

	| instances |

	instances := (SimplePerson storedInstancesIn: reStore) asSortedCollection.
	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' )).
	instances with: instances reverse do: [ :person :friend | person friend: friend].
	instances storeAll.

	self addMethod: SimplePerson>>#friendCompareWithBlocks: withSelector: #<= toClass: SimplePerson.
	instances := (SimplePerson storedInstancesIn: reStore) asSortedCollection.

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('David Smythe' 'John Smith' 'Zoe Brown' 'Jim Brown' ))!

testDeepSort

	| instances |

	instances := (SimplePerson storedInstancesIn: reStore) asSortedCollection.
	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' )).
	instances with: instances reverse do: [ :person :friend | person friend: friend].
	instances storeAll.

	instances := (SimplePerson storedInstancesIn: reStore) asSortedCollection: [ :a :b | (a friend firstName < b friend firstName) | (a friend firstName = b friend firstName & (a friend surname <= b friend surname))].

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'David Smythe' 'Zoe Brown' 'John Smith' ))!

testDeepSortWithBlocks

	| instances |

	instances := (SimplePerson storedInstancesIn: reStore) asSortedCollection.
	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' )).
	instances with: instances reverse do: [ :person :friend | person friend: friend].
	instances storeAll.

	instances := (SimplePerson storedInstancesIn: reStore) asSortedCollection: [ :a :b | a friend firstName < b friend firstName or: [a friend firstName = b friend firstName and: [a friend surname <= b friend surname]]].

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'David Smythe' 'Zoe Brown' 'John Smith' ))!

testSortImplementation

	| instances |

	instances := (SimplePerson storedInstancesIn: reStore) asSortedCollection: [ :a :b | a <= b].

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' ))!

testSortImplementationOnPersistentObject

	| instances |

	instances := (SimplePerson storedInstancesIn: reStore) asSortedCollection.
	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' )).
	instances with: instances reverse do: [ :person :friend | person friend: friend].
	instances storeAll.

	instances := (SimplePerson storedInstancesIn: reStore) asSortedCollection: [ :a :b | a friendCompare: b].

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('David Smythe' 'John Smith' 'Zoe Brown' 'Jim Brown' ))!

testSortImplementationOnPersistentObjectWithBlocks

	| instances |

	instances := (SimplePerson storedInstancesIn: reStore) asSortedCollection.
	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' )).
	instances with: instances reverse do: [ :person :friend | person friend: friend].
	instances storeAll.

	instances := (SimplePerson storedInstancesIn: reStore) asSortedCollection: [ :a :b | a friendCompareWithBlocks: b].

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('David Smythe' 'John Smith' 'Zoe Brown' 'Jim Brown' ))!

testSortImplementationReversed

	| instances |

	instances := (SimplePerson storedInstancesIn: reStore) sortBlock: [ :a :b | a <= b].

	self assert: (instances reverse asOrderedCollection collect: [ :each | each fullName]) asArray equals: #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' ) reverse!

testSortImplementationWithBlocks

	| instances |

	instances := (SimplePerson storedInstancesIn: reStore) asSortedCollection: [ :a :b | a <== b].

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' ))!

testStandardSort

	| instances |

	self changeDavidToJohn.

	instances := (SimplePerson storedInstancesIn: reStore) asSortedCollection: [ :a :b | (a firstName < b firstName) | (a firstName = b firstName & (a surname <= b surname))].

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'John Smith' 'John Smythe' 'Zoe Brown'))!

testStandardSortOnPersistentObject

	| instances |

	instances := (SimplePerson storedInstancesIn: reStore) asSortedCollection.
	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' )).
	instances with: instances reverse do: [ :person :friend | person friend: friend].
	instances storeAll.

	instances := (SimplePerson storedInstancesIn: reStore) asSortedCollection: [ :a :b | a friend <= b friend].

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('David Smythe' 'John Smith' 'Zoe Brown' 'Jim Brown' ))!

testStandardSortOnPersistentObjectWithBlocks

	| instances |

	instances := (SimplePerson storedInstancesIn: reStore) asSortedCollection.
	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'Zoe Brown' 'John Smith' 'David Smythe' )).
	instances with: instances reverse do: [ :person :friend | person friend: friend].
	instances storeAll.

	self addMethod: SimplePerson>>#<== withSelector: #<= toClass: SimplePerson.
	instances := (SimplePerson storedInstancesIn: reStore) asSortedCollection: [ :a :b | a friend <= b friend].

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('David Smythe' 'John Smith' 'Zoe Brown' 'Jim Brown' ))!

testStandardSortWithBlocks

	| instances |

	self changeDavidToJohn.

	instances := (SimplePerson storedInstancesIn: reStore) asSortedCollection: [ :a :b | a firstName < b firstName or: [a firstName = b firstName and: [a surname <= b surname]]].

	self assert: ((instances collect: [ :each | each fullName]) asArray = #('Jim Brown' 'John Smith' 'John Smythe' 'Zoe Brown'))! !
!SSWReStoreSortTest categoriesForMethods!
_testClassSortImplementationInverted!inverse!public! !
_testClassSortImplementationWithBlocksInverted!inverse!public! !
_testSortInverted!inverse!public! !
_testSortWithBlocksInverted!inverse!public! !
changeDavidToJohn!public!running! !
setUp!public!running! !
tearDown!public!running! !
testClassSortImplementation!public!unit tests! !
testClassSortImplementationOnPersistentObject!public!unit tests! !
testClassSortImplementationReversed!public!unit tests! !
testClassSortImplementationWithBlocks!public!unit tests! !
testClassSortImplementationWithBlocksOnPersistentObject!public!unit tests! !
testDeepSort!public!unit tests! !
testDeepSortWithBlocks!public!unit tests! !
testSortImplementation!public!unit tests! !
testSortImplementationOnPersistentObject!public!unit tests! !
testSortImplementationOnPersistentObjectWithBlocks!public!unit tests! !
testSortImplementationReversed!public!unit tests! !
testSortImplementationWithBlocks!public!unit tests! !
testStandardSort!public!unit tests! !
testStandardSortOnPersistentObject!public!unit tests! !
testStandardSortOnPersistentObjectWithBlocks!public!unit tests! !
testStandardSortWithBlocks!public!unit tests! !
!


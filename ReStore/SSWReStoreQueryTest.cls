﻿"Filed out from Dolphin Smalltalk 7"!

SSWReStoreAbstractQueryTest subclass: #SSWReStoreQueryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreQueryTest guid: (GUID fromString: '{bdd80d80-9313-4dda-a7e9-f1aa56633da2}')!
SSWReStoreQueryTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreQueryTest categoriesForClass!Unclassified! !
!SSWReStoreQueryTest methodsFor!

addClassesTo: aReStore

	super addClassesTo: aReStore.
	aReStore
		addClass: SimpleProduct!

convertToDictionary: results index: anInteger

	| dict |

	dict := IdentityDictionary new.
	results do: [ :each | (each at: anInteger) ifNotNil: [ :key | dict at: key put: (each asOrderedCollection removeAtIndex: anInteger; asArray)]].
	^dict!

createProducts

	reStore evaluateAsTransaction: 
		[SimpleProduct new
			description: 'widget';
			supplierPrice: 1;
			retailPrice: 1.2;
			storeIn: reStore.
		SimpleProduct new
			description: 'gadget';
			supplierPrice: 5;
			retailPrice: 6;
			storeIn: reStore.
		SimpleProduct new
			description: 'wobulator';
			supplierPrice: 100;
			retailPrice: 200;
			storeIn: reStore]!

test1Simple

	| instances |

	instances := reStore instancesOf: SimplePerson.

	self assert: (instances size = 4).

	self assert: (instances allSatisfy: [ :each | (each surname ~= nil) & (each firstName ~= nil)]).
	
	self assert: (instances anySatisfy: [ :each | each surname = 'Smith']).
	self assert: (instances satisfying: [ :each | each surname = 'Smith']) size = 1.
	self assert: (instances satisfying: [ :each | each surname = 'Smith']) first firstName = 'John'.

	instances := instances satisfying: [ :each | each surname = 'Brown'].
	self assert: (instances size = 2).
	self assert: (instances detect: [ :each | each firstName = 'Zoe']) emailAddress isNil.
	self assert: ((instances project: [ :each | each surname]) asArray = #('Brown')).

	instances := instances satisfying: [ :each | each emailAddress ~= nil].
	self assert: (instances size = 1).
	self assert: (instances anySatisfy: [ :each | each emailAddress = 'jim@somewhere'])
!

test2Wildcards

	| instances |

	instances := reStore instancesOf: SimplePerson satisfying:  [ :each | 'Sm*' match: each surname].

	self assert: (instances isEmpty not).
	self assert: (instances size = 2).
	self assert: ((instances collect: [ :each | each firstName]) asSortedCollection asArray = #('David' 'John'))!

test3Order

	| instances |

	instances := reStore instancesOf: SimplePerson satisfying: [ :each | each surname = 'Brown'].
	instances sortBlock: [ :a :b | a firstName <= b firstName].

	self assert: (instances first firstName = 'Jim').
	self assert: (instances last firstName = 'Zoe').

	instances sortBlock: [ :a :b | a firstName > b firstName].
	self assert: (instances first firstName = 'Zoe').
	self assert: (instances last firstName = 'Jim').
!

test3Sort

	| instances |

	instances := reStore instancesOf: SimplePerson satisfying: [ :each | each surname = 'Brown'].
	self assert: ((instances asSortedCollection: [ :a :b | a firstName <= b firstName]) first firstName = 'Jim').

	instances sortBlock: [ :a :b | a firstName > b firstName].
	self assert: ((instances collect: [ :each | each firstName]) asArray = #('Zoe' 'Jim'))!

test4Modify

	| instances |

	instances := reStore instancesOf: SimplePerson satisfying: [ :each | each surname = 'Brown'].
	self assert: (instances anySatisfy: [ :e | e emailAddress = '<unknown>']) not.

	instances modify: [ :e | e emailAddress: '<unknown>'].
	self assert: (instances allSatisfy: [ :e | e emailAddress = '<unknown>']).

"	instances := instances satisfying: [ :each | each firstName = 'Zoe'].
	self assert: (instances anySatisfy: [ :e | e friend emailAddress = '<friend_unknown>']) not.

	instances modify: [ :e | e friend emailAddress: '<unknown>'].
	self assert: (instances allSatisfy: [ :e | e friend emailAddress = '<unknown>']).
"!

test5InlineFunctionQuery

	| instances |

	instances := reStore instancesOf: SimplePerson.
	instances := instances satisfying: [ :each | (each firstName, ' ', each surname) = 'Jim Brown'].
	self assert: (instances size = 1)!

test6MethodFunctionQuery

	| instances |

	instances := reStore instancesOf: SimplePerson.
	instances := instances satisfying: [ :each | each fullName = 'Jim Brown'].
	self assert: (instances size = 1)!

test6MethodFunctionQueryWithDirectInstVars

	"Unsupported - should fail"

	| instances |

	instances := reStore instancesOf: SimplePerson.
	self should: [instances := instances satisfying: [ :each | each fullNameDirect = 'Jim Brown']] raise: Error!

test7InlineFunctionQueryComplex

	| instances |

	self createProducts.

	instances := reStore instancesOf: SimpleProduct.

	instances := instances satisfying: [ :each | (each supplierPrice \\ 5) = 0].
	self assert: (instances size = 2)!

test7MethodFunctionQueryComplex

	| instances |

	self createProducts.

	instances := reStore instancesOf: SimpleProduct.
	self assert: ((instances detect: [ :each | each profitMargin > 50]) description = 'wobulator')!

test8CustomQuery

	| instances results|

	self createProducts.

	reStore sqlDialect sqlFunctions at: #plusPercent: put: '%1 * (1 + (%2 / 100))' asSQLFunction.

	instances := reStore instancesOf: SimpleProduct.
	results := instances collect: [ :each | each supplierPrice plusPercent: 100].
	self assert: (results asSortedCollection asArray = #(2 10 200))!

test9MultiArgumentFieldQuery

	| instances results|

	self createProducts.

	instances := reStore instancesOf: SimpleProduct.

	"Nonsensical query, but tests a previously failing case with functions with > 1 argument, whose arguments are other fields (or functions thereof)"
	results := instances select: [ :each | each retailPrice between: each supplierPrice and: each description size].
	self assert: (results size = 2)!

testAMultiArgumentMixedQuery

	| instances results|

	self createProducts.

	instances := reStore instancesOf: SimpleProduct.

	"Nonsensical query, but tests a previously failing case with functions with > 1 argument, whose arguments are a mix of constants and other fields (or functions thereof)"
	results := instances select: [ :each | each retailPrice between: each supplierPrice and: 10].
	self assert: (results size = 2)!

testBMultiArgumentFunctionCollectFieldQuery

	| instances results|

	self createProducts.

	instances := (reStore instancesOf: SimpleProduct) satisfying: [ :each | each description = 'gadget'].

	"Nonsensical query, but tests a previously failing case with functions with > 1 argument, whose arguments are other fields (or functions thereof)"
	results := instances collect: [ :each | each description midString: (each retailPrice - each supplierPrice) asInteger + 1 from: each supplierPrice asInteger].
	self assert: (results asArray = #('et'))!

testCMultiArgumentFunctionCollectMixedQuery

	| instances results|

	self createProducts.

	instances := (reStore instancesOf: SimpleProduct) satisfying: [ :each | each description = 'gadget'].

	"Nonsensical query, but tests a previously failing case with functions with > 1 argument, whose arguments are a mix of constants and other fields (or functions thereof)"	
	results := instances collect: [ :each | each description midString: (each retailPrice - each supplierPrice) asInteger + 1 from: 5].
	self assert: (results asArray = #('et'))!

testCollectQuery

	| instances john results |

	instances := reStore instancesOf: SimplePerson.

	john := instances detect: [ :each | each firstName = 'John'].
	john test: (Test new name: 'jTest').
	reStore commit: john.

	"Test various combinations and orderings"
	results := ((instances collect: [ :each | each firstName || each surname || each friend firstName || each friend surname]) asSortedCollection: [ :a :b | a first <= b first]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #('David' 'Smythe' nil nil)).
	self assert: ((results at: 2) = #('Jim' 'Brown' nil nil)).
	self assert: ((results at: 3) = #('John' 'Smith' 'David' 'Smythe')).
	self assert: ((results at: 4) = #('Zoe' 'Brown' 'John' 'Smith')).

	results := ((instances collect: [ :each | each friend firstName || each friend surname || each firstName || each surname]) asSortedCollection: [ :a :b | (a at: 3) <= (b at: 3)]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #(nil nil 'David' 'Smythe')).
	self assert: ((results at: 2) = #(nil nil 'Jim' 'Brown')).
	self assert: ((results at: 3) = #('David' 'Smythe' 'John' 'Smith')).
	self assert: ((results at: 4) = #('John' 'Smith' 'Zoe' 'Brown')).

	results := ((instances collect: [ :each | each firstName || each friend surname || each friend firstName || each surname]) asSortedCollection: [ :a :b | a first <= b first]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #('David' nil nil 'Smythe')).
	self assert: ((results at: 2) = #('Jim' nil nil 'Brown')).
	self assert: ((results at: 3) = #('John' 'Smythe' 'David' 'Smith')).
	self assert: ((results at: 4) = #('Zoe' 'Smith' 'John' 'Brown')).
	
	results := ((instances collect: [ :each | each friend firstName || each surname || each firstName || each friend surname]) asSortedCollection: [ :a :b | (a at: 3) <= (b at: 3)]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #(nil 'Smythe' 'David' nil)).
	self assert: ((results at: 2) = #(nil 'Brown' 'Jim' nil)).
	self assert: ((results at: 3) = #('David' 'Smith' 'John' 'Smythe')).
	self assert: ((results at: 4) = #('John' 'Brown' 'Zoe' 'Smith')).

	results := ((instances collect: [ :each | each firstName || each friend firstName|| each test name || each surname]) asSortedCollection: [ :a :b | a first <= b first]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #('David' nil nil 'Smythe')).
	self assert: ((results at: 2) = #('Jim' nil nil 'Brown')).
	self assert: ((results at: 3) = #('John' 'David' 'jTest' 'Smith')).
	self assert: ((results at: 4) = #('Zoe' 'John' nil 'Brown')).

	results := ((instances collect: [ :each | each test name || each firstName|| each friend firstName || each surname]) asSortedCollection: [ :a :b | (a at: 2) <= (b at: 2)]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #(nil 'David' nil 'Smythe')).
	self assert: ((results at: 2) = #(nil 'Jim' nil 'Brown')).
	self assert: ((results at: 3) = #('jTest' 'John' 'David' 'Smith')).
	self assert: ((results at: 4) = #(nil 'Zoe' 'John' 'Brown')).!

testCollectQueryWithActualObject

	| instances john dave zoe jim testBlock testCount |

	instances := reStore instancesOf: SimplePerson.

	john := instances detect: [ :each | each firstName = 'John'].
	dave := instances detect: [ :each | each firstName = 'David'].
	zoe := instances detect: [ :each | each firstName = 'Zoe'].
	jim := instances detect: [ :each | each firstName = 'Jim'].

	testCount := 0.
	testBlock := 
		[ :results :position || dict |
		dict := self convertToDictionary: results index: position.
		self assert: (dict size = 4).
		self assert: ((dict at: john) = #('John' 'Smith' 'David' 'Smythe')).
		self assert: ((dict at: zoe) = #('Zoe' 'Brown' 'John' 'Smith')).
		self assert: ((dict at: dave) = #('David' 'Smythe' nil nil)).
		self assert: ((dict at: jim) = #('Jim' 'Brown' nil nil)).
		testCount := testCount + 1].

	"Test with the actual object at different positions in the query block"
	testBlock value: (instances collect: [ :each | each || each firstName || each surname || each friend firstName || each friend surname]) value: 1.
	"NB: With each at position 2 in the query block we actually get (and expect) the object at position 1 in the results (its appearance at position 2 can't be (easily) detected compared to position 1 due to lack distinguishing message send)"
	testBlock value: (instances collect: [ :each | each firstName || each || each surname || each friend firstName || each friend surname]) value: 1.
	testBlock value: (instances collect: [ :each | each firstName || each surname || each || each friend firstName || each friend surname]) value: 3.
	testBlock value: (instances collect: [ :each | each firstName || each surname || each friend firstName || each || each friend surname]) value: 4.
	testBlock value: (instances collect: [ :each | each firstName || each surname || each friend firstName || each friend surname || each]) value: 5.

	"Ensure we actually did some testing"
	self assert: (testCount = 5)!

testCollectQueryWithFunction

	| instances john results |

	instances := reStore instancesOf: SimplePerson.

	john := instances detect: [ :each | each firstName = 'John'].
	john test: (Test new name: 'jTest').
	reStore commit: john.

	"Test various combinations and orderings"
	results := ((instances collect: [ :each | each firstName || each surname || (each friend firstName, ' ', each friend surname)]) asSortedCollection: [ :a :b | a first <= b first]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #('David' 'Smythe' nil)).
	self assert: ((results at: 2) = #('Jim' 'Brown' nil)).
	self assert: ((results at: 3) = #('John' 'Smith' 'David Smythe')).
	self assert: ((results at: 4) = #('Zoe' 'Brown' 'John Smith')).
"
	results := ((instances collect: [ :each | each friend firstName || each friend surname || each firstName || each surname]) asSortedCollection: [ :a :b | (a at: 3) <= (b at: 3)]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #(nil nil 'David' 'Smythe')).
	self assert: ((results at: 2) = #(nil nil 'Jim' 'Brown')).
	self assert: ((results at: 3) = #('David' 'Smythe' 'John' 'Smith')).
	self assert: ((results at: 4) = #('John' 'Smith' 'Zoe' 'Brown')).

	results := ((instances collect: [ :each | each firstName || each friend surname || each friend firstName || each surname]) asSortedCollection: [ :a :b | a first <= b first]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #('David' nil nil 'Smythe')).
	self assert: ((results at: 2) = #('Jim' nil nil 'Brown')).
	self assert: ((results at: 3) = #('John' 'Smythe' 'David' 'Smith')).
	self assert: ((results at: 4) = #('Zoe' 'Smith' 'John' 'Brown')).
	
	results := ((instances collect: [ :each | each friend firstName || each surname || each firstName || each friend surname]) asSortedCollection: [ :a :b | (a at: 3) <= (b at: 3)]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #(nil 'Smythe' 'David' nil)).
	self assert: ((results at: 2) = #(nil 'Brown' 'Jim' nil)).
	self assert: ((results at: 3) = #('David' 'Smith' 'John' 'Smythe')).
	self assert: ((results at: 4) = #('John' 'Brown' 'Zoe' 'Smith')).

	results := ((instances collect: [ :each | each firstName || each friend firstName|| each test name || each surname]) asSortedCollection: [ :a :b | a first <= b first]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #('David' nil nil 'Smythe')).
	self assert: ((results at: 2) = #('Jim' nil nil 'Brown')).
	self assert: ((results at: 3) = #('John' 'David' 'jTest' 'Smith')).
	self assert: ((results at: 4) = #('Zoe' 'John' nil 'Brown')).

	results := ((instances collect: [ :each | each test name || each firstName|| each friend firstName || each surname]) asSortedCollection: [ :a :b | (a at: 2) <= (b at: 2)]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #(nil 'David' nil 'Smythe')).
	self assert: ((results at: 2) = #(nil 'Jim' nil 'Brown')).
	self assert: ((results at: 3) = #('jTest' 'John' 'David' 'Smith')).
	self assert: ((results at: 4) = #(nil 'Zoe' 'John' 'Brown'))."!

testCollectQueryWithInlineFunction

	| instances john results |

	instances := reStore instancesOf: SimplePerson.

	john := instances detect: [ :each | each firstName = 'John'].
	john test: (Test new name: 'jTest').
	reStore commit: john.

	"Test various combinations and orderings"
	results := ((instances collect: [ :each | each firstName || each surname || each fullName]) asSortedCollection: [ :a :b | a first <= b first]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #('David' 'Smythe' 'David Smythe')).
	self assert: ((results at: 2) = #('Jim' 'Brown' 'Jim Brown')).
	self assert: ((results at: 3) = #('John' 'Smith' 'John Smith')).
	self assert: ((results at: 4) = #('Zoe' 'Brown' 'Zoe Brown')).
"
	results := ((instances collect: [ :each | each friend firstName || each friend surname || each firstName || each surname]) asSortedCollection: [ :a :b | (a at: 3) <= (b at: 3)]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #(nil nil 'David' 'Smythe')).
	self assert: ((results at: 2) = #(nil nil 'Jim' 'Brown')).
	self assert: ((results at: 3) = #('David' 'Smythe' 'John' 'Smith')).
	self assert: ((results at: 4) = #('John' 'Smith' 'Zoe' 'Brown')).

	results := ((instances collect: [ :each | each firstName || each friend surname || each friend firstName || each surname]) asSortedCollection: [ :a :b | a first <= b first]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #('David' nil nil 'Smythe')).
	self assert: ((results at: 2) = #('Jim' nil nil 'Brown')).
	self assert: ((results at: 3) = #('John' 'Smythe' 'David' 'Smith')).
	self assert: ((results at: 4) = #('Zoe' 'Smith' 'John' 'Brown')).
	
	results := ((instances collect: [ :each | each friend firstName || each surname || each firstName || each friend surname]) asSortedCollection: [ :a :b | (a at: 3) <= (b at: 3)]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #(nil 'Smythe' 'David' nil)).
	self assert: ((results at: 2) = #(nil 'Brown' 'Jim' nil)).
	self assert: ((results at: 3) = #('David' 'Smith' 'John' 'Smythe')).
	self assert: ((results at: 4) = #('John' 'Brown' 'Zoe' 'Smith')).

	results := ((instances collect: [ :each | each firstName || each friend firstName|| each test name || each surname]) asSortedCollection: [ :a :b | a first <= b first]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #('David' nil nil 'Smythe')).
	self assert: ((results at: 2) = #('Jim' nil nil 'Brown')).
	self assert: ((results at: 3) = #('John' 'David' 'jTest' 'Smith')).
	self assert: ((results at: 4) = #('Zoe' 'John' nil 'Brown')).

	results := ((instances collect: [ :each | each test name || each firstName|| each friend firstName || each surname]) asSortedCollection: [ :a :b | (a at: 2) <= (b at: 2)]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #(nil 'David' nil 'Smythe')).
	self assert: ((results at: 2) = #(nil 'Jim' nil 'Brown')).
	self assert: ((results at: 3) = #('jTest' 'John' 'David' 'Smith')).
	self assert: ((results at: 4) = #(nil 'Zoe' 'John' 'Brown'))."!

testCollectQueryWithMultipleObjects

	| instances john results |

	instances := reStore instancesOf: SimplePerson.

	john := instances detect: [ :each | each firstName = 'John'].
	john test: (Test new name: 'jTest').
	reStore commit: john.

	"Test various combinations and orderings"
	results := ((instances collect: [ :each | each firstName || each friend firstName|| each test name || each surname]) asSortedCollection: [ :a :b | a first <= b first]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #('David' nil nil 'Smythe')).
	self assert: ((results at: 2) = #('Jim' nil nil 'Brown')).
	self assert: ((results at: 3) = #('John' 'David' 'jTest' 'Smith')).
	self assert: ((results at: 4) = #('Zoe' 'John' nil 'Brown')).

	results := ((instances collect: [ :each | each test name || each firstName|| each friend firstName || each surname]) asSortedCollection: [ :a :b | (a at: 2) <= (b at: 2)]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #(nil 'David' nil 'Smythe')).
	self assert: ((results at: 2) = #(nil 'Jim' nil 'Brown')).
	self assert: ((results at: 3) = #('jTest' 'John' 'David' 'Smith')).
	self assert: ((results at: 4) = #(nil 'Zoe' 'John' 'Brown')).!

testCollectQueryWithMultipleObjectsFunction

	| instances john results |

	instances := reStore instancesOf: SimplePerson.

	john := instances detect: [ :each | each firstName = 'John'].
	john test: (Test new name: 'jTest').
	reStore commit: john.

	results := ((instances collect: [ :each | each firstName || each friend firstName|| each test name || (each firstName, ' ', each surname)]) asSortedCollection: [ :a :b | a first <= b first]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #('David' nil nil 'David Smythe')).
	self assert: ((results at: 2) = #('Jim' nil nil 'Jim Brown')).
	self assert: ((results at: 3) = #('John' 'David' 'jTest' 'John Smith')).
	self assert: ((results at: 4) = #('Zoe' 'John' nil 'Zoe Brown'))!

testCollectQueryWithMultipleObjectsInlineFunction

	| instances john results |

	instances := reStore instancesOf: SimplePerson.

	john := instances detect: [ :each | each firstName = 'John'].
	john test: (Test new name: 'jTest').
	reStore commit: john.

	results := ((instances collect: [ :each | each firstName || each friend firstName|| each test name || each fullName]) asSortedCollection: [ :a :b | a first <= b first]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #('David' nil nil 'David Smythe')).
	self assert: ((results at: 2) = #('Jim' nil nil 'Jim Brown')).
	self assert: ((results at: 3) = #('John' 'David' 'jTest' 'John Smith')).
	self assert: ((results at: 4) = #('Zoe' 'John' nil 'Zoe Brown'))!

testCollectQueryWithRelatedObject

	| instances john dave testBlock testCount |

	instances := reStore instancesOf: SimplePerson.

	john := instances detect: [ :each | each firstName = 'John'].
	dave := instances detect: [ :each | each firstName = 'David'].

	testCount := 0.
	testBlock := 
		[ :results :position || dict |
		dict := self convertToDictionary: results index: position.
		self assert: (dict size = 2).
		self assert: ((dict at: dave) = #('John' 'Smith' 'David' 'Smythe')).
		self assert: ((dict at: john) = #('Zoe' 'Brown' 'John' 'Smith')).
		testCount := testCount + 1].

	"Test with the related object at different positions in the query block"
	testBlock value: (instances collect: [ :each | each friend || each firstName || each surname || each friend firstName || each friend surname]) value: 1.
	testBlock value: (instances collect: [ :each | each firstName || each friend || each surname || each friend firstName || each friend surname]) value: 2.
	testBlock value: (instances collect: [ :each | each firstName || each surname || each friend || each friend firstName || each friend surname]) value: 3.
	testBlock value: (instances collect: [ :each | each firstName || each surname || each friend firstName || each friend || each friend surname]) value: 4.
	testBlock value: (instances collect: [ :each | each firstName || each surname || each friend firstName || each friend surname || each friend]) value: 5.

	"Ensure we actually did some testing"
	self assert: (testCount = 5)!

testCollectQueryWithRelatedObjectFunction

	| instances john results |

	instances := reStore instancesOf: SimplePerson.

	john := instances detect: [ :each | each firstName = 'John'].
	john test: (Test new name: 'jTest').
	reStore commit: john.

	"Test various combinations and orderings"
	results := ((instances collect: [ :each | each firstName || each surname || (each friend firstName, ' ', each friend surname)]) asSortedCollection: [ :a :b | a first <= b first]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #('David' 'Smythe' nil)).
	self assert: ((results at: 2) = #('Jim' 'Brown' nil)).
	self assert: ((results at: 3) = #('John' 'Smith' 'David Smythe')).
	self assert: ((results at: 4) = #('Zoe' 'Brown' 'John Smith')).

	results := ((instances collect: [ :each | each friend firstName || each friend surname || (each firstName, ' ', each surname)]) asSortedCollection: [ :a :b | (a at: 3) <= (b at: 3)]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #(nil nil 'David Smythe')).
	self assert: ((results at: 2) = #(nil nil 'Jim Brown')).
	self assert: ((results at: 3) = #('David' 'Smythe' 'John Smith')).
	self assert: ((results at: 4) = #('John' 'Smith' 'Zoe Brown')).

	results := ((instances collect: [ :each | each firstName || each friend surname || (each firstName, ' ', each surname)]) asSortedCollection: [ :a :b | a first <= b first]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #('David' nil 'David Smythe')).
	self assert: ((results at: 2) = #('Jim' nil 'Jim Brown')).
	self assert: ((results at: 3) = #('John' 'Smythe' 'John Smith')).
	self assert: ((results at: 4) = #('Zoe' 'Smith' 'Zoe Brown')).

	results := ((instances collect: [ :each | each friend firstName || each surname || (each friend firstName, ' ', each friend surname) || each firstName]) asSortedCollection: [ :a :b | (a at: 4) <= (b at: 4)]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #(nil 'Smythe' nil 'David')).
	self assert: ((results at: 2) = #(nil 'Brown' nil 'Jim')).
	self assert: ((results at: 3) = #('David' 'Smith' 'David Smythe' 'John')).
	self assert: ((results at: 4) = #('John' 'Brown' 'John Smith' 'Zoe'))!

testCollectQueryWithRelatedObjectInlineFunction

	| instances john results |

	instances := reStore instancesOf: SimplePerson.

	john := instances detect: [ :each | each firstName = 'John'].
	john test: (Test new name: 'jTest').
	reStore commit: john.

	"Test various combinations and orderings"
	results := ((instances collect: [ :each | each firstName || each surname || each friend fullName]) asSortedCollection: [ :a :b | a first <= b first]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #('David' 'Smythe' nil)).
	self assert: ((results at: 2) = #('Jim' 'Brown' nil)).
	self assert: ((results at: 3) = #('John' 'Smith' 'David Smythe')).
	self assert: ((results at: 4) = #('Zoe' 'Brown' 'John Smith')).

	results := ((instances collect: [ :each | each friend firstName || each friend surname || each fullName]) asSortedCollection: [ :a :b | (a at: 3) <= (b at: 3)]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #(nil nil 'David Smythe')).
	self assert: ((results at: 2) = #(nil nil 'Jim Brown')).
	self assert: ((results at: 3) = #('David' 'Smythe' 'John Smith')).
	self assert: ((results at: 4) = #('John' 'Smith' 'Zoe Brown')).

	results := ((instances collect: [ :each | each firstName || each friend surname || each fullName]) asSortedCollection: [ :a :b | a first <= b first]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #('David' nil 'David Smythe')).
	self assert: ((results at: 2) = #('Jim' nil 'Jim Brown')).
	self assert: ((results at: 3) = #('John' 'Smythe' 'John Smith')).
	self assert: ((results at: 4) = #('Zoe' 'Smith' 'Zoe Brown')).

	results := ((instances collect: [ :each | each friend firstName || each surname || each friend fullName || each firstName]) asSortedCollection: [ :a :b | (a at: 4) <= (b at: 4)]) asArray.
	self assert: (results size = 4).
	self assert: ((results at: 1) = #(nil 'Smythe' nil 'David')).
	self assert: ((results at: 2) = #(nil 'Brown' nil 'Jim')).
	self assert: ((results at: 3) = #('David' 'Smith' 'David Smythe' 'John')).
	self assert: ((results at: 4) = #('John' 'Brown' 'John Smith' 'Zoe'))!

testConcatenateQueryWithJoins

	| instances john results |

	instances := reStore instancesOf: SimplePerson.

	john := instances detect: [ :each | each firstName = 'John'].
	john test: (Test new name: 'jTest').
	reStore commit: john.

	"Test various combinations and orderings which previously gave problems"
	results := instances collect: [ :each | each firstName, each surname, each friend firstName, each friend surname].
	self assert: ((results reject: [ :each | each isNil]) asSortedCollection asArray = #('JohnSmithDavidSmythe'  'ZoeBrownJohnSmith')).

	results := instances collect: [ :each | each friend firstName, each surname, each firstName, each friend surname].
	self assert: ((results reject: [ :each | each isNil]) asSortedCollection asArray = #('DavidSmithJohnSmythe'  'JohnBrownZoeSmith')).

	results := instances collect: [ :each | each friend firstName, each friend surname, each firstName, each surname].
	self assert: ((results reject: [ :each | each isNil]) asSortedCollection asArray = #('DavidSmytheJohnSmith'  'JohnSmithZoeBrown')).

	results := instances collect: [ :each | each firstName, each surname, each test name].
	self assert: ((results reject: [ :each | each isNil]) asArray = #('JohnSmithjTest')).

	results := instances collect: [ :each | each firstName, each test name, each surname].
	self assert: ((results reject: [ :each | each isNil]) asArray = #('JohnjTestSmith')).

	results := instances collect: [ :each | each firstName, each friend firstName, each test name, each friend surname, each surname].
	self assert: ((results reject: [ :each | each isNil]) asArray = #('JohnDavidjTestSmytheSmith'))!

testIncludesInQueryBlockEmptyCriteria

	| instances |

	instances := reStore instancesOf: SimplePerson.

	{Array. OrderedCollection. Set} do:
		[ :collectionClass || criteria matches |
		criteria := collectionClass new.

		self shouldnt: [matches := instances select: [ :each | criteria includes: each firstName]] raise: Error.
		self assert: matches isEmpty.

		self shouldnt: [matches := instances select: [ :each | each firstName = 'John' and: [criteria includes: each firstName]]] raise: Error.
		self assert: matches isEmpty.

		self shouldnt: [matches := instances reject: [ :each | criteria includes: each firstName]] raise: Error.
		self assert: matches size = instances size.

		self shouldnt: [matches := instances reject: [ :each | each firstName = 'John' and: [criteria includes: each firstName]]] raise: Error.
		self assert: matches size = instances size]!

testIncludesInQueryBlockPersistentObject

	| instances john david |

	instances := reStore instancesOf: SimplePerson.

	john := instances detect: [ :each | each firstName = 'John'].
	david := instances detect: [ :each | each firstName = 'David'].

	"Test common collection classes (previously only Array worked"
	{Array. Set. OrderedCollection} do: 
		[ :collectionClass || criteria matches |
		criteria := collectionClass with: john with: david.

		matches := instances select: [ :each | criteria includes: each friend].

		self assert: (matches size = 2).
		self assert: ((matches collect: [ :e | e fullName]) asSortedCollection asArray = #('John Smith' 'Zoe Brown'))]!

testIncludesInQueryBlockSimple

	| instances |

	instances := reStore instancesOf: SimplePerson.

	"Test common collection classes (previously only Array worked"
	{Array. Set. OrderedCollection} do: 
		[ :collectionClass || criteria matches |
		criteria := collectionClass withAll: #('Zoe' 'John').

		matches := instances select: [ :each | criteria includes: each firstName].

		self assert: (matches size = 2).
		self assert: ((matches collect: [ :e | e fullName]) asSortedCollection asArray = #('John Smith' 'Zoe Brown'))]!

testInstancesCollectionIncludes

	| instances zoe |

	instances := reStore instancesOf: SimplePerson.
	zoe := instances detect: [ :each | each firstName = 'Zoe'].

	self assert: (instances includes: zoe).
	self assert: ((instances satisfying: [ :each | each surname = 'Brown']) includes: zoe).
	self deny: ((instances satisfying: [ :each | each surname = 'Smith']) includes: zoe).
	self deny: (instances includes: SimplePerson new)!

testQueryEvaluationLocationDatabase

	"Test database side of imageDo:databaseDo:"

	| instances names|

	instances := reStore instancesOf: SimplePerson.

	names := instances collect: [ :each | each firstName || each surname || each fullNameWithEvaluationLocation].

	names do: 
		[ :array |
		self assert: array last equals: ('<1s> <2s> (DATABASE)' expandMacrosWith: array first with: array second)].!

testQueryEvaluationLocationImage

	"Test image side of imageDo:databaseDo:"

	| instances names|

	instances := reStore instancesOf: SimplePerson.

	names := instances asOrderedCollection collect: [ :each | each firstName || each surname || each fullNameWithEvaluationLocation].

	names do: 
		[ :array |
		self assert: array last equals: ('<1s> <2s> (IMAGE)' expandMacrosWith: array first with: array second)].! !
!SSWReStoreQueryTest categoriesFor: #addClassesTo:!public!Running! !
!SSWReStoreQueryTest categoriesFor: #convertToDictionary:index:!helpers!private! !
!SSWReStoreQueryTest categoriesFor: #createProducts!public!Running! !
!SSWReStoreQueryTest categoriesFor: #test1Simple!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #test2Wildcards!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #test3Order!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #test3Sort!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #test4Modify!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #test5InlineFunctionQuery!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #test6MethodFunctionQuery!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #test6MethodFunctionQueryWithDirectInstVars!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #test7InlineFunctionQueryComplex!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #test7MethodFunctionQueryComplex!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #test8CustomQuery!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #test9MultiArgumentFieldQuery!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #testAMultiArgumentMixedQuery!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #testBMultiArgumentFunctionCollectFieldQuery!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #testCMultiArgumentFunctionCollectMixedQuery!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #testCollectQuery!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #testCollectQueryWithActualObject!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #testCollectQueryWithFunction!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #testCollectQueryWithInlineFunction!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #testCollectQueryWithMultipleObjects!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #testCollectQueryWithMultipleObjectsFunction!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #testCollectQueryWithMultipleObjectsInlineFunction!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #testCollectQueryWithRelatedObject!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #testCollectQueryWithRelatedObjectFunction!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #testCollectQueryWithRelatedObjectInlineFunction!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #testConcatenateQueryWithJoins!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #testIncludesInQueryBlockEmptyCriteria!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #testIncludesInQueryBlockPersistentObject!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #testIncludesInQueryBlockSimple!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #testInstancesCollectionIncludes!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #testQueryEvaluationLocationDatabase!public!unit tests! !
!SSWReStoreQueryTest categoriesFor: #testQueryEvaluationLocationImage!public!unit tests! !

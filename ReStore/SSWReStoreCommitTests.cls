"Filed out from Dolphin Smalltalk 7"!

SSWReStorePersonTest subclass: #SSWReStoreCommitTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreCommitTests guid: (GUID fromString: '{b23f6a7e-7018-4b0b-b981-2d45c37064f0}')!
SSWReStoreCommitTests comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreCommitTests categoriesForClass!Unclassified! !
!SSWReStoreCommitTests methodsFor!

addClassesTo: aReStore

	super addClassesTo: aReStore.
	aReStore
		addClass: OwnerTest;
		addClass: Test!

test01SelfReference

	| obj |

	obj := SimplePerson new firstName: 'Dave'.
	obj friend: obj.
	reStore evaluateAsTransaction: [obj storeIn: reStore].

	reStore simulateReconnect.

	obj := (reStore instancesOf: SimplePerson) first.
	self assert: (obj friend == obj)

	!

test02MultiCommitSameObject

	| obj success people|

	obj := SimplePerson new firstName: 'Dave'.
	reStore evaluateAsTransaction: [obj storeIn: reStore].

	reStore simulateReconnect.

	obj := (reStore instancesOf: SimplePerson) first.
	obj firstName: 'David'.

	self shouldnt: [success := reStore commitAll: ((Array new: 20) atAllPut: obj; yourself)] raise: Error.
	self assert: success.

	reStore simulateReconnect.
	people := reStore instancesOf: SimplePerson.
	self assert: (people size = 1).
	obj := people first.
	self assert: (obj firstName = 'David')!

test03MultiStoreSameObject

	| obj success people |

	obj := SimplePerson new firstName: 'Dave'.
	self shouldnt: [success := reStore commitAll: (Array with: obj with: obj with: obj with: obj)] raise: Error.
	self assert: success.

	reStore simulateReconnect.
	people := reStore instancesOf: SimplePerson.
	self assert: (people size = 1).
	obj := people first.
	self assert: (obj firstName = 'Dave')!

test04MultiStoreSameObjectViaRelationships

	| obj1 obj2 tst success ownerTests tests |

	obj1 := OwnerTest template name: 'owner1'.
	obj2 := OwnerTest template name: 'owner2'.
	tst := Test new name: 'test'.

	"single2 and single3 are dependents"
	obj1 
		single2: tst;
		single3: tst.
	obj2 
		single2: tst;
		single3: tst.

	self shouldnt: [success := reStore commitAll: (Array with: obj1 withRelatedComponents with: obj2 withRelatedComponents with: tst)] raise: Error.
	self assert: success.

	reStore simulateReconnect.
	ownerTests := (reStore instancesOf: OwnerTest) sortBlock: [ :a :b | a name <= b name].
	tests := (reStore instancesOf: Test) sortBlock: [ :a :b | a name <= b name].
	self assert: (ownerTests size = 2).
	self assert: (tests size = 1).
	obj1 := ownerTests first.
	obj2 := ownerTests last.
	self assert: (tests first == obj1 single2).
	self assert: (obj1 single2 == obj1 single3).
	self assert: (tests first == obj2 single2).
	self assert: (obj2 single2 == obj2 single3)! !
!SSWReStoreCommitTests categoriesFor: #addClassesTo:!public!Running! !
!SSWReStoreCommitTests categoriesFor: #test01SelfReference!public! !
!SSWReStoreCommitTests categoriesFor: #test02MultiCommitSameObject!public! !
!SSWReStoreCommitTests categoriesFor: #test03MultiStoreSameObject!public! !
!SSWReStoreCommitTests categoriesFor: #test04MultiStoreSameObjectViaRelationships!public! !


"Filed out from Dolphin Smallalk"!

SSWReStoreDeleteDependentCollectionTest subclass: #SSWReStoreDeleteDependentOwnedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreDeleteDependentOwnedCollectionTest guid: (GUID fromString: '{18fb7c39-9ef9-4902-a817-475cd4a7a655}')!
SSWReStoreDeleteDependentOwnedCollectionTest comment: ''!
!SSWReStoreDeleteDependentOwnedCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreDeleteDependentOwnedCollectionTest methodsFor!

deleteQueriesCount

	^1!

ordersCollectionDefinition

	"Owned collection"

	^(OrderedCollection of: SimpleProductOrder dependent owner: #customer)!

testUnstoreCollectionElements

	"Verify unstoring collection elements does not delete the owning customer (previous error case)"

	| id expectedCount |

	self deny: customer1 orders isEmpty.

	id := customer1 _id.
	expectedCount := (reStore instancesOf: SimpleProductOrder) size - customer1 orders size.

	"For dialects which do not supportsDeleteWithJoin this isn't supported"
	reStore sqlDialect supportsDeleteWithJoin
		ifTrue: [(reStore instancesOf: SimpleProductOrder) unstore: [ :each | each customer firstName = customer1 firstName]]
		ifFalse: [^self should: [(reStore instancesOf: SimpleProductOrder) unstore: [ :each | each customer firstName = customer1 firstName]] raise: Error].

	reStore simulateReconnect.
	customer1 := (reStore instancesOf: SimplePerson) detect: [ :each | each _id = id] ifNone: [nil].

	"Verify customer1 still exists"
	self assert: customer1 notNil.

	"Verify deletion has happened"
	self assert: customer1 orders isEmpty.	
	self assert: (reStore instancesOf: SimpleProductOrder) size equals: expectedCount! !
!SSWReStoreDeleteDependentOwnedCollectionTest categoriesForMethods!
deleteQueriesCount!constants!public! !
ordersCollectionDefinition!constants!public! !
testUnstoreCollectionElements!public!unit tests! !
!

!SSWReStoreDeleteDependentOwnedCollectionTest class methodsFor!

testSelectors

	^self myTestSelectors! !
!SSWReStoreDeleteDependentOwnedCollectionTest class categoriesForMethods!
testSelectors!public! !
!


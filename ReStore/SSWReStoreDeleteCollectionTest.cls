﻿"Filed out from Dolphin Smallalk"!

SSWReStoreReadWithComponentsTest subclass: #SSWReStoreDeleteCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreDeleteCollectionTest guid: (GUID fromString: '{dca79c5a-dd73-416e-a6fd-6a6d65cf095c}')!
SSWReStoreDeleteCollectionTest comment: ''!
!SSWReStoreDeleteCollectionTest categoriesForClass!Unclassified! !
!SSWReStoreDeleteCollectionTest methodsFor!

_testDeleteAll

	customers := customers asOrderedCollection.

	Transcript cr; print: (Time millisecondsToRun: [reStore evaluateAsTransaction: [customers unstoreAll]]); flush!

deleteCustomer1QueriesCount

	"How many queries to delete customer1?"
	^1 + self deleteQueriesCount "delete customer + delete collection"!

deleteCustomer2QueriesCount

	"How many queries to delete customer2?"
	^1 + self deleteQueriesCount "delete customer + delete collection"!

deleteProxiedCollectionQueryCount

	^3 + self deleteCustomer2QueriesCount "read customer + read collection + delete customer + delete query(s)"!

deleteQueriesCount

	"How many queries to delete a collection?"
	^self subclassResponsibility!

deproxyQueryCount

	^2 "read customer + read collection"!

otherCustomersSize

	"Not used here"
	^0!

testDeleteProxiedCollectionQueryCount

	self assert: customer2 isDBProxy.

	self resetQueryCount.
	self assert: customer2 unstore.
	self assert: self queryCount equals: self deproxyQueryCount + self deleteCustomer2QueriesCount!

testDeleteUnproxiedCollectionQueryCount

	customer1 orders _deproxify.
	self deny: customer1 isDBProxy.
	self deny: customer1 orders isDBProxy.

	self resetQueryCount.
	self assert: customer1 unstore.
	self assert: self queryCount equals: self deleteCustomer1QueriesCount! !
!SSWReStoreDeleteCollectionTest categoriesForMethods!
_testDeleteAll!public!unit tests! !
deleteCustomer1QueriesCount!constants!public! !
deleteCustomer2QueriesCount!constants!public! !
deleteProxiedCollectionQueryCount!constants!public! !
deleteQueriesCount!constants!public! !
deproxyQueryCount!constants!public! !
otherCustomersSize!constants!public! !
testDeleteProxiedCollectionQueryCount!public!unit tests! !
testDeleteUnproxiedCollectionQueryCount!public!unit tests! !
!

!SSWReStoreDeleteCollectionTest class methodsFor!

isAbstract

	^self = SSWReStoreDeleteCollectionTest! !
!SSWReStoreDeleteCollectionTest class categoriesForMethods!
isAbstract!public! !
!


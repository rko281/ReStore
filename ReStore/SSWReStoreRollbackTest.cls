"Filed out from Dolphin Smalltalk"!

SSWReStoreAbstractQueryTest subclass: #SSWReStoreRollbackTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWReStoreRollbackTest guid: (GUID fromString: '{c8a21d1e-c138-4bbf-b12a-53b745bb4f5e}')!

SSWReStoreRollbackTest comment: ''!

!SSWReStoreRollbackTest categoriesForClass!Unclassified! !

!SSWReStoreRollbackTest methodsFor!

testRollbackChanges

	| person rolledBack |

	person := self john.
	rolledBack := false.
	person rollbackBlock: [rolledBack := true].

	reStore beginTransaction.
	person firstName: 'Jon'.
	reStore rollbackTransaction.

	"Following the rollback the object should be an unchanged proxy which has had #onRollback invoked on it"
	self assert: rolledBack.
	self assert: person isDBProxy.
	self assert: person _isPersistent.
	self assert: ((reStore classCacheFor: person class) includes: person).
	self assert: person firstName equals: 'John'!

testRollbackChangesPreservesEventsInRegister

	"Verify a rollback preserves events stored in the _EventsRegister / EventManager"

	| person rolledBack |

	person := self john.
	rolledBack := false.
	person when: #someEvent send: #value to: [rolledBack := true].
	
	reStore beginTransaction.
	person firstName: 'Jon'.
	reStore rollbackTransaction.

	"Verify the event is still present"
	person trigger: #someEvent.
	self assert: rolledBack!

testRollbackChangesPreservesLocalEvents

	"Verify a rollback preserves events stored locally in the object"

	| person rolledBack |

	(reStore addClass: SimplePersonWithEvents) name: (reStore tableForClass: SimplePerson) name.
	reStore tableCache removeKey: SimplePerson.

	person := (SimplePersonWithEvents storedInstancesIn: reStore) detect: [ :each | each firstName = 'John'].
	rolledBack := false.
	person when: #someEvent send: #value to: [rolledBack := true].
	self assert: person hasLocalEvents.
	
	reStore beginTransaction.
	person firstName: 'Jon'.
	reStore rollbackTransaction.

	"Verify the event is still present"
	person trigger: #someEvent.
	self assert: rolledBack.
	self assert: person hasLocalEvents!

testRollbackStore

	| newPerson rolledBack |

	newPerson := SimplePerson new firstName: 'Partario'.
	rolledBack := false.
	newPerson rollbackBlock: [rolledBack := true].

	reStore beginTransaction.
	newPerson storeIn: reStore.
	reStore rollbackTransaction.

	"Following the rollback the object should not be a proxy which has had #onRollback invoked on it, and no proxy for it should exist"
	self assert: rolledBack.
	self deny: newPerson isDBProxy.
	self deny: ((reStore classCacheFor: newPerson class) anySatisfy: [ :each | each _proxiedObject == newPerson])!

testRollbackStorePreservesEventsInRegister

	"Verify a rollback preserves events stored in the _EventsRegister / EventManager"

	| newPerson rolledBack |

	newPerson := SimplePerson new firstName: 'Partario'.
	rolledBack := false.
	newPerson when: #someEvent send: #value to: [rolledBack := true].

	reStore beginTransaction.
	newPerson storeIn: reStore.
	reStore rollbackTransaction.

	"Verify the event is still present"
	newPerson trigger: #someEvent.
	self assert: rolledBack!

testRollbackStorePreservesLocalEvents

	"Verify a rollback preserves events stored locally in the object"

	| newPerson rolledBack |

	(reStore addClass: SimplePersonWithEvents) name: (reStore tableForClass: SimplePerson) name.
	reStore tableCache removeKey: SimplePerson.

	newPerson := SimplePersonWithEvents new firstName: 'Partario'.
	rolledBack := false.
	newPerson when: #someEvent send: #value to: [rolledBack := true].
	self assert: newPerson hasLocalEvents.

	reStore beginTransaction.
	newPerson storeIn: reStore.
	reStore rollbackTransaction.

	"Verify the event is still present"
	newPerson trigger: #someEvent.
	self assert: rolledBack.
	self assert: newPerson hasLocalEvents!

testRollbackUnstore

	| person rolledBack |

	person := self john.
	rolledBack := false.
	person rollbackBlock: [rolledBack := true].

	reStore beginTransaction.
	person unstore.
	reStore rollbackTransaction.

	"Following the rollback the object should be an unchanged proxy which has had #onRollback invoked on it"
	self assert: rolledBack.
	self assert: person isDBProxy.
	self assert: person _isPersistent.
	self assert: ((reStore classCacheFor: person class) includes: person).!

testRollbackUnstorePreservesEventsInRegister

	"Verify a rollback preserves events stored in the _EventsRegister / EventManager"

	| person rolledBack |

	person := self john.
	rolledBack := false.
	person when: #someEvent send: #value to: [rolledBack := true].
	
	reStore beginTransaction.
	person unstore.
	reStore rollbackTransaction.

	"Verify the event is still present"
	person trigger: #someEvent.
	self assert: rolledBack!

testRollbackUnstorePreservesLocalEvents

	"Verify a rollback preserves events stored locally in the object"

	| person rolledBack |

	(reStore addClass: SimplePersonWithEvents) name: (reStore tableForClass: SimplePerson) name.
	reStore tableCache removeKey: SimplePerson.

	person := (SimplePersonWithEvents storedInstancesIn: reStore) detect: [ :each | each firstName = 'John'].
	rolledBack := false.
	person when: #someEvent send: #value to: [rolledBack := true].
	self assert: person hasLocalEvents.
	
	reStore beginTransaction.
	person unstore.
	reStore rollbackTransaction.

	"Verify the event is still present"
	person trigger: #someEvent.
	self assert: rolledBack.
	self assert: person hasLocalEvents! !

!SSWReStoreRollbackTest categoriesForMethods!
testRollbackChanges!public! !
testRollbackChangesPreservesEventsInRegister!public! !
testRollbackChangesPreservesLocalEvents!public! !
testRollbackStore!public! !
testRollbackStorePreservesEventsInRegister!public! !
testRollbackStorePreservesLocalEvents!public! !
testRollbackUnstore!public! !
testRollbackUnstorePreservesEventsInRegister!public! !
testRollbackUnstorePreservesLocalEvents!public! !
!


"Filed out from Dolphin Smalltalk 7"!

SSWReStoreTest subclass: #SSWReStoreRemoteTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreRemoteTest guid: (GUID fromString: '{ed2739da-fff6-4f7c-9591-5eed7991e4d7}')!
SSWReStoreRemoteTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreRemoteTest categoriesForClass!Unclassified! !
!SSWReStoreRemoteTest methodsFor!

setUp

	super setUp.

	self createStandardTestInstance.
	reStore simulateReconnect!

test1OwnedRemote

	| inst |

	inst := (reStore instancesOf: OwnerTest) first.

	self assert: (inst ownedOrdered remote size = 2).
	self assert: (inst ownedOrdered remote asOrderedCollection anySatisfy: [ :each | each name = 'owned1']).
	self assert: (inst ownedOrdered orRemote size = 2).
	self assert: (inst ownedOrdered orRemote asOrderedCollection anySatisfy: [ :each | each name = 'owned1']).
	self assert: (inst ownedOrdered isDBProxy).

	reStore beginTransaction.
	inst ownedOrdered add: (OwnedTest new name: 'owned3').
	self deny: (inst ownedOrdered isDBProxy).

	self assert: (inst ownedOrdered remote size = 2).
	self assert: (inst ownedOrdered remote asOrderedCollection anySatisfy: [ :each | each name = 'owned1']).
	self assert: (inst ownedOrdered orRemote size = 3).
	self assert: (inst ownedOrdered orRemote asOrderedCollection last name = 'owned3').

	reStore commitTransaction.	
	self assert: (inst ownedOrdered remote size = 3).
	self assert: (inst ownedOrdered remote asOrderedCollection last name = 'owned3').

!

test2GeneralRemote

	| inst |

	inst := (reStore instancesOf: OwnerTest) first.

	self assert: (inst ordered remote size = 2).
	self assert: (inst ordered remote asOrderedCollection first name = 'ordered1').
	self assert: (inst ordered orRemote size = 2).
	self assert: (inst ordered orRemote asOrderedCollection first name = 'ordered1').
	self assert: (inst ordered isDBProxy).

	reStore beginTransaction.
	inst ordered add: (Test new name: 'ordered3').
	self deny: (inst ordered isDBProxy).

	self assert: (inst ordered remote size = 2).
	self assert: (inst ordered remote asOrderedCollection first name = 'ordered1').
	self assert: (inst ordered orRemote size = 3).
	self assert: (inst ordered orRemote asOrderedCollection last name = 'ordered3').

	reStore commitTransaction.
	self assert: (inst ordered remote size = 3).
	self assert: (inst ordered remote asOrderedCollection last name = 'ordered3')! !
!SSWReStoreRemoteTest categoriesFor: #setUp!public!running! !
!SSWReStoreRemoteTest categoriesFor: #test1OwnedRemote!public!unit tests! !
!SSWReStoreRemoteTest categoriesFor: #test2GeneralRemote!public!unit tests! !


"Filed out from Dolphin Smalltalk"!

SSWDBAbstractSingleTransaction subclass: #SSWDBSingleTransaction
	instanceVariableNames: 'updateStatementsCache'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWDBSingleTransaction guid: (GUID fromString: '{5a3e3dd6-3990-11d5-b1df-444553540000}')!

SSWDBSingleTransaction comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!

!SSWDBSingleTransaction categoriesForClass!Unclassified! !

!SSWDBSingleTransaction methodsFor!

commitTo: aDBConnection

	"Commit the receiver's objects without any checking (done in prepareToCommit).
	Use aDBConnection for database-level transaction (Txn) control."
	
	aDBConnection beginRWTxn.
	self preCommit.
	self changedObjects 
		do: [ :proxyObj | proxyObj _commitChangesPhase1];
		do: [ :proxyObj | proxyObj _commitChangesPhase2].
	aDBConnection commitTxn.

	self postCommit.

	self resetChangedObjects.
	self beginObjectCollection
!

freeStatements

	self updateStatementsCache do: [ :stmts | stmts do: [ :stmt | stmt free]]!

hasChanges

	^self currentReferencedObjects anySatisfy: [ :obj | obj _checkHasChanged]!

hasFailedCommit

	"The receiver does not support commit-time checking of update clashes.
	Therefore commits are always considered to succeed.
	Subclasses may do something smarter"
	
	^false!

postCommit

	self postCommitAllocatedIDs.
	self changedObjects do: [ :proxyObj | proxyObj _postCommitChanges].
	self freeStatements!

postRollback

	self endObjectCollection!

preCommit

	self updateStatementsCache: IdentityDictionary new.
	self commitAllocatedIDs!

rollback

	| rolledBack |

	rolledBack := OrderedCollection new: (self currentReferencedObjects size * 2).

	self currentReferencedObjects isNil ifFalse:
		[[self currentReferencedObjects isEmpty] whileFalse:
			[| toSwap toRollback |
			toSwap := OrderedCollection new: self currentReferencedObjects size. 
			toRollback := toSwap copy.
			self currentReferencedObjects do: 
				[ :each |
				each _isPersistent
				ifTrue: 
					[toRollback add: each _proxiedObject.
					toSwap add: each.
					rolledBack add: each]
				ifFalse: 
					[toRollback add: each.
					rolledBack add: each _proxiedObject]].
			self currentReferencedObjects: (self newEmptyObjectsSet: (toSwap size // 2)). 
			SSWDBTransactionProxySwapper unswapAll: toSwap.
			toRollback do: [ :proxy | proxy isDBProxy ifTrue: [proxy _rollbackChanges]]]].

	self postRollback.

	^rolledBack!

statementForUpdateQuery: anUpdateQuery ifAbsent: aBlock

	^(self updateStatementsCache at: anUpdateQuery table ifAbsentPut: [Dictionary new])
		at: anUpdateQuery updatedFields ifAbsentPut: [aBlock value]!

updateStatementsCache
	^updateStatementsCache!

updateStatementsCache: anObject
	updateStatementsCache := anObject! !

!SSWDBSingleTransaction categoriesForMethods!
commitTo:!actions!public! !
freeStatements!actions!private! !
hasChanges!public!testing! !
hasFailedCommit!public!testing! !
postCommit!actions!private! !
postRollback!actions!private! !
preCommit!actions!private! !
rollback!actions!public! !
statementForUpdateQuery:ifAbsent:!public! !
updateStatementsCache!public! !
updateStatementsCache:!public! !
!


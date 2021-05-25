"Filed out from Dolphin Smalltalk 7"!

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
			[| toRollback |
			toRollback := self currentReferencedObjects copy.
			self currentReferencedObjects: (self newEmptyObjectsSet: (toRollback size // 2)). 
			toRollback do: [ :proxy | proxy _rollbackChanges].
			rolledBack addAll: toRollback]].

	self postRollback.

	^rolledBack!

statementForUpdateQuery: anUpdateQuery ifAbsent: aBlock

	^(self updateStatementsCache at: anUpdateQuery table ifAbsentPut: [Dictionary new])
		at: anUpdateQuery updatedFields ifAbsentPut: [aBlock value]!

updateStatementsCache
	^updateStatementsCache!

updateStatementsCache: anObject
	updateStatementsCache := anObject! !
!SSWDBSingleTransaction categoriesFor: #commitTo:!actions!public! !
!SSWDBSingleTransaction categoriesFor: #freeStatements!actions!private! !
!SSWDBSingleTransaction categoriesFor: #hasChanges!public!testing! !
!SSWDBSingleTransaction categoriesFor: #hasFailedCommit!public!testing! !
!SSWDBSingleTransaction categoriesFor: #postCommit!actions!private! !
!SSWDBSingleTransaction categoriesFor: #postRollback!actions!private! !
!SSWDBSingleTransaction categoriesFor: #preCommit!actions!private! !
!SSWDBSingleTransaction categoriesFor: #rollback!actions!public! !
!SSWDBSingleTransaction categoriesFor: #statementForUpdateQuery:ifAbsent:!public! !
!SSWDBSingleTransaction categoriesFor: #updateStatementsCache!public! !
!SSWDBSingleTransaction categoriesFor: #updateStatementsCache:!public! !


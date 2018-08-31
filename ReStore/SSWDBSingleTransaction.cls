"Filed out from Dolphin Smalltalk 7"!

SSWDBAbstractSingleTransaction subclass: #SSWDBSingleTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBSingleTransaction guid: (GUID fromString: '{5a3e3dd6-3990-11d5-b1df-444553540000}')!
SSWDBSingleTransaction comment: 'Copyright 2000/2001 Solutions Software Limited'!
!SSWDBSingleTransaction categoriesForClass!Unclassified! !
!SSWDBSingleTransaction methodsFor!

commitTo: aDBConnection

	"Commit the receiver's objects without any checking (done in prepareToCommit).
	Use aDBConnection for database-level transaction (Txn) control."
	
	aDBConnection beginRWTxn.
	self changedObjects do: [ :proxyObj | proxyObj _commitChanges].
	aDBConnection commitTxn.
	self changedObjects do: [ :proxyObj | proxyObj _postCommitChanges].

	self resetChangedObjects.
	self beginObjectCollection
!

hasChanges

	"12/3/01"
	
	^self currentReferencedObjects anySatisfy: [ :obj | obj _checkHasChanged]!

hasFailedCommit

	"The receiver does not support commit-time checking of update clashes.
	Therefore commits are always considered to succeed.
	Subclasses may do something smarter"
	
	^false!

postRollback

	self endObjectCollection!

rollback

	"20/10/2000"
	
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

	^rolledBack! !
!SSWDBSingleTransaction categoriesFor: #commitTo:!actions!public! !
!SSWDBSingleTransaction categoriesFor: #hasChanges!public!testing! !
!SSWDBSingleTransaction categoriesFor: #hasFailedCommit!public!testing! !
!SSWDBSingleTransaction categoriesFor: #postRollback!actions!private! !
!SSWDBSingleTransaction categoriesFor: #rollback!actions!public! !


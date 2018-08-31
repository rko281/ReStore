"Filed out from Dolphin Smalltalk 7"!

SSWDBSingleTransaction subclass: #SSWDBSingleTransactionWithVersioning
	instanceVariableNames: 'proxyCommitFailures'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBSingleTransactionWithVersioning guid: (GUID fromString: '{d7154f77-36ed-4fed-83ec-4733b4e34795}')!
SSWDBSingleTransactionWithVersioning comment: ''!
!SSWDBSingleTransactionWithVersioning categoriesForClass!Unclassified! !
!SSWDBSingleTransactionWithVersioning methodsFor!

commitFailures

	"23/4/2001
	
	Return the actual objects (not proxies) which failed to commit"
	
	^self proxyCommitFailures collect: [ :proxy | proxy _proxiedObject]!

commitTo: aDBConnection

	"Commit the receiver's objects without any checking (done in prepareToCommit).
	Use aDBConnection for database-level transaction (Txn) control.
	Set commitFailures accordingly"
	
	| toCommit conflicts resolved failures |

	toCommit := self changedObjects. 

	"Iteratively commit, resolving update conflicts and retrying if all are resolved"
	[aDBConnection beginRWTxn.
	conflicts := toCommit reject: [ :proxyObj | proxyObj _commitChanges].
	resolved := OrderedCollection new.
	failures := OrderedCollection new.

	conflicts isEmpty ifFalse:
		[aDBConnection rollbackTxn.
		conflicts do: 
			[ :proxyObj | 
			([proxyObj _resolveUpdateConflicts] on: Error do: [ :exc | exc return: false])
				ifTrue: [resolved add: proxyObj]
				ifFalse: [failures add: proxyObj _proxiedObject]]].	"Use the proxiedObject so we get 
												the proxy after _swapReferences"
	failures isEmpty and: [resolved isEmpty not]] whileTrue.

	"currentReferencedObjects usually empty, but could contain objects ref'd during conflict resolution"
	self currentReferencedObjects do: [ :obj | obj _swapReferences].
	self beginObjectCollection.

	self proxyCommitFailures: failures.
	self hasFailedCommit 
	ifTrue: 
		[aDBConnection rollbackTxn.
		self currentReferencedObjects: (self changedObjects collect: [ :obj | obj _swapReferences])]
	ifFalse: 
		[aDBConnection commitTxn.
		self changedObjects do: [ :proxyObj | proxyObj _postCommitChanges]].

	self resetChangedObjects!

ensureHasFailedCommit

	"Private - 24/4/2001"
	
	self hasFailedCommit ifFalse: [self error: 'Transaction has not failed a commit'].!

hasFailedCommit

	"12/3/01"
	
	^self proxyCommitFailures notNil and: [self proxyCommitFailures isEmpty not]!

postRollback

	self proxyCommitFailures: nil.
	super postRollback!

proxyCommitFailures

	"23/4/2001
	
	proxyCommitFailures stores an OrderdCollection of those proxy objects which error
	when an attempt is made to commit them"
	
	^proxyCommitFailures!

proxyCommitFailures: anOrderedCollection

	"23/4/2001
	
	proxyCommitFailures stores an OrderdCollection of those proxy objects which error
	when an attempt is made to commit them"
	
	proxyCommitFailures := anOrderedCollection!

refreshAndRollforward

	"20/10/2000"
	
	self ensureHasFailedCommit.
	
	self proxyCommitFailures do: 
		[ :proxyObj |
		(proxyObj _refreshAndRollforward) ifFalse: [self currentReferencedObjects remove: proxyObj]]!

rollbackAndRefresh

	"20/10/2000"
	
	self ensureHasFailedCommit.
	
	self proxyCommitFailures do: 
		[ :proxyObj | 
		self currentReferencedObjects remove: proxyObj.
		proxyObj _swapReferences _forgetProxiedObject].

	self rollback! !
!SSWDBSingleTransactionWithVersioning categoriesFor: #commitFailures!accessing!public! !
!SSWDBSingleTransactionWithVersioning categoriesFor: #commitTo:!actions!public! !
!SSWDBSingleTransactionWithVersioning categoriesFor: #ensureHasFailedCommit!actions!private! !
!SSWDBSingleTransactionWithVersioning categoriesFor: #hasFailedCommit!public!testing! !
!SSWDBSingleTransactionWithVersioning categoriesFor: #postRollback!actions!private! !
!SSWDBSingleTransactionWithVersioning categoriesFor: #proxyCommitFailures!accessing!public! !
!SSWDBSingleTransactionWithVersioning categoriesFor: #proxyCommitFailures:!accessing!public! !
!SSWDBSingleTransactionWithVersioning categoriesFor: #refreshAndRollforward!actions!public! !
!SSWDBSingleTransactionWithVersioning categoriesFor: #rollbackAndRefresh!actions!public! !


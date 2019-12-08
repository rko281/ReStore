"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SSWDBTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBTransaction guid: (GUID fromString: '{5a3e3dd3-3990-11d5-b1df-444553540000}')!
SSWDBTransaction comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBTransaction categoriesForClass!Unclassified! !
!SSWDBTransaction methodsFor!

beginWithin: anotherTransaction

	"Initialize the receiver transaction as a nested transaction within anotherTransaction.
	anotherTransaction may be nil - i.e. receiver is root transaction"
	
	self subclassResponsibility!

canCommit

	"Return whether the receiver is capable of committing.
	Default - true"
	
	^true!

commitTo: aDBConnection

	"Write the changes associated with the receiver transaction.
	Use aDBConnection for database-level transaction (Txn) control"
	
	self subclassResponsibility!

hasChanges

	"Return whether receiver contains any changed (modified/created/deleted) objects"
	
	^self subclassResponsibility!

hasFailedCommit

	"Return whether the receiver's last commit failed"
	
	^self subclassResponsibility!

includesProxy: anSSWDBProxy

	"Return a Boolean indicating whether the given proxy is contained in this transaction"

	^self subclassResponsibility!

isDumb

	"Return whether the receiver is a 'dumb' transaction
	 - one which absorbs traversed objects but cannot commit changes"
	
	^false!

ownerTransaction

	"Return the transaction that the receiver is nested within, or nil if none (root transaction).
	This becomes the current transaction after the receiver is commit'd/rollback'd"
	
	^self subclassResponsibility!

prepareToCommit

	self subclassResponsibility!

proxy: aProxydObject forwarded: aMessage

	"aProxydObject has forwarded the given message to its proxiedObject. 
	Act accordingly"
	
	self subclassResponsibility!

rollback

	"Forget the changes associated with the receiver transaction.
	Also refresh all changed objects.
	Return the collection of changed objects"
	
	^self subclassResponsibility! !
!SSWDBTransaction categoriesFor: #beginWithin:!actions!public! !
!SSWDBTransaction categoriesFor: #canCommit!public!testing! !
!SSWDBTransaction categoriesFor: #commitTo:!actions!public! !
!SSWDBTransaction categoriesFor: #hasChanges!public!testing! !
!SSWDBTransaction categoriesFor: #hasFailedCommit!public!testing! !
!SSWDBTransaction categoriesFor: #includesProxy:!public!testing! !
!SSWDBTransaction categoriesFor: #isDumb!public!testing! !
!SSWDBTransaction categoriesFor: #ownerTransaction!evaluating!public! !
!SSWDBTransaction categoriesFor: #prepareToCommit!actions!public! !
!SSWDBTransaction categoriesFor: #proxy:forwarded:!proxy tracking!public! !
!SSWDBTransaction categoriesFor: #rollback!actions!public! !


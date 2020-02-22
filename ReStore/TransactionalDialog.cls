"Filed out from Dolphin Smalltalk 7"!

Dialog subclass: #TransactionalDialog
	instanceVariableNames: 'reStore'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TransactionalDialog guid: (GUID fromString: '{638997a1-59d7-11d5-b1df-0010a70883e2}')!
TransactionalDialog comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!TransactionalDialog categoriesForClass!Unclassified! !
!TransactionalDialog methodsFor!

answer

	"Overrident to avoid sending subject to the model (see bufferedModelFor:)"

	^self isConfirmed
		ifTrue: [self model]
		ifFalse: [nil]!

apply

	"Apply the changes by committing the transaction,
	and start a new transaction ready for further changes"

	self attemptApply ifTrue: 
		[self model isNil ifFalse: [self model: self model].
		self beginTransaction]!

attemptApply

	"Private - Attempt to apply the changes by committing the transaction.
	Set the receiver's confirmed inst var to represent the success of the commit"

	| focus |

	"First ensure that any changes cached in the view with focus (if any) are flushed"
	focus := View focus.
	focus isNil ifFalse: [focus updateModel].

	self commitTransaction 
		ifTrue: [confirmed := true]
		ifFalse: [self handleFailedCommit].

	^confirmed!

beginTransaction

	"Begin a transaction"
	
	self reStore beginTransaction!

beginTransactionIfNecessary

	"Begin a transaction if there is not currently one in progress"
	
	self isTransactionInProgress ifFalse: [self beginTransaction]!

bufferedModelFor: aSubjectModel

	"The receiver manages its OK/Cancel behaviour via ReStore transactions.
	Hence it does not need to buffer its model - use the model itself, ensuring it is persistent (Issue#0012)"

	(aSubjectModel notNil and: [aSubjectModel _reStore isNil]) ifTrue: 
		[self beginTransactionIfNecessary.
		aSubjectModel storeIn: self reStore].

	^aSubjectModel!

cancel

	"Check change status, then rollback any transaction before closing"

	self reStore hasTransactionChanges ifTrue:
		[self confirmLossOfChanges ifFalse: [^self]].

	self rollbackTransactionIfNecessary.
	self view close.
!

commitTransaction

	"Commit the active transaction"
	
	self trigger: #aboutToCommit.
	^self reStore commitTransaction!

confirmLossOfChanges

	"Private - The user is attempting an action that will result in loss of changes (e.g. cancel).
	Confirm this loss. Subclasses may override but should always return a Boolean"

	^MessageBox confirm: 'There are unsaved changes. Are you sure?'!

createSchematicWiring

	"It is important that the receiver is not closed when a transaction is in progress.
	Install a handler to prevent this"

	super createSchematicWiring.
	self when: #closeRequested: send: #onCloseRequested: to: self
!

evaluateAsTransaction: aBlock

	"Evaluate a Block within an isolated ReStore transaction, 
	whilst preserving the transaction behaviour of the receiver"

	self rollbackTransactionIfNecessary.
	self reStore evaluateAsTransaction: aBlock.

	"Return the Dialog to normal operation"
	self beginTransaction!

handleFailedCommit

	"Private - The user tried to commit (OK/Apply) but changes were not successful.
	Default handler - warn, rollback-refresh and revert.
	Subclasses may override, but should always set confirmed to indicate
	whether commit was eventually successful or not"

	MessageBox warning: 'Changes were not successful. Please retry'.
	self reStore rollbackAndRefreshTransaction.
	confirmed := false.
	self revert!

hasChanges

	"Answer whether changes have been made in the receiver"
	
	^self reStore hasTransactionChanges!

isEditing

	"23/8/2001	Promoted from example app (issue#0011)

	Return a Boolean indicating if editing is currently taking place.
	This default implementation uses the transaction to determine if there are any changes.
	Subclasses may override to add to or amend this behaviour"

	^self reStore notNil and: [self reStore hasTransactionChanges]!

isModelValid

	"Answer whether the model is in a valid state to store in the ReStore.
	Default - true. Subclasses should override as necessary"
	
	^true!

isTransactionInProgress

	"Answer whether there is an active transaction"
	
	^self reStore isTransactionInProgress!

ok

	"Close the receiver and commit the current transaction.
	Use basicApply to avoid starting a new transaction"

	self attemptApply ifTrue: [self view close]
!

onCloseRequested: aValueHolder
	
	"Handle as a cancel attempt"

	self reStore hasTransactionChanges ifTrue:
		[self confirmLossOfChanges ifFalse: [aValueHolder value: false. ^self]].

	self rollbackTransactionIfNecessary!

onViewOpened
	
	"Ensure there is a transaction in progress on opening"

	super onViewOpened.

	self beginTransactionIfNecessary!

parentReStore

	"For a Dialog, the parentReStore comes from the owner"

	^self ownerView isNil
		ifTrue: [nil]
		ifFalse: [self ownerView presenter reStore]!

queryCommand: query

	"Enters details about a potential command for the receiver into the 
	<CommandQuery>,  query."

	| cmd |

	cmd := query commandSymbol.

	"Handle Apply - must be editing and in a valid state"
	cmd == #apply ifTrue: 
		[(self isEditing and: [self isModelValid])
			ifTrue: [query beEnabled]
			ifFalse: [query beDisabled].
		^true].

	"Handle OK - if editing must be in a valid state"
	cmd == #ok ifTrue: 
		[(self isEditing not or: [self isModelValid])
			ifTrue: [query beEnabled]
			ifFalse: [query beDisabled].
		^true].

	"Handle Revert - must be editing"
	cmd == #revert ifTrue: 
		[self isEditing
			ifTrue: [query beEnabled]
			ifFalse: [query beDisabled].
		^true].

	^super queryCommand: query!

reStore

	"reStore stores the SSWReStore in which objects 
	created or modified by the receiver exist"

	"If reStore has not been set explicitly, attempt to deduce it"
	reStore == nil ifTrue: [self deduceReStore].

	^reStore

	!

reStore: anSSWReStore

	"reStore stores the SSWReStore in which
	objects created or modified by the receiver exist"

	reStore := anSSWReStore!

revert

	"Revert changes in the receiver by rolling back the transaction
	and refreshing the model"

	"If the receiver was working on a new object,
	then this will no longer be valid after rollback"
	self rollbackTransactionIfNecessary.
	self model isDBProxy ifFalse: [self model: nil].

	"Refresh the model, then begin a new transaction to handle subsequent changes"
	self model isNil ifFalse: [self model: self model].
	self beginTransaction

!

rollbackTransaction

	"Rollback the active transaction"
	
	self trigger: #aboutToRollback.
	self reStore rollbackTransaction!

rollbackTransactionIfNecessary

	"Rollback a transaction if there is one in progress"
	
	self isTransactionInProgress ifTrue: [self rollbackTransaction]! !
!TransactionalDialog categoriesFor: #answer!accessing!public! !
!TransactionalDialog categoriesFor: #apply!commands!public! !
!TransactionalDialog categoriesFor: #attemptApply!helpers!private! !
!TransactionalDialog categoriesFor: #beginTransaction!public!transactions! !
!TransactionalDialog categoriesFor: #beginTransactionIfNecessary!public!transactions! !
!TransactionalDialog categoriesFor: #bufferedModelFor:!accessing!private! !
!TransactionalDialog categoriesFor: #cancel!commands!public! !
!TransactionalDialog categoriesFor: #commitTransaction!public!transactions! !
!TransactionalDialog categoriesFor: #confirmLossOfChanges!helpers!private! !
!TransactionalDialog categoriesFor: #createSchematicWiring!initializing!public! !
!TransactionalDialog categoriesFor: #evaluateAsTransaction:!private!transactions! !
!TransactionalDialog categoriesFor: #handleFailedCommit!helpers!private! !
!TransactionalDialog categoriesFor: #hasChanges!public!testing!transactions! !
!TransactionalDialog categoriesFor: #isEditing!public!testing!transactions! !
!TransactionalDialog categoriesFor: #isModelValid!public!testing!transactions! !
!TransactionalDialog categoriesFor: #isTransactionInProgress!public!testing!transactions! !
!TransactionalDialog categoriesFor: #ok!commands!public! !
!TransactionalDialog categoriesFor: #onCloseRequested:!event handling!public! !
!TransactionalDialog categoriesFor: #onViewOpened!event handling!public! !
!TransactionalDialog categoriesFor: #parentReStore!accessing!private! !
!TransactionalDialog categoriesFor: #queryCommand:!commands!public! !
!TransactionalDialog categoriesFor: #reStore!accessing!private! !
!TransactionalDialog categoriesFor: #reStore:!accessing!private! !
!TransactionalDialog categoriesFor: #revert!commands!public! !
!TransactionalDialog categoriesFor: #rollbackTransaction!public!transactions! !
!TransactionalDialog categoriesFor: #rollbackTransactionIfNecessary!public!transactions! !


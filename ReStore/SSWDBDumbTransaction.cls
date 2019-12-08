"Filed out from Dolphin Smalltalk 7"!

SSWDBAbstractSingleTransaction subclass: #SSWDBDumbTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBDumbTransaction guid: (GUID fromString: '{03578021-659b-11d5-b1df-0010a70883e2}')!
SSWDBDumbTransaction comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBDumbTransaction categoriesForClass!Unclassified! !
!SSWDBDumbTransaction methodsFor!

canCommit

	"The purpose of the receiver is to absorb objects traversed when not in a 'real' transaction.
	As such, it cannot commit any changes"
	
	^false!

commitTo: aReStore

	"Cannot actually commit (just here to satisfy subclassResponsibility protocol)"
!

hasChanges

	"Cannot commit, therefore does not track changes (just here to satisfy subclassResponsibility protocol)"

	^false!

hasFailedCommit

	"Cannot commit, therefore cannot fail (just here to satisfy subclassResponsibility protocol)"

	^false!

isDumb

	"The purpose of the receiver is to absorb objects traversed when not in a 'real' transaction.
	As such, it is a dumb transaction"
	
	^true!

rollback

	"To rollback the receiver just abandon it.
	Note that since the receiver is 'dumb', we return an empty collection of changed objects"
	
	self abandon.

	^#()! !
!SSWDBDumbTransaction categoriesFor: #canCommit!public!testing! !
!SSWDBDumbTransaction categoriesFor: #commitTo:!actions!public! !
!SSWDBDumbTransaction categoriesFor: #hasChanges!public!testing! !
!SSWDBDumbTransaction categoriesFor: #hasFailedCommit!public!testing! !
!SSWDBDumbTransaction categoriesFor: #isDumb!public!testing! !
!SSWDBDumbTransaction categoriesFor: #rollback!actions!public! !


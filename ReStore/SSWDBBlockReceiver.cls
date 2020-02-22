"Filed out from Dolphin Smalltalk 7"!

SSWDBBlockArgument subclass: #SSWDBBlockReceiver
	instanceVariableNames: 'currentTable path'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBBlockReceiver guid: (GUID fromString: '{0cfeee99-7787-4b16-954c-b0c6f4cb0b64}')!
SSWDBBlockReceiver comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBBlockReceiver categoriesForClass!Unclassified! !
!SSWDBBlockReceiver methodsFor!

_id

	"Query on the ID field of the receiver's currentTable. 
	Explicitly set the receiver's finalField to be the join field leading to the table; this will pop the joined table if it is not otherwise required"

	self finalField: self finalField!

currentTable

	^currentTable!

currentTable: anSSWDBTable

	currentTable := anSSWDBTable!

finalField

	"If the receiver is parsing a comparison on a joining field (rather than a plain text/number etc.) then finalField will not have been set"
		
	| finalField |

	self hasFinalField ifTrue: [^super finalField].
	
	"Must be comparison on a joining field - use it as the finalField"
	finalField := self parser lastFieldEncounterFor: self.

	"If this is the first encounter with this field then it is not required for a join - remove it.
	Since it is the first encounter then it must by definition be responsible for the last (most recent) join"
	(self parser fieldEncountersWith: finalField) = 1 ifTrue: 
		[self parser referencedTables removeLast.
		self parser removeFieldEncountersWith: finalField].

	^SSWDBQueryTableField forField: finalField in: finalField table!

forModify

	^self!

newReceiverFor: aField

	^super newReceiverFor: (self queryFieldFor: aField)!

path
	^path!

path: anObject
	path := anObject! !
!SSWDBBlockReceiver categoriesFor: #_id!accessing!public! !
!SSWDBBlockReceiver categoriesFor: #currentTable!accessing!public! !
!SSWDBBlockReceiver categoriesFor: #currentTable:!accessing!public! !
!SSWDBBlockReceiver categoriesFor: #finalField!accessing!public! !
!SSWDBBlockReceiver categoriesFor: #forModify!parsing - internal!public! !
!SSWDBBlockReceiver categoriesFor: #newReceiverFor:!helpers!public! !
!SSWDBBlockReceiver categoriesFor: #path!accessing!private! !
!SSWDBBlockReceiver categoriesFor: #path:!accessing!private! !


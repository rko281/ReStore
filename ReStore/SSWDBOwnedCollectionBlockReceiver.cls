"Filed out from Dolphin Smalltalk 7"!

SSWDBCollectionBlockReceiver subclass: #SSWDBOwnedCollectionBlockReceiver
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBOwnedCollectionBlockReceiver guid: (GUID fromString: '{01bed422-c50b-4117-ac6d-19cbad360213}')!
SSWDBOwnedCollectionBlockReceiver comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBOwnedCollectionBlockReceiver categoriesForClass!Unclassified! !
!SSWDBOwnedCollectionBlockReceiver methodsFor!

targetField

	self collectionSpec ownerField isNil ifTrue: [self collectionSpec setOwnerFieldFrom: self reStore].

	^self collectionSpec ownerField!

targetFieldCollectQuery

	^self collectionParser collectQueryFrom: [ :each | (each perform: self targetField accessor name) _id]!

targetTableFromParser

	"Ensure the target collection table is included in the parser.
	Return the table, aliased if necessary"

	^(self parser referencedTables tableJoinedWithField: self targetField) ifNil:
		[| sourceTable targetTable occurrences |
		sourceTable := self collectionSpec table.
		targetTable := self collectionSpec targetTable.
		occurrences := self parser referencedTables occurrencesOf: targetTable.
		occurrences > 0 ifTrue: [targetTable := SSWDBQueryTable forRepetition: occurrences of: targetTable].
		self parser referencedTables add: targetTable joinedWith: (SSWSQLCondition field: sourceTable idField equalTo: self targetField)]! !
!SSWDBOwnedCollectionBlockReceiver categoriesFor: #targetField!accessing!public! !
!SSWDBOwnedCollectionBlockReceiver categoriesFor: #targetFieldCollectQuery!accessing!public! !
!SSWDBOwnedCollectionBlockReceiver categoriesFor: #targetTableFromParser!accessing!public! !


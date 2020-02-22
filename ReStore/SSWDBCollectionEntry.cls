"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SSWDBCollectionEntry
	instanceVariableNames: 'table entryID sourceID target'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBCollectionEntry guid: (GUID fromString: '{5a3e3dc9-3990-11d5-b1df-444553540000}')!
SSWDBCollectionEntry comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBCollectionEntry categoriesForClass!Unclassified! !
!SSWDBCollectionEntry methodsFor!

_dbTable

	"Make the receiver polymorphic with a persistent proxy"
	
	^self table!

_id

	"Make the receiver polymorphic with a persistent proxy"
	
	^self entryID!

_id: anInteger

	"Make the receiver polymorphic with a persistent proxy"
	
	self entryID: anInteger!

_proxiedObject

	"Make the receiver polymorphic with a persistent proxy"
	
	^self!

addTargetTo: aCollection

	aCollection directAdd: self target!

addTo: aCollectionOfEntries

	aCollectionOfEntries add: self!

entryID

	"entryID stores the unique ID of this particular entry object"
	
	^entryID!

entryID: anInteger

	"entryID stores the unique ID of this particular entry object"
	
	entryID := anInteger!

isPersistent

	^self entryID ~= nil!

prepareToCommitFor: anSSWDBCachingCollectionProxy

	^self!

removeFrom: aCollectionOfEntries

	aCollectionOfEntries removeAtIndex: (aCollectionOfEntries identityIndexOf: self)!

sourceID

	"sourceID stores the unique ID of the object which owns the collection 
	of which the receiver represents a member"
	
	^sourceID!

sourceID: anInteger

	"sourceID stores the unique ID of the object which owns the collection 
	of which the receiver represents a member"
	
	sourceID := anInteger!

table

	"table stores the SSWDBTable of collection entries which the receiver belongs to"
	
	^table!

table: anSSWDBTable

	"table stores the SSWDBTable of collection entries which the receiver belongs to"
	
	table := anSSWDBTable!

target

	^target!

target: anObjectOrNil

	"Set the target object of the receiver"
	
	target := anObjectOrNil! !
!SSWDBCollectionEntry categoriesFor: #_dbTable!evaluating!public! !
!SSWDBCollectionEntry categoriesFor: #_id!evaluating!public! !
!SSWDBCollectionEntry categoriesFor: #_id:!evaluating!public! !
!SSWDBCollectionEntry categoriesFor: #_proxiedObject!evaluating!public! !
!SSWDBCollectionEntry categoriesFor: #addTargetTo:!actions!public! !
!SSWDBCollectionEntry categoriesFor: #addTo:!actions!public! !
!SSWDBCollectionEntry categoriesFor: #entryID!accessing!public! !
!SSWDBCollectionEntry categoriesFor: #entryID:!accessing!public! !
!SSWDBCollectionEntry categoriesFor: #isPersistent!public!testing! !
!SSWDBCollectionEntry categoriesFor: #prepareToCommitFor:!actions!public! !
!SSWDBCollectionEntry categoriesFor: #removeFrom:!actions!public! !
!SSWDBCollectionEntry categoriesFor: #sourceID!accessing!public! !
!SSWDBCollectionEntry categoriesFor: #sourceID:!accessing!public! !
!SSWDBCollectionEntry categoriesFor: #table!accessing!public! !
!SSWDBCollectionEntry categoriesFor: #table:!accessing!public! !
!SSWDBCollectionEntry categoriesFor: #target!accessing!public! !
!SSWDBCollectionEntry categoriesFor: #target:!accessing!public! !

!SSWDBCollectionEntry class methodsFor!

dbTableNamed: aString in: anSSWReStore

	^(SSWDBTable forClass: self)
		name: aString;
		fullName: aString;
		reStore: anSSWReStore;
		defineAsID: #entryID fieldName: (anSSWReStore sqlDialect transformInstVarName: #id);
		define: #sourceID as: Integer;
		define: #target asFieldNamed: (anSSWReStore sqlDialect transformInstVarName: #targetID) holding: Integer;
		yourself! !
!SSWDBCollectionEntry class categoriesFor: #dbTableNamed:in:!persistence!public! !


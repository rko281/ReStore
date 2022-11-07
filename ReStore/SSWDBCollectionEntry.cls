"Filed out from Dolphin Smalltalk"!

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

	aCollection _dbAdd: self target!

addTo: aCollectionOfEntries

	aCollectionOfEntries add: self!

copyTargetTo: aCollection

	aCollection _dbAdd: self target copy!

entryID

	"entryID stores the unique ID of this particular entry object"
	
	^entryID!

entryID: anInteger

	"entryID stores the unique ID of this particular entry object"
	
	entryID := anInteger!

hasMutableTarget

	^self target class isMutableDirectlyPersistedNonBaseClass!

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
!SSWDBCollectionEntry categoriesForMethods!
_dbTable!evaluating!public! !
_id!evaluating!public! !
_id:!evaluating!public! !
_proxiedObject!evaluating!public! !
addTargetTo:!actions!public! !
addTo:!actions!public! !
copyTargetTo:!actions!public! !
entryID!accessing!public! !
entryID:!accessing!public! !
hasMutableTarget!public!testing! !
isPersistent!public!testing! !
prepareToCommitFor:!actions!public! !
removeFrom:!actions!public! !
sourceID!accessing!public! !
sourceID:!accessing!public! !
table!accessing!public! !
table:!accessing!public! !
target!accessing!public! !
target:!accessing!public! !
!

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
!SSWDBCollectionEntry class categoriesForMethods!
dbTableNamed:in:!persistence!public! !
!


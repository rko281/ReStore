"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SSWDBTableRecord
	instanceVariableNames: 'tableName fullTableName nextID'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBTableRecord guid: (GUID fromString: '{c9939531-b39a-4ac3-b6d3-55cea290fd54}')!
SSWDBTableRecord comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBTableRecord categoriesForClass!Unclassified! !
!SSWDBTableRecord methodsFor!

_proxiedObject

	"The receiver is always non-persistent. 
	Answer the receiver for compatability with a persistent proxy"

	^self!

fullTableName

	"fullTableName stores the full-length name of the table related to the receiver.
	This will usually be the same as the tableName. However, where the size of 
	the fullTableName is greater than the max length supported by the database,
	then tableName will contain an auto-abbreviated version"
	
	"Backwards-compatability: nil fullTableName means tableName == fullTableName"
	^fullTableName ifNil: [tableName]!

fullTableName: aString

	"fullTableName stores the full-length name of the table related to the receiver.
	This will usually be the same as the tableName. However, where the size of 
	the fullTableName is greater than the max length supported by the database,
	then tableName will contain an auto-abbreviated version"
	
	fullTableName := aString!

incrementNextIDBy: anInteger

	self nextID: (self nextID + anInteger)!

nextID

	"nextID stores the next available ID value for the receiver's table, as stored in the database"
	
	^nextID!

nextID: anInteger

	"nextID stores the next available ID value for the receiver's table, as stored in the database"
	
	nextID := anInteger!

tableName

	"tableName stores the name (String) of the SSWDBTable 
	for which the receiver maintains the next available IDs"
	
	^tableName!

tableName: aString

	"tableName stores the name (String) of the SSWDBTable 
	for which the receiver maintains the next available IDs"
	
	tableName := aString! !
!SSWDBTableRecord categoriesFor: #_proxiedObject!accessing!public! !
!SSWDBTableRecord categoriesFor: #fullTableName!accessing!public! !
!SSWDBTableRecord categoriesFor: #fullTableName:!accessing!public! !
!SSWDBTableRecord categoriesFor: #incrementNextIDBy:!public!updating! !
!SSWDBTableRecord categoriesFor: #nextID!accessing!public! !
!SSWDBTableRecord categoriesFor: #nextID:!accessing!public! !
!SSWDBTableRecord categoriesFor: #tableName!accessing!public! !
!SSWDBTableRecord categoriesFor: #tableName:!accessing!public! !

!SSWDBTableRecord class methodsFor!

preferredObjectProxyClass 

	^SSWDBCachingObjectProxy!

tableIn: anSSWReStore

	| table |
	
	table := SSWDBTable forClass: self in: anSSWReStore.

	table
		name: (anSSWReStore sqlDialect transformClassName: #NextID);	"Name for historical reasons"
		define: #tableName as: (String maxSize: anSSWReStore sqlDialect maxTableNameLength);
		define: #nextID as: Integer.

	anSSWReStore supportsFullTableRecords ifTrue:
		[table define: #fullTableName as: (String maxSize: 255)].

	^table
		! !
!SSWDBTableRecord class categoriesFor: #preferredObjectProxyClass!persistence!public! !
!SSWDBTableRecord class categoriesFor: #tableIn:!persistence!public! !


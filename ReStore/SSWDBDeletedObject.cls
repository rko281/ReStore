"Filed out from Dolphin Smallalk"!

DeafObject subclass: #SSWDBDeletedObject
	instanceVariableNames: 'deletedObjectClass id'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBDeletedObject guid: (GUID fromString: '{36513de1-63fc-11d5-b1df-0010a70883e2}')!
SSWDBDeletedObject comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBDeletedObject categoriesForClass!Unclassified! !
!SSWDBDeletedObject methodsFor!

_id

	^self id!

_instVarAt: anInteger

	"Encountered when 'recovering' a deleted object; ignore"

	^nil!

_instVarAt: anInteger put: anObject

	"Encountered when 'recovering' a deleted object; ignore"!

= anObject 

	^self class == anObject class and: [self deletedObjectClass = anObject deletedObjectClass and: [self id = anObject id]]!

copy

	"Do not copy the receiver"

	^self!

deletedObjectClass

	"deletedObjectClass stores the Class of object for which the receiver 
	represents a deleted instance"

	^deletedObjectClass!

deletedObjectClass: aClass

	"deletedObjectClass stores the Class of object for which the receiver 
	represents a deleted instance"

	deletedObjectClass := aClass!

displayOn: aStream

	self id displayOn: aStream!

hash

	^deletedObjectClass hash bitXor: id hash!

id

	"id stores the unique ID of the instance of deletedObjectClass
	that the receiver represents"

	^id!

id: anInteger

	"id stores the unique ID of the instance of deletedObjectClass
	that the receiver represents"

	id := anInteger!

isDBDeleted

	^true!

printOn: aStream

	aStream 
		nextPutAll: 'A deleted ';
		nextPutAll: self deletedObjectClass name;
		nextPutAll: '; ID: ';
		nextPutAll: self id printString!

unstore

	"Do nothing - the receiver is already deleted"

	^self! !
!SSWDBDeletedObject categoriesForMethods!
_id!accessing!public! !
_instVarAt:!accessing!public! !
_instVarAt:put:!accessing!public! !
=!comparing!public! !
copy!copying!public! !
deletedObjectClass!accessing!public! !
deletedObjectClass:!accessing!public! !
displayOn:!printing!public! !
hash!comparing!public! !
id!accessing!public! !
id:!accessing!public! !
isDBDeleted!public!testing! !
printOn:!printing!public! !
unstore!public!testing! !
!

!SSWDBDeletedObject class methodsFor!

newForClass: aClass id: anInteger

	^self basicNew
		deletedObjectClass: aClass;
		id: anInteger;
		yourself! !
!SSWDBDeletedObject class categoriesForMethods!
newForClass:id:!instance creation!public! !
!


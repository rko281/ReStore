"Filed out from Dolphin Smalltalk 7"!

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

shallowCopy

	"Do not copy the receiver"

	^self
!

unstore

	"Do nothing - the receiver is already deleted"

	^self! !
!SSWDBDeletedObject categoriesFor: #deletedObjectClass!accessing!public! !
!SSWDBDeletedObject categoriesFor: #deletedObjectClass:!accessing!public! !
!SSWDBDeletedObject categoriesFor: #displayOn:!printing!public! !
!SSWDBDeletedObject categoriesFor: #id!accessing!public! !
!SSWDBDeletedObject categoriesFor: #id:!accessing!public! !
!SSWDBDeletedObject categoriesFor: #isDBDeleted!public!testing! !
!SSWDBDeletedObject categoriesFor: #printOn:!printing!public! !
!SSWDBDeletedObject categoriesFor: #shallowCopy!copying!public! !
!SSWDBDeletedObject categoriesFor: #unstore!public!testing! !

!SSWDBDeletedObject class methodsFor!

newForClass: aClass id: anInteger

	^self basicNew
		deletedObjectClass: aClass;
		id: anInteger;
		yourself! !
!SSWDBDeletedObject class categoriesFor: #newForClass:id:!instance creation!public! !


"Filed out from Dolphin Smallalk"!

Object subclass: #ReStoreTestWithID
	instanceVariableNames: 'name nmbr other'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ReStoreTestWithID guid: (GUID fromString: '{fdda7f24-2bea-4ddb-8471-85776a25e815}')!
ReStoreTestWithID comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!ReStoreTestWithID categoriesForClass!Unclassified! !
!ReStoreTestWithID methodsFor!

name
	^name!

name: anObject
	name := anObject!

nmbr
	^nmbr!

nmbr: anObject
	nmbr := anObject!

other
	^other!

other: anObject
	other := anObject! !
!ReStoreTestWithID categoriesForMethods!
name!accessing!private! !
name:!accessing!private! !
nmbr!accessing!private! !
nmbr:!accessing!private! !
other!accessing!private! !
other:!accessing!private! !
!

!ReStoreTestWithID class methodsFor!

name: aString nmbr: anInteger

	^self new
		name: aString;
		nmbr: anInteger;
		yourself!

reStoreDefinition

	^super reStoreDefinition
		defineAsID: #nmbr;
		define: #name as: (String maxSize: 64);
		define: #other as: ReStoreTestWithID;
		yourself!

shouldSubclassesInheritPersistency

	^false! !
!ReStoreTestWithID class categoriesForMethods!
name:nmbr:!instance creation!public! !
reStoreDefinition!persistency!public! !
shouldSubclassesInheritPersistency!persistency!public! !
!


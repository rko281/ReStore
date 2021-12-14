"Filed out from Dolphin Smallalk"!

ReStoreTestWithIDOnly subclass: #ReStoreTestWithIDSubclass
	instanceVariableNames: 'name other'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ReStoreTestWithIDSubclass guid: (GUID fromString: '{8279e380-974d-44a8-868e-bf1316b601f1}')!
ReStoreTestWithIDSubclass comment: ''!
!ReStoreTestWithIDSubclass categoriesForClass!Unclassified! !
!ReStoreTestWithIDSubclass methodsFor!

name
	^name!

name: anObject
	name := anObject!

other
	^other!

other: anObject
	other := anObject! !
!ReStoreTestWithIDSubclass categoriesForMethods!
name!accessing!private! !
name:!accessing!private! !
other!accessing!private! !
other:!accessing!private! !
!

!ReStoreTestWithIDSubclass class methodsFor!

name: aString nmbr: anInteger

	^self new
		name: aString;
		nmbr: anInteger;
		yourself!

reStoreDefinition

	^super reStoreDefinition
		define: #name as: (String maxSize: 64);
		define: #other as: ReStoreTestWithIDOnly;
		yourself! !
!ReStoreTestWithIDSubclass class categoriesForMethods!
name:nmbr:!instance creation!public! !
reStoreDefinition!persistency!public! !
!


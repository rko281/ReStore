"Filed out from Dolphin Smallalk"!

ReStoreTestWithID subclass: #ReStoreTestWithStringID
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'counter'!
ReStoreTestWithStringID guid: (GUID fromString: '{995dd9d9-0561-454f-8a93-ece575c53949}')!
ReStoreTestWithStringID comment: ''!
!ReStoreTestWithStringID categoriesForClass!Unclassified! !
!ReStoreTestWithStringID methodsFor!

reStoreNewUniqueID

	self class counter: self class counter + 1.
	^'new ', self class counter printString! !
!ReStoreTestWithStringID categoriesForMethods!
reStoreNewUniqueID!public! !
!

!ReStoreTestWithStringID class methodsFor!

counter
	^counter!

counter: anObject
	counter := anObject!

reStoreDefinition

	^(SSWDBClassDefinition forClass: self)
		defineAsID: #name;
		define: #nmbr as: Integer;
		define: #other as: ReStoreTestWithStringID;
		yourself!

reStoreIDClass

	^String maxSize: 32! !
!ReStoreTestWithStringID class categoriesForMethods!
counter!accessing!private! !
counter:!accessing!private! !
reStoreDefinition!public! !
reStoreIDClass!public! !
!


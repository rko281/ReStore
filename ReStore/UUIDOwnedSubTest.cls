"Filed out from Dolphin Smallalk"!

UUIDOwnedTest subclass: #UUIDOwnedSubTest
	instanceVariableNames: 'number'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
UUIDOwnedSubTest guid: (GUID fromString: '{84caed00-351b-4a94-8007-baa4266fba03}')!
UUIDOwnedSubTest comment: ''!
!UUIDOwnedSubTest categoriesForClass!Unclassified! !
!UUIDOwnedSubTest methodsFor!

number
	^number!

number: anObject
	number := anObject! !
!UUIDOwnedSubTest categoriesForMethods!
number!accessing!private! !
number:!accessing!private! !
!

!UUIDOwnedSubTest class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #number as: Integer;
		yourself!

shouldInheritPersistency

	^true! !
!UUIDOwnedSubTest class categoriesForMethods!
reStoreDefinition!public! !
shouldInheritPersistency!public! !
!


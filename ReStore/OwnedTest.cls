"Filed out from Dolphin Smalltalk 7"!

Test subclass: #OwnedTest
	instanceVariableNames: 'owner'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
OwnedTest guid: (GUID fromString: '{75e7c263-4b99-11d5-b1df-0010a70883e2}')!
OwnedTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!OwnedTest categoriesForClass!Unclassified! !
!OwnedTest methodsFor!

owner
	"Private - Answer the value of the receiver's ''owner'' instance variable."

	^owner!

owner: anObject
	"Private - Set the value of the receiver's ''owner'' instance variable to the argument, anObject."

	owner := anObject!

testOnRollback

	self owner name! !
!OwnedTest categoriesFor: #owner!accessing!private! !
!OwnedTest categoriesFor: #owner:!accessing!private! !
!OwnedTest categoriesFor: #testOnRollback!public! !

!OwnedTest class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #owner as: OwnerTest;
		yourself! !
!OwnedTest class categoriesFor: #reStoreDefinition!public! !


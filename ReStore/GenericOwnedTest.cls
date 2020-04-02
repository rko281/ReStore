"Filed out from Dolphin Smalltalk 7"!

Test subclass: #GenericOwnedTest
	instanceVariableNames: 'owner key deepTest'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GenericOwnedTest guid: (GUID fromString: '{be9dc27e-867c-4ce1-8f42-0c2e8a4e94e0}')!
GenericOwnedTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!GenericOwnedTest categoriesForClass!Unclassified! !
!GenericOwnedTest methodsFor!

deepTest
	^deepTest!

deepTest: anObject
	deepTest := anObject!

key
	^key!

key: anObject
	key := anObject!

owner
	"Private - Answer the value of the receiver's ''owner'' instance variable."

	^owner!

owner: anObject
	"Private - Set the value of the receiver's ''owner'' instance variable to the argument, anObject."

	owner := anObject! !
!GenericOwnedTest categoriesFor: #deepTest!accessing!private! !
!GenericOwnedTest categoriesFor: #deepTest:!accessing!private! !
!GenericOwnedTest categoriesFor: #key!accessing!private! !
!GenericOwnedTest categoriesFor: #key:!accessing!private! !
!GenericOwnedTest categoriesFor: #owner!accessing!private! !
!GenericOwnedTest categoriesFor: #owner:!accessing!private! !

!GenericOwnedTest class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #owner as: GenericTest;
		define: #key as: (String maxSize: 128);
		define: #deepTest as: Test dependent;
		yourself! !
!GenericOwnedTest class categoriesFor: #reStoreDefinition!public! !


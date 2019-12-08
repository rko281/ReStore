"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SSWDBClassWithInfo
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBClassWithInfo guid: (GUID fromString: '{f9276a81-4893-11d5-b1df-0010a70883e2}')!
SSWDBClassWithInfo comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBClassWithInfo categoriesForClass!Unclassified! !
!SSWDBClassWithInfo methodsFor!

beKeyClassOf: aCollectionSpec

	"Polymorphic with Class implementation"

	aCollectionSpec keyClass: self!

beTargetClassOf: aCollectionSpec

	"Polymorphic with Class implementation"

	aCollectionSpec targetClass: self!

includesBehavior: aBehavior

	"Required class-like behavior"

	^self infoClass includesBehavior: aBehavior!

infoClass

	"Return the class which the receiver represents a paramterised version of.
	Subclasses should override"

	^self subclassResponsibility!

isPersistentBaseClass

	^self infoClass isPersistentBaseClass
!

new

	"Create and return an instance of the receiver's infoClass"

	^self infoClass new! !
!SSWDBClassWithInfo categoriesFor: #beKeyClassOf:!defining!public! !
!SSWDBClassWithInfo categoriesFor: #beTargetClassOf:!defining!public! !
!SSWDBClassWithInfo categoriesFor: #includesBehavior:!public!testing! !
!SSWDBClassWithInfo categoriesFor: #infoClass!constants!public! !
!SSWDBClassWithInfo categoriesFor: #isPersistentBaseClass!public!testing! !
!SSWDBClassWithInfo categoriesFor: #new!instance creation!public! !


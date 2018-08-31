"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SSWDBClassWithInfo
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBClassWithInfo guid: (GUID fromString: '{f9276a81-4893-11d5-b1df-0010a70883e2}')!
SSWDBClassWithInfo comment: 'Copyright 2000/2001 Solutions Software Limited'!
!SSWDBClassWithInfo categoriesForClass!Unclassified! !
!SSWDBClassWithInfo methodsFor!

beKeyClassOf: aCollectionSpec

	"30/9/2001

	Polymorphic with Class implementation"

	aCollectionSpec keyClass: self!

beTargetClassOf: aCollectionSpec

	"30/9/2001

	Polymorphic with Class implementation"

	aCollectionSpec targetClass: self!

includesBehavior: aBehavior

	"30/9/2001

	Required class-like behavior"

	^self infoClass includesBehavior: aBehavior!

infoClass

	"15/4/2001

	Return the class which the receiver represents a paramterised version of.
	Subclasses should override"

	^self subclassResponsibility!

isPersistentBaseClass

	"30/9/2001"

	^self infoClass isPersistentBaseClass
!

new

	"15/4/2001

	Create and return an instance of the receiver's infoClass"

	^self infoClass new! !
!SSWDBClassWithInfo categoriesFor: #beKeyClassOf:!defining!public! !
!SSWDBClassWithInfo categoriesFor: #beTargetClassOf:!defining!public! !
!SSWDBClassWithInfo categoriesFor: #includesBehavior:!public!testing! !
!SSWDBClassWithInfo categoriesFor: #infoClass!constants!public! !
!SSWDBClassWithInfo categoriesFor: #isPersistentBaseClass!public!testing! !
!SSWDBClassWithInfo categoriesFor: #new!instance creation!public! !


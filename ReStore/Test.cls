"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Test
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Test guid: (GUID fromString: '{75e7c262-4b99-11d5-b1df-0010a70883e2}')!
Test comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!Test categoriesForClass!Unclassified! !
!Test methodsFor!

<= a

	^self name <= a name!

= a

	^self name = a name!

handleUpdateClash: aSymbol from: old to: new

	aSymbol = #name ifFalse: [^false].
	(new name beginsWith: 'BLOCK') ifTrue: [^false].

	self name: (self name, ' (overriden ', new name, ')').
	^true!

hash

	^self name hash!

name
	"Private - Answer the value of the receiver's ''name'' instance variable."

	^name!

name: anObject
	"Private - Set the value of the receiver's ''name'' instance variable to the argument, anObject."

	name := anObject!

printOn: aStream

	aStream nextPutAll: self name! !
!Test categoriesFor: #<=!comparing!public! !
!Test categoriesFor: #=!comparing!public! !
!Test categoriesFor: #handleUpdateClash:from:to:!public! !
!Test categoriesFor: #hash!comparing!public! !
!Test categoriesFor: #name!accessing!private! !
!Test categoriesFor: #name:!accessing!private! !
!Test categoriesFor: #printOn:!public! !

!Test class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #name as: (String maxSize: 128);
		yourself! !
!Test class categoriesFor: #reStoreDefinition!public! !


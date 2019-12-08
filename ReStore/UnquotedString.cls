"Filed out from Dolphin Smalltalk 7"!

Object subclass: #UnquotedString
	instanceVariableNames: 'string'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
UnquotedString guid: (GUID fromString: '{c7faaeaf-1838-4a2e-913a-91087b600e7b}')!
UnquotedString comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStoreForDolphin
https://github.com/rko281/ReStoreForPharo'!
!UnquotedString categoriesForClass!Unclassified! !
!UnquotedString methodsFor!

= aString

	^aString class = UnquotedString
		ifTrue: [self string = aString string]
		ifFalse: [self string = aString]!

hash

	^self string hash!

isEmpty

	^self size = 0!

orNilIfEmpty

	^self isEmpty
		ifTrue: [nil]
		ifFalse: [self]!

printOn: aStream

	"The sole purpose of the receiver is to print the string without quote marks"

	aStream nextPutAll: self string!

size

	^self string size!

string
	^string!

string: anObject
	string := anObject! !
!UnquotedString categoriesFor: #=!comparing!public! !
!UnquotedString categoriesFor: #hash!accessing!public! !
!UnquotedString categoriesFor: #isEmpty!public!testing! !
!UnquotedString categoriesFor: #orNilIfEmpty!accessing!public! !
!UnquotedString categoriesFor: #printOn:!printing!public! !
!UnquotedString categoriesFor: #size!accessing!public! !
!UnquotedString categoriesFor: #string!accessing!private! !
!UnquotedString categoriesFor: #string:!accessing!private! !

!UnquotedString class methodsFor!

isPersistentBaseClass

	^true! !
!UnquotedString class categoriesFor: #isPersistentBaseClass!public!testing! !


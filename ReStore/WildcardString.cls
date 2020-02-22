"Filed out from Dolphin Smalltalk 7"!

Object subclass: #WildcardString
	instanceVariableNames: 'string'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WildcardString guid: (GUID fromString: '{adacc540-6259-41f2-b7cc-a16801560117}')!
WildcardString comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!WildcardString categoriesForClass!Unclassified! !
!WildcardString methodsFor!

collect: aBlock

	^self string collect: aBlock!

hash

	^self string hash!

isEmpty

	^self size = 0!

orNilIfEmpty

	^self isEmpty
		ifTrue: [nil]
		ifFalse: [self]!

reStoreValue

	^self string!

similarityComparator

	"Private - The receiver is just a String for which the similarity is defined by like:"

	^#matches:!

size

	^self string size!

string
	^string!

string: anObject
	string := anObject! !
!WildcardString categoriesFor: #collect:!enumerating!public! !
!WildcardString categoriesFor: #hash!accessing!public! !
!WildcardString categoriesFor: #isEmpty!public!testing! !
!WildcardString categoriesFor: #orNilIfEmpty!accessing!public! !
!WildcardString categoriesFor: #reStoreValue!accessing!public! !
!WildcardString categoriesFor: #similarityComparator!accessing!private! !
!WildcardString categoriesFor: #size!accessing!public! !
!WildcardString categoriesFor: #string!accessing!private! !
!WildcardString categoriesFor: #string:!accessing!private! !


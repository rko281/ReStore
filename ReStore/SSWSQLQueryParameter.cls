"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SSWSQLQueryParameter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLQueryParameter guid: (GUID fromString: '{59892182-3a33-11d5-b1df-444553540000}')!
SSWSQLQueryParameter comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLQueryParameter categoriesForClass!Unclassified! !
!SSWSQLQueryParameter class methodsFor!

new

	"The receiver should not have instances created"

	^self error: 'Do not create instances of this class'!

writeSQLOn: aStream

	"The receiver exists purely to write the parameter placeholder character(s) (usually '?')"

	aStream nextPutParameterPlaceholder! !
!SSWSQLQueryParameter class categoriesFor: #new!instance creation!public! !
!SSWSQLQueryParameter class categoriesFor: #writeSQLOn:!instance creation!public! !


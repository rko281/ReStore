"Filed out from Dolphin Smalltalk 7"!

OrderedCollection variableSubclass: #SSWSQLCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLCollection guid: (GUID fromString: '{6266c921-3983-11d5-b1df-444553540000}')!
SSWSQLCollection comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLCollection categoriesForClass!Unclassified! !
!SSWSQLCollection methodsFor!

asOrderedCollection
	"Answer an OrderedCollection containing the same elements as the receiver.
	The elements of the OrderedCollection will be sorted (at least initially) in the
	sort order of the receiver.
	Implementation Note: Revert to the Collection implementation."

	^(OrderedCollection new: self size)
		addAll: self;
		yourself!

isFieldCollection

	^false!

sqlConcatenator

	"Return the String that concatenates the list of SQL entities held by the receiver
	(this should also contain any required whitespace characters)"
	
	^self subclassResponsibility!

writeSQLOn: aStream

	self isEmpty ifTrue: [^self].

	self do: [ :condition | condition writeSQLOn: aStream] separatedBy: [aStream nextPutAll: self sqlConcatenator]! !
!SSWSQLCollection categoriesFor: #asOrderedCollection!converting!public! !
!SSWSQLCollection categoriesFor: #isFieldCollection!public!testing! !
!SSWSQLCollection categoriesFor: #sqlConcatenator!output!public! !
!SSWSQLCollection categoriesFor: #writeSQLOn:!output!public! !


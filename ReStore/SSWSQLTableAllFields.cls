"Filed out from Dolphin Smalltalk 7"!

SSWSQLTableComponent subclass: #SSWSQLTableAllFields
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLTableAllFields guid: (GUID fromString: '{643ab7c2-5af7-11d6-87e7-0010a70883e2}')!
SSWSQLTableAllFields comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLTableAllFields categoriesForClass!Unclassified! !
!SSWSQLTableAllFields methodsFor!

collect: aBlock

	^aBlock value: self!

fieldNamed: aString

	"Return the individual field with the given name"

	^self table allFieldsDetect: [ :field | field name = aString] ifNone: [nil]!

hasAggregateFunction

	^false!

isAll

	"Since the receiver is (conceptually) multiple fields, make it polymorphic with a field collection.
	Further - since the receiver is not the true 'all fields' concept (i.e all fields in a query), return false"

	^false!

isAllInTable

	^true!

isEmpty

	"Assume a table will always have at least one field"
	
	^false!

isFieldCollection

	"Effectively, yes"

	^true!

reject: aBlock

	"The receiver is indivisible"

	^self!

requiresAliasing

	"The 'all fields' concept does not require aliasing"
	^false!

writeAliasedSQLOn: aStream

	"Aliasing is handled by the receiver's table.
	Hence - defer to writeSQLOn:"
	
	self writeSQLOn: aStream!

writeSQLOn: aStream

	"Use <table name>.<field name> notation to avoid ambiguity"
	self table writeSQLNameOn: aStream.
	aStream nextPut: $..
	
	"Use an empty (i.e. 'all') field collection to handle the SQL representation of 'all'"
	##(SSWSQLFieldCollection new) writeSQLOn: aStream! !
!SSWSQLTableAllFields categoriesFor: #collect:!enumerating!public! !
!SSWSQLTableAllFields categoriesFor: #fieldNamed:!accessing!public! !
!SSWSQLTableAllFields categoriesFor: #hasAggregateFunction!public!testing! !
!SSWSQLTableAllFields categoriesFor: #isAll!public!testing! !
!SSWSQLTableAllFields categoriesFor: #isAllInTable!public!testing! !
!SSWSQLTableAllFields categoriesFor: #isEmpty!public!testing! !
!SSWSQLTableAllFields categoriesFor: #isFieldCollection!public!testing! !
!SSWSQLTableAllFields categoriesFor: #reject:!enumerating!public! !
!SSWSQLTableAllFields categoriesFor: #requiresAliasing!public!testing! !
!SSWSQLTableAllFields categoriesFor: #writeAliasedSQLOn:!output!public! !
!SSWSQLTableAllFields categoriesFor: #writeSQLOn:!output!public! !


"Filed out from Dolphin Smalltalk"!

SSWDBStaticField subclass: #SSWDBDataField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWDBDataField guid: (GUID fromString: '{caf73965-42bb-4a4b-bf79-34f5a71d3394}')!

SSWDBDataField comment: ''!

!SSWDBDataField categoriesForClass!Unclassified! !

!SSWDBDataField methodsFor!

asPolymorphicDataField

	| polymorphic |

	polymorphic := SSWDBPolymorphicDataField new.

	polymorphic
		name: self name;
		table: self table;
		accessor: self accessor;
		columnIndex: self columnIndex;
		targetClass: self targetClass.

	self isDependent ifTrue: [polymorphic beDependent].
	self isRelated ifTrue: [polymorphic beRelated].

	^polymorphic!

populateObject: anObject with: aValue

	(self convertValue: aValue) ifNotNil: [ :obj | self accessor value: obj in: anObject]! !

!SSWDBDataField categoriesForMethods!
asPolymorphicDataField!converting!public! !
populateObject:with:!actions!private! !
!


"Filed out from Dolphin Smallalk"!

Test subclass: #TestWithBitmask
	instanceVariableNames: 'number1 number2 bitmask orderedCollection sortedCollection array set dictionary'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TestWithBitmask guid: (GUID fromString: '{6f2713c7-1c0c-46c4-bd8d-246f68ca91fd}')!
TestWithBitmask comment: ''!
!TestWithBitmask categoriesForClass!Unclassified! !
!TestWithBitmask methodsFor!

array
	^array!

array: anObject
	array := anObject!

bitmask
	^bitmask!

bitmask: anObject
	bitmask := anObject!

dictionary
	^dictionary!

dictionary: anObject
	dictionary := anObject!

number1
	^number1!

number1: anObject
	number1 := anObject!

number2
	^number2!

number2: anObject
	number2 := anObject!

orderedCollection
	^orderedCollection!

orderedCollection: anObject
	orderedCollection := anObject!

set
	^set!

set: anObject
	set := anObject!

sortedCollection
	^sortedCollection!

sortedCollection: anObject
	sortedCollection := anObject! !
!TestWithBitmask categoriesForMethods!
array!accessing!private! !
array:!accessing!private! !
bitmask!accessing!private! !
bitmask:!accessing!private! !
dictionary!accessing!private! !
dictionary:!accessing!private! !
number1!accessing!private! !
number1:!accessing!private! !
number2!accessing!private! !
number2:!accessing!private! !
orderedCollection!accessing!private! !
orderedCollection:!accessing!private! !
set!accessing!private! !
set:!accessing!private! !
sortedCollection!accessing!private! !
sortedCollection:!accessing!private! !
!

!TestWithBitmask class methodsFor!

new

	^super new
		bitmask: TestBitmask new;
		orderedCollection: OrderedCollection new;
		sortedCollection: SortedCollection new;
		array: (Array new: 8);
		set: Set new;
		dictionary: Dictionary new;
		yourself!

reStoreDefinition

	^super reStoreDefinition

		"These two are just here so the bitmask accessor is out of range for SSWDBDeletedObject (see SSWReStoreDirectlyPersistedTest>>testDeletedObjectRecovery)"
		define: #number1 as: Integer;
		define: #number2 as: Integer;

		define: #bitmask as: TestBitmask;
		define: #orderedCollection as: (OrderedCollection of: TestBitmask);
		define: #sortedCollection as: (SortedCollection of: TestBitmask);
		define: #array as: ((Array new: 8) of: TestBitmask);
		define: #set as: (Set of: TestBitmask);
		define: #dictionary as: (Dictionary of: TestBitmask -> TestBitmask);
		yourself!

shouldInheritPersistency

	^false! !
!TestWithBitmask class categoriesForMethods!
new!instance creation!public! !
reStoreDefinition!persistency!public! !
shouldInheritPersistency!persistency!public! !
!


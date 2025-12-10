"Filed out from Dolphin Smalltalk"!

Object subclass: #OwnerTest
	instanceVariableNames: 'name number single1 single2 single3 owned ownedSet ownedArray ownedOrdered ownedSorted ownedList setOfDates arrayOfNames orderedBools sortedNumbers descNumbers listOfTimes dictOfSizes set array ordered sorted list aspectDictionary keyedBaseDictionary keyedGeneralDictionary keyedIdentityDictionary refreshCount dependentOwnedOrdered dependentOrdered selfReferencingOrdered'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

OwnerTest guid: (GUID fromString: '{75e7c261-4b99-11d5-b1df-0010a70883e2}')!

OwnerTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!

!OwnerTest categoriesForClass!Unclassified! !

!OwnerTest methodsFor!

<= another

	^(self single1 name <= another single1 name) |
		((self single1 name = another single1 name) & (self single2 name <= another single2 name))!

array
	"Private - Answer the value of the receiver's ''array'' instance variable."

	^array!

array: anObject
	"Private - Set the value of the receiver's ''array'' instance variable to the argument, anObject."

	array := anObject!

arrayOfNames
	"Private - Answer the value of the receiver's ''arrayOfNames'' instance variable."

	^arrayOfNames!

arrayOfNames: anObject
	"Private - Set the value of the receiver's ''arrayOfNames'' instance variable to the argument, anObject."

	arrayOfNames := anObject!

aspectDictionary
	"Private - Answer the value of the receiver's ''aspectDictionary'' instance variable."

	^aspectDictionary!

aspectDictionary: anObject
	"Private - Set the value of the receiver's ''aspectDictionary'' instance variable to the argument, anObject."

	aspectDictionary := anObject!

dependentOrdered
	^dependentOrdered!

dependentOrdered: anObject
	dependentOrdered := anObject!

dependentOwnedOrdered
	^dependentOwnedOrdered!

dependentOwnedOrdered: anObject
	dependentOwnedOrdered := anObject!

descNumbers
	"Private - Answer the value of the receiver's ''descNumbers'' instance variable."

	^descNumbers!

descNumbers: anObject
	"Private - Set the value of the receiver's ''descNumbers'' instance variable to the argument, anObject."

	descNumbers := anObject!

dictOfSizes
	"Private - Answer the value of the receiver's ''dictOfSizes'' instance variable."

	^dictOfSizes!

dictOfSizes: anObject
	"Private - Set the value of the receiver's ''dictOfSizes'' instance variable to the argument, anObject."

	dictOfSizes := anObject!

keyedBaseDictionary
	"Private - Answer the value of the receiver's ''keyedBaseDictionary'' instance variable."

	^keyedBaseDictionary!

keyedBaseDictionary: anObject
	"Private - Set the value of the receiver's ''keyedBaseDictionary'' instance variable to the argument, anObject."

	keyedBaseDictionary := anObject!

keyedGeneralDictionary
	"Private - Answer the value of the receiver's ''keyedGeneralDictionary'' instance variable."

	^keyedGeneralDictionary!

keyedGeneralDictionary: anObject
	"Private - Set the value of the receiver's ''keyedGeneralDictionary'' instance variable to the argument, anObject."

	keyedGeneralDictionary := anObject!

keyedIdentityDictionary
	^keyedIdentityDictionary!

keyedIdentityDictionary: anObject
	keyedIdentityDictionary := anObject!

list
	"Private - Answer the value of the receiver's ''list'' instance variable."

	^list!

list: anObject
	"Private - Set the value of the receiver's ''list'' instance variable to the argument, anObject."

	list := anObject!

listOfTimes
	"Private - Answer the value of the receiver's ''listOfTimes'' instance variable."

	^listOfTimes!

listOfTimes: anObject
	"Private - Set the value of the receiver's ''listOfTimes'' instance variable to the argument, anObject."

	listOfTimes := anObject!

mergeUpdate: aSymbol from: anObject

	^(aSymbol = #name and: [anObject name = 'blockMerge'])
		ifTrue: [false]
		ifFalse: [super mergeUpdate: aSymbol from: anObject]!

name
	^name!

name: anObject
	name := anObject!

number
	^number!

number: anObject
	number := anObject!

onRefresh

	self refreshCount: (self refreshCount + 1)!

ordered
	"Private - Answer the value of the receiver's ''ordered'' instance variable."

	^ordered!

ordered: anObject
	"Private - Set the value of the receiver's ''ordered'' instance variable to the argument, anObject."

	ordered := anObject!

orderedBools
	"Private - Answer the value of the receiver's ''orderedBools'' instance variable."

	^orderedBools!

orderedBools: anObject
	"Private - Set the value of the receiver's ''orderedBools'' instance variable to the argument, anObject."

	orderedBools := anObject!

owned
	^owned!

owned: anObject
	owned := anObject!

ownedArray
	"Private - Answer the value of the receiver's ''ownedArray'' instance variable."

	^ownedArray!

ownedArray: anObject
	"Private - Set the value of the receiver's ''ownedArray'' instance variable to the argument, anObject."

	ownedArray := anObject!

ownedList
	"Private - Answer the value of the receiver's ''ownedList'' instance variable."

	^ownedList!

ownedList: anObject
	"Private - Set the value of the receiver's ''ownedList'' instance variable to the argument, anObject."

	ownedList := anObject!

ownedOrdered
	"Private - Answer the value of the receiver's ''ownedOrdered'' instance variable."

	^ownedOrdered!

ownedOrdered: anObject
	"Private - Set the value of the receiver's ''ownedOrdered'' instance variable to the argument, anObject."

	ownedOrdered := anObject!

ownedSet
	"Private - Answer the value of the receiver's ''ownedSet'' instance variable."

	^ownedSet!

ownedSet: anObject
	"Private - Set the value of the receiver's ''ownedSet'' instance variable to the argument, anObject."

	ownedSet := anObject!

ownedSorted
	"Private - Answer the value of the receiver's ''ownedSorted'' instance variable."

	^ownedSorted!

ownedSorted: anObject
	"Private - Set the value of the receiver's ''ownedSorted'' instance variable to the argument, anObject."

	ownedSorted := anObject!

refreshCount
	^refreshCount ifNil: [0]!

refreshCount: anObject
	refreshCount := anObject!

selfReferencingOrdered
	^selfReferencingOrdered!

selfReferencingOrdered: anObject
	selfReferencingOrdered := anObject!

set
	"Private - Answer the value of the receiver's ''set'' instance variable."

	^set!

set: anObject
	"Private - Set the value of the receiver's ''set'' instance variable to the argument, anObject."

	set := anObject!

setOfDates
	"Private - Answer the value of the receiver's ''setOfDates'' instance variable."

	^setOfDates!

setOfDates: anObject
	"Private - Set the value of the receiver's ''setOfDates'' instance variable to the argument, anObject."

	setOfDates := anObject!

single1
	"Private - Answer the value of the receiver's ''single1'' instance variable."

	^single1!

single1: anObject
	"Private - Set the value of the receiver's ''single1'' instance variable to the argument, anObject."

	single1 := anObject!

single2
	"Private - Answer the value of the receiver's ''single2'' instance variable."

	^single2!

single2: anObject
	"Private - Set the value of the receiver's ''single2'' instance variable to the argument, anObject."

	single2 := anObject!

single3
	"Private - Answer the value of the receiver's ''single3'' instance variable."

	^single3!

single3: anObject
	"Private - Set the value of the receiver's ''single3'' instance variable to the argument, anObject."

	single3 := anObject!

sorted
	"Private - Answer the value of the receiver's ''sorted'' instance variable."

	^sorted!

sorted: anObject
	"Private - Set the value of the receiver's ''sorted'' instance variable to the argument, anObject."

	sorted := anObject!

sortedNumbers
	"Private - Answer the value of the receiver's ''sortedNumbers'' instance variable."

	^sortedNumbers!

sortedNumbers: anObject
	"Private - Set the value of the receiver's ''sortedNumbers'' instance variable to the argument, anObject."

	sortedNumbers := anObject!

testOnRollback

	self owned name! !

!OwnerTest categoriesForMethods!
<=!accessing!private! !
array!accessing!private! !
array:!accessing!private! !
arrayOfNames!accessing!private! !
arrayOfNames:!accessing!private! !
aspectDictionary!accessing!private! !
aspectDictionary:!accessing!private! !
dependentOrdered!accessing!private! !
dependentOrdered:!accessing!private! !
dependentOwnedOrdered!accessing!private! !
dependentOwnedOrdered:!accessing!private! !
descNumbers!accessing!private! !
descNumbers:!accessing!private! !
dictOfSizes!accessing!private! !
dictOfSizes:!accessing!private! !
keyedBaseDictionary!accessing!private! !
keyedBaseDictionary:!accessing!private! !
keyedGeneralDictionary!accessing!private! !
keyedGeneralDictionary:!accessing!private! !
keyedIdentityDictionary!accessing!private! !
keyedIdentityDictionary:!accessing!private! !
list!accessing!private! !
list:!accessing!private! !
listOfTimes!accessing!private! !
listOfTimes:!accessing!private! !
mergeUpdate:from:!accessing!public! !
name!accessing!private! !
name:!accessing!private! !
number!accessing!private! !
number:!accessing!private! !
onRefresh!event handling!public! !
ordered!accessing!private! !
ordered:!accessing!private! !
orderedBools!accessing!private! !
orderedBools:!accessing!private! !
owned!accessing!private! !
owned:!accessing!private! !
ownedArray!accessing!private! !
ownedArray:!accessing!private! !
ownedList!accessing!private! !
ownedList:!accessing!private! !
ownedOrdered!accessing!private! !
ownedOrdered:!accessing!private! !
ownedSet!accessing!private! !
ownedSet:!accessing!private! !
ownedSorted!accessing!private! !
ownedSorted:!accessing!private! !
refreshCount!accessing!private! !
refreshCount:!accessing!private! !
selfReferencingOrdered!accessing!private! !
selfReferencingOrdered:!accessing!private! !
set!accessing!private! !
set:!accessing!private! !
setOfDates!accessing!private! !
setOfDates:!accessing!private! !
single1!accessing!private! !
single1:!accessing!private! !
single2!accessing!private! !
single2:!accessing!private! !
single3!accessing!private! !
single3:!accessing!private! !
sorted!accessing!private! !
sorted:!accessing!private! !
sortedNumbers!accessing!private! !
sortedNumbers:!accessing!private! !
testOnRollback!public! !
!

!OwnerTest class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #name as: (String maxSize: 64);
		define: #number as: Integer;
		define: #single1 as: Test;
		define: #single2 as: Test dependent;
		define: #single3 as: Test dependent;
		define: #owned as: OwnedTest dependent;		
		define: #ownedSet as: 
			(Set of: OwnedTest dependent owner: #owner);
		define: #ownedArray as:
			((Array new: 4) of: OwnedTest dependent owner: #owner);
		define: #ownedOrdered as: 
			(OrderedCollection of: OwnedTest dependent owner: #owner);
		define: #ownedSorted as:
			(SortedCollection of: OwnedTest dependent owner: #owner);
		define: #ownedList as: 
			((SSWReStoreTest listModelOn: OrderedCollection new) of: OwnedTest dependent owner: #owner) ;

		define: #setOfDates as: (Set of: Date);
		define: #arrayOfNames as: ((Array new: 2) of: (String maxSize: 32));
		define: #orderedBools as: (OrderedCollection of: Boolean);
		define: #sortedNumbers as: (SortedCollection of: Integer);
		define: #descNumbers as: (((SortedCollection sortBlock: [ :x :y | x > y] "sortDescendingOn: #yourself")) of: Integer);
		define: #listOfTimes as: ((SSWReStoreTest listModelOn: OrderedCollection new) of: Time);
		define: #dictOfSizes as: (Dictionary of: String -> Integer);

		define: #set as: (Set of: Test dependent);
		define: #array as: ((Array new: 4) of: Test dependent);
		define: #ordered as: (OrderedCollection of: Test dependent);
		define: #sorted as: ((SortedCollection new" sortAscendingOn: #name") of: Test dependent);
		define: #list as: ((SSWReStoreTest listModelOn: OrderedCollection new) of: Test dependent);
		define: #aspectDictionary as: (Dictionary of: #name -> Test dependent);
		define: #keyedBaseDictionary as: (Dictionary of: String -> Test dependent);
		define: #keyedGeneralDictionary as: (Dictionary of: Test dependent -> Test dependent);
		define: #keyedIdentityDictionary as: (IdentityDictionary of: Test dependent -> Test dependent);
		define: #selfReferencingOrdered as: (OrderedCollection of: self);
		yourself!

template

	^self new
		ownedArray: Array new;
		ownedSet: Set new;
		ownedOrdered: OrderedCollection new;
		ownedSorted: OrderedCollection new;
		ownedList: SSWReStoreTest listModelClass new;

		setOfDates: Set new;
		arrayOfNames: Array new;
		orderedBools: OrderedCollection new;
		sortedNumbers: SortedCollection  new;
		descNumbers: SortedCollection  new;
		listOfTimes: SSWReStoreTest listModelClass new;
		dictOfSizes: Dictionary new;

		set: Set new;
		array: Array new;
		ordered: OrderedCollection new;
		sorted: SortedCollection new;
		list: SSWReStoreTest listModelClass new;
		aspectDictionary: Dictionary new;
		keyedBaseDictionary: Dictionary new;
		keyedGeneralDictionary: Dictionary new;
		yourself! !

!OwnerTest class categoriesForMethods!
reStoreDefinition!public! !
template!instance creation!public! !
!


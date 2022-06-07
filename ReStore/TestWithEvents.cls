"Filed out from Dolphin Smallalk"!

TestWithEventsAbstract subclass: #TestWithEvents
	instanceVariableNames: 'items count'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TestWithEvents guid: (GUID fromString: '{594091ed-3beb-472f-acbe-599ab1b07904}')!
TestWithEvents comment: ''!
!TestWithEvents categoriesForClass!Unclassified! !
!TestWithEvents methodsFor!

_count
	^count!

count
	^count ifNil: [count := self items size]!

items
	^items!

items: anObject
	items := anObject!

onRecovered

	super onRecovered.
	count := self items size!

onRefresh

	count := self items size!

onRollback

	count := nil!

removeItem: anItem

	self count.
	self items remove: anItem.
	count := count - 1! !
!TestWithEvents categoriesForMethods!
_count!accessing!private! !
count!accessing!public! !
items!accessing!private! !
items:!accessing!private! !
onRecovered!event handling!public! !
onRefresh!event handling!public! !
onRollback!event handling!public! !
removeItem:!public!removing! !
!

!TestWithEvents class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #items as: (OrderedCollection of: TestWithEventsItem related);
		yourself! !
!TestWithEvents class categoriesForMethods!
reStoreDefinition!public! !
!


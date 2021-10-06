"Filed out from Dolphin Smallalk"!

TypeTest subclass: #DolphinTypeTest
	instanceVariableNames: 'timeStamp'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DolphinTypeTest guid: (GUID fromString: '{2da22fbe-2f76-437c-8df9-f819cd26108f}')!
DolphinTypeTest comment: ''!
!DolphinTypeTest categoriesForClass!Unclassified! !
!DolphinTypeTest methodsFor!

timeStamp
	^timeStamp!

timeStamp: anObject
	timeStamp := anObject! !
!DolphinTypeTest categoriesForMethods!
timeStamp!accessing!private! !
timeStamp:!accessing!private! !
!

!DolphinTypeTest class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #timeStamp as: TimeStamp;
		yourself! !
!DolphinTypeTest class categoriesForMethods!
reStoreDefinition!public! !
!


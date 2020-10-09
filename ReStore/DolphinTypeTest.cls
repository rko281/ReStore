"Filed out from Dolphin Smalltalk 7"!

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
!DolphinTypeTest categoriesFor: #timeStamp!accessing!private! !
!DolphinTypeTest categoriesFor: #timeStamp:!accessing!private! !

!DolphinTypeTest class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #timeStamp as: TimeStamp;
		yourself! !
!DolphinTypeTest class categoriesFor: #reStoreDefinition!public! !


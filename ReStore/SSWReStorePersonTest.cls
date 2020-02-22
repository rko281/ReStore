"Filed out from Dolphin Smalltalk 7"!

SSWReStoreTest subclass: #SSWReStorePersonTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStorePersonTest guid: (GUID fromString: '{62405943-2891-408b-b300-20098399d281}')!
SSWReStorePersonTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStorePersonTest categoriesForClass!Unclassified! !
!SSWReStorePersonTest methodsFor!

addClassesTo: aReStore

	super addClassesTo: aReStore.
	aReStore
		addClass: SimplePerson;
		addClass: SuperPerson;
		addClass: DetailedPerson;
		addClass: SimpleAddress! !
!SSWReStorePersonTest categoriesFor: #addClassesTo:!public!Running! !

!SSWReStorePersonTest class methodsFor!

isAbstract

	^self name == #SSWReStorePersonTest! !
!SSWReStorePersonTest class categoriesFor: #isAbstract!public! !


"Filed out from Dolphin Smalltalk 7"!

SSWReStoreAbstractQueryTest subclass: #SSWReStoreDefaultTest
	instanceVariableNames: 'reStore2'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreDefaultTest guid: (GUID fromString: '{7e7027f0-99e7-41de-8535-553cb543b5a7}')!
SSWReStoreDefaultTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreDefaultTest categoriesForClass!Unclassified! !
!SSWReStoreDefaultTest methodsFor!

createReStore

	"Private - Use the default instance"

	reStore := ReStore!

newAlan

	^SimplePerson new
		surname: 'Jones'; 
		firstName: 'Alan'; 
		emailAddress: 'alan@jones.co'; 
		age: 39;
		address: (SimpleAddress new postcode: 'A1 1AA');
		yourself!

setUp

	super setUp.

	reStore2 := SSWReStore new.
	self initReStore: reStore2.

	reStore2 connect.
	self addClassesTo: reStore2!

tearDown

	super tearDown.

	SSWReStore reset.

	reStore2 isNil ifFalse: 
		[self releaseReStore: reStore2.
		reStore2 := nil]! !
!SSWReStoreDefaultTest categoriesFor: #createReStore!private!running! !
!SSWReStoreDefaultTest categoriesFor: #newAlan!public!Running! !
!SSWReStoreDefaultTest categoriesFor: #setUp!public!running! !
!SSWReStoreDefaultTest categoriesFor: #tearDown!public!running! !

!SSWReStoreDefaultTest class methodsFor!

isAbstract

	^self == SSWReStoreDefaultTest! !
!SSWReStoreDefaultTest class categoriesFor: #isAbstract!public! !


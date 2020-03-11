"Filed out from Dolphin Smalltalk 7"!

SSWReStoreTest subclass: #SSWReStore2Test
	instanceVariableNames: 'reStore2'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStore2Test guid: (GUID fromString: '{441283e9-87fb-4b2e-bd6c-a5588f64f937}')!
SSWReStore2Test comment: ''!
!SSWReStore2Test categoriesForClass!Unclassified! !
!SSWReStore2Test methodsFor!

setUp

	super setUp.

	reStore2 := SSWReStore new.
	self initReStore: reStore2.
	reStore2 connect.
	self addClassesTo: reStore2!

tearDown

	reStore2 isNil ifFalse: 
		[self releaseReStore: reStore2.
		reStore2 := nil].

	super tearDown! !
!SSWReStore2Test categoriesFor: #setUp!public!running! !
!SSWReStore2Test categoriesFor: #tearDown!public!running! !

!SSWReStore2Test class methodsFor!

isAbstract

	^self == SSWReStore2Test! !
!SSWReStore2Test class categoriesFor: #isAbstract!public! !


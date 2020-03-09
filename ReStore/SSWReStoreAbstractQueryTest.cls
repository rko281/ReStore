"Filed out from Dolphin Smalltalk 7"!

SSWReStorePersonTest subclass: #SSWReStoreAbstractQueryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreAbstractQueryTest guid: (GUID fromString: '{eb4bed1a-f162-4ec9-bcfc-73fcf94f55e4}')!
SSWReStoreAbstractQueryTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreAbstractQueryTest categoriesForClass!Unclassified! !
!SSWReStoreAbstractQueryTest methodsFor!

setUp

	| john jim david zoe |

	super setUp.

	reStore beginTransaction.

	john := SimplePerson new 
		surname: 'Smith'; 
		firstName: 'John'; 
		emailAddress: 'john@something'; 
		age: 20;
		storeIn: reStore.

	jim := SimplePerson new 
		surname: 'Brown'; 
		firstName: 'Jim'; 
		emailAddress: 'jim@somewhere'; 
		age: 30;
		storeIn: reStore.

	david := SimplePerson new 
		surname: 'Smythe'; 
		firstName: 'David'; 
		emailAddress: 'david@somewhere'; 
		age: 40;
		storeIn: reStore.

	zoe := SimplePerson new 
		surname: 'Brown'; 
		firstName: 'Zoe';  
		friend: john;
		age: 20;
		yourself;
		storeIn: reStore.

	john friend: david.

	reStore commitTransaction
!

sortedPersonFullNames

	^#('David Smythe' 'Jim Brown' 'John Smith' 'Zoe Brown')! !
!SSWReStoreAbstractQueryTest categoriesFor: #setUp!public! !
!SSWReStoreAbstractQueryTest categoriesFor: #sortedPersonFullNames!public! !

!SSWReStoreAbstractQueryTest class methodsFor!

isAbstract

	^self name == #SSWReStoreAbstractQueryTest! !
!SSWReStoreAbstractQueryTest class categoriesFor: #isAbstract!public! !


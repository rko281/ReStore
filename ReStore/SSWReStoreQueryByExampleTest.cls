"Filed out from Dolphin Smalltalk 7"!

SSWReStoreAbstractQueryTest subclass: #SSWReStoreQueryByExampleTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreQueryByExampleTest guid: (GUID fromString: '{3b04cb42-dd24-4e87-bdd4-96effe0ec489}')!
SSWReStoreQueryByExampleTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreQueryByExampleTest categoriesForClass!Unclassified! !
!SSWReStoreQueryByExampleTest methodsFor!

test1Simple

	| template instances |

	template := SimplePerson new.
	template time: nil.

	template surname: 'Smith'.
	instances := template similarInstancesIn: reStore.
	self assert: (instances size = 1).
	self assert: (instances first firstName = 'John').

	template surname: 'Brown'.
	instances := template similarInstancesIn: reStore.
	self assert: (instances size = 2).
	self assert: (instances anySatisfy: [ :each | each firstName = 'Jim']).
	self assert: (instances anySatisfy: [ :each | each firstName = 'Zoe']).

	template firstName: 'Jim'.
	instances := template similarInstancesIn: reStore.
	self assert: (instances size = 1).
	self assert: (instances anySatisfy: [ :each | each emailAddress = 'jim@somewhere'])
!

test2Wildcards

	| template instances |

	template := SimplePerson new.
	template time: nil.

	template surname: 'Sm*' asWildcard.
	instances := template similarInstancesIn: reStore.
	self assert: (instances size = 2).
	self assert: (instances anySatisfy: [ :each | each firstName = 'John']).
	self assert: (instances anySatisfy: [ :each | each firstName = 'David']).

	template surname: nil.
	template emailAddress: '*somewhere' asWildcard.
	instances := template similarInstancesIn: reStore.
	self assert: (instances size = 2).
	self assert: (instances anySatisfy: [ :each | each firstName = 'Jim']).
	self assert: (instances anySatisfy: [ :each | each firstName = 'David'])!

test3NilRequired

	| template instances |

	template := SimplePerson new.
	template time: nil.

	template emailAddress: nil required.	
	instances := template similarInstancesIn: reStore.
	self assert: (instances size = 1).
	self assert: (instances first firstName = 'Zoe')!

test4PersistentByValue

	| template instances |

	template := SimplePerson new.
	template
		time: nil;
		surname: 'Brown';
		friend: (SimplePerson new time: nil; firstName: 'John').
	instances := template similarInstancesIn: reStore.
	self assert: (instances size = 1).
	self assert: (instances first firstName = 'Zoe').
	self assert: (instances first surname = 'Brown').

	template friend surname: 'XYZ'.
	instances := template similarInstancesIn: reStore.
	self assert: (instances size = 0)!

test5PersistentByRef

	| template instances |

	template := SimplePerson new.
	template
		time: nil;
		surname: 'Brown';
		friend: ((reStore instancesOf: SimplePerson) detect: [ :e | (e firstName = 'John') & (e surname = 'Smith')]).

	instances := template similarInstancesIn: reStore.
	self assert: (instances size = 1).

	self assert: (instances first firstName = 'Zoe').
	self assert: (instances first surname = 'Brown').

	template friend: 
		((reStore instancesOf: SimplePerson) detect: [ :e | (e firstName = 'Jim') & (e surname = 'Brown')]).
	instances := template similarInstancesIn: reStore.
	self assert: (instances size = 0)! !
!SSWReStoreQueryByExampleTest categoriesFor: #test1Simple!public! !
!SSWReStoreQueryByExampleTest categoriesFor: #test2Wildcards!public! !
!SSWReStoreQueryByExampleTest categoriesFor: #test3NilRequired!public! !
!SSWReStoreQueryByExampleTest categoriesFor: #test4PersistentByValue!public! !
!SSWReStoreQueryByExampleTest categoriesFor: #test5PersistentByRef!public! !


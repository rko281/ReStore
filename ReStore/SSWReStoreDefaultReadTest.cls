"Filed out from Dolphin Smalltalk 7"!

SSWReStoreDefaultTest subclass: #SSWReStoreDefaultReadTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreDefaultReadTest guid: (GUID fromString: '{1cb4f327-ca48-444f-a72c-f27dcbe5cba6}')!
SSWReStoreDefaultReadTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreDefaultReadTest categoriesForClass!Unclassified! !
!SSWReStoreDefaultReadTest methodsFor!

testDefaultWithOtherReStore

	"Test separation of the default ReStore and another instance"

	| zoe1 zoe2 |

	zoe1 := SimplePerson storedInstances detect: [ :each | each fullName = 'Zoe Brown'].
	zoe2 := (SimplePerson storedInstancesIn: reStore2) detect: [ :each | each fullName = 'Zoe Brown'].

	self assert: zoe1 ~~ zoe2.

	self assert: zoe1 _reStore = SSWReStore default.
	self assert: zoe1 _reStore = reStore.

	self assert: zoe2 _reStore = reStore2!

testStoredInstances

	"Test simple querying using <Class> storedInstances"

	| browns smXs|

	self assert: (SimplePerson storedInstances size = 4).

	browns := SimplePerson storedInstances satisfying: [ :each | each surname = 'Brown'].
	self assert: (browns size = 2).
	self assert: (browns detect: [ :each | each firstName = 'Zoe']) emailAddress isNil.

	smXs := SimplePerson storedInstances satisfying:  [ :each | 'Sm*' match: each surname].
	self assert: (smXs isEmpty not).
	self assert: (smXs size = 2).
	self assert: ((smXs collect: [ :each | each firstName]) asSortedCollection asArray = #('David' 'John'))! !
!SSWReStoreDefaultReadTest categoriesFor: #testDefaultWithOtherReStore!public!unit tests! !
!SSWReStoreDefaultReadTest categoriesFor: #testStoredInstances!public!unit tests! !


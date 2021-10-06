"Filed out from Dolphin Smallalk"!

SSWReStoreTest subclass: #SSWReStoreIDTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreIDTest guid: (GUID fromString: '{fe0ab3a2-5bf6-4988-83af-43a03160f273}')!
SSWReStoreIDTest comment: ''!
!SSWReStoreIDTest categoriesForClass!Unclassified! !
!SSWReStoreIDTest methodsFor!

addClassesTo: aReStore

	aReStore addClass: self testClass!

testClass

	^self subclassResponsibility!

testInstances

	^self testClass storedInstancesIn: reStore! !
!SSWReStoreIDTest categoriesForMethods!
addClassesTo:!public!running! !
testClass!constants!public! !
testInstances!accessing!public! !
!

!SSWReStoreIDTest class methodsFor!

allTestSelectors

	^super allTestSelectors reject: [ :each | #(#testClass #testInstances) includes: each]!

isAbstract

	^self == SSWReStoreIDTest!

testSelectors

	^super testSelectors reject: [ :each | #(#testClass #testInstances) includes: each]! !
!SSWReStoreIDTest class categoriesForMethods!
allTestSelectors!public! !
isAbstract!public! !
testSelectors!public! !
!


"Filed out from Dolphin Smallalk"!

Object subclass: #ReStoreTestWithIDOnly
	instanceVariableNames: 'nmbr'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ReStoreTestWithIDOnly guid: (GUID fromString: '{146630d5-64f2-4115-a0ff-728f47c4709f}')!
ReStoreTestWithIDOnly comment: ''!
!ReStoreTestWithIDOnly categoriesForClass!Unclassified! !
!ReStoreTestWithIDOnly methodsFor!

nmbr
	^nmbr!

nmbr: anObject
	nmbr := anObject! !
!ReStoreTestWithIDOnly categoriesForMethods!
nmbr!accessing!private! !
nmbr:!accessing!private! !
!

!ReStoreTestWithIDOnly class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		defineAsID: #nmbr;
		yourself! !
!ReStoreTestWithIDOnly class categoriesForMethods!
reStoreDefinition!persistency!public! !
!


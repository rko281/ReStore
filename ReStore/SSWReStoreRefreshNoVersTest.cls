"Filed out from Dolphin Smalltalk 7"!

SSWReStoreRefreshTest subclass: #SSWReStoreRefreshNoVersTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreRefreshNoVersTest guid: (GUID fromString: '{233734e1-53a9-4749-a8cc-f5fec310384a}')!
SSWReStoreRefreshNoVersTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWReStoreRefreshNoVersTest categoriesForClass!Unclassified! !
!SSWReStoreRefreshNoVersTest methodsFor!

initReStore: aReStore

	super initReStore: aReStore.
	aReStore useTransactionsWithoutVersioning
!

usesVersioning

	^false! !
!SSWReStoreRefreshNoVersTest categoriesFor: #initReStore:!public!Running! !
!SSWReStoreRefreshNoVersTest categoriesFor: #usesVersioning!public! !


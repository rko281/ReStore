"Filed out from Dolphin Smalltalk"!

SSWMSAccessDialect subclass: #SSWMSAccess2013Dialect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWMSAccess2013Dialect guid: (GUID fromString: '{94921e1d-0ad5-48be-bb40-33c3ff1e062a}')!

SSWMSAccess2013Dialect comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!

!SSWMSAccess2013Dialect categoriesForClass!Unclassified! !

!SSWMSAccess2013Dialect methodsFor!

maxAllocatedStatements

	"Access 2013 gives an error about number of open tables around 340 allocated statements"

	"Leave some headroom"
	^300! !

!SSWMSAccess2013Dialect categoriesForMethods!
maxAllocatedStatements!constants!public! !
!


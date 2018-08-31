"Filed out from Dolphin Smalltalk 7"!

SSWDBObjectWithComponents subclass: #SSWDBCollectionWithContents
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBCollectionWithContents guid: (GUID fromString: '{126721e2-6b73-4215-a3a7-190525450c9f}')!
SSWDBCollectionWithContents comment: ''!
!SSWDBCollectionWithContents categoriesForClass!Unclassified! !
!SSWDBCollectionWithContents methodsFor!

componentsIn: aReStore do: aBlock visited: visitedSet evaluated: evaluatedSet

	((self object _dbProxyIn: aReStore ifNone: [nil]) ifNil: [self object] ifNotNil: [ :prx | prx _proxiedObject]) do:
		[ :each | 
		each withComponents withComponentsIn: aReStore do: aBlock visited: visitedSet evaluated: evaluatedSet]! !
!SSWDBCollectionWithContents categoriesFor: #componentsIn:do:visited:evaluated:!enumerating!private! !


"Filed out from Dolphin Smalltalk 7"!

SSWDBObjectWithRelatedComponents subclass: #SSWDBCollectionWithRelatedContents
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBCollectionWithRelatedContents guid: (GUID fromString: '{a6c80a2a-76cb-4431-bb99-1428c9e7667d}')!
SSWDBCollectionWithRelatedContents comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBCollectionWithRelatedContents categoriesForClass!Unclassified! !
!SSWDBCollectionWithRelatedContents methodsFor!

componentsIn: aReStore do: aBlock visited: visitedSet evaluated: evaluatedSet

	| proxy |

	proxy := self object _dbProxyIn: aReStore ifNone: [nil]. 
	(proxy isNil or: [proxy _collectionSpec isRelated]) ifFalse: [^self].

	(proxy ifNil: [self object] ifNotNil: [ :prx | prx _proxiedObject]) do:
		[ :each | 
		each withRelatedComponents withComponentsIn: aReStore do: aBlock visited: visitedSet evaluated: evaluatedSet]! !
!SSWDBCollectionWithRelatedContents categoriesFor: #componentsIn:do:visited:evaluated:!enumerating!private! !


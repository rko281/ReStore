"Filed out from Dolphin Smalltalk 7"!

SSWDBObjectWithRelatedComponents subclass: #SSWDBCollectionWithRelatedContents
	instanceVariableNames: 'cachedProxy'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBCollectionWithRelatedContents guid: (GUID fromString: '{a6c80a2a-76cb-4431-bb99-1428c9e7667d}')!
SSWDBCollectionWithRelatedContents comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBCollectionWithRelatedContents categoriesForClass!Unclassified! !
!SSWDBCollectionWithRelatedContents methodsFor!

collection

	^self proxy 
		ifNil: [self object] 
		ifNotNil: [ :proxy | proxy _proxiedObject]!

componentsIn: aReStore do: aBlock visited: visitedSet evaluated: evaluatedSet

	self isRelated ifFalse: [^self].

	self collection do:
		[ :each | 
		each withRelatedComponents withComponentsIn: aReStore do: aBlock visited: visitedSet evaluated: evaluatedSet]!

isRelated

	^(self originatingComponent ifNil: [self proxy ifNotNil: [ :proxy | proxy _collectionSpec]])
		ifNil: [true]
		ifNotNil: [ :spec | spec isRelated]!

object: anObject

	anObject isDBProxy 
		ifTrue: [cachedProxy := anObject _proxiedObject]
		ifFalse: [cachedProxy := anObject].

	super object: anObject!

proxy

	self object isDBProxy ifTrue: [^self object].

	^cachedProxy isDBProxy 
		ifTrue: [cachedProxy]
		ifFalse: [self object _dbProxyIfNone: [nil]]! !
!SSWDBCollectionWithRelatedContents categoriesFor: #collection!public! !
!SSWDBCollectionWithRelatedContents categoriesFor: #componentsIn:do:visited:evaluated:!enumerating!private! !
!SSWDBCollectionWithRelatedContents categoriesFor: #isRelated!public! !
!SSWDBCollectionWithRelatedContents categoriesFor: #object:!public! !
!SSWDBCollectionWithRelatedContents categoriesFor: #proxy!public! !


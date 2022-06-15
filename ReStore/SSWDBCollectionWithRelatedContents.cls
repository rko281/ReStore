"Filed out from Dolphin Smallalk"!

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

collectionSpec

	^self originatingComponent ifNil: [self proxy ifNotNil: [ :proxy | proxy _collectionSpec]]!

componentsIn: aReStore do: aBlock visited: visitedSet evaluated: evaluatedSet

	| spec |

	spec := self collectionSpec.
	(spec isNil or: [spec isKeyRelated or: [spec isValueRelated]]) ifFalse: [^self].

	(spec isNil or: [spec isValueRelated])
	ifTrue: 
		[(spec isNil or: [spec isKeyRelated])
		ifTrue: 
			[self collection keysAndValuesDo:
				[ :key :value | 
				key withRelatedComponents withComponentsIn: aReStore do: aBlock visited: visitedSet evaluated: evaluatedSet.
				value withRelatedComponents withComponentsIn: aReStore do: aBlock visited: visitedSet evaluated: evaluatedSet]]
		ifFalse: 
			[self collection do: [ :each | each withRelatedComponents withComponentsIn: aReStore do: aBlock visited: visitedSet evaluated: evaluatedSet]]]
	ifFalse: 
		[self collection keysDo: [ :key | key withRelatedComponents withComponentsIn: aReStore do: aBlock visited: visitedSet evaluated: evaluatedSet]]!

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
!SSWDBCollectionWithRelatedContents categoriesForMethods!
collection!accessing!public! !
collectionSpec!accessing!public! !
componentsIn:do:visited:evaluated:!enumerating!private! !
isRelated!public!testing! !
object:!accessing!public! !
proxy!accessing!public! !
!


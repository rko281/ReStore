﻿"Filed out from Dolphin Smallalk"!

SSWDBWrapper subclass: #SSWDBObjectWithComponents
	instanceVariableNames: 'exclusions originatingComponent'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBObjectWithComponents guid: (GUID fromString: '{20b24c39-7603-434e-ac26-ff0b6be81ede}')!
SSWDBObjectWithComponents comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBObjectWithComponents categoriesForClass!Unclassified! !
!SSWDBObjectWithComponents methodsFor!

_changedObjectsIn: aReStore

	| allChanged |

	allChanged := IdentitySet new.

	self withComponentsIn: aReStore do: [ :each | (each _checkHasChangedIn: aReStore) ifTrue: [allChanged add: each]].

	^allChanged!

_checkHasChangedIn: aReStore

	"true if either the object itself has changed, or any of its components (or their components, recursively) have changed"

	self withComponentsIn: aReStore do: [ :each | (each _checkHasChangedIn: aReStore) ifTrue: [^true]].

	^false!

_commitIn: aReStore

	self withComponentsIn: aReStore do: [ :each | each _commitIn: aReStore]!

_forceRefreshIn: aReStore

	self _refreshIn: aReStore with: [ :obj | obj _forceRefreshWithContents]!

_lazyRefreshIn: aReStore

	| all |

	"Lazy refresh is basically forgetting the objects so we need to accumulate all items first"
	all := IdentitySet new.
	self withComponentsIn: aReStore do: [ :each | all add: each].

	all do: [ :each | each _lazyRefreshIn: aReStore]!

_refreshIfUpdatedIn: aReStore

	self _refreshIn: aReStore with: [ :obj | obj _refreshWithContentsIfUpdated]!

_refreshIn: aReStore

	self _refreshIn: aReStore with: [ :obj | obj _refreshWithContents]!

_refreshIn: aReStore with: aBlock

	"Private - Refresh objects represented by the receiver by evaluating each one with aBlock. Each evaluation should return a collection of refreshed objects"

	| all evaluated |

	"Refresh happens immediately so may cause some items to be skipped; examples: 
	 - item added to collection in this session; refresh of collection removes it
	 - item removed from collection in other session; refresh removes it in this session 
	To prevent these objects being skipped we first accumulate all items"
	all := IdentitySet new.
	self withComponentsIn: aReStore do: [ :each | all add: each].

	evaluated := self exclusions copy.
	self withComponentsIn: aReStore do: [ :each | evaluated addAll: (aBlock value: each)] visited: self exclusions copy evaluated: evaluated.

	"Now refresh any skipped items"
	all do: [ :each | (evaluated includes: each) ifFalse: [evaluated addAll: (aBlock value: each)]]!

_rollbackIn: aReStore

	self withComponentsIn: aReStore do: [ :each | each _rollbackIn: aReStore]!

componentsIn: aReStore do: aBlock visited: visitedSet evaluated: evaluatedSet

	(aReStore tableForClass: self object class ifAbsent: [nil]) ifNotNil: 
		[ :table |
		table componentsDo: 
			[ :component |
			component componentsOf: self object do: 
				[ :each | 
				each withComponents 
					originatingComponent: component;
					withComponentsIn: aReStore do: aBlock visited: visitedSet evaluated: evaluatedSet]]]!

exclusions
	^exclusions!

exclusions: anObject
	exclusions := anObject!

originatingComponent
	^originatingComponent!

originatingComponent: anObject
	originatingComponent := anObject!

withComponents

	^self!

withComponentsIn: aReStore do: aBlock

	self withComponentsIn: aReStore do: aBlock visited: self exclusions copy evaluated: IdentitySet new!

withComponentsIn: aReStore do: aBlock visited: visitedSet evaluated: evaluatedSet

	(self object isNil or: [visitedSet includes: self object]) ifTrue: [^self].
	visitedSet add: self object.

	(evaluatedSet includes: self object) ifFalse: 
		[evaluatedSet add: self object.
		aBlock value: self object].

	self object _isRecovered ifTrue: [self componentsIn: aReStore do: aBlock visited: visitedSet evaluated: evaluatedSet]!

without: anObject

	"Exclude anObject from the components of the receiver's object that will be traversed by the receiver"

	self exclusions add: anObject.
	^self!

withoutAll: aCollection

	"Exclude all elements of aCollection from the components of the receiver's object that will be traversed by the receiver"

	self exclusions addAll: aCollection.
	^self! !
!SSWDBObjectWithComponents categoriesForMethods!
_changedObjectsIn:!public!testing! !
_checkHasChangedIn:!public!testing! !
_commitIn:!actions!public! !
_forceRefreshIn:!actions!public! !
_lazyRefreshIn:!actions!public! !
_refreshIfUpdatedIn:!actions!public! !
_refreshIn:!actions!public! !
_refreshIn:with:!actions!private! !
_rollbackIn:!actions!public! !
componentsIn:do:visited:evaluated:!enumerating!private! !
exclusions!accessing!private! !
exclusions:!accessing!private! !
originatingComponent!public! !
originatingComponent:!public! !
withComponents!accessing!public! !
withComponentsIn:do:!enumerating!private! !
withComponentsIn:do:visited:evaluated:!enumerating!private! !
without:!initializing!public! !
withoutAll:!initializing!public! !
!

!SSWDBObjectWithComponents class methodsFor!

new

	^super new
		exclusions: IdentitySet new;
		yourself! !
!SSWDBObjectWithComponents class categoriesForMethods!
new!instance creation!public! !
!


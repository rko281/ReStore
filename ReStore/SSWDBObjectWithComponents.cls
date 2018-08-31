"Filed out from Dolphin Smalltalk 7"!

SSWDBWrapper subclass: #SSWDBObjectWithComponents
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBObjectWithComponents guid: (GUID fromString: '{20b24c39-7603-434e-ac26-ff0b6be81ede}')!
SSWDBObjectWithComponents comment: ''!
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

	| all evaluated |

	"Refresh happens immediately so may cause some items to be skipped; examples: 
	 - item added to collection in this session; refresh of collection removes it
	 - item removed from collection in other session; refresh removes it in this session 
	To prevent these objects being skipped we first accumulate all items"
	all := IdentitySet new.
	self withComponentsIn: aReStore do: [ :each | all add: each].

	evaluated := IdentitySet new.
	self withComponentsIn: aReStore do: [ :each | evaluated addAll: each _forceRefreshWithContents] visited: IdentitySet new evaluated: evaluated.

	"Now refresh any skipped items"
	all do: [ :each | (evaluated includes: each) ifFalse: [evaluated addAll: each _forceRefreshWithContents]]!

_refreshIfUpdatedIn: aReStore

	| all evaluated |

	"RefreshIfUpdated happens immediately so may cause some items to be skipped:
	e.g. consider where an item has been removed from a collection in another session; the refresh removes it in this session so it is skipped.
	To prevent these objects being skipped we first accumulate all items"
	all := IdentitySet new.
	self withComponentsIn: aReStore do: [ :each | all add: each].

	evaluated := IdentitySet new.
	self withComponentsIn: aReStore do: [ :each | evaluated addAll: each _refreshWithContentsIfUpdated] visited: IdentitySet new evaluated: evaluated.

	"Now refresh any skipped items"
	all do: [ :each | (evaluated includes: each) ifFalse: [evaluated addAll: each _refreshWithContentsIfUpdated]]!

_refreshIn: aReStore

	| all evaluated |

	"Refresh happens immediately so may cause some items to be skipped; examples: 
	 - item added to collection in this session; refresh of collection removes it
	 - item removed from collection in other session; refresh removes it in this session 
	To prevent these objects being skipped we first accumulate all items"
	all := IdentitySet new.
	self withComponentsIn: aReStore do: [ :each | all add: each].

	evaluated := IdentitySet new.
	self withComponentsIn: aReStore do: [ :each | evaluated addAll: each _refreshWithContents] visited: IdentitySet new evaluated: evaluated.

	"Now refresh any skipped items"
	all do: [ :each | (evaluated includes: each) ifFalse: [evaluated addAll: each _refreshWithContents]]!

_rollbackIn: aReStore

	self withComponentsIn: aReStore do: [ :each | each _rollbackIn: aReStore]!

componentsIn: aReStore do: aBlock visited: visitedSet evaluated: evaluatedSet

	(aReStore tableForClass: self object class ifAbsent: [nil]) ifNotNil: 
		[ :table |
		table componentsDo: 
			[ :component |
			component componentsOf: self object do: 
				[ :each | 
				each withComponents withComponentsIn: aReStore do: aBlock visited: visitedSet evaluated: evaluatedSet]]]!

withComponents

	^self!

withComponentsIn: aReStore do: aBlock

	self withComponentsIn: aReStore do: aBlock visited: IdentitySet new evaluated: IdentitySet new!

withComponentsIn: aReStore do: aBlock visited: visitedSet evaluated: evaluatedSet

	(self object isNil or: [visitedSet includes: self object]) ifTrue: [^self].
	visitedSet add: self object.

	(evaluatedSet includes: self object) ifFalse: 
		[evaluatedSet add: self object.
		aBlock value: self object].

	self object _isRecovered ifTrue: [self componentsIn: aReStore do: aBlock visited: visitedSet evaluated: evaluatedSet]! !
!SSWDBObjectWithComponents categoriesFor: #_changedObjectsIn:!public!testing! !
!SSWDBObjectWithComponents categoriesFor: #_checkHasChangedIn:!public!testing! !
!SSWDBObjectWithComponents categoriesFor: #_commitIn:!actions!public! !
!SSWDBObjectWithComponents categoriesFor: #_forceRefreshIn:!actions!public! !
!SSWDBObjectWithComponents categoriesFor: #_refreshIfUpdatedIn:!actions!public! !
!SSWDBObjectWithComponents categoriesFor: #_refreshIn:!actions!public! !
!SSWDBObjectWithComponents categoriesFor: #_rollbackIn:!actions!public! !
!SSWDBObjectWithComponents categoriesFor: #componentsIn:do:visited:evaluated:!enumerating!private! !
!SSWDBObjectWithComponents categoriesFor: #withComponents!accessing!public! !
!SSWDBObjectWithComponents categoriesFor: #withComponentsIn:do:!enumerating!private! !
!SSWDBObjectWithComponents categoriesFor: #withComponentsIn:do:visited:evaluated:!enumerating!private! !


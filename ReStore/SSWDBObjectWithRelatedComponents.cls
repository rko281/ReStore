"Filed out from Dolphin Smalltalk 7"!

SSWDBObjectWithComponents subclass: #SSWDBObjectWithRelatedComponents
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBObjectWithRelatedComponents guid: (GUID fromString: '{e7c24009-d351-4b88-a629-2fcd40796a39}')!
SSWDBObjectWithRelatedComponents comment: ''!
!SSWDBObjectWithRelatedComponents categoriesForClass!Unclassified! !
!SSWDBObjectWithRelatedComponents methodsFor!

componentsIn: aReStore do: aBlock visited: visitedSet evaluated: evaluatedSet

	(aReStore tableForClass: self object class ifAbsent: [nil]) ifNotNil: 
		[ :table |
		table componentsDo: 
			[ :component |
			component relatedComponentsOf: self object do: 
				[ :each | 
				each withRelatedComponents withComponentsIn: aReStore do: aBlock visited: visitedSet evaluated: evaluatedSet]]]!

withRelatedComponents

	^self! !
!SSWDBObjectWithRelatedComponents categoriesFor: #componentsIn:do:visited:evaluated:!enumerating!private! !
!SSWDBObjectWithRelatedComponents categoriesFor: #withRelatedComponents!accessing!public! !


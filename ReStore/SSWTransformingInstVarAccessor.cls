"Filed out from Dolphin Smalltalk 7"!

SSWInstVarAccessor subclass: #SSWTransformingInstVarAccessor
	instanceVariableNames: 'transformation'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWTransformingInstVarAccessor guid: (GUID fromString: '{f1bb1ea1-b74b-11d5-b1e0-444553540000}')!
SSWTransformingInstVarAccessor comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWTransformingInstVarAccessor categoriesForClass!Unclassified! !
!SSWTransformingInstVarAccessor methodsFor!

transformation

	"transformation stores a monadic valuable (zero-arg Message or 1-arg block)
	which transforms the actual object held in the inst var accessed by the receiver to another object"

	^transformation!

transformation: aMonadicValuable

	"transformation stores a monadic valuable (zero-arg Message or 1-arg block)
	which transforms the actual object held in the inst var accessed by the receiver to another object"

	transformation := aMonadicValuable!

valueIn: anObject

	"Override to apply the transformation.
	Also update anObject so it is storing the transformed value"	

	| origValue modValue |

	origValue := super valueIn: anObject.
	modValue := self transformation value: origValue.

	origValue ~~ modValue ifTrue: [self value: modValue in: anObject].

	^modValue! !
!SSWTransformingInstVarAccessor categoriesFor: #transformation!accessing!public! !
!SSWTransformingInstVarAccessor categoriesFor: #transformation:!accessing!public! !
!SSWTransformingInstVarAccessor categoriesFor: #valueIn:!evaluating!public! !

!SSWTransformingInstVarAccessor class methodsFor!

newWithTransformation: aMonadicValuable

	^self new
		transformation: aMonadicValuable;
		yourself! !
!SSWTransformingInstVarAccessor class categoriesFor: #newWithTransformation:!instance creation!public! !


"Filed out from Dolphin Smalltalk 7"!

SSWDBOwnedCacheDictionarySpec subclass: #SSWDBOwnedMultiValueCacheDictionarySpec
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBOwnedMultiValueCacheDictionarySpec guid: (GUID fromString: '{ac70cd20-08bc-4b34-9b4e-c5282da58bf9}')!
SSWDBOwnedMultiValueCacheDictionarySpec comment: 'ReStore
©2020 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBOwnedMultiValueCacheDictionarySpec categoriesForClass!Unclassified! !
!SSWDBOwnedMultiValueCacheDictionarySpec methodsFor!

allElementsIn: aDictionary

	^aDictionary inject: OrderedCollection new into: [ :all :each | all addAll: each; yourself]!

copyCollection: aCollection

	| copy |

	copy := aCollection copyEmpty.

	aCollection keysAndValuesDo: [ :key :values | copy at: key put: values copy].

	^copy!

elementsIn: updatedCollection notIn: originalCollection

	| additions |

	additions := OrderedCollection new.

	updatedCollection keysAndValuesDo: 
		[ :key :values || originalValues |
		originalValues := originalCollection at: key ifAbsent: [#()].
		values do: [ :each | (originalValues includes: each) ifFalse: [additions add: each]]].

	^additions!

hasCollection: updatedCollection anyAdditionsOrRemovalsFrom: originalCollection

	updatedCollection size ~= originalCollection size ifTrue: [^true].

	updatedCollection keysAndValuesDo: 
		[ :key :values || originalValues |
		originalValues := originalCollection at: key ifAbsent: [^true].
		(values size ~= originalValues size or: [values anySatisfy: [ :val | (originalValues identityIncludes: val) not]]) ifTrue: [^true]].

	^false!

newCollectionWrapper

	^SSWDBMultiValueCacheDictionaryWrapper new! !
!SSWDBOwnedMultiValueCacheDictionarySpec categoriesFor: #allElementsIn:!private!testing! !
!SSWDBOwnedMultiValueCacheDictionarySpec categoriesFor: #copyCollection:!actions!private! !
!SSWDBOwnedMultiValueCacheDictionarySpec categoriesFor: #elementsIn:notIn:!private!testing! !
!SSWDBOwnedMultiValueCacheDictionarySpec categoriesFor: #hasCollection:anyAdditionsOrRemovalsFrom:!private!testing! !
!SSWDBOwnedMultiValueCacheDictionarySpec categoriesFor: #newCollectionWrapper!helpers!private! !


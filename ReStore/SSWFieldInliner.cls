"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SSWFieldInliner
	instanceVariableNames: 'table instanceClass inlinedName inlinedSlot inlinedClass fields'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWFieldInliner guid: (GUID fromString: '{c8049b9e-b863-43c3-a1ae-3195249c4783}')!
SSWFieldInliner comment: ''!
!SSWFieldInliner categoriesForClass!Unclassified! !
!SSWFieldInliner methodsFor!

define: aSymbol as: anObject

	"Double-despatch; the object knows how to define itself"
	^anObject defineAs: aSymbol in: self!

define: aSymbol asInstVarHolding: anObject

	| rootTable cachedInstanceClass field |

	rootTable := self rootTable.
	cachedInstanceClass := rootTable instanceClass.
	[rootTable instanceClass: self inlinedClass.
	field := rootTable define: aSymbol asInstVarHolding: anObject] ensure: [rootTable instanceClass: cachedInstanceClass].

	self wrapField: field.

	^self fields add: field!

define: aSymbol asInstVarHoldingInlined: aClass

	| inliner |

	inliner := SSWFieldInliner new.
	inliner 
		table: self;
		instanceClass: self inlinedClass;
		inlinedName: aSymbol;
		inlinedSlot: (self inlinedClass allInstVarNames indexOf: aSymbol asString);
		inlinedClass: aClass .

	inliner inlinedSlot < 1 ifTrue: [self error: ('Undefined instance variable ', aSymbol)].

	aClass reStoreDefinition addDefinitionToTable: inliner.

	inliner fields do: [ :each | self wrapField: each]!

fields
	^fields!

fields: anObject
	fields := anObject!

inlinedClass
	^inlinedClass!

inlinedClass: anObject
	inlinedClass := anObject!

inlinedName
	^inlinedName!

inlinedName: anObject
	inlinedName := anObject!

inlinedSlot
	^inlinedSlot!

inlinedSlot: anObject
	inlinedSlot := anObject!

instanceClass
	^instanceClass!

instanceClass: anObject
	instanceClass := anObject!

rootTable

	^self table rootTable!

table
	^table!

table: anObject
	table := anObject!

wrapField: aField

	| prefix |

	prefix := self rootTable sqlDialect transformInstVarName: (self inlinedName, '_') asSymbol.
	aField name: (prefix, aField name).

	aField accessor: 
		((SSWInlinedInstVarAccessor toAccess: self inlinedName in: self instanceClass)
			inlinedClass: self inlinedClass;
			inlinedAccessor: aField accessor;
			yourself)! !
!SSWFieldInliner categoriesFor: #define:as:!defining!public! !
!SSWFieldInliner categoriesFor: #define:asInstVarHolding:!defining!public! !
!SSWFieldInliner categoriesFor: #define:asInstVarHoldingInlined:!defining!public! !
!SSWFieldInliner categoriesFor: #fields!accessing!private! !
!SSWFieldInliner categoriesFor: #fields:!accessing!private! !
!SSWFieldInliner categoriesFor: #inlinedClass!accessing!private! !
!SSWFieldInliner categoriesFor: #inlinedClass:!accessing!private! !
!SSWFieldInliner categoriesFor: #inlinedName!accessing!private! !
!SSWFieldInliner categoriesFor: #inlinedName:!accessing!private! !
!SSWFieldInliner categoriesFor: #inlinedSlot!accessing!private! !
!SSWFieldInliner categoriesFor: #inlinedSlot:!accessing!private! !
!SSWFieldInliner categoriesFor: #instanceClass!accessing!private! !
!SSWFieldInliner categoriesFor: #instanceClass:!accessing!private! !
!SSWFieldInliner categoriesFor: #rootTable!accessing!private! !
!SSWFieldInliner categoriesFor: #table!accessing!private! !
!SSWFieldInliner categoriesFor: #table:!accessing!private! !
!SSWFieldInliner categoriesFor: #wrapField:!defining!public! !

!SSWFieldInliner class methodsFor!

new

	^super new
		fields: OrderedCollection new;
		yourself! !
!SSWFieldInliner class categoriesFor: #new!instance creation!public! !


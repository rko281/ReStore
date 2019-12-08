"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SSWSQLFunction
	instanceVariableNames: 'parameterizedString resultParamIndex staticResultClass isAggregateFunction'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLFunction guid: (GUID fromString: '{cafa2ee2-c6e5-41ab-bc3b-1cc476458838}')!
SSWSQLFunction comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLFunction categoriesForClass!Kernel-Objects! !
!SSWSQLFunction methodsFor!

beAggregateFunction

	self isAggregateFunction: true!

convertValue: aValue forFunctionField: aFunctionField

	"Convert the given DB value object to the class of object specified as the result of this function. Return the converted object.

	The result can be of a specified class (staticResultClass) or the class of one of the parameters (the index of which is stored in resultParamIndex).
	The latter is the default, with resultParamIndex being 1"

	^self staticResultClass isNil 
		ifTrue: [(aFunctionField fieldAtIndex: self resultParamIndex) convertValue: aValue]
		ifFalse: [self staticResultClass instanceFromDBValue: aValue in: aFunctionField reStore]!

initialize

	"By default the class of the first parameter (the receiver in the corresponding Smalltalk expression) is the class of the result"
	self resultParamIndex: 1.

	self isAggregateFunction: false!

isAggregateFunction
	^isAggregateFunction!

isAggregateFunction: anObject
	isAggregateFunction := anObject!

parameterizedString
	^parameterizedString!

parameterizedString: anObject
	parameterizedString := anObject!

resultParamIndex
	^resultParamIndex!

resultParamIndex: anObject
	resultParamIndex := anObject!

staticResultClass
	^staticResultClass!

staticResultClass: anObject
	staticResultClass := anObject!

targetClassForFunctionField: aFunctionField

	^self staticResultClass ifNil: [(aFunctionField fieldAtIndex: self resultParamIndex) targetClass]! !
!SSWSQLFunction categoriesFor: #beAggregateFunction!initializing!public! !
!SSWSQLFunction categoriesFor: #convertValue:forFunctionField:!helpers!public! !
!SSWSQLFunction categoriesFor: #initialize!initializing!public! !
!SSWSQLFunction categoriesFor: #isAggregateFunction!accessing!public!testing! !
!SSWSQLFunction categoriesFor: #isAggregateFunction:!accessing!private! !
!SSWSQLFunction categoriesFor: #parameterizedString!accessing!private! !
!SSWSQLFunction categoriesFor: #parameterizedString:!accessing!private! !
!SSWSQLFunction categoriesFor: #resultParamIndex!accessing!private! !
!SSWSQLFunction categoriesFor: #resultParamIndex:!accessing!private! !
!SSWSQLFunction categoriesFor: #staticResultClass!accessing!private! !
!SSWSQLFunction categoriesFor: #staticResultClass:!accessing!private! !
!SSWSQLFunction categoriesFor: #targetClassForFunctionField:!accessing!public! !

!SSWSQLFunction class methodsFor!

new

	^super new initialize! !
!SSWSQLFunction class categoriesFor: #new!instance creation!public! !


"Filed out from Dolphin Smallalk"!

Object subclass: #GenericTest
	instanceVariableNames: 'name component'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'componentDefinition reStoreIDClass'!
GenericTest guid: (GUID fromString: '{2c37a8c4-fe10-4775-9f44-50dd5f8c3d0f}')!
GenericTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!GenericTest categoriesForClass!Unclassified! !
!GenericTest methodsFor!

= a

	^self name = a name!

addToMultiKeyDictionary: aTest

	^(self component at: aTest key ifAbsentPut: [OrderedCollection new]) add: aTest!

addToSingleKeyDictionary: aTest

	^self component at: aTest key put: aTest!

component
	^component!

component: anObject
	component := anObject!

hash

	^self name hash!

name
	^name!

name: anObject
	name := anObject! !
!GenericTest categoriesForMethods!
=!comparing!public! !
addToMultiKeyDictionary:!adding!public! !
addToSingleKeyDictionary:!adding!public! !
component!accessing!private! !
component:!accessing!private! !
hash!comparing!public! !
name!accessing!private! !
name:!accessing!private! !
!

!GenericTest class methodsFor!

componentDefinition: anObject

	componentDefinition := anObject

	!

reStoreDefinition

	^super reStoreDefinition 
		define: #name as: (String maxSize: 128);
		define: #component as: componentDefinition;
		yourself!

reStoreIDClass
	^reStoreIDClass ifNil: [super reStoreIDClass]!

reStoreIDClass: anObject
	reStoreIDClass := anObject! !
!GenericTest class categoriesForMethods!
componentDefinition:!public! !
reStoreDefinition!public! !
reStoreIDClass!accessing!public! !
reStoreIDClass:!accessing!private! !
!


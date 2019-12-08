"Filed out from Dolphin Smalltalk 7"!

Object subclass: #GenericTest
	instanceVariableNames: 'name component'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'componentDefinition'!
GenericTest guid: (GUID fromString: '{2c37a8c4-fe10-4775-9f44-50dd5f8c3d0f}')!
GenericTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!GenericTest categoriesForClass!Unclassified! !
!GenericTest methodsFor!

component
	^component!

component: anObject
	component := anObject!

name
	^name!

name: anObject
	name := anObject! !
!GenericTest categoriesFor: #component!accessing!private! !
!GenericTest categoriesFor: #component:!accessing!private! !
!GenericTest categoriesFor: #name!accessing!private! !
!GenericTest categoriesFor: #name:!accessing!private! !

!GenericTest class methodsFor!

componentDefinition: anObject

	componentDefinition := anObject

	!

reStoreDefinition

	^super reStoreDefinition 
		define: #name as: (String maxSize: 128);
		define: #component as: componentDefinition;
		yourself! !
!GenericTest class categoriesFor: #componentDefinition:!public! !
!GenericTest class categoriesFor: #reStoreDefinition!public! !


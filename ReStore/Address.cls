"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Address
	instanceVariableNames: 'line1 postcode country'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Address guid: (GUID fromString: '{7498583d-34c1-4ee5-81e0-e582c824f97a}')!
Address comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!Address categoriesForClass!Unclassified! !
!Address methodsFor!

country
	^country!

country: anObject
	country := anObject!

line1
	^line1!

line1: anObject
	line1 := anObject!

postcode
	^postcode!

postcode: anObject
	postcode := anObject! !
!Address categoriesFor: #country!accessing!private! !
!Address categoriesFor: #country:!accessing!private! !
!Address categoriesFor: #line1!accessing!private! !
!Address categoriesFor: #line1:!accessing!private! !
!Address categoriesFor: #postcode!accessing!private! !
!Address categoriesFor: #postcode:!accessing!private! !

!Address class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #line1 as: (String maxSize: 100);
		define: #postcode as: (String maxSize: 16);
		define: #country as: (String maxSize: 100);
		yourself.! !
!Address class categoriesFor: #reStoreDefinition!public! !


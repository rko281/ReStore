"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Product
	instanceVariableNames: 'name description'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Product guid: (GUID fromString: '{2f477660-b7a9-4c4a-80e3-38f01aa7c7a6}')!
Product comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!Product categoriesForClass!Unclassified! !
!Product methodsFor!

description
	^description!

description: anObject
	description := anObject!

displayOn: aStream

	aStream nextPutAll: self name!

name
	^name!

name: anObject
	name := anObject!

printOn: aStream
	"Answer the name of the receiver as a developer would wish to see it ."

	super printOn: aStream.
	aStream nextPut: $(.
	self displayOn: aStream.
	aStream nextPut: $).! !
!Product categoriesFor: #description!accessing!private! !
!Product categoriesFor: #description:!accessing!private! !
!Product categoriesFor: #displayOn:!printing!public! !
!Product categoriesFor: #name!accessing!private! !
!Product categoriesFor: #name:!accessing!private! !
!Product categoriesFor: #printOn:!printing!public! !

!Product class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #name as: (String maxSize: 100);
		define: #description as: String;
		yourself.! !
!Product class categoriesFor: #reStoreDefinition!public! !


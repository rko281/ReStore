"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Where
	instanceVariableNames: 'select'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Where guid: (GUID fromString: '{0783dcd9-73c1-44a9-9a65-01b9c221dfc6}')!
Where comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!Where categoriesForClass!Kernel-Objects! !
!Where methodsFor!

select
	^select!

select: anObject
	select := anObject! !
!Where categoriesFor: #select!accessing!private! !
!Where categoriesFor: #select:!accessing!private! !

!Where class methodsFor!

reStoreDefinition

	"This class just exists to check name handling on a SQL reserved word"

	^super reStoreDefinition
		define: #select as: Integer;
		yourself! !
!Where class categoriesFor: #reStoreDefinition!public! !


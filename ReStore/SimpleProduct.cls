"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SimpleProduct
	instanceVariableNames: 'description supplierPrice retailPrice'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SimpleProduct guid: (GUID fromString: '{6eef3f0c-7b31-4ea4-a5ba-af29de14c4bb}')!
SimpleProduct comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SimpleProduct categoriesForClass!Unclassified! !
!SimpleProduct methodsFor!

description
	^description!

description: anObject
	description := anObject!

markUp

	^self retailPrice - self supplierPrice!

profitMargin

	^((self markUp * 100) / self supplierPrice) rounded!

retailPrice
	^retailPrice!

retailPrice: anObject
	retailPrice := anObject!

supplierPrice
	^supplierPrice!

supplierPrice: anObject
	supplierPrice := anObject! !
!SimpleProduct categoriesFor: #description!accessing!private! !
!SimpleProduct categoriesFor: #description:!accessing!private! !
!SimpleProduct categoriesFor: #markUp!calculating!public! !
!SimpleProduct categoriesFor: #profitMargin!calculating!public! !
!SimpleProduct categoriesFor: #retailPrice!accessing!private! !
!SimpleProduct categoriesFor: #retailPrice:!accessing!private! !
!SimpleProduct categoriesFor: #supplierPrice!accessing!private! !
!SimpleProduct categoriesFor: #supplierPrice:!accessing!private! !

!SimpleProduct class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #description as: (String maxSize: 100);
		define: #supplierPrice as: (ScaledDecimal withScale: 2);
		define: #retailPrice as: (ScaledDecimal withScale: 2);
		yourself! !
!SimpleProduct class categoriesFor: #reStoreDefinition!public! !


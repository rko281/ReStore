"Filed out from Dolphin Smalltalk 7"!

Object subclass: #InlinedTestPerson
	instanceVariableNames: 'firstName surname address1 address2 address3 line1 code1 bankBalance'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
InlinedTestPerson guid: (GUID fromString: '{a864ebd8-06ec-4b13-8138-21e57afd3093}')!
InlinedTestPerson comment: 'ReStore
©2020 John Aspinall
https://github.com/rko281/ReStore'!
!InlinedTestPerson categoriesForClass!Unclassified! !
!InlinedTestPerson methodsFor!

address1
	^address1!

address1: anObject
	address1 := anObject!

address2
	^address2!

address2: anObject
	address2 := anObject!

address3
	^address3!

address3: anObject
	address3 := anObject!

bankBalance
	^bankBalance!

bankBalance: anObject
	bankBalance := anObject!

bankBalanceString
	^bankBalance displayString!

code1
	^code1!

code1: anObject
	code1 := anObject!

firstName
	^firstName!

firstName: anObject
	firstName := anObject!

line1
	^line1!

line1: anObject
	line1 := anObject!

surname
	^surname!

surname: anObject
	surname := anObject! !
!InlinedTestPerson categoriesFor: #address1!accessing!private! !
!InlinedTestPerson categoriesFor: #address1:!accessing!private! !
!InlinedTestPerson categoriesFor: #address2!accessing!private! !
!InlinedTestPerson categoriesFor: #address2:!accessing!private! !
!InlinedTestPerson categoriesFor: #address3!accessing!private! !
!InlinedTestPerson categoriesFor: #address3:!accessing!private! !
!InlinedTestPerson categoriesFor: #bankBalance!accessing!private! !
!InlinedTestPerson categoriesFor: #bankBalance:!accessing!private! !
!InlinedTestPerson categoriesFor: #bankBalanceString!accessing!private! !
!InlinedTestPerson categoriesFor: #code1!accessing!private! !
!InlinedTestPerson categoriesFor: #code1:!accessing!private! !
!InlinedTestPerson categoriesFor: #firstName!accessing!private! !
!InlinedTestPerson categoriesFor: #firstName:!accessing!private! !
!InlinedTestPerson categoriesFor: #line1!accessing!private! !
!InlinedTestPerson categoriesFor: #line1:!accessing!private! !
!InlinedTestPerson categoriesFor: #surname!accessing!private! !
!InlinedTestPerson categoriesFor: #surname:!accessing!private! !

!InlinedTestPerson class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #firstName as: (String maxSize: 64);
		define: #surname as: (String maxSize: 96);
		define: #address1 as: InlinedAddress inlined;
		define: #address2 as: InlinedAddress inlined;
		define: #address3 as: SimpleAddress;
		define: #line1 as: (String maxSize: 64);
		define: #code1 as: (String maxSize: 64);
		define: #bankBalance as: NumberWithCurrency "<- always inlined"! !
!InlinedTestPerson class categoriesFor: #reStoreDefinition!public! !


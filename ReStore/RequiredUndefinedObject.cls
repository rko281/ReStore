"Filed out from Dolphin Smalltalk 7"!

Object subclass: #RequiredUndefinedObject
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'soleInstance'!
RequiredUndefinedObject guid: (GUID fromString: '{2abef0f0-30cf-4b9b-b857-72f45a62297d}')!
RequiredUndefinedObject comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!RequiredUndefinedObject categoriesForClass!Kernel-Objects! !
!RequiredUndefinedObject methodsFor!

= anObject

	^anObject isNil!

hash

	^nil hash!

isRequiredForSimilarity

	"This is the purpose of the receiver"
	^true!

orNilIfEmpty

	^self!

printOn: aStream

	aStream nextPutAll: 'nil (required)'!

qualify: instances in: aReStore via: aCollection

	^instances qualifyWith: [ :each | (each chainPerform: aCollection) = nil]!

reStoreValue

	^nil!

writeSQLOn: aStream forCondition: aSQLCondition

	nil writeSQLOn: aStream forCondition: aSQLCondition! !
!RequiredUndefinedObject categoriesFor: #=!comparing!public! !
!RequiredUndefinedObject categoriesFor: #hash!comparing!public! !
!RequiredUndefinedObject categoriesFor: #isRequiredForSimilarity!public!testing! !
!RequiredUndefinedObject categoriesFor: #orNilIfEmpty!accessing!public! !
!RequiredUndefinedObject categoriesFor: #printOn:!printing!public! !
!RequiredUndefinedObject categoriesFor: #qualify:in:via:!accessing!public! !
!RequiredUndefinedObject categoriesFor: #reStoreValue!accessing!public! !
!RequiredUndefinedObject categoriesFor: #writeSQLOn:forCondition:!printing!public! !

!RequiredUndefinedObject class methodsFor!

soleInstance

	soleInstance isNil ifTrue: [soleInstance := self basicNew].

	^soleInstance! !
!RequiredUndefinedObject class categoriesFor: #soleInstance!accessing!public! !


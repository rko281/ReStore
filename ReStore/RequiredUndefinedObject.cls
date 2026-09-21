"Filed out from Dolphin Smalltalk"!

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

isSQLNull

	^true!

orNilIfEmpty

	^self!

printOn: aStream

	aStream nextPutAll: 'nil (required)'!

qualify: instances in: aReStore via: aCollection

	^instances qualifyWith: [ :each | (each chainPerform: aCollection) = nil]!

reStoreValue

	^nil!

writeHardCodedSQLOn: aStream

	nil writeSQLOn: aStream!

writeSQLOn: aStream forCondition: aSQLCondition

	nil writeSQLOn: aStream forCondition: aSQLCondition! !

!RequiredUndefinedObject categoriesForMethods!
=!comparing!public! !
hash!comparing!public! !
isRequiredForSimilarity!public!testing! !
isSQLNull!public!testing! !
orNilIfEmpty!accessing!public! !
printOn:!printing!public! !
qualify:in:via:!accessing!public! !
reStoreValue!accessing!public! !
writeHardCodedSQLOn:!printing!public! !
writeSQLOn:forCondition:!printing!public! !
!

!RequiredUndefinedObject class methodsFor!

soleInstance

	soleInstance isNil ifTrue: [soleInstance := self basicNew].

	^soleInstance! !

!RequiredUndefinedObject class categoriesForMethods!
soleInstance!accessing!public! !
!


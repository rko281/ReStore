"Filed out from Dolphin Smallalk"!

SSWDBDirectlyPersistedObject subclass: #TestBitmask
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TestBitmask guid: (GUID fromString: '{dbef9750-8147-4e9b-9aa5-2a99f122d8a2}')!
TestBitmask comment: ''!
!TestBitmask categoriesForClass!Kernel-Objects! !
!TestBitmask methodsFor!

bitAnd2

	^self value & 2!

bitSet: anInteger

	value := value setBit: anInteger!

initialize

	value := 0!

isBitSet: anInteger

	"Implement directly for database in form that can be translated to SQL for queries"

	^self 
		imageDo: [self value isBitSet: anInteger] 
		databaseDo: [(self value & (2 ** (anInteger - 1))) > 0]!

reStoreValue

	^self value!

value
	^value!

value: anObject
	value := anObject! !
!TestBitmask categoriesForMethods!
bitAnd2!public! !
bitSet:!public! !
initialize!initialize/release!public! !
isBitSet:!public!testing! !
reStoreValue!accessing!public! !
value!accessing!private! !
value:!accessing!private! !
!

!TestBitmask class methodsFor!

fromReStoreValue: aValue

	^aValue ifNotNil: 
		[self new 
			value: aValue;
			yourself]!

hasMutablePersistentInstances

	^true!

new
	^super new initialize!

reStoreValueClass

	^Integer!

value: anInteger

	^self new 
		value: anInteger; 
		yourself! !
!TestBitmask class categoriesForMethods!
fromReStoreValue:!instance creation!public! !
hasMutablePersistentInstances!public!testing! !
new!instance creation!public! !
reStoreValueClass!accessing!public! !
value:!instance creation!public! !
!


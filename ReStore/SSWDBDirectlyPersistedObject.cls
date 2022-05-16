"Filed out from Dolphin Smallalk"!

Object subclass: #SSWDBDirectlyPersistedObject
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBDirectlyPersistedObject guid: (GUID fromString: '{912d4de6-f66a-4e8e-b720-0b7631416623}')!
SSWDBDirectlyPersistedObject comment: ''!
!SSWDBDirectlyPersistedObject categoriesForClass!Kernel-Objects! !
!SSWDBDirectlyPersistedObject methodsFor!

<= anObject

	"Directly persisted objects should always be compared based on their reStoreValue"

	^self reStoreValue <= anObject reStoreValue!

= anObject

	"Directly persisted objects should always be compared based on their reStoreValue"

	^self reStoreValue = anObject reStoreValue!

hash

	^self reStoreValue hash!

isValidForPersistence

	^true!

reStoreValue

	"Return the value used to represent the receiver in the database.
	Should be an instance of this class's reStoreValueClass"

	^self subclassResponsibility! !
!SSWDBDirectlyPersistedObject categoriesForMethods!
<=!public! !
=!comparing!public! !
hash!comparing!public! !
isValidForPersistence!public!testing! !
reStoreValue!accessing!public! !
!

!SSWDBDirectlyPersistedObject class methodsFor!

fromReStoreValue: aValue

	"Return an instance of the receiver generated from aValue (an instance of the receiver's reStoreValueClass)"

	^self subclassResponsibility!

hasMutablePersistentInstances

	"Are instances of this class mutable (at least from the database's point of view)"

	^false!

instanceFromDBValue: aValue in: aReStore

	"Return an instance of the receiver generated from aValue (an instance of the receiver's reStoreValueClass) read from aReStore"

	"Ususally aReStore is irrelevant"
	^self fromReStoreValue: aValue!

isDirectlyPersisted

	^true!

reStoreInstVarAccessor

	^self hasMutablePersistentInstances
		ifTrue: [SSWMutableInstVarAccessor new]
		ifFalse: [super reStoreInstVarAccessor]!

reStoreValueClass

	"Return the class of object of which instances of the receiver are persisted in the database, i.e. the class of an instance's reStoreValue"

	^self subclassResponsibility!

writeSQLTypeOn: aStream using: anSQLDialect

	self reStoreValueClass writeSQLTypeOn: aStream using: anSQLDialect! !
!SSWDBDirectlyPersistedObject class categoriesForMethods!
fromReStoreValue:!instance creation!public! !
hasMutablePersistentInstances!public!testing! !
instanceFromDBValue:in:!instance creation!public! !
isDirectlyPersisted!public!testing! !
reStoreInstVarAccessor!persistency!public! !
reStoreValueClass!accessing!public! !
writeSQLTypeOn:using:!printing!public! !
!


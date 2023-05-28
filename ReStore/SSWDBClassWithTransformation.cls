"Filed out from Dolphin Smalltalk"!

SSWDBClassWithInfo subclass: #SSWDBClassWithTransformation
	instanceVariableNames: 'databaseClass toDatabaseTransformation toImageTransformation hasValueChangedBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBClassWithTransformation guid: (GUID fromString: '{53591898-aced-4941-bc40-9fbe59bc8c17}')!
SSWDBClassWithTransformation comment: ''!
!SSWDBClassWithTransformation categoriesForClass!Unclassified! !
!SSWDBClassWithTransformation methodsFor!

databaseClass
	^databaseClass!

databaseClass: anObject
	databaseClass := anObject!

hasValueChangedBlock
	^hasValueChangedBlock!

hasValueChangedBlock: anObject
	hasValueChangedBlock := anObject!

infoClass

	^self databaseClass!

toDatabaseTransformation
	^toDatabaseTransformation!

toDatabaseTransformation: anObject
	toDatabaseTransformation := anObject!

toImageTransformation
	^toImageTransformation!

toImageTransformation: anObject
	toImageTransformation := anObject!

writeSQLTypeOn: aStream  using: anSQLDialect

	self databaseClass writeSQLTypeOn: aStream  using: anSQLDialect! !
!SSWDBClassWithTransformation categoriesForMethods!
databaseClass!accessing!private! !
databaseClass:!accessing!private! !
hasValueChangedBlock!accessing!private! !
hasValueChangedBlock:!accessing!private! !
infoClass!accessing!public! !
toDatabaseTransformation!accessing!private! !
toDatabaseTransformation:!accessing!private! !
toImageTransformation!accessing!private! !
toImageTransformation:!accessing!private! !
writeSQLTypeOn:using:!printing!public! !
!


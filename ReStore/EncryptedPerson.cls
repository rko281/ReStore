"Filed out from Dolphin Smalltalk"!

Object subclass: #EncryptedPerson
	instanceVariableNames: 'name dateOfBirth identifier isEncrypted'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EncryptedPerson guid: (GUID fromString: '{8e81dff0-ed61-4db6-9d85-d8fa145a66ce}')!
EncryptedPerson comment: ''!
!EncryptedPerson categoriesForClass!Unclassified! !
!EncryptedPerson methodsFor!

dateOfBirth
	^dateOfBirth!

dateOfBirth: anObject
	dateOfBirth := anObject!

identifier
	^identifier!

identifier: anObject
	identifier := anObject!

isEncrypted
	^isEncrypted!

isEncrypted: anObject
	isEncrypted := anObject!

name
	^name!

name: anObject
	name := anObject!

onAboutToStore

	self isEncrypted ifFalse: [self isEncrypted: true]! !
!EncryptedPerson categoriesForMethods!
dateOfBirth!accessing!private! !
dateOfBirth:!accessing!private! !
identifier!accessing!private! !
identifier:!accessing!private! !
isEncrypted!accessing!private! !
isEncrypted:!accessing!private! !
name!accessing!private! !
name:!accessing!private! !
onAboutToStore!public! !
!

!EncryptedPerson class methodsFor!

new

	^super new 
		isEncrypted: true;
		yourself!

reStoreDefinition

	^super reStoreDefinition
		define: #isEncrypted as: Boolean;
		define: #identifier as: (String maxSize: 64);
		define: #name as: 
			(SSWDBClassWithTransformation new 
				databaseClass: (ByteArray maxSize: 2048); 
				toDatabaseTransformation: [ :value | value ifNotNil: [(Crypt32Library protectData: value) asByteArray]];
				toImageTransformation: [ :value :obj | value ifNotNil: [obj isEncrypted ifTrue: [(Crypt32Library unprotectData: value) asString] ifFalse: [value asString]]];
				hasValueChangedBlock: [ :current :previous | previous isEncrypted ifTrue: [nil "default check"] ifFalse: [true "force change and encryption"]];
				yourself);
		define: #dateOfBirth as: 
			(SSWDBClassWithTransformation new 
				databaseClass: (ByteArray maxSize: 2048); 
				toDatabaseTransformation: [ :value | value ifNotNil: [(Crypt32Library protectData: (value printStringFormat: 'yyyy-MM-dd')) asByteArray]];
				toImageTransformation: [ :value | value ifNotNil: [Date fromString: (Crypt32Library unprotectData: value) asString format: 'yyyy-MM-dd']];
				yourself)! !
!EncryptedPerson class categoriesForMethods!
new!public! !
reStoreDefinition!public! !
!


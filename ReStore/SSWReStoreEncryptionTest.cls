"Filed out from Dolphin Smalltalk"!

SSWReStoreTest subclass: #SSWReStoreEncryptionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWReStoreEncryptionTest guid: (GUID fromString: '{ffb085fa-ac6e-46ea-9a06-d6ed205cce10}')!
SSWReStoreEncryptionTest comment: ''!
!SSWReStoreEncryptionTest categoriesForClass!Unclassified! !
!SSWReStoreEncryptionTest methodsFor!

addClassesTo: aReStore

	aReStore addClass: EncryptedPerson!

testAutoEncryption

	"Test that unencrypted data in the database is automatically encrypted when the object is updated"

	| person |

	"Create unencrypted object directly in database and validate. Note we actually use a ByteArray for the name field since some databases (e.g. SQLite) terminate the data at a zero if we use a String (presumbly treat it as null-terminated)"
	reStore executeSQLAsTxn: #('insert into encrypted_person (id_, identifier, is_encrypted, name) values (99, "testAutoEncryption", 0, "Tim Smith")').
	self assert: ((reStore executeSQL: 'select * from encrypted_person where identifier = "testAutoEncryption"') results first at: 'name') equals: 'Tim Smith' asByteArray.

	"Test reading of unencrypted data"
	person := (EncryptedPerson storedInstancesIn: reStore) detect: [ :each | each identifier = 'testAutoEncryption'].
	self deny: person isEncrypted.
	self assert: person name equals: 'Tim Smith'.

	"Update a different field"
	person dateOfBirth: (Date newDay: 1 monthIndex: 2 year: 1993); storeIn: reStore.
	reStore simulateReconnect.

	person := (EncryptedPerson storedInstancesIn: reStore) detect: [ :each | each identifier = 'testAutoEncryption'].
	self assert: person isEncrypted.
	self assert: person dateOfBirth equals: (Date newDay: 1 monthIndex: 2 year: 1993).

	"Validate data in database is encrypted"
	self assert: (Crypt32Library unprotectData: ((reStore executeSQL: 'select * from encrypted_person where identifier = "testAutoEncryption"') results first at: 'name')) equals: 'Tim Smith'.
	self assert: (Crypt32Library unprotectData: ((reStore executeSQL: 'select * from encrypted_person where identifier = "testAutoEncryption"') results first at: 'date_of_birth')) equals: ((Date newDay: 1 monthIndex: 2 year: 1993) printStringFormat: 'yyyy-MM-dd')!

testStoreNew

	| person |

	EncryptedPerson new 
		identifier: 'testStoreNew';
		name: 'John Smith'; 
		storeIn: reStore.

	person := (EncryptedPerson storedInstancesIn: reStore) detect: [ :each | each identifier = 'testStoreNew'].
	self assert: person name equals: 'John Smith'.
	self assert: person dateOfBirth isNil.

	"Validate data in database is encrypted"
	self assert: (Crypt32Library unprotectData: ((reStore executeSQL: 'select * from encrypted_person where identifier = "testStoreNew"') results first at: 'name')) equals: 'John Smith'!

testStoreUpdate

	| person |

	EncryptedPerson new 
		identifier: 'testStoreUpdate';
		name: 'Dave Smith'; 
		storeIn: reStore.

	person := (EncryptedPerson storedInstancesIn: reStore) detect: [ :each | each identifier = 'testStoreUpdate'].
	person dateOfBirth: (Date newDay: 1 monthIndex: 2 year: 1993); storeIn: reStore.

	reStore simulateReconnect.
	person := (EncryptedPerson storedInstancesIn: reStore) detect: [ :each | each identifier = 'testStoreUpdate'].
	self assert: person dateOfBirth equals: (Date newDay: 1 monthIndex: 2 year: 1993).

	"Validate data in database is encrypted"
	self assert: (Crypt32Library unprotectData: ((reStore executeSQL: 'select * from encrypted_person where identifier = "testStoreUpdate"') results first at: 'name')) equals: 'Dave Smith'.
	self assert: (Crypt32Library unprotectData: ((reStore executeSQL: 'select * from encrypted_person where identifier = "testStoreUpdate"') results first at: 'date_of_birth')) equals: ((Date newDay: 1 monthIndex: 2 year: 1993) printStringFormat: 'yyyy-MM-dd')! !
!SSWReStoreEncryptionTest categoriesForMethods!
addClassesTo:!public! !
testAutoEncryption!public!unit tests! !
testStoreNew!public!unit tests! !
testStoreUpdate!public!unit tests! !
!


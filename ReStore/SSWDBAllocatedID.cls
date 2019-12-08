"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SSWDBAllocatedID
	instanceVariableNames: 'tableRecord offset object'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBAllocatedID guid: (GUID fromString: '{292d171b-7777-42db-b0d3-5ad4b6bc5385}')!
SSWDBAllocatedID comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBAllocatedID categoriesForClass!Kernel-Objects! !
!SSWDBAllocatedID methodsFor!

asInteger

	^self id!

id

	^self nextID + self offset!

nextID

	"tableRecord should always be a proxy at this point"
	^self tableRecord _proxiedObject nextID!

object
	^object!

object: anObject
	object := anObject!

offset
	^offset!

offset: anObject
	offset := anObject!

postCommit

	"Update the object with the real ID and update the ReStore cache to match"

	self object _id: self id.

	"object may be a persistent object (in which case immediately post-commit it will be a proxy) or a collection entry (not a proxy and not stored in ReStore cache)"
	self object isDBProxy ifTrue: 
		[(self object _reStore classCacheFor: self object class) 
			at: self object _id put: self object;
			removeKey: self]!

reStoreValue

	^self id!

tableRecord
	^tableRecord!

tableRecord: anObject
	tableRecord := anObject!

writeSQLOn: aStream

	self id writeSQLOn: aStream! !
!SSWDBAllocatedID categoriesFor: #asInteger!converting!public! !
!SSWDBAllocatedID categoriesFor: #id!accessing!public! !
!SSWDBAllocatedID categoriesFor: #nextID!accessing!public! !
!SSWDBAllocatedID categoriesFor: #object!accessing!private! !
!SSWDBAllocatedID categoriesFor: #object:!accessing!private! !
!SSWDBAllocatedID categoriesFor: #offset!accessing!private! !
!SSWDBAllocatedID categoriesFor: #offset:!accessing!private! !
!SSWDBAllocatedID categoriesFor: #postCommit!operations!public! !
!SSWDBAllocatedID categoriesFor: #reStoreValue!accessing!public! !
!SSWDBAllocatedID categoriesFor: #tableRecord!accessing!private! !
!SSWDBAllocatedID categoriesFor: #tableRecord:!accessing!private! !
!SSWDBAllocatedID categoriesFor: #writeSQLOn:!printing!public! !


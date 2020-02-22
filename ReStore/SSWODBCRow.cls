"Filed out from Dolphin Smalltalk 7"!

DBRow subclass: #SSWODBCRow
	instanceVariableNames: 'fieldMap'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWODBCRow guid: (GUID fromString: '{a08f875a-3b6c-4962-9633-730ff9ab89b2}')!
SSWODBCRow comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWODBCRow categoriesForClass!Kernel-Objects! !
!SSWODBCRow methodsFor!

atField: aField

	^self atField: aField ifAbsent: [nil]
!

atField: aField ifAbsent: aBlock

	^fieldMap at: aField ifAbsent: aBlock!

initializeFromBuffer: anSSWODBCBuffer

	super initializeFromBuffer: anSSWODBCBuffer.

	fieldMap := Dictionary new: columns size * 2.
	columns with: contents do: [ :col :obj | col field ifNotNil: [ :field | fieldMap at: field put: obj]]! !
!SSWODBCRow categoriesFor: #atField:!accessing!public! !
!SSWODBCRow categoriesFor: #atField:ifAbsent:!accessing!public! !
!SSWODBCRow categoriesFor: #initializeFromBuffer:!initializing!public! !


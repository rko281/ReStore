"Filed out from Dolphin Smalltalk"!

SSWDBStaticField subclass: #SSWDBIDField
	instanceVariableNames: 'dataField'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBIDField guid: (GUID fromString: '{ed39134a-481a-4378-9585-42a5257e3504}')!
SSWDBIDField comment: ''!
!SSWDBIDField categoriesForClass!Unclassified! !
!SSWDBIDField methodsFor!

accesses: aSymbol

	"Additionally check the dataField"
	
	^(super accesses: aSymbol) or: [dataField notNil and: [dataField accesses: aSymbol]]!

accessInstVarNamed: aSymbol

	"Configure the receiver to access the target class's inst var named aSymbol, in addition to the proxy's id value"

	self dataField: 
		(SSWDBDataField new
			name: self name;
			table: self table;
			targetClass: self targetClass;
			accessor: ((self targetClass reStoreInstVarAccessorIn: self sqlDialect) access: aSymbol in: self table instanceClass);
			yourself)!

dataField

	"dataField optionally stores an SSWDBDataField that relates to an instance variable holding the ID value in an actual persistent object (in addition to its proxy).

	By default this is nil - persistent objects do not normally store their ID"

	^dataField!

dataField: anSSWDBDataField

	"dataField optionally stores an SSWDBDataField that relates to an instance variable holding the ID value in an actual persistent object (in addition to its proxy).

	By default this is nil - persistent objects do not normally store their ID"

	dataField := anSSWDBDataField!

initialize

	super initialize.

	self accessor: SSWDBIDAccessor new!

lookupIn: aDBRow

	^aDBRow lookupIDField: self!

populateObject: anObject with: aValue

	dataField ifNotNil: [ :df | df populateObject: anObject with: aValue]! !
!SSWDBIDField categoriesForMethods!
accesses:!public!testing! !
accessInstVarNamed:!initialize/release!public! !
dataField!accessing!public! !
dataField:!accessing!public! !
initialize!initialize/release!public! !
lookupIn:!accessing!public! !
populateObject:with:!actions!private! !
!


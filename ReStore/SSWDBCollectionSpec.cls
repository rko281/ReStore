"Filed out from Dolphin Smallalk"!

SSWDBTableComponent subclass: #SSWDBCollectionSpec
	instanceVariableNames: 'templateCollection isValueDependent isValueRelated readStatement refreshStatement refreshWithContentsIfUpdatedStatement deleteStatement'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBCollectionSpec guid: (GUID fromString: '{266e4dd1-398e-11d5-b1df-444553540000}')!
SSWDBCollectionSpec comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBCollectionSpec categoriesForClass!Unclassified! !
!SSWDBCollectionSpec methodsFor!

applyTo: anObject withID: anInteger in: anSSWReStore

	"'Apply' the one-to-many relationship expressed by this object to the 'one' object anObject.
	This is done by assigning (using the receiver's accessor) a suitable proxy that can
	recover the collection of 'many' objects relating to anObject"
	
	| proxyCollection |
	
	proxyCollection := self collectionProxyClass new.
	proxyCollection
		_reStore: anSSWReStore;
		_collectionSpec: self.
	
	self accessor value: proxyCollection in: anObject!

beValueDependent

	isValueDependent := true!

beValueRelated

	isValueRelated := true!

beValueUnrelated

	isValueRelated := false!

collectionClass

	^self templateCollection class!

collectionProxyClass

	"Return the class of collection proxy to use for collections created by the receiver"
	
	^self subclassResponsibility!

containedTables

	"By default, no tables are contained"

	^#()!

dbInstancesFor: aCollectionProxy

	"Return a DBInstancesCollection representing the instances owned by aCollectionProxy
	and specified by the receiver"

	^self subclassResponsibility!

defineAs: aSymbol in: anSSWDBTable

	"The receiver has been specified as the kind of object held in inst var named aSymbol
	for the class whose DB table is anSSWDBTable.

	Add the receiver to anSSWDBTable returning the object created"

	^anSSWDBTable define: aSymbol asCollectionSpec: self
!

deleteQuery

	"Return a SQL query for deleting the elements of this collection"

	^self subclassResponsibility!

deleteStatement

	"Return a prepared statement for deleting this collection"

	^deleteStatement ifNil: [deleteStatement := self reStore prepareStatementForQuery: self deleteQuery]!

freePreparedStatements

	readStatement notNil ifTrue: [readStatement free].
	readAllStatement notNil ifTrue: [readAllStatement free].
	refreshStatement notNil ifTrue: [refreshStatement free].
	refreshWithContentsIfUpdatedStatement notNil ifTrue: [refreshWithContentsIfUpdatedStatement free].

	readStatement := nil.
	readAllStatement := nil.
	refreshStatement := nil.
	refreshWithContentsIfUpdatedStatement := nil!

initialize

	super initialize.

	isValueDependent := false.
	isValueRelated := false!

isKeyDependent

	"isKeyDependent indicates whether the key objects of the specified collection are dependent on the existence of the owner of that collection for their own existence.
	False by default since not all collections support keys; subclasses may override.

	c.f. isValueDependent (key and value terminology taken from keysAndValuesDo:)"

	^false!

isKeyRelated

	"isKeyRelated indicates whether the key elements of the collection represented by the receiver are related to the owning/source object.
	False by default since not all collections support keys; subclasses may override.

	c.f. isValueDependent (key and value terminology taken from keysAndValuesDo:)"

	^false!

isRelated

	^self isValueRelated or: [self isKeyRelated]!

isValueDependent

	"isValueDependent indicates whether the value objects of the specified collection are dependent on the existence of the owner of that collection for their own existence.
	c.f. isKeyDependent (key and value terminology taken from keysAndValuesDo:)"

	^isValueDependent!

isValueRelated

	"isValueRelated indicates whether elements of the collection represented by the receiver are related to the owning/source object, such that they will be commited/rolled-back with that object when withRelatedComponents is used.
	c.f. isKeyRelated (key and value terminology taken from keysAndValuesDo:)"

	^isValueRelated!

newCollection

	^self templateCollection copy!

newProxydCollectionFor: aProxyObject

	^self collectionProxyClass new
		_reStore: aProxyObject _reStore;
		_owner: aProxyObject;
		_collectionSpec: self;
		yourself!

readQuery

	"Return a SQL query for reading this collection"

	^self subclassResponsibility!

readStatement

	"Return a prepared statement for reading this collection"

	^readStatement ifNil: [readStatement := self reStore prepareStatementForQuery: self readQuery]!

recoverCollectionForProxy: aCollectionProxy

	"Recover and return the collection defined by the receiver 
	that is wrappered by the given collection proxy"

	^self subclassResponsibility!

refreshCollectionForProxy: aCollectionProxy

	"Refresh as opposed to read - just fetch the IDs. 
	Return the refreshed contents, i.e. none"

	^self subclassResponsibility!

refreshCollectionIfUpdatedForProxy: aCollectionProxy

	"No versioning on collections themselves, so revert to a standard refresh"

	^self refreshCollectionForProxy: aCollectionProxy!

refreshCollectionWithContentsForProxy: aCollectionProxy

	"Refresh the receiver collection and its contents. Essentially, the same as recovering the collection.
	Return the refreshed contents, i.e. the collection itself"

	^self recoverCollectionForProxy: aCollectionProxy!

refreshCollectionWithContentsIfUpdatedForProxy: aCollectionProxy

	"Refresh the receiver collection and its contents if they have been updated
	Return the refreshed contents, i.e. the collection itself"

	^self subclassResponsibility!

refreshQuery

	"Return a SQL query for refreshing this collection"

	^self subclassResponsibility!

refreshStatement

	"Return a prepared statement for refreshing this collection"

	^refreshStatement ifNil: [refreshStatement := self reStore prepareStatementForQuery: self refreshQuery]!

refreshWithContentsIfUpdatedQuery

	"Return a SQL query for refreshing this collection together with its updated contents"

	^self subclassResponsibility!

refreshWithContentsIfUpdatedStatement

	"Return a prepared statement for refreshing this collection together with its updated contents"

	^refreshWithContentsIfUpdatedStatement ifNil: [refreshWithContentsIfUpdatedStatement := self reStore prepareStatementForQuery: self refreshWithContentsIfUpdatedQuery]!

relatedComponentsOf: anObject do: aBlock

	"We consider a collection always related to the source object since, in ReStore, a collection cannot exist without the source object.
	NB - we are referring to the collection itself, not its elements - these may or may not be related, see isValueRelated / isKeyRelated"

	self componentsOf: anObject do: aBlock!

targetClass

	"The homogeous (super)class of elements of the receiver"

	^self subclassResponsibility!

templateCollection

	"collection stores an empty collection that is used as the template 
	for collections created by this class (i.e. a copy of templateCollection is used)"
	
	^templateCollection!

templateCollection: aCollection

	"collection stores an empty collection that is used as the template 
	for collections created by this class (i.e. a copy of templateCollection is used)"
	
	templateCollection := aCollection! !
!SSWDBCollectionSpec categoriesForMethods!
applyTo:withID:in:!actions!public! !
beValueDependent!defining!public! !
beValueRelated!defining!public! !
beValueUnrelated!defining!public! !
collectionClass!evaluating!public! !
collectionProxyClass!constants!public! !
containedTables!evaluating!public! !
dbInstancesFor:!evaluating!public! !
defineAs:in:!defining!public! !
deleteQuery!accessing-queries!public! !
deleteStatement!accessing!public! !
freePreparedStatements!initialize/release!public! !
initialize!initialize/release!public! !
isKeyDependent!public!testing! !
isKeyRelated!public!testing! !
isRelated!public!testing! !
isValueDependent!public!testing! !
isValueRelated!public!testing! !
newCollection!evaluating!public! !
newProxydCollectionFor:!evaluating!public! !
readQuery!accessing-queries!public! !
readStatement!accessing!public! !
recoverCollectionForProxy:!actions!public! !
refreshCollectionForProxy:!actions!public! !
refreshCollectionIfUpdatedForProxy:!actions!public! !
refreshCollectionWithContentsForProxy:!actions!public! !
refreshCollectionWithContentsIfUpdatedForProxy:!actions!public! !
refreshQuery!accessing-queries!public! !
refreshStatement!accessing!public! !
refreshWithContentsIfUpdatedQuery!accessing-queries!public! !
refreshWithContentsIfUpdatedStatement!accessing!public! !
relatedComponentsOf:do:!evaluating!public! !
targetClass!accessing!public! !
templateCollection!accessing!public! !
templateCollection:!accessing!public! !
!


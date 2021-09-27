"Filed out from Dolphin Smallalk"!

PositionableStream subclass: #SSWDBReadStream
	instanceVariableNames: 'instancesCollection peeked'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBReadStream guid: (GUID fromString: '{5a3e3dd7-3990-11d5-b1df-444553540000}')!
SSWDBReadStream comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBReadStream categoriesForClass!Unclassified! !
!SSWDBReadStream methodsFor!

basicNext

	peeked ifNotNil: [ :wasPeeked | peeked := nil. ^wasPeeked].

	"DBResultSet returns nil for next if atEnd"
	^self collectionNext
		ifNil: [self errorEndOfStream]
		ifNotNil: [ :row | self instancesCollection reStore objectFromRow: row table: self instancesCollection table]!

close

	"Close the DBResultSet (and hence the DBStatement).
	Not essential as finalization will do this, but it is good practice"
	
	collection close!

collectionNext

	"Private - Check for error - usually 'record deleted' "

	^[| next |
	next := collection next.
	position := position + 1.
	next] on: self reStore dbErrorClass do: 
		[ :exc |
		"If a 'deleted' error, skip until we find a valid next. Otherwise try resync"
		exc isRecordDeletedError
			ifTrue: [readLimit := readLimit - 1]
			ifFalse: [self resync].
		exc return: self collectionNext]!

evaluatePostReadActionsFor: aCollection

	self instancesCollection postReadActions do: [ :each | each value: aCollection].

	^aCollection!

instancesCollection

	"instancesCollection stores the SSWDBInstancesCollection which the receiver
	is a stream 'onto' (in fact, a DBResultSet is the receiver's collection"
	
	^instancesCollection!

instancesCollection: anSSWDBInstancesCollection

	"instancesCollection stores the SSWDBInstancesCollection which the receiver
	is a stream 'onto' (in fact, a DBResultSet is the receiver's collection"
	
	instancesCollection := anSSWDBInstancesCollection!

next

	^self basicNext ifNotNil: 
		[ :next |
		self evaluatePostReadActionsFor: {next}.
		next]!

next: anInteger

	| results |
	
	results := OrderedCollection new: anInteger.
	[self atEnd or: [results size = anInteger]] whileFalse: [results add: self basicNext].

	^self evaluatePostReadActionsFor: results!

nextAvailable: anInteger

	| results count |
	
	results := OrderedCollection new: (count := anInteger).
	[count == 0 or: [self atEnd]] whileFalse: 
		[results add: self basicNext. 
		count := count - 1].

	^self evaluatePostReadActionsFor: results!

peek

	^peeked ifNil: [peeked := self atEnd ifFalse: [self next]]!

position: anInteger

	collection position: anInteger.
	self resetPeeked.

	^super position: anInteger!

reinitialize

	self resetPeeked.
	self on: self instancesCollection resultSet.
	self setInstancesCollection: self instancesCollection!

reset

	self instancesCollection isNil ifFalse: [self resetResultsSet].
	^super reset!

resetPeeked

	peeked := nil!

resetResultsSet

	peeked := self instancesCollection reStore objectFromRow: collection resetAndFetchFirst table: self instancesCollection table!

reStore

	^self instancesCollection reStore!

resync

	"Private - Reinitialize the receiver by requerying"

	| oldPosition |

	oldPosition := self position.
	collection close.
	self reinitialize.

	self position: oldPosition!

setInstancesCollection: anSSWDBInstancesCollection

	self instancesCollection: anSSWDBInstancesCollection.

	"If the resultSet couldn't set the readLimit we have to query"
	readLimit isNil ifTrue: [readLimit := instancesCollection size]!

upTo: anObject

	| results nextObject |
		
	results := OrderedCollection new: ((readLimit - position) // 2).
	[self atEnd or: [(nextObject := self basicNext) = anObject]] whileFalse: [results add: nextObject].

	^self evaluatePostReadActionsFor: results!

upToEnd

	| results |
		
	results := OrderedCollection new: (readLimit - position).
	[self atEnd] whileFalse: [results add: self basicNext].

	^self evaluatePostReadActionsFor: results! !
!SSWDBReadStream categoriesForMethods!
basicNext!evaluating!private! !
close!actions!public! !
collectionNext!evaluating!private! !
evaluatePostReadActionsFor:!evaluating!private! !
instancesCollection!accessing!public! !
instancesCollection:!accessing!public! !
next!evaluating!public! !
next:!evaluating!public! !
nextAvailable:!evaluating!public! !
peek!evaluating!public! !
position:!positioning!public! !
reinitialize!initializing!private! !
reset!positioning!public! !
resetPeeked!initializing!private! !
resetResultsSet!positioning!private! !
reStore!accessing!public! !
resync!initializing!private! !
setInstancesCollection:!initializing!private! !
upTo:!evaluating!public! !
upToEnd!evaluating!public! !
!


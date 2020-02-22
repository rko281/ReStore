"Filed out from Dolphin Smalltalk 7"!

SSWDBBlockEvaluator subclass: #SSWDBBlockArgument
	instanceVariableNames: 'currentClass isForModify finalFields'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBBlockArgument guid: (GUID fromString: '{5a3e3dcd-3990-11d5-b1df-444553540000}')!
SSWDBBlockArgument comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBBlockArgument categoriesForClass!Unclassified! !
!SSWDBBlockArgument methodsFor!

& aValue

	"Only sent in case of an implicit '= true' expression (or an error)"

	^self implicitEqualsTrue 
		ifNil: [self]
		ifNotNil: [ :result | result & aValue]!

_doesNotUnderstand: aMessage

	| selector arguments field |

	selector := aMessage selector.
	arguments := aMessage arguments.
	
	"If we have a finalField, attempt to interpret selector as a function message send"
	(self reStore sqlDialect sqlFunctionFor: selector) ifNotNil: 
		[ :function | 
		^self applyFunction: function withArguments: arguments].

	^arguments isEmpty
	ifTrue:
		[field := self currentTable fieldAccessing: selector.
		field isNil 
		ifTrue: 
			[(self currentTable collectionAccessing: selector)
				ifNil: [self simulateMessageSend: aMessage]
				ifNotNil: [ :collection | self newCollectionReceiverFor: collection]]
		ifFalse: 
			[field isInlined "Need explicit check for inlined fields"
			ifTrue: 
				[self newInlinedReceiverFor: selector] 
			ifFalse: 
				[(field targetClass isPersistentIn: self reStore)
					ifTrue: [self newReceiverFor: field]
					ifFalse: [self finalField: (self queryFieldFor: field)]]]]
	ifFalse:
		[arguments size > 1 ifTrue: [self parseError: 'Cannot support more than one comparison argument'].
		(self hasFinalField not and: [self currentClass isPersistentBaseClass not and: [arguments last == SSWDBDumbArgument current]]) ifTrue: 
			["Sort block parsing"
			^self simulateMessageSend: aMessage].
		selector last = $: ifTrue: 
			["Check for 'assignment' in modify: block"
			field := self currentTable fieldAccessing: selector allButLast asSymbol.
			field notNil ifTrue: [^(self forModify perform: selector allButLast asSymbol) value: arguments first]].
		self sqlConditionFor: aMessage]!

_instVarAt: anIndex

	"Allow InstVarAccessors to interrogate the receiver"

	^self perform: (self currentClass allInstVarNames at: anIndex) asSymbol!

| aValue

	"Only sent in case of an implicit '= true' expression (or an error)"

	^self implicitEqualsTrue | aValue!

-> aBlockEvaluator

	"Convenience method for collect: and project: query blocks returning two results; allow the results to be returned as an Association"

	self parser isCollectingAssociations: true.

	^self || aBlockEvaluator!

applyFunction: aString withArguments: aCollection

	"Apply the given SQL function String to the finalField"

	self finalField: (self parser applyFunction: aString toResultOf: [self finalField] withArguments: aCollection)!

asSQLConditions

	"Polymorphic with DBQueryCondition(Collection)"

	^self hasFinalField 
		ifTrue: [self implyTrue: SSWSQLCondition new]
		ifFalse: [self error: 'cannot determine a valid condition']!

asSQLFields

	"Polymorphic with DBQueryCondition(Collection), DBQueryFieldCollection.
	If we don't have a final field then we're interested in the actual object so return all fields"

	^self hasFinalField 
		ifTrue: [SSWSQLFieldCollection with: self finalField]
		ifFalse: [SSWSQLTableAllFields forTable: self currentTable]!

at: anIndex

	"SQL does not differentiate between 1-char Strings and Characters.
	Therefore turn this into a midString:from: extraction of a single char"
	
	^self midString: 1 from: anIndex!

class

	"Override to handle as DNU (happens automatically but this implementation makes this explicit)
	 - enables comparions based on clasx for persistent class hierarchies.
	
	NB complicates debugging/inspection - see isKindOf:, printOn:"
	
	^self doesNotUnderstand: (Message selector: #class arguments: #())!

copyFrom: startPos to: endPos

	"Turn into a midString:from: (handled via DNU)"
	
	self midString: ((endPos - startPos) + 1) from: startPos!

count

	"Turn into SQL function via DNU - typically COUNT(field)"

	"Allow counting of actual objects by counting unique ids"
	self hasFinalField ifFalse: [self _id].

	^self doesNotUnderstand: (Message selector: #count arguments: #())!

currentClass

	"currentClass stores the class of object which is the receiver of the next message in the block being parsed"
	
	^currentClass!

currentClass: aClass

	"currentClass stores the class of object which is the receiver of the next message in the block being parsed"
	
	currentClass := aClass!

currentTable

	"Return the table associated with the currentClass. By default, this is requested from the parser.
	Subclasses which have other requirements may override"

	^self parser tableForClass: self currentClass!

doesNotUnderstand: aMessage

	self parser activeReceiver: self.

	^self postProcessDNU: (self _doesNotUnderstand: aMessage)!

finalField

	"Return the last field in the finalFields queue; error if none.
	NB - this also REMOVES the last finalField, destructively changing the queue.
	Use peekFinalField or hasFinalField (non destructive) to test.

	The finalField is the last field that is referenced when parsing a block; usually also the subject of an operator, e.g.
	[ :cd | cd label address postcode = 'WC1 1AA'] - finalField would be POSTCODE."

	^self hasFinalField
		ifTrue: [self finalFields removeLast]
		ifFalse: [self currentTable ifNil: [self parseError: 'No finalField set' with: #finalField] ifNotNil: [ :table | table idField copy targetClass: table instanceClass; yourself]]!

finalField: aField

	"Add aField to the end of the finalFields queue.

	The finalField is the last field that is referenced when parsing a block; usually also the subject of an operator, e.g.
	[ :cd | cd label address postcode = 'WC1 1AA'] - finalField would be POSTCODE."

	self finalFields addLast: aField!

finalFields

	"finalFields stores an OrderedCollection of SSWDBQueryFields as a queue of 'final fields' encountered during parsing;
	There will be at most two final fields, e.g.
		[ :cd | cd title = 'Come on Pilgrim']		- 1 final field, TITLE
		[ :cd | cd title = cd artistName]			- 2 final fields, TITLE and ARTIST_NAME
		
	The Queue nature is caused by the order or parsing, e.g. 
	Parse: 'cd title'				#(TITLE)
	Parse: 'cd artistName'	#(TITLE ARTIST_NAME)
	When evaluating the '=' comparator, TITLE is compared (first) with ARTIST_NAME, i.e First In, First Out"
		
	^finalFields!

finalFields: anOrderedCollection

	"finalFields stores an OrderedCollection of SSWDBQueryFields as a queue of 'final fields' encountered during parsing;
	There will be at most two final fields, e.g.
		[ :cd | cd title = 'Come on Pilgrim']		- 1 final field, TITLE
		[ :cd | cd title = cd artistName]			- 2 final fields, TITLE and ARTIST_NAME
		
	The Queue nature is caused by the order or parsing, e.g. 
	Parse: 'cd title'				#(TITLE)
	Parse: 'cd artistName'	#(TITLE ARTIST_NAME)
	When evaluating the '=' comparator, TITLE is compared (first) with ARTIST_NAME, i.e First In, First Out"
		
	finalFields := anOrderedCollection!

first

	"Turn into at: 1"
	
	^self at: 1!

forModify

	^self parser newBlockArgument!

hasFinalField

	^self finalFields isEmpty not!

implicitEqualsTrue

	"If the receiver has parsed an implicait Boolean test (e.g. [ :cd | cd isDeleted]),
	then the eventual result will be the receiver instead of an SQLCondition.
	
	Transform the receiver into the correct Condition"

	^(self hasFinalField and: [self peekFinalField targetClass == Boolean])
		ifTrue: [self implyTrue: self newCondition]
		ifFalse: [nil]!

implyTrue: aCondition

	"Private - Initialize aCondition to represent the implicit truth of the receiver's finalField, returning the condition"

	"Some dialects (SQL Server) require an actual equality test"
	self reStore sqlDialect supportsImplicitTrueConditions
		ifTrue: [aCondition fieldOnly: self finalField]
		ifFalse: [aCondition field: self finalField equalTo: true].

	^aCondition!

indexOf: aCharacter

	"SQL does not differentiate between Characters and Strings.
	Turn into indexOfSubCollection: (parsed via DNU)"
	
	^self indexOfSubCollection: (String with: aCharacter)!

isEmpty

	"Turn into the message sequence 'size = 0';
	or could be sent following an implicit = true"
	
	^(self hasFinalField and: [self peekFinalField targetClass == Boolean])
		ifTrue: [self = true]
		ifFalse: [self size = 0]!

isForModify

	^isForModify ifNil: [false]!

isForModify: aBoolean

	isForModify := aBoolean!

isKindOf: aClass 

	"Overriden due to 'odd' behaviour of #class in the receiver"

	^(Array 
		with: SSWDBBlockEvaluator
		with: SSWDBBlockArgument
		with: SSWDBBlockReceiver) includes: aClass!

leftString: lenInteger

	"Dolphin #leftString:from: message - turn into a midString:from: (handled via DNU)"
	
	^self midString: lenInteger from: 1!

matches: aString

	"Essentially the inverse of match: (ie pattern is the argument, not the receiver)	
	Equivalent to like: (which is handled via DNU) but translate Dolphin-specific wildcards"
	
	^self like: 
		(aString collect: 
			[ :char || fixedChar |
			fixedChar := char.
			char = $* ifTrue: [fixedChar := $%].
			char = $# ifTrue: [fixedChar = $_].
			fixedChar])!

mustBeBoolean

	"Only sent in case of an implicit '= true' expression (or an error)"

	^self implicitEqualsTrue !

newCollectionReceiverFor: aCollectionSpec

	^aCollectionSpec dbBlockCollectionReceiver
		parser: self parser;
		yourself!

newInlinedReceiverFor: aSymbol

	^SSWDBInlinedBlockReceiver new
		parser: self parser;
		currentClass: self currentClass;
		inlinedInstVar: aSymbol;
		yourself!

newReceiverFor: aField

	"Create and return a new SSWDBBlockReceiver to receive (and parse) messages for the class of object which is referenced by aField"

	| newReceiver |

	newReceiver := self parser newReceiverFor: aField from: self.

	self isForModify ifTrue:
		[newReceiver
			finalField: (self queryFieldFor: aField);
			isForModify: true].

	^newReceiver!

not

	"Only sent in case of an implicit '= true' expression (or an error)"

	^self implicitEqualsTrue not!

parseError: aString

	^self parser parseError: aString!

parseError: aString with: anObject

	^self parser parseError: aString with: anObject!

peekFinalField

	"Return the first field in the finalFields queue (if any) WITHOUT modifying the queue.
	c.f. finalField"

	^self hasFinalField
		ifTrue: [self finalFields first]
		ifFalse: [nil]!

printOn: aStream

	"Overriden due to 'odd' behaviour of #class in the receiver"

	^'a SSWDBBlockEvaluator'!

queryFieldFor: aField

	^SSWDBQueryTableField forField: aField in: self currentTable path: self path!

replaceFrom: start to: stop with: replacementElements startingAt: startAt

	"Turn this into replaceFrom:length:with: (handled via DNU) which is supported by some DBs"
	
	| length |
	
	length := (stop - start) + 1.
	
	^self replaceFrom: start length: length with: (replacementElements copyFrom: startAt to: ((startAt + length) - 1))!

sqlAnd: anSQLCondition

	"Only sent in case of an implicit '= true' expression (or an error)"
	
	^self implicitEqualsTrue sqlAnd: anSQLCondition
	
	!

sqlAndWithCondition: anSQLCondition

	"Only sent in case of an implicit '= true' expression (or an error)"
	
	^anSQLCondition sqlAnd: self implicitEqualsTrue
	!

sqlConditionFor: aMessage

	| argument |

	argument := aMessage arguments first.
	(argument isKindOf: SSWDBBlockEvaluator) ifTrue: [argument := argument finalField].

	^self newCondition 
		field: self finalField 
		is: (SSWSQLOperator messageSelector: aMessage selector)
		to: argument!

sqlOr: anSQLCondition

	"Only sent in case of an implicit '= true' expression (or an error)"
	
	^self implicitEqualsTrue sqlOr: anSQLCondition
	
	!

sqlOrWithCondition: anSQLCondition

	"Only sent in case of an implicit '= true' expression (or an error)"
	
	^anSQLCondition sqlOr: self implicitEqualsTrue!

writeSQLOn: aStream

	"If the receiver has been sent this message,
	then the receiver did not finish parsing a block due to an implicit ' = true'.
	
	Complete the translation and forward to the resulting condition.
	Note we reinstate the finalField, since if this message has been received
	it will possibly be sent again - need to maintain the receiver's state"
	
	| field condition |
	
	field := self peekFinalField.
	condition := self implicitEqualsTrue.
	condition isNil ifFalse: [self finalField: field].
	
	^(condition ifNil: [self finalField]) writeSQLOn: aStream! !
!SSWDBBlockArgument categoriesFor: #&!parsing - implicit true!public! !
!SSWDBBlockArgument categoriesFor: #_doesNotUnderstand:!parsing - internal!public! !
!SSWDBBlockArgument categoriesFor: #_instVarAt:!parsing - internal!public! !
!SSWDBBlockArgument categoriesFor: #|!parsing - implicit true!public! !
!SSWDBBlockArgument categoriesFor: #->!parsing - functions!public! !
!SSWDBBlockArgument categoriesFor: #applyFunction:withArguments:!parsing - internal!public! !
!SSWDBBlockArgument categoriesFor: #asSQLConditions!parsing - internal!public! !
!SSWDBBlockArgument categoriesFor: #asSQLFields!parsing - internal!public! !
!SSWDBBlockArgument categoriesFor: #at:!parsing - functions!public! !
!SSWDBBlockArgument categoriesFor: #class!parsing - internal!public! !
!SSWDBBlockArgument categoriesFor: #copyFrom:to:!parsing - functions!public! !
!SSWDBBlockArgument categoriesFor: #count!parsing - aggregations!public! !
!SSWDBBlockArgument categoriesFor: #currentClass!accessing!public! !
!SSWDBBlockArgument categoriesFor: #currentClass:!accessing!public! !
!SSWDBBlockArgument categoriesFor: #currentTable!accessing!public! !
!SSWDBBlockArgument categoriesFor: #doesNotUnderstand:!parsing - internal!public! !
!SSWDBBlockArgument categoriesFor: #finalField!accessing!public! !
!SSWDBBlockArgument categoriesFor: #finalField:!accessing!public! !
!SSWDBBlockArgument categoriesFor: #finalFields!accessing!public! !
!SSWDBBlockArgument categoriesFor: #finalFields:!accessing!public! !
!SSWDBBlockArgument categoriesFor: #first!parsing - functions!public! !
!SSWDBBlockArgument categoriesFor: #forModify!parsing - internal!public! !
!SSWDBBlockArgument categoriesFor: #hasFinalField!public!testing! !
!SSWDBBlockArgument categoriesFor: #implicitEqualsTrue!parsing - implicit true!public! !
!SSWDBBlockArgument categoriesFor: #implyTrue:!parsing - implicit true!private! !
!SSWDBBlockArgument categoriesFor: #indexOf:!parsing - functions!public! !
!SSWDBBlockArgument categoriesFor: #isEmpty!parsing - functions!parsing - implicit true!public! !
!SSWDBBlockArgument categoriesFor: #isForModify!accessing!public! !
!SSWDBBlockArgument categoriesFor: #isForModify:!accessing!public! !
!SSWDBBlockArgument categoriesFor: #isKindOf:!parsing - internal!public! !
!SSWDBBlockArgument categoriesFor: #leftString:!parsing - functions!public! !
!SSWDBBlockArgument categoriesFor: #matches:!parsing - comparisons!public! !
!SSWDBBlockArgument categoriesFor: #mustBeBoolean!parsing - implicit true!public! !
!SSWDBBlockArgument categoriesFor: #newCollectionReceiverFor:!helpers!public! !
!SSWDBBlockArgument categoriesFor: #newInlinedReceiverFor:!helpers!public! !
!SSWDBBlockArgument categoriesFor: #newReceiverFor:!helpers!public! !
!SSWDBBlockArgument categoriesFor: #not!parsing - implicit true!public! !
!SSWDBBlockArgument categoriesFor: #parseError:!parsing - internal!public! !
!SSWDBBlockArgument categoriesFor: #parseError:with:!parsing - internal!public! !
!SSWDBBlockArgument categoriesFor: #peekFinalField!evaluating!public! !
!SSWDBBlockArgument categoriesFor: #printOn:!parsing - internal!public! !
!SSWDBBlockArgument categoriesFor: #queryFieldFor:!parsing - internal!public! !
!SSWDBBlockArgument categoriesFor: #replaceFrom:to:with:startingAt:!parsing - functions!public! !
!SSWDBBlockArgument categoriesFor: #sqlAnd:!parsing - implicit true!public! !
!SSWDBBlockArgument categoriesFor: #sqlAndWithCondition:!parsing - implicit true!public! !
!SSWDBBlockArgument categoriesFor: #sqlConditionFor:!parsing - internal!public! !
!SSWDBBlockArgument categoriesFor: #sqlOr:!parsing - implicit true!public! !
!SSWDBBlockArgument categoriesFor: #sqlOrWithCondition:!parsing - implicit true!public! !
!SSWDBBlockArgument categoriesFor: #writeSQLOn:!parsing - implicit true!public! !

!SSWDBBlockArgument class methodsFor!

new

	^super new
		finalFields: (OrderedCollection new: 2);
		yourself! !
!SSWDBBlockArgument class categoriesFor: #new!instance creation!public! !


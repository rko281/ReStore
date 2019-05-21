"Filed out from Dolphin Smalltalk 7"!

SSWDBBlockEvaluator subclass: #SSWDBBlockArgument
	instanceVariableNames: 'currentClass isForModify finalFields'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBBlockArgument guid: (GUID fromString: '{5a3e3dcd-3990-11d5-b1df-444553540000}')!
SSWDBBlockArgument comment: 'Copyright 2000/2001 Solutions Software Limited'!
!SSWDBBlockArgument categoriesForClass!Unclassified! !
!SSWDBBlockArgument methodsFor!

& aValue

	"9/4/2001
	
	Only sent in case of an implicit '= true' expression (or an error)"

	^self implicitEqualsTrue 
		ifNil: [self]
		ifNotNil: [ :result | result & aValue]!

_doesNotUnderstand: aMessage

	"14/8/2000"

	| selector arguments mode field |

	mode := self currentMode.
	self resetCurrentMode.

	selector := aMessage selector.
	arguments := aMessage arguments.
	
	"If we have a finalField, attempt to interpret selector as a function message send"
	self hasFinalField ifTrue:
		[(self reStore sqlDialect sqlFunctionFor: selector) ifNotNil: [ :function | ^self applyFunction: function withArguments: arguments]].

	^arguments isEmpty
	ifTrue:
		[field := self currentTable fieldAccessing: selector.
		field isNil 
		ifTrue: 
			[(self currentTable collectionAccessing: selector)
				ifNil: [self simulateMessageSend: aMessage]
				ifNotNil: [ :collection | self newCollectionReceiverFor: collection]]
		ifFalse: 
			[field isEmbedded "Need explicit check for embedded fields (always false if embedded package not loaded)"
			ifTrue: 
				[self embeddedEvaluatorFor: selector "Will be undefined if embedded package not loaded; this is OK"] 
			ifFalse: 
				[((field targetClass isPersistentIn: self reStore) and: [mode ~= #_idOf])
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

_idOf

	"Set the receiver's mode such that the next message, which should be a reference to a persistent component, refers to the unique id of that component rather than the component itself"

	self currentMode: #_idOf!

_instVarAt: anIndex

	"Allow InstVarAccessors to interrogate the receiver"

	^self perform: (self currentClass allInstVarNames at: anIndex) asSymbol!

| aValue

	"9/4/2001
	
	Only sent in case of an implicit '= true' expression (or an error)"

	^self implicitEqualsTrue | aValue!

-> aBlockEvaluator

	"Convenience method for collect: and project: query blocks returning two results; allow the results to be returned as an Association"

	self parser isCollectingAssociations: true.

	^self || aBlockEvaluator!

applyFunction: aString withArguments: aCollection

	"Apply the given SQL function String to the finalField"

	| arguments |

	arguments := OrderedCollection new: aCollection size.
	aCollection reverseDo: 
		[ :arg |
		(arg isKindOf: SSWDBBlockEvaluator)
			ifTrue: [arguments addFirst: arg finalField]
			ifFalse: [arguments addFirst: arg]].
	
	arguments size = aCollection size
		ifTrue: [self finalField: (self finalField withFunction: aString arguments: arguments asArray)]
		ifFalse: [self parseError: 'No Final Field found']!

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

	"3/4/01
	
	SQL does not differentiate between 1-char Strings and Characters.
	Therefore turn this into a midString:from: extraction of a single char"
	
	^self midString: 1 from: anIndex!

between: min and: max

	"16/4/2001

	Special case 2-arg comparator. Handle manually"

	| function |

	function := self reStore sqlDialect sqlFunctionFor: #between:and:.
	self applyFunction: function withArguments: (Array with: min with: max).

	^self newCondition fieldOnly: self finalField!

class

	"18/4/2001
	
	Override to handle as DNU (happens automatically but this implementation makes this explicit)
	 - enables comparions based on clasx for persistent class hierarchies.
	
	NB complicates debugging/inspection - see isKindOf:, printOn:"
	
	^self doesNotUnderstand: (Message selector: #class arguments: #())!

copyFrom: startPos to: endPos

	"14/8/2000
	
	Turn into a midString:from: (handled via DNU)"
	
	self midString: ((endPos - startPos) + 1) from: startPos!

count

	"Turn into SQL function via DNU - typically COUNT(field)"

	"Allow counting of actual objects by counting unique ids"
	self hasFinalField ifFalse: [self _id].

	^self doesNotUnderstand: (Message selector: #count arguments: #())!

currentClass

	"21/1/2001
	
	currentClass stores the class of object which is the receiver of the next message in the block being parsed"
	
	^currentClass!

currentClass: aClass

	"21/1/2001
	
	currentClass stores the class of object which is the receiver of the next message in the block being parsed"
	
	currentClass := aClass!

currentTable

	"14/8/2000
	
	Return the table associated with the currentClass. By default, this is requested from the parser.
	Subclasses which have other requirements may override"

	^self parser tableForClass: self currentClass!

doesNotUnderstand: aMessage

	self parser activeReceiver: self.

	^self postProcessDNU: (self _doesNotUnderstand: aMessage) from: Processor activeProcess topFrame sender!

finalField

	"20/3/2001
	
	Return the last field in the finalFields queue; error if none.
	NB - this also REMOVES the last finalField, destructively changing the queue.
	Use peekFinalField or hasFinalField (non destructive) to test.

	The finalField is the last field that is referenced when parsing a block; usually also the subject of an operator, e.g.
	[ :cd | cd label address postcode = 'WC1 1AA'] - finalField would be POSTCODE."

	^self hasFinalField
		ifTrue: [self finalFields removeLast]
		ifFalse: [self parseError: 'No finalField set' with: #finalField]!

finalField: aField

	"20/3/2001
	
	Add aField to the end of the finalFields queue.

	The finalField is the last field that is referenced when parsing a block; usually also the subject of an operator, e.g.
	[ :cd | cd label address postcode = 'WC1 1AA'] - finalField would be POSTCODE."

	self finalFields addLast: aField!

finalFields

	"20/3/01
	
	finalFields stores an OrderedCollection of SSWDBQueryFields as a queue of 'final fields' encountered during parsing;
	There will be at most two final fields, e.g.
		[ :cd | cd title = 'Come on Pilgrim']		- 1 final field, TITLE
		[ :cd | cd title = cd artistName]			- 2 final fields, TITLE and ARTIST_NAME
		
	The Queue nature is caused by the order or parsing, e.g. 
	Parse: 'cd title'				#(TITLE)
	Parse: 'cd artistName'	#(TITLE ARTIST_NAME)
	When evaluating the '=' comparator, TITLE is compared (first) with ARTIST_NAME, i.e First In, First Out"
		
	^finalFields!

finalFields: anOrderedCollection

	"20/3/01
	
	finalFields stores an OrderedCollection of SSWDBQueryFields as a queue of 'final fields' encountered during parsing;
	There will be at most two final fields, e.g.
		[ :cd | cd title = 'Come on Pilgrim']		- 1 final field, TITLE
		[ :cd | cd title = cd artistName]			- 2 final fields, TITLE and ARTIST_NAME
		
	The Queue nature is caused by the order or parsing, e.g. 
	Parse: 'cd title'				#(TITLE)
	Parse: 'cd artistName'	#(TITLE ARTIST_NAME)
	When evaluating the '=' comparator, TITLE is compared (first) with ARTIST_NAME, i.e First In, First Out"
		
	finalFields := anOrderedCollection!

first

	"3/4/01
	
	Turn into at: 1"
	
	^self at: 1!

forModify

	^self parser newBlockArgument!

hasFinalField

	"20/3/2001"

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

	"4/3/01
	
	SQL does not differentiate between Characters and Strings.
	Turn into indexOfSubCollection: (parsed via DNU)"
	
	^self indexOfSubCollection: (String with: aCharacter)!

isEmpty

	"27/3/2001
	
	Turn into the message sequence 'size = 0';
	or could be sent following an implicit = true"
	
	^(self hasFinalField and: [self peekFinalField targetClass == Boolean])
		ifTrue: [self = true]
		ifFalse: [self size = 0]!

isForModify

	^isForModify ifNil: [false]!

isForModify: aBoolean

	isForModify := aBoolean!

isJumpOnNilBytecode: anInteger

	^##(Array with: OpcodePool.NearJumpIfNil with: OpcodePool.NearJumpIfNotNil with: OpcodePool.LongJumpIfNil with: OpcodePool.LongJumpIfNotNil) includes: anInteger!

isKindOf: aClass 
	"18/4/2001
	
	Overriden due to 'odd' behaviour of #class in the receiver"

	^(Array 
		with: SSWDBBlockEvaluator
		with: SSWDBBlockArgument
		with: SSWDBBlockReceiver) includes: aClass!

leftString: lenInteger

	"14/8/2000
	
	Dolphin #leftString:from: message - turn into a midString:from: (handled via DNU)"
	
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

	"9/4/2001
	
	Only sent in case of an implicit '= true' expression (or an error)"

	^self implicitEqualsTrue not!

parseError: aString

	^self parser parseError: aString!

parseError: aString with: anObject

	^self parser parseError: aString with: anObject!

peekFinalField

	"20/3/2001
	
	Return the first field in the finalFields queue (if any) WITHOUT modifying the queue.
	c.f. finalField"

	^self hasFinalField
		ifTrue: [self finalFields first]
		ifFalse: [nil]!

postProcessDNU: anObject from: aStackFrame

	"Following doesNotUnderstand: handling, pre-check the next bytecode to be executed in the sending stack frame.
	This is necessary to detect the following inlined message combinations:
		isNil
		notNil
		isNil and: [...]
		isNil or: [...]
		notNil and: [...]
		notNil or: [...]
	If these are detected, the isNil/notNil condition is added to the query result and subsequent query processing is modified accordingly"

	| bytecodes ip nextBytecode isJumpIfNil isLongJump checkOffset jumpOffset postCheckBytecode preJumpBytecode postJumpBytecode trueBytecode falseBytecode postCheckResult preJumpResult postJumpResult isNil method |

	bytecodes := aStackFrame method byteCodes.
	ip := aStackFrame ip.
	nextBytecode := bytecodes at: ip.

	"Check for Break bytecode - means we are debugging; need to skip it"
	(nextBytecode = OpcodePool.Break) ifTrue: 
		[ip := ip + ##(ByteCodeDispatcher lengthOfInstruction: OpcodePool.Break).
		nextBytecode := bytecodes at: ip].

	"isNil / notNil in isolation - evaluate as standard = / ~= nil and skip the next bytecode"
	nextBytecode = OpcodePool.ShortSendIsNil ifTrue: 
		[aStackFrame ip: ip + ##(ByteCodeDispatcher lengthOfInstruction: OpcodePool.ShortSendIsNil).
		^anObject = nil].
	nextBytecode = OpcodePool.ShortSendNotNil ifTrue: 
		[aStackFrame ip: ip + ##(ByteCodeDispatcher lengthOfInstruction: OpcodePool.ShortSendNotNil).
		^anObject ~= nil].

	"isNil / notNil followed by and: / or: compile down to a JumpIf(Not)Nil bytecode - this requires special handling"
	(self isJumpOnNilBytecode: nextBytecode) ifFalse: [^self preProcessNextMessageFor: anObject in: aStackFrame].

	"There are 8(!!) different known possibilities to consider when deciding if this is an isNil or notNil test:

	 - JumpIfNil to ^True = isNil
	 - JumpIfNil to ^False = notNil
	 - JumpIfNil to other bytecode with ^True in the jumped-over code = notNil
	 - JumpIfNil to other bytecode without ^True in the jumped-over code = isNil

	 - JumpIfNotNil to ^True = notNil
	 - JumpIfNotNil to ^False = isNil
	 - JumpIfNotNil to other bytecode with ^True in the jumped-over code = isNil
	 - JumpIfNotNil to other bytecode without ^True in the jumped-over code = notNil

	Presumably these could change with a change in the compiler, so we have full SUnit coverage for all combinations"

	checkOffset := ByteCodeDispatcher lengthOfInstruction: nextBytecode.
	isJumpIfNil := (nextBytecode = OpcodePool.NearJumpIfNil or: [nextBytecode = OpcodePool.LongJumpIfNil]).
	isLongJump := (nextBytecode = OpcodePool.LongJumpIfNotNil or: [nextBytecode = OpcodePool.LongJumpIfNil]).

	isLongJump
		ifTrue: [jumpOffset := checkOffset + (bytecodes swordAtOffset: ip)] 
		ifFalse: [jumpOffset := checkOffset + (bytecodes sbyteAtOffset: ip)].

	"Result bytecodes differ between block frames (push result, jump/return) and method frames (return result)"
	postCheckBytecode := bytecodes at: (ip + checkOffset).
	postJumpBytecode := bytecodes at: (ip + jumpOffset).
	aStackFrame isBlockFrame
	ifTrue: 
		[preJumpBytecode := bytecodes at: (ip + jumpOffset - ##((ByteCodeDispatcher lengthOfInstruction: OpcodePool.PushPseudo) + ##(ByteCodeDispatcher lengthOfInstruction: OpcodePool.ReturnFromBlock))).
		trueBytecode := OpcodePool.PushPseudo "PushTrue".
		falseBytecode := ##(OpcodePool.PushPseudo + 1) "PushFalse"]
	ifFalse: 
		[preJumpBytecode := bytecodes at: (ip + jumpOffset - ##(ByteCodeDispatcher lengthOfInstruction: OpcodePool.ReturnPseudo)).
		trueBytecode := OpcodePool.ReturnPseudo. "ReturnTrue"
		falseBytecode := OpcodePool.ReturnFalse].

	postCheckBytecode = trueBytecode ifTrue: [postCheckResult := true].
	preJumpBytecode = trueBytecode ifTrue: [preJumpResult := true].
	postJumpBytecode = falseBytecode ifTrue: [postJumpResult := false].

	(postJumpResult == false or: [postCheckResult == true or: [preJumpResult == true]])
		ifTrue: [isNil := isJumpIfNil not]
		ifFalse: [isNil := isJumpIfNil].

	isNil ifFalse: [isJumpIfNil := isJumpIfNil not].

	"Replace the JumpIf(Not)Nil with a JumpIfFalse to avoid shortcutting of the and: / or: block"	
	bytecodes := bytecodes copy.

	isLongJump
		ifTrue: [bytecodes at: ip put: (isJumpIfNil ifTrue: [OpcodePool.LongJumpIfTrue] ifFalse: [OpcodePool.LongJumpIfFalse])]
		ifFalse: [bytecodes at: ip put: (isJumpIfNil ifTrue: [OpcodePool.NearJumpIfTrue] ifFalse: [OpcodePool.NearJumpIfFalse])].

	method := aStackFrame method copy.
	method setByteCodes: bytecodes.
	aStackFrame _method: method.

	^isNil 
		ifTrue: [anObject = nil]
		ifFalse: [anObject ~= nil]!

preProcessNextMessageFor: anObject in: aStackFrame

	"Check if the next message needs special handling, usually due to anObject (block evaluator) being an argument rather than the receiver"

	| dispatcher nextMessage |

	dispatcher := aStackFrame sswByteCodeDispatcher.
	nextMessage := dispatcher peekForSelector.

	"Collection>>includes: -> self>>includedIn:"
	nextMessage = #includes: ifTrue: 
		[aStackFrame ip: dispatcher ip.
		^anObject includedIn: (aStackFrame process at: aStackFrame sp)].
	
	"String>>match: -> self>>matches:"
	nextMessage = #match: ifTrue: 
		[aStackFrame ip: dispatcher ip.
		^anObject matches: (aStackFrame process at: aStackFrame sp)].

	"No special handling"
	^anObject!

printOn: aStream

	"18/4/2001
	
	Overriden due to 'odd' behaviour of #class in the receiver"

	^'a SSWDBBlockEvaluator'!

queryFieldFor: aField

	^SSWDBQueryTableField forField: aField in: self currentTable path: self path!

replaceFrom: start to: stop with: replacementElements startingAt: startAt

	"3/4/01
	
	Turn this into replaceFrom:length:with: (handled via DNU) which is supported by some DBs"
	
	| length |
	
	length := (stop - start) + 1.
	
	^self replaceFrom: start length: length with: (replacementElements copyFrom: startAt to: ((startAt + length) - 1))!

simulateMessageSend: aMessage

	"Attempt to simulate the method named aSymbol in the current class's methodDictionary, turning it into equivalent SQL function(s).
	Limitations - the method (and any methods it invokes) must NOT directly access inst vars, other than simple getter accessor methods.
	Also any messages sent my the method must map to SQL functions in the current dialect.
	If any of these do not hold true a parseError will occur (or possibly something weirder)"

	| method |

	method := self currentClass lookupMethod: aMessage selector.
	method isNil ifTrue: [self parseError: (self currentClass name, ' does not implement #', aMessage selector)].

	"Check the method has no direct inst var accesses - we can't allow these since the method is actually evaluated with the receiver as, er, the receiver..."
	method readsOrWritesAnyInstVar ifTrue: [self parseError: aMessage selector, ' directly accesses inst vars - cannot convert to SQL'].

	"Make a local copy of the method in this class in order to invoke it"
	method := method copy.
	method methodClass: self basicClass.

	"Try it!!"
	^method value: self withArguments: aMessage arguments!

sqlAnd: anSQLCondition

	"9/4/2001
	
	Only sent in case of an implicit '= true' expression (or an error)"
	
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

	"9/4/2001
	
	Only sent in case of an implicit '= true' expression (or an error)"
	
	^self implicitEqualsTrue sqlOr: anSQLCondition
	
	!

sqlOrWithCondition: anSQLCondition

	"Only sent in case of an implicit '= true' expression (or an error)"
	
	^anSQLCondition sqlOr: self implicitEqualsTrue!

writeSQLOn: aStream

	"10/4/2001
	
	If the receiver has been sent this message,
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
!SSWDBBlockArgument categoriesFor: #_idOf!parsing - functions!public! !
!SSWDBBlockArgument categoriesFor: #_instVarAt:!parsing - internal!public! !
!SSWDBBlockArgument categoriesFor: #|!parsing - implicit true!public! !
!SSWDBBlockArgument categoriesFor: #->!parsing - functions!public! !
!SSWDBBlockArgument categoriesFor: #applyFunction:withArguments:!parsing - internal!public! !
!SSWDBBlockArgument categoriesFor: #asSQLConditions!parsing - internal!public! !
!SSWDBBlockArgument categoriesFor: #asSQLFields!parsing - internal!public! !
!SSWDBBlockArgument categoriesFor: #at:!parsing - functions!public! !
!SSWDBBlockArgument categoriesFor: #between:and:!parsing - comparisons!public! !
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
!SSWDBBlockArgument categoriesFor: #isJumpOnNilBytecode:!parsing - internal!private! !
!SSWDBBlockArgument categoriesFor: #isKindOf:!parsing - internal!public! !
!SSWDBBlockArgument categoriesFor: #leftString:!parsing - functions!public! !
!SSWDBBlockArgument categoriesFor: #matches:!parsing - comparisons!public! !
!SSWDBBlockArgument categoriesFor: #mustBeBoolean!parsing - implicit true!public! !
!SSWDBBlockArgument categoriesFor: #newCollectionReceiverFor:!helpers!public! !
!SSWDBBlockArgument categoriesFor: #newReceiverFor:!helpers!public! !
!SSWDBBlockArgument categoriesFor: #not!parsing - implicit true!public! !
!SSWDBBlockArgument categoriesFor: #parseError:!parsing - internal!public! !
!SSWDBBlockArgument categoriesFor: #parseError:with:!parsing - internal!public! !
!SSWDBBlockArgument categoriesFor: #peekFinalField!evaluating!public! !
!SSWDBBlockArgument categoriesFor: #postProcessDNU:from:!parsing - internal!private! !
!SSWDBBlockArgument categoriesFor: #preProcessNextMessageFor:in:!parsing - internal!private! !
!SSWDBBlockArgument categoriesFor: #printOn:!parsing - internal!public! !
!SSWDBBlockArgument categoriesFor: #queryFieldFor:!parsing - internal!public! !
!SSWDBBlockArgument categoriesFor: #replaceFrom:to:with:startingAt:!parsing - functions!public! !
!SSWDBBlockArgument categoriesFor: #simulateMessageSend:!helpers!public! !
!SSWDBBlockArgument categoriesFor: #sqlAnd:!parsing - implicit true!public! !
!SSWDBBlockArgument categoriesFor: #sqlAndWithCondition:!parsing - implicit true!public! !
!SSWDBBlockArgument categoriesFor: #sqlConditionFor:!parsing - internal!public! !
!SSWDBBlockArgument categoriesFor: #sqlOr:!parsing - implicit true!public! !
!SSWDBBlockArgument categoriesFor: #sqlOrWithCondition:!parsing - implicit true!public! !
!SSWDBBlockArgument categoriesFor: #writeSQLOn:!parsing - implicit true!public! !

!SSWDBBlockArgument class methodsFor!

new

	"20/3/2001"
	
	^super new
		finalFields: (OrderedCollection new: 2);
		yourself! !
!SSWDBBlockArgument class categoriesFor: #new!instance creation!public! !


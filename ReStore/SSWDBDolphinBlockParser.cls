"Filed out from Dolphin Smalltalk 7"!

SSWDBBlockParser subclass: #SSWDBDolphinBlockParser
	instanceVariableNames: 'isAccumulatingConditions accumulatedConditionsStack accumulatedConditions currentConditions'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBDolphinBlockParser guid: (GUID fromString: '{cfc749da-e6eb-4ba5-9b3f-f4ffc1fcfb66}')!
SSWDBDolphinBlockParser comment: 'ReStore
©2020 John Aspinall
https://github.com/rko281/ReStore

Adds support for handling inlined blocks'!
!SSWDBDolphinBlockParser categoriesForClass!Unclassified! !
!SSWDBDolphinBlockParser methodsFor!

_parse: aOneArgBlock

	| parseResult |

	parseResult := super _parse: aOneArgBlock.

	self accumulatedConditions isEmpty ifFalse: 
		["Accumulated conditions arise from detection of inlined logical operators (and:, or:) during the parse. Add the parseResult (final condition) to these"
		self accumulatedConditions == self currentConditions 
			ifTrue: [self currentConditions add: parseResult]
			ifFalse: [self currentConditions become: parseResult].

		parseResult := self accumulatedConditions.
		self resetConditions].

	^parseResult!

_parseSortBlock: aTwoArgBlock inverted: aBoolean

	| parseResult |

	parseResult := super _parseSortBlock: aTwoArgBlock inverted: aBoolean.
	
	self hasAccumulatedConditions ifTrue:
		["Accumulated conditions arise from detection of inlined tests (and:, or:) during the parse. Add the parseResult (final condition) to these"
		self accumulatedConditions == self currentConditions 
			ifTrue: [self currentConditions add: parseResult]
			ifFalse: [self currentConditions become: parseResult].
		parseResult := self accumulatedConditions].

	^parseResult!

accumulatedConditions
	^accumulatedConditions!

accumulatedConditions: anObject
	accumulatedConditions := anObject!

accumulatedConditionsStack
	^accumulatedConditionsStack!

accumulatedConditionsStack: anObject
	accumulatedConditionsStack := anObject!

currentConditions
	^currentConditions!

currentConditions: anObject
	currentConditions := anObject!

handleMustBeBooleanIn: aCondition

	"Private - aCondition(Collection) has been subject to an inlined and: / or: message in a query block, resulting in a mustBeBoolean send.
	Deduce which from the original sender's bytecodes, returning the appropriate value to ensure the argument block is evaluated (true for and:, false for or:).
	Also update the receiver to ensure this condition is combined with the eventual result"

	| senderFrame bytecodes ip bytecode length nextBytecode jumpOffset blockEndpoint temp |

	senderFrame := Processor activeProcess topFrame sender sender.
	bytecodes := senderFrame method byteCodes.
	ip := senderFrame ip.
	bytecode := bytecodes at: ip.
	length := ByteCodeDispatcher lengthOfInstruction: bytecode.
	nextBytecode := bytecodes at: ip + length.

	(nextBytecode = OpcodePool.ReturnFalse or: [nextBytecode = OpcodePool.ReturnPseudo "ReturnTrue" or: [(bytecodes at: ip + 2) = OpcodePool.ReturnFromBlock "Jump+2 over Push<result>; ReturnFromBlock"]]) 
	ifTrue: 
		[senderFrame method isUnbound "return out of simulated method - use ip of sender"
			ifTrue: [blockEndpoint := senderFrame sender sender sender sender ip]
			ifFalse: [blockEndpoint := SmallInteger maximum]]
	ifFalse: 
		[(bytecode = OpcodePool.LongJumpIfFalse or: [bytecode = OpcodePool.LongJumpIfTrue]) 
		ifTrue: 
			[jumpOffset := length + (bytecodes swordAtOffset: ip)]
		ifFalse: 
			[(bytecode = OpcodePool.NearJumpIfFalse or: [bytecode = OpcodePool.NearJumpIfTrue]) 
				ifTrue: [jumpOffset := length + (bytecodes sbyteAtOffset: ip)]
				ifFalse: [jumpOffset := length + (bytecode - ##(OpcodePool.ShortJumpIfFalse - 1))]].
		blockEndpoint := ip + jumpOffset].

	self isAccumulatingConditions: true.

	"First possibility - last condition within a sequence of OR tests"
	(nextBytecode = OpcodePool.PushPseudo "PushTrue" or: [nextBytecode = OpcodePool.ReturnPseudo "ReturnTrue"]) ifTrue:
		[self currentConditions isEmpty
		ifTrue: 
			[self currentConditions add: aCondition; beOR; addLast: (self newConditionCollection blockEndpoint: blockEndpoint; yourself).
			self currentConditions: self currentConditions last]
		ifFalse: 
			[self currentConditions add: aCondition.
			temp := self newConditionCollection beOR.
			temp _add: temp "will become: currentCondiitions"; add: (self newConditionCollection blockEndpoint: blockEndpoint; yourself).
			self currentConditions become: temp.
			self currentConditions: self currentConditions last].
		^false].

	"Second possibility - condition within a sequence of OR tests, but not the last"
	(bytecode = OpcodePool.NearJumpIfTrue or: [bytecode = OpcodePool.LongJumpIfTrue]) ifTrue:
		[self currentConditions add: aCondition; beOR.
		^false].

	"and: possibilities"
	((bytecode between: 118 and: 125 "JumpIfFalse+offsets") or: [bytecode  = OpcodePool.NearJumpIfFalse or: [bytecode = OpcodePool.LongJumpIfFalse]]) ifTrue:
		["For and:, a PushFalse bytecode would be after the jump"
		nextBytecode := bytecodes at: blockEndpoint.
		(nextBytecode = ##(OpcodePool.PushPseudo+1) "PushFalse" or: [nextBytecode = OpcodePool.ReturnFalse]) ifFalse: 
			["Condition within a sequence of and: tests but not the last"
			self currentConditions add: aCondition; beAND. 
			^true].
		"Last condition in a sequence of and: tests"
		self currentConditions isEmpty 
		ifTrue: 
			[self currentConditions add: aCondition; beAND; blockEndpoint: blockEndpoint; addLast: (self newConditionCollection blockEndpoint: blockEndpoint; yourself).
			self currentConditions: self currentConditions last]
		ifFalse: 
			[self currentConditions add: aCondition.
			temp := self newConditionCollection beAND.
			temp _add: temp "will become: currentCondiitions"; add: (self newConditionCollection blockEndpoint: blockEndpoint; yourself).
			self currentConditions become: temp.
			self currentConditions: self currentConditions last].
		^true].

	self parseError: 'unexpected bytecodes encountered during and: / or: block parsing'!

hasAccumulatedConditions

	^self accumulatedConditions isEmpty not!

isAccumulatingConditions
	^isAccumulatingConditions!

isAccumulatingConditions: anObject
	isAccumulatingConditions := anObject!

newCondition

	| newCondition |

	newCondition := super newCondition.

	self hasAccumulatedConditions ifTrue: 
		[self isAccumulatingConditions
		ifTrue: 
			[self isAccumulatingConditions: false. 
			self currentConditions postCondition: newCondition]
		ifFalse: 
			[self pushAccumulatedConditions]].

	^newCondition!

popAccumulatedConditions

	| popped |

	self accumulatedConditionsStack isEmpty ifTrue: [^self resetConditions].

	popped := self accumulatedConditionsStack removeLast.
	self 
		accumulatedConditions: popped key;
		currentConditions: popped value!

pushAccumulatedConditions

	self accumulatedConditionsStack addLast: (self accumulatedConditions -> self currentConditions).
	self resetConditions!

reset

	super reset.

	self
		resetConditions;
		accumulatedConditionsStack: OrderedCollection new!

resetConditions

	self
		currentConditions: self newConditionCollection;
		accumulatedConditions: self currentConditions;
		isAccumulatingConditions: false!

unprocessedConditionsCombinedForConcatenation: aBlockEvaluatorOrCondition

	"Combine any unprocessed conditions left over from inlined messages with aCondition, which is the argument of a concatenation operation ( || ) whose receiver is a block evaluator.
	Return the combined conditions for concatenation, or aCondition forConcatenation if none"

	^self hasAccumulatedConditions 
		ifTrue: [self unprocessedConditionsCombinedWith: aBlockEvaluatorOrCondition depth: 2]
		ifFalse: [aBlockEvaluatorOrCondition forConcatenation]
!

unprocessedConditionsCombinedWith: aCondition depth: anInteger

	"Combine any unprocessed conditions left over from inlined messages with aCondition.
	Return the combined conditions, or aCondition if none"

	| frame conditions |

	"This line is obviously very sensitive to the overall implementation of the parser"
	frame := Processor activeProcess topFrame sender. 
	anInteger timesRepeat: [frame := frame sender].
	frame ip < self currentConditions blockEndpoint ifTrue: [^aCondition].

	"Accumulated conditions arise from detection of inlined logical operators (and:, or:) during the parse. Add the parseResult (final condition) to these"
	self accumulatedConditions == self currentConditions 
		ifTrue: [self currentConditions add: aCondition]
		ifFalse: [self currentConditions become: aCondition].

	conditions := self accumulatedConditions.
	self popAccumulatedConditions.
	^conditions!

unprocessedConditionsCombinedWithArgument: aCondition

	"Combine any unprocessed conditions left over from inlined messages with aCondition, which is the argument of a combination operation (&, | or ||).
	The argument must be combined BEFORE the receiver.
	Return the combined conditions, or aCondition if none"

	self hasAccumulatedConditions ifFalse: 
		[self popAccumulatedConditions.
		^aCondition].

	^self unprocessedConditionsCombinedWith: aCondition depth: 4!

unprocessedConditionsCombinedWithReceiver: aCondition

	"Combine any unprocessed conditions left over from inlined messages with aCondition, which is the receiver of a combination operation (&, | or ||).
	Return the combined conditions, or aCondition if none"

	self hasAccumulatedConditions ifFalse: [^aCondition].
	aCondition == self currentConditions postCondition ifFalse: [self pushAccumulatedConditions. ^aCondition].

	^self unprocessedConditionsCombinedWith: aCondition depth: 4! !
!SSWDBDolphinBlockParser categoriesFor: #_parse:!parsing - internal!private! !
!SSWDBDolphinBlockParser categoriesFor: #_parseSortBlock:inverted:!parsing - internal!private! !
!SSWDBDolphinBlockParser categoriesFor: #accumulatedConditions!accessing!public! !
!SSWDBDolphinBlockParser categoriesFor: #accumulatedConditions:!accessing!public! !
!SSWDBDolphinBlockParser categoriesFor: #accumulatedConditionsStack!accessing!public! !
!SSWDBDolphinBlockParser categoriesFor: #accumulatedConditionsStack:!accessing!public! !
!SSWDBDolphinBlockParser categoriesFor: #currentConditions!accessing!public! !
!SSWDBDolphinBlockParser categoriesFor: #currentConditions:!accessing!public! !
!SSWDBDolphinBlockParser categoriesFor: #handleMustBeBooleanIn:!parsing - internal!private! !
!SSWDBDolphinBlockParser categoriesFor: #hasAccumulatedConditions!public!testing! !
!SSWDBDolphinBlockParser categoriesFor: #isAccumulatingConditions!accessing!public! !
!SSWDBDolphinBlockParser categoriesFor: #isAccumulatingConditions:!accessing!public! !
!SSWDBDolphinBlockParser categoriesFor: #newCondition!parsing - internal!private! !
!SSWDBDolphinBlockParser categoriesFor: #popAccumulatedConditions!parsing - internal!private! !
!SSWDBDolphinBlockParser categoriesFor: #pushAccumulatedConditions!parsing - internal!private! !
!SSWDBDolphinBlockParser categoriesFor: #reset!parsing - internal!private! !
!SSWDBDolphinBlockParser categoriesFor: #resetConditions!parsing - internal!private! !
!SSWDBDolphinBlockParser categoriesFor: #unprocessedConditionsCombinedForConcatenation:!parsing - internal!private! !
!SSWDBDolphinBlockParser categoriesFor: #unprocessedConditionsCombinedWith:depth:!parsing - internal!private! !
!SSWDBDolphinBlockParser categoriesFor: #unprocessedConditionsCombinedWithArgument:!parsing - internal!private! !
!SSWDBDolphinBlockParser categoriesFor: #unprocessedConditionsCombinedWithReceiver:!parsing - internal!private! !

!SSWDBDolphinBlockParser class methodsFor!

new

	^super new
		accumulatedConditionsStack: OrderedCollection new;
		resetConditions;
		yourself! !
!SSWDBDolphinBlockParser class categoriesFor: #new!instance creation!public! !


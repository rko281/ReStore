"Filed out from Dolphin Smalltalk 7"!

SSWDBAbstractSubTable subclass: #SSWDBIntermediateTable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBIntermediateTable guid: (GUID fromString: '{464b1409-81ca-11d5-b1df-0010a70883e2}')!
SSWDBIntermediateTable comment: ''!
!SSWDBIntermediateTable categoriesForClass!Unclassified! !
!SSWDBIntermediateTable methodsFor!

hasStaticConditions

	^true!

recoverInstanceFromRow: aDBRow into: anSSWDBObjectProxy
	
	"Redirect to the relevant concrete class. Also set the class of the proxy to the actual class of object.
	(since this may be one of the receiver's instanceClass' subclasses)"
	
	| class |
	
	class := self instanceClassFromRow: aDBRow.

	class = self instanceClass
		ifTrue: [super recoverInstanceFromRow: aDBRow into: anSSWDBObjectProxy]
		ifFalse: [(self reStore tableForClass: class) 
				recoverInstanceFromRow: aDBRow into: anSSWDBObjectProxy].
	
	anSSWDBObjectProxy _class: anSSWDBObjectProxy _proxiedObject class!

staticConditions

	| conditions |

	conditions := SSWSQLConditionCollection forOR.

	conditions add: (SSWSQLCondition field: self classField equalTo: self instanceClass).
	self subclasses do:
		[ :each | conditions add: (SSWSQLCondition field: self classField equalTo: each)].

	^conditions!

subclasses

	"Return those classes which inherit persistency from the receiver"

	^self instanceClass allSubclasses select:
		[ :each | 
		(self reStore tableForClass: each) ifNil: [false] ifNotNil: [ :table | table rootClass = self rootClass]]! !
!SSWDBIntermediateTable categoriesFor: #hasStaticConditions!public!testing! !
!SSWDBIntermediateTable categoriesFor: #recoverInstanceFromRow:into:!instance creation!public! !
!SSWDBIntermediateTable categoriesFor: #staticConditions!evaluating!public! !
!SSWDBIntermediateTable categoriesFor: #subclasses!evaluating!public! !


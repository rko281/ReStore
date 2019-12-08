"Filed out from Dolphin Smalltalk 7"!

SSWDBAbstractSubTable subclass: #SSWDBIntermediateTable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBIntermediateTable guid: (GUID fromString: '{464b1409-81ca-11d5-b1df-0010a70883e2}')!
SSWDBIntermediateTable comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBIntermediateTable categoriesForClass!Unclassified! !
!SSWDBIntermediateTable methodsFor!

_classCondition

	"For an intermediate table we have to consider subclasses"

	| conditions |

	conditions := SSWSQLConditionCollection forOR.

	conditions add: super _classCondition.
	self subclasses do: [ :each | conditions add: (SSWSQLCondition field: self classField equalTo: each)].

	^conditions!

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

subclasses

	"Return those classes which inherit persistency from the receiver"

	^self instanceClass allSubclasses select:
		[ :each | 
		(self reStore tableForClass: each) ifNil: [false] ifNotNil: [ :table | table rootClass = self rootClass]]! !
!SSWDBIntermediateTable categoriesFor: #_classCondition!evaluating!private! !
!SSWDBIntermediateTable categoriesFor: #recoverInstanceFromRow:into:!instance creation!public! !
!SSWDBIntermediateTable categoriesFor: #subclasses!evaluating!public! !


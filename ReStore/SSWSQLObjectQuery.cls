"Filed out from Dolphin Smalltalk 7"!

SSWSQLQuery subclass: #SSWSQLObjectQuery
	instanceVariableNames: 'object table'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLObjectQuery guid: (GUID fromString: '{6266c92d-3983-11d5-b1df-444553540000}')!
SSWSQLObjectQuery comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLObjectQuery categoriesForClass!Unclassified! !
!SSWSQLObjectQuery methodsFor!

isWriteQuery

	^true!

object

	"object stores the proxy'd persistent object on which the receiver represents its query"
	
	^object
	!

object: aProxydObject

	"object stores the proxy'd persistent object on which the receiver represents its query"
	
	object := aProxydObject
	!

objectControlConditions

	"Create and return an SSWSQLConditionCollection which constrains the receiver query
	by whatever fields are in the table's controlFields"
	
	| conditions |

	conditions := SSWSQLConditionCollection forAND.

	self table controlFields do:
		[ :controlField |
		conditions add:
			(SSWSQLCondition
				field: controlField
				equalTo: (controlField accessor valueIn: self object))].

	^conditions!

objectIDCondition

	"Create and return an SSWSQLCondition which identifies the receiver's object
	within its table"
	
	^SSWSQLCondition 
		field: self table idField
		equalTo: self object _id!

table

	"table is a lazy-initialized cache for the table to which the receiver's object belongs"
	
	table == nil ifTrue: [table := object _dbTable].
	
	^table!

table: anSSWDBTable

	"table is a lazy-initialized cache for the table to which the receiver's object belongs"
	
	table := anSSWDBTable! !
!SSWSQLObjectQuery categoriesFor: #isWriteQuery!public!testing! !
!SSWSQLObjectQuery categoriesFor: #object!accessing!public! !
!SSWSQLObjectQuery categoriesFor: #object:!accessing!public! !
!SSWSQLObjectQuery categoriesFor: #objectControlConditions!evaluating!public! !
!SSWSQLObjectQuery categoriesFor: #objectIDCondition!evaluating!public! !
!SSWSQLObjectQuery categoriesFor: #table!accessing!public! !
!SSWSQLObjectQuery categoriesFor: #table:!accessing!public! !

!SSWSQLObjectQuery class methodsFor!

forObject: aProxydObject

	^self new
		object: aProxydObject;
		yourself! !
!SSWSQLObjectQuery class categoriesFor: #forObject:!instance creation!public! !


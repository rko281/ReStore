"Filed out from Dolphin Smalltalk 7"!

SSWSQLTableQuery subclass: #SSWSQLConditionalQuery
	instanceVariableNames: 'conditions'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLConditionalQuery guid: (GUID fromString: '{6266c932-3983-11d5-b1df-444553540000}')!
SSWSQLConditionalQuery comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWSQLConditionalQuery categoriesForClass!Unclassified! !
!SSWSQLConditionalQuery methodsFor!

conditions

	"conditions stores an SQLConditionCollection which filters this query"
	
	^conditions!

conditions: anSQLConditionCollection

	"conditions stores an SQLConditionCollection which filters this query"
	
	conditions := anSQLConditionCollection!

hasConditions

	^self conditions isEmpty not!

parameterisedFields

	| parameterisedFields |

	parameterisedFields := OrderedCollection new.

	self conditions do:
		[ :condition |
		condition operator messageSelector = #includedIn:
			ifTrue: [(condition value occurrencesOf: SSWSQLQueryParameter) timesRepeat: [parameterisedFields add: condition field]]
			ifFalse: [(condition value == SSWSQLQueryParameter) ifTrue: [parameterisedFields add: condition field]]].

	^parameterisedFields!

writeWhereClauseOn: aStream

	"Write the SQL for the WHERE clause for the receiver's conditions on aStream.
	If no conditions, do nothing"
	
	| allConditions |
	
	allConditions := self conditions.
	self tables do:
		[ :table |
		table hasStaticConditions ifTrue: [allConditions := table sqlAndStaticConditionsWith: allConditions]].
	
	allConditions isEmpty ifFalse:
		[aStream nextPutAll: ' WHERE '.
		allConditions writeSQLOn: aStream]! !
!SSWSQLConditionalQuery categoriesFor: #conditions!accessing!public! !
!SSWSQLConditionalQuery categoriesFor: #conditions:!accessing!public! !
!SSWSQLConditionalQuery categoriesFor: #hasConditions!public!testing! !
!SSWSQLConditionalQuery categoriesFor: #parameterisedFields!evaluating!public! !
!SSWSQLConditionalQuery categoriesFor: #writeWhereClauseOn:!output!public! !


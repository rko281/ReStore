"Filed out from Dolphin Smalltalk 7"!

SSWSQLOrderedSelectQuery subclass: #SSWSQLAggregatedOrderedSelectQuery
	instanceVariableNames: 'groupByFields'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWSQLAggregatedOrderedSelectQuery guid: (GUID fromString: '{52a01adb-1424-4593-ab2a-9886f0d6649f}')!
SSWSQLAggregatedOrderedSelectQuery comment: ''!
!SSWSQLAggregatedOrderedSelectQuery categoriesForClass!Unclassified! !
!SSWSQLAggregatedOrderedSelectQuery methodsFor!

groupByFields
	^groupByFields!

groupByFields: anObject
	groupByFields := anObject!

writeSQLOn: aStream

	| first aggConditions |
	
	self writeUnorderedSQLOn: aStream.
	
	aStream nextPutAll: ' GROUP BY '.
	self groupByFields do: [ :field | field writeSQLOn: aStream] separatedBy: [aStream nextPutAll: ', '].

	aggConditions := self conditions aggregatedConditions.
	aggConditions isEmpty ifFalse:
		[aStream nextPutAll: ' HAVING '.
		aggConditions writeSQLOn: aStream].

	self writeOrderingSQLOn: aStream!

writeWhereClauseOn: aStream

	"Overriden to factor aggregated conditions out to HAVING clause"
	
	| allConditions |
	
	allConditions := self conditions unaggregatedConditions.
	self tables do:
		[ :table |
		table hasStaticConditions ifTrue: [allConditions := table sqlAndStaticConditionsWith: allConditions]].
	
	allConditions isEmpty ifFalse:
		[aStream nextPutAll: ' WHERE '.
		allConditions writeSQLOn: aStream]
! !
!SSWSQLAggregatedOrderedSelectQuery categoriesFor: #groupByFields!accessing!private! !
!SSWSQLAggregatedOrderedSelectQuery categoriesFor: #groupByFields:!accessing!private! !
!SSWSQLAggregatedOrderedSelectQuery categoriesFor: #writeSQLOn:!output!public! !
!SSWSQLAggregatedOrderedSelectQuery categoriesFor: #writeWhereClauseOn:!output!public! !


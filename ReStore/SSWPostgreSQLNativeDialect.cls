"Filed out from Dolphin Smalltalk"!

SSWPostgreSQLDialect subclass: #SSWPostgreSQLNativeDialect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWPostgreSQLNativeDialect guid: (GUID fromString: '{5c12d2e9-45e6-487c-898b-0ea468b77e95}')!

SSWPostgreSQLNativeDialect comment: ''!

!SSWPostgreSQLNativeDialect categoriesForClass!Unclassified! !

!SSWPostgreSQLNativeDialect methodsFor!

datetimeTimezoneAware

	^'TIMESTAMPTZ'!

datetimeTimezoneAwareWithResolution

	^'TIMESTAMPTZ(<1p>)'!

defaultDateTimeResolution

	^self maxDateTimeResolution!

maxDateTimeResolution

	^6! !

!SSWPostgreSQLNativeDialect categoriesForMethods!
datetimeTimezoneAware!datatypes!public! !
datetimeTimezoneAwareWithResolution!datatypes!public! !
defaultDateTimeResolution!constants!public! !
maxDateTimeResolution!constants!public! !
!

!SSWPostgreSQLNativeDialect class methodsFor!

isNative

	^true! !

!SSWPostgreSQLNativeDialect class categoriesForMethods!
isNative!public!testing! !
!


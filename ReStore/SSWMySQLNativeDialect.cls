"Filed out from Dolphin Smalltalk"!

SSWMySQLDialect subclass: #SSWMySQLNativeDialect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SSWMySQLNativeDialect guid: (GUID fromString: '{96755ce0-15ec-4665-8806-eec7067aa017}')!

SSWMySQLNativeDialect comment: ''!

!SSWMySQLNativeDialect categoriesForClass!Unclassified! !

!SSWMySQLNativeDialect methodsFor!

datetimeTimezoneAware

	^'TIMESTAMP'!

datetimeTimezoneAwareWithResolution

	^'TIMESTAMP(<1p>)'!

maxDateTimeResolution

	^6!

postLoginScript

	"All communication to/from the client is in UTF8"

	^'SET NAMES utf8mb4 '! !

!SSWMySQLNativeDialect categoriesForMethods!
datetimeTimezoneAware!datatypes!public! !
datetimeTimezoneAwareWithResolution!datatypes!public! !
maxDateTimeResolution!constants!public! !
postLoginScript!constants!public! !
!

!SSWMySQLNativeDialect class methodsFor!

isNative

	^true! !

!SSWMySQLNativeDialect class categoriesForMethods!
isNative!public!testing! !
!


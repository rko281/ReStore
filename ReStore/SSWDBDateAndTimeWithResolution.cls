"Filed out from Dolphin Smalltalk 7"!

SSWDBClassWithInfo subclass: #SSWDBDateAndTimeWithResolution
	instanceVariableNames: 'resolution'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBDateAndTimeWithResolution guid: (GUID fromString: '{9e464b5e-ac2b-431e-b153-4c7068cdede8}')!
SSWDBDateAndTimeWithResolution comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBDateAndTimeWithResolution categoriesForClass!Unclassified! !
!SSWDBDateAndTimeWithResolution methodsFor!

beMicrosecondResolution

	self resolution: 6!

beMillisecondResolution

	self resolution: 3!

infoClass

	^DateAndTime!

resolution 

	"resolution is the number of digits after the decimal point following seconds:
	 - 0 for seconds resolution
	 - 3 for milliseconds resolution
	 - 6 for microseconds resolution etc."

	^resolution!

resolution: anInteger

	"resolution is the number of digits after the decimal point following seconds:
	 - 0 for seconds resolution
	 - 3 for milliseconds resolution
	 - 6 for microseconds resolution etc."

	resolution := anInteger! !
!SSWDBDateAndTimeWithResolution categoriesFor: #beMicrosecondResolution!initializing!public! !
!SSWDBDateAndTimeWithResolution categoriesFor: #beMillisecondResolution!initializing!public! !
!SSWDBDateAndTimeWithResolution categoriesFor: #infoClass!constants!public! !
!SSWDBDateAndTimeWithResolution categoriesFor: #resolution!accessing!public! !
!SSWDBDateAndTimeWithResolution categoriesFor: #resolution:!accessing!public! !


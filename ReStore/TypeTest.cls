"Filed out from Dolphin Smalltalk 7"!

Object subclass: #TypeTest
	instanceVariableNames: 'char varchar medText largeText unsizedText integer float decimal date time datetime timeWithMilliseconds datetimeWithMilliseconds trueBoolean falseBoolean'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TypeTest guid: (GUID fromString: '{b3ad4982-4b76-11d5-b1df-0010a70883e2}')!
TypeTest comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!TypeTest categoriesForClass!Unclassified! !
!TypeTest methodsFor!

char
	"Private - Answer the value of the receiver's ''char'' instance variable."

	^char!

char: anObject
	"Private - Set the value of the receiver's ''char'' instance variable to the argument, anObject."

	char := anObject!

date
	"Private - Answer the value of the receiver's ''date'' instance variable."

	^date!

date: anObject
	"Private - Set the value of the receiver's ''date'' instance variable to the argument, anObject."

	date := anObject!

datetime
	"Private - Answer the value of the receiver's ''datetime'' instance variable."

	^datetime!

datetime: anObject
	"Private - Set the value of the receiver's ''datetime'' instance variable to the argument, anObject."

	datetime := anObject!

datetimeWithMilliseconds
	^datetimeWithMilliseconds!

datetimeWithMilliseconds: anObject
	datetimeWithMilliseconds := anObject!

decimal
	"Private - Answer the value of the receiver's ''decimal'' instance variable."

	^decimal!

decimal: anObject
	"Private - Set the value of the receiver's ''decimal'' instance variable to the argument, anObject."

	decimal := anObject!

falseBoolean
	"Private - Answer the value of the receiver's ''falseBoolean'' instance variable."

	^falseBoolean!

falseBoolean: anObject
	"Private - Set the value of the receiver's ''falseBoolean'' instance variable to the argument, anObject."

	falseBoolean := anObject!

float
	"Private - Answer the value of the receiver's ''float'' instance variable."

	^float!

float: anObject
	"Private - Set the value of the receiver's ''float'' instance variable to the argument, anObject."

	float := anObject!

integer
	"Private - Answer the value of the receiver's ''integer'' instance variable."

	^integer!

integer: anObject
	"Private - Set the value of the receiver's ''integer'' instance variable to the argument, anObject."

	integer := anObject!

largeText
	"Private - Answer the value of the receiver's ''largeText'' instance variable."

	^largeText!

largeText: anObject
	"Private - Set the value of the receiver's ''largeText'' instance variable to the argument, anObject."

	largeText := anObject!

medText
	"Private - Answer the value of the receiver's ''medText'' instance variable."

	^medText!

medText: anObject
	"Private - Set the value of the receiver's ''medText'' instance variable to the argument, anObject."

	medText := anObject!

time
	"Private - Answer the value of the receiver's ''time'' instance variable."

	^time!

time: anObject
	"Private - Set the value of the receiver's ''time'' instance variable to the argument, anObject."

	time := anObject!

trueBoolean
	"Private - Answer the value of the receiver's ''trueBoolean'' instance variable."

	^trueBoolean!

trueBoolean: anObject
	"Private - Set the value of the receiver's ''trueBoolean'' instance variable to the argument, anObject."

	trueBoolean := anObject!

unsizedText
	"Private - Answer the value of the receiver's ''unsizedText'' instance variable."

	^unsizedText!

unsizedText: anObject
	"Private - Set the value of the receiver's ''unsizedText'' instance variable to the argument, anObject."

	unsizedText := anObject!

varchar
	"Private - Answer the value of the receiver's ''varchar'' instance variable."

	^varchar!

varchar: anObject
	"Private - Set the value of the receiver's ''varchar'' instance variable to the argument, anObject."

	varchar := anObject! !
!TypeTest categoriesFor: #char!accessing!private! !
!TypeTest categoriesFor: #char:!accessing!private! !
!TypeTest categoriesFor: #date!accessing!private! !
!TypeTest categoriesFor: #date:!accessing!private! !
!TypeTest categoriesFor: #datetime!accessing!private! !
!TypeTest categoriesFor: #datetime:!accessing!private! !
!TypeTest categoriesFor: #datetimeWithMilliseconds!accessing!private! !
!TypeTest categoriesFor: #datetimeWithMilliseconds:!accessing!private! !
!TypeTest categoriesFor: #decimal!accessing!private! !
!TypeTest categoriesFor: #decimal:!accessing!private! !
!TypeTest categoriesFor: #falseBoolean!accessing!private! !
!TypeTest categoriesFor: #falseBoolean:!accessing!private! !
!TypeTest categoriesFor: #float!accessing!private! !
!TypeTest categoriesFor: #float:!accessing!private! !
!TypeTest categoriesFor: #integer!accessing!private! !
!TypeTest categoriesFor: #integer:!accessing!private! !
!TypeTest categoriesFor: #largeText!accessing!private! !
!TypeTest categoriesFor: #largeText:!accessing!private! !
!TypeTest categoriesFor: #medText!accessing!private! !
!TypeTest categoriesFor: #medText:!accessing!private! !
!TypeTest categoriesFor: #time!accessing!private! !
!TypeTest categoriesFor: #time:!accessing!private! !
!TypeTest categoriesFor: #trueBoolean!accessing!private! !
!TypeTest categoriesFor: #trueBoolean:!accessing!private! !
!TypeTest categoriesFor: #unsizedText!accessing!private! !
!TypeTest categoriesFor: #unsizedText:!accessing!private! !
!TypeTest categoriesFor: #varchar!accessing!private! !
!TypeTest categoriesFor: #varchar:!accessing!private! !

!TypeTest class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #char as: (String fixedSize: 50);
		define: #varchar as: (String maxSize: 250);
		define: #medText as: (String maxSize: 2000);
		define: #largeText as: (String maxSize: 5000);
		define: #unsizedText as: String;
		define: #integer as: Integer;
		define: #float as: Float;
		define: #decimal as: (ScaledDecimal withPrecision: 20 scale: 4);
		define: #date as: Date;
		define: #time as: Time;
		define: #datetime as: DateAndTime;
		define: #datetimeWithMilliseconds as: DateAndTime withMillisecondResolution;
		define: #trueBoolean as: Boolean;
		define: #falseBoolean as: Boolean;
		yourself! !
!TypeTest class categoriesFor: #reStoreDefinition!public! !


"Filed out from Dolphin Smallalk"!

Object subclass: #TypeTest
	instanceVariableNames: 'char varchar medText largeText unsizedText tinyBlob medBlob largeBlob unsizedBlob integer largeInteger float decimal date time datetime timeWithMilliseconds datetimeWithMilliseconds trueBoolean falseBoolean uuid'
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

largeBlob
	^largeBlob!

largeBlob: anObject
	largeBlob := anObject!

largeInteger
	^largeInteger!

largeInteger: anObject
	largeInteger := anObject!

largeText
	"Private - Answer the value of the receiver's ''largeText'' instance variable."

	^largeText!

largeText: anObject
	"Private - Set the value of the receiver's ''largeText'' instance variable to the argument, anObject."

	largeText := anObject!

medBlob
	^medBlob!

medBlob: anObject
	medBlob := anObject!

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

tinyBlob
	^tinyBlob!

tinyBlob: anObject
	tinyBlob := anObject!

trueBoolean
	"Private - Answer the value of the receiver's ''trueBoolean'' instance variable."

	^trueBoolean!

trueBoolean: anObject
	"Private - Set the value of the receiver's ''trueBoolean'' instance variable to the argument, anObject."

	trueBoolean := anObject!

unsizedBlob
	^unsizedBlob!

unsizedBlob: anObject
	unsizedBlob := anObject!

unsizedText
	"Private - Answer the value of the receiver's ''unsizedText'' instance variable."

	^unsizedText!

unsizedText: anObject
	"Private - Set the value of the receiver's ''unsizedText'' instance variable to the argument, anObject."

	unsizedText := anObject!

uuid
	^uuid!

uuid: anObject
	uuid := anObject!

varchar
	"Private - Answer the value of the receiver's ''varchar'' instance variable."

	^varchar!

varchar: anObject
	"Private - Set the value of the receiver's ''varchar'' instance variable to the argument, anObject."

	varchar := anObject! !
!TypeTest categoriesForMethods!
char!accessing!private! !
char:!accessing!private! !
date!accessing!private! !
date:!accessing!private! !
datetime!accessing!private! !
datetime:!accessing!private! !
datetimeWithMilliseconds!accessing!private! !
datetimeWithMilliseconds:!accessing!private! !
decimal!accessing!private! !
decimal:!accessing!private! !
falseBoolean!accessing!private! !
falseBoolean:!accessing!private! !
float!accessing!private! !
float:!accessing!private! !
integer!accessing!private! !
integer:!accessing!private! !
largeBlob!accessing!private! !
largeBlob:!accessing!private! !
largeInteger!accessing!private! !
largeInteger:!accessing!private! !
largeText!accessing!private! !
largeText:!accessing!private! !
medBlob!accessing!private! !
medBlob:!accessing!private! !
medText!accessing!private! !
medText:!accessing!private! !
time!accessing!private! !
time:!accessing!private! !
tinyBlob!accessing!private! !
tinyBlob:!accessing!private! !
trueBoolean!accessing!private! !
trueBoolean:!accessing!private! !
unsizedBlob!accessing!private! !
unsizedBlob:!accessing!private! !
unsizedText!accessing!private! !
unsizedText:!accessing!private! !
uuid!accessing!private! !
uuid:!accessing!private! !
varchar!accessing!private! !
varchar:!accessing!private! !
!

!TypeTest class methodsFor!

reStoreDefinition

	^super reStoreDefinition
		define: #char as: (String fixedSize: 50);
		define: #varchar as: (String maxSize: 250);
		define: #medText as: (String maxSize: 2000);
		define: #largeText as: (String maxSize: 5000);
		define: #unsizedText as: String;

		define: #tinyBlob as: (ByteArray maxSize: 255);
		define: #medBlob as: (ByteArray maxSize: 2000);
		define: #largeBlob as: (ByteArray maxSize: 5000);
		define: #unsizedBlob as: ByteArray;

		define: #integer as: Integer;
		define: #largeInteger as: LargeInteger;
		define: #float as: Float;
		define: #decimal as: (ScaledDecimal withPrecision: 20 scale: 4);

		define: #date as: Date;
		define: #time as: Time;
		define: #datetime as: DateAndTime;
		define: #datetimeWithMilliseconds as: DateAndTime withMillisecondResolution;

		define: #trueBoolean as: Boolean;
		define: #falseBoolean as: Boolean;

		define: #uuid as: GUID;

		yourself! !
!TypeTest class categoriesForMethods!
reStoreDefinition!public! !
!


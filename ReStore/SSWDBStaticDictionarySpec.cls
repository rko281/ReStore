"Filed out from Dolphin Smalltalk 7"!

SSWDBKeyedStaticCollectionSpec subclass: #SSWDBStaticDictionarySpec
	instanceVariableNames: 'keyClass isKeyDependent isKeyRelated'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SSWDBStaticDictionarySpec guid: (GUID fromString: '{51e5267a-93ea-11d5-b1e0-444553540000}')!
SSWDBStaticDictionarySpec comment: 'ReStore
©2019 John Aspinall
https://github.com/rko281/ReStore'!
!SSWDBStaticDictionarySpec categoriesForClass!Unclassified! !
!SSWDBStaticDictionarySpec methodsFor!

aboutToBeUnstored: aProxyObject

	"Also unstore member keys, if the receiver is so dependent"

	self isKeyDependent ifTrue: [(self accessor valueIn: aProxyObject) keysDo: [ :each | each unstore]].

	^super aboutToBeUnstored: aProxyObject!

beKeyDependent

	isKeyDependent := true!

beKeyRelated

	isKeyRelated := true!

beKeyUnrelated

	isKeyRelated := false!

createCollectionTable

	"Intercept to set the Class of the key field in the collection table"
		
	super createCollectionTable.

	(self collectionTable fieldAccessing: #index) targetClass: self keyClass!

initialize

	super initialize.

	isKeyDependent := false.
	isKeyRelated := false!

isKeyDependent

	"Dictionary keys can optionally be dependent (see isValueDependent)"

	^isKeyDependent!

isKeyRelated

	"Dictionary keys can optionally be related (see isValueRelated)"

	^isKeyRelated!

keyClass

	"keyClass stores the Class of the objects that are the keys to this Dictionary.
	This should be a valid base class (String, Date etc.) or a persistent class"

	^keyClass!

keyClass: aBasicClass

	"keyClass stores the Class of the objects that are the keys to this Dictionary.
	This should be a valid base class (String, Date etc.) or a persistent class"

	keyClass := aBasicClass!

setKeyClass: aClass

	"Double-despatch to the argument"
	
	aClass beKeyClassOf: self
! !
!SSWDBStaticDictionarySpec categoriesFor: #aboutToBeUnstored:!actions - api!public! !
!SSWDBStaticDictionarySpec categoriesFor: #beKeyDependent!initializing!public! !
!SSWDBStaticDictionarySpec categoriesFor: #beKeyRelated!initializing!public! !
!SSWDBStaticDictionarySpec categoriesFor: #beKeyUnrelated!initializing!public! !
!SSWDBStaticDictionarySpec categoriesFor: #createCollectionTable!initializing!public! !
!SSWDBStaticDictionarySpec categoriesFor: #initialize!initialize/release!public! !
!SSWDBStaticDictionarySpec categoriesFor: #isKeyDependent!public!testing! !
!SSWDBStaticDictionarySpec categoriesFor: #isKeyRelated!public!testing! !
!SSWDBStaticDictionarySpec categoriesFor: #keyClass!accessing!public! !
!SSWDBStaticDictionarySpec categoriesFor: #keyClass:!accessing!public! !
!SSWDBStaticDictionarySpec categoriesFor: #setKeyClass:!accessing!public! !


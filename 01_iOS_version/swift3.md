
## 목차
* The Grand Renaming
* Foundation value types
* Working with C APIs
* Language feature changes
* Where to go from here?

<br>
## The Grand Renaming

1. Clarity at the call site : 가능한 한 영어 문장 처럼 읽힐 수 있도록... (영어 잘 모르는 나 같은 사람은? ㅠ.ㅠ)
2. Assume common patterns and naming convensions 
3. Avoid repeated words

#### Overloading
함수이름에서 Parameter Name을 제거하다 보면 같은이름의 함수가 여럿 생성될 수 있음을 주의


#### Grammatical rules
**Reads like a sentence**

만약 method에 side effects가 있다면 동사로 시작하는 이름을 갖는게 좋음.

```
// "Sort" is a verb, the sorting is in-place,// so it is a side effect.mutating func sortAlphabetically() {
	...
}
```

스스로 변경되는 것이 아니라 변경된 instance를 return한다면 ed/ing rule 적용

```
// sortED
func sortedAlphabetically() -> WordList {	... 
}

// Remove is a verbmutating func removeWordsContaining(_ substring: String) {	... 
}
// RemovINGfunc removingWordsContaining(_ substring: String) -> WordList {	... 
}
```

Bool은 is로 시작하는 변수명을 갖는게 좋음.


## Foundation value types

```
Copy on write : 하나의 value type의 값이 바뀌기 전까지
    1개의 본체만 존재하다가 값이 변경될 때 복사가 일어나면서 분리됨! 
```

[1. Apple Blog](https://developer.apple.com/swift/blog/?id=10)
#### How to Choose? 

* NSObject의 subclass는 당근 class
* 이럴 땐 value type:
	* 인스턴스 데이터 비교(```==```)가 말이될 때
	* copy가(assign?) 독립적인 상태를 갖기를 원할 때 
	* 해당 data가 multi-thread 환경에서 사용될 때
		* 만약 공유되어야 하면 reference type with locking
* 이럴 땐 reference type:
	* 인스턴스 identity 비교(```===```)가 말이될 때
	* 공유되거나 변경가능한 상태를 원할 때 (shared and mutable)

> You can safely pass copies of values across threads without synchronization. In the spirit of improving safety, this model will help you write more predictable code in Swift.

[2. The Swift Programming Language](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/ClassesAndStructures.html)
#### Choosing Between Classes and Structures
* General guideline, 아래 조건 중 하나이상이 만족되면 structure:
	* structure의 primary purpose는 몇몇 비교적 간단한 데이터 value들을 묶는(encapsulate) 것임.
	* encapsulated value들이 인스턴스에 assign 또는 pass around될 때, 참조되기보다는 복사되는 것이 합리적일 때 structure를 사용
	* structure의 모든 property는 그 자체가 value type이며 참조되는 것이 아니라 복사 될 것으로 expected.
	* structure는 존재하는 다른 type의 properties와 behavior를 상속할 필요가 없음.

> In all other cases, define a class, and create instances of that class to be managed and passed by reference. In practice, this means that most custom data constructs should be classes, not structures.

[3. Raywenderlich](https://www.raywenderlich.com/112029/reference-value-types-in-swift-part-2)
#### Getting Value Semantics From Mixed Types
 * Reference Types Containing Value Type Properties
 	* NO PROBLEM!
 * Value Types Containing Reference Type Properties
 	* Getting value semantics from mixed types
 	* Copying References During Initialization
 	* Using Copy-on-Write Computed Properties
 
```
struct Bill {
	let amount: Float
	private var _billedTo: Person 

	var billedToForRead: Person {
		return _billedTo
	}
	var billedToForWrite: Person {
		mutating get {
			if !isKnownUniquelyReferenced(&_billedTo) {
				_billedTo = Person(name: _billedTo.name, address: _billedTo.address)
			}
			return _billedTo
		}
	}
 	
 	init(amount: Float, billedTo: Person) {
		self.amount = amount
		_billedTo = Person(name: billedTo.name, address: billedTo.address)
	}
}
```

[fag.sa](http://faq.sealedabstract.com/structs_or_classes/)
#### Should I use a Swift struct or a class?
* anything that wraps (read: calls) the kernel really shouldn't be a struct.
	* File I/O
	* Networking
	* Message passing
	* Heap memory allocation
	* etc.
* you shouldn't wrap not just the kernel, but any singleton. Any singleton that you try and mess with from a struct will have this issue, becuase the references to those singletons don't get copied.
	* Location stuff (you have 1 GPS)
	* Screen-drawing stuff (you have 1 display)
	* Stuff that talk to UIApplication.shared
	* etc.
* Classic value type stuff are left.
	* Pure data : "Bag of ints" ```CGRect``` 
	* leaf nodes 
	* dumb models in MVC

> Classes everywhere. Not "immutable valuable types everywhere" like in the Struct Philosophy™

* tl;dr
	* structs are for "bags of data". Your Ints, your CGRect. Your Person record.
	* If you find yourself talking to "something else" inside your struct code, where "something else" is the file system, the network, the GPS, you have made a wrong turn somewhere.
	* If you find yourself with structs that contain structs that contain structs that contain structs, you have probably made a wrong turn somewhere. You'll discover that way the hell down there somewhere you forgot a mutating, and now you have to mark mutating for all the things.
	* Most types don't need to be threadsafe. Most instances do. Use struct for the 10% of your types that make 90% of the instances. Use class for the 90% of your types that make up 10% of your instances.
	* If overloading == to compare two things elementwise sounds like a great idea, use a struct. If you hesitate, use a class.
	* The Swift Book is consistent with this guidance.


## Working with C APIs

Grand Central Dispatch, Core Graphics가 Class로 구조화됨

## Language feature changes

#### Increment operators 
불명확성 때문에 제거됨. 

#### C-Style for loops
제거됨

#### Currying syntax
제거됨

#### Key paths
```
lass TimeMachine: NSObject {  var currentYear = 2016}let timeMachine = TimeMachine()timeMachine.value(forKey: #keyPath(TimeMachine.currentYear))// gives 2016

class TimeMachine {  dynamic var currentYear = 2016  var destinationYear = 1985}#keyPath(TimeMachine.currentYear) // "currentYear"#keyPath(TimeMachine.destinationYear) // Error
```

#### Access control

#### Enums
소문자로 시작하는 것이 standard, enum 선언 block 안에서도 "." 사용해야함.

#### Closures
디폴트 nonescaping (self 사용안해도 됨.)

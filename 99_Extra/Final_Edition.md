Final Edition
=============

# agile, TDD
### agile
간단히 말해 폭포수 개발방식에 식상한 사람들이 만들어낸 짧은 주기로 기능을 개선시켜 나가는 개발 방식입니다.

### TDD
TDD 는 production 코드를 작성하기 전에 실패하는 case 코드를 먼저 작성하는 기술입니다. 테스트 주도 구현 및 설계는 production 코드를 더도 말고 덜도 말고, 딱 해당 case 를 통과할 수 있는만큼만 구현할 수 있도록 도와줍니다.
적응하는데 시간이 걸리고, 가시적인 결과가 바로 나타나지도 않지만 계속 하다보면 점차 빠르게 개발할 수 있도록 도와줍니다.
TDD 는 코드의 변경이나 리팩토링이 발생했을 때 특히나 진가를 발휘합니다. 왜냐하면 그동안 진행한 테스트 코드들을 통해 변경되지 않는 코드들은 정상적으로 동작한다는 확신을 얻을 수 있기 때문입니다.

#### XCTest
실패하는 테스트 케이스 작성 -> 통과하도록 구현 -> 성능 향상을 위한 리팩토링, 이 과정을 Red-Green-Refactor cycle 이라고 부릅니다. 각 테스트 케이스마다 공통으로 사용할 만한 것들은 setUp 메서드에서 생성해 놓습니다. 테스트 클래스의 멤버변수 같은 것들 말이죠. 그리고 테스트 종료시 생성된 객체들을 해제하는 등의 작업을 tearDown 메서드에서 수행합니다.

- Unit Test
    - 테스트 케이스 내부에서 loop 를 돌면서 테스트하는 것은 지양해야 합니다. 어떤 index 에서 fail 이 발생하는지 한 번에 알아보기 힘들기 때문입니다. 
    - 코드의 어느 부분에서 문제가되는지 확인하기 어려운 경우에는 "Test Failure Breakpoint" 를 추가하여 실패하는 케이스의 변수/데이터 값들을 분석할 수 있습니다.

- UI Test
    - 먼저 XCUIApplication 객체를 생성합니다. 이 녀석은 테스트할 애플리케이션이라고 생각하면 됩니다.
    - 애플리케이션 객체에는 대표적인 UI Component 들에 접근할 수 있는 프로퍼티, 메서드에 접근하여 테스트를 진행할 수 있습니다.
    - 테스트 케이스를 잘 작성하면 자동화가 가능합니다.
``` swift
// 애플리케이션 받아오기
let app = XCUIApplication()
// collectionView 에 접근하기
let collectionView = app.collectionViews.firstMatch
// collectionView 의 cell 갯수 확인
XCAssertEqual(collectionView.cell.count, 10)
// collectionView 의 5 번째 cell 잡고 swipe up 하기
collectionView.cells.element(boundBy: 5).swipeUp()
```

[UI Test 관련 apple keynote WWDC2015 - Session 406](https://youtu.be/7zMGf-0OnoU)

그러나 iOS UI 개발에 있어서 세세한 테스트 케이스의 작성은 현실적으로 힘든 점이 있습니다. model 이나 business logic 의 경우라면 Unit 테스트 케이스를 작성할만 하지만 일반적인 UI 에 맞춰 케이스를 작성한다는건 꽤나 지루하고 고통스러운 작업이겠죠...

다행히 UI test 함수에서 화면을 기록하며 해당 행위를 코드로 작성해주는 기능이 있습니다. 기본적인 case 는 화면 기록으로 작성하고 추후 각 코드를 customizing 하면 좀 더 수월하게 테스트를 진행할 수 있습니다.

[RWDevcon UI Testing 및 Accessibility 를 자세히 설명하는 영상 링크(목소리와 발음으로 추측컨데.... WWDC 2017 Building Visually Rich User Experiences 에서 강연한 여자인 듯 함)](https://youtu.be/NrHSZgbQ7_k)

#### Quick/Nimble
CXTest 를 기반으로 만들어진 테스트 환경을 제공합니다. 테스트를 위해 새로운 클래스를 만들때 QuickSpec 을 상속받아야 하는 번거로움이 있지만 테스트 케이스가 직관적이며 함수형으로 작성할 수 있습니다.




* * *
# Thread, Run Loop
### Process
 애플리케이션을 실행하는데 필요한 모든 것이 포함되어 있으며, stack, heap 및 기타 모든 리소스도 포함됩니다. iOS 는 멀티테스킹을 지원하지만 애플리케이션은 단 하나의 process 만을 가집니다. 반면 macOS 는 Process 객체를 생성해서 사용할 수 있습니다.

### Thread
 작은 process 라고 생각하면 됩니다. process 와 달리 thread 는 메모리를 자신의 부모 process 와 공유합니다. 이로 인해 하나의 변수는 여러개의 thread 로부터 data races 당할 수 있습니다. 즉 값을 읽어들일 때 원치 않는 결과가 나올 수 있습니다. thread 는 iOS 에서 제한된 리소스입니다. process 하나당 64개의 thread 를 생성할 수 있지만 일반적으로 그럴만한 일은 거의 없습니다.

### Dispatch Queues
 위와 같은 환경에서 코드를 동시에 동작시키기 위한 옵션이 필요한데 그게 바로 Dispatch Queues 입니다. queue 에 task 를 추가하면 어느 시점엔가 실행되도록 할 수 있습니다. queue 에는 몇가지 종류가 있는데, 바로 serial, concurrent queue 입니다. serial queue 는 queue 에 task 를 추가한 순서대로 각 task 가 진행 및 마무리 됩니다., concurrent 는 각 task 의 종료를 기다리지 않고 추가된 순서대로 실행시켜서 동시에 여러가지 작업을 진행할 수 있습니다.

### Operation Queues
 Dispatch Queue 를 OOP 적으로 wrapping 한 개체입니다. 간단하게 block 으로 사용할 수도 있고 의존성 주입으로 작업의 선/후행을 정할 수도 있습니다. 그리고 실행되기 전에 cancel 할 수도 있지만 해당 기능을 사용하려면 Operation 을 sub classing 해서 구현해야 합니다.

### Run Loops
 위에 설명한 Queues 와 유사합니다. 시스템은 모든 작업을 queue 에 넣고 모든 작업을 실행한 다음 다시 처음부터 시작합니다. 예를 들면 화면을 redraw 하는 과정은 Run Loop 에 의해 동작합니다. Run Loop 는 concurrecy 를 위한 방법은 아닙니다. 오히려 하나의 thread 에 묶여 있습니다. 그렇다고 모든 thread 에 run loop 가 있는건 아니고 요청이 있을 경우 처음으로 생성됩니다. run loop 는 input source 가 있는 경우에만 계속 동작할 수 있습니다. 그렇지 않으면 실행된 모든 작업들이 즉시 종료됩니다.

### Atomic
기능적으로 분할할 수 없거나 분할되지 않도록 보증되는 상태를 말합니다. 즉 atomic operation 이란, 멀티 thread 상황에서 공유자원에 대해 여러 thread 가 동시에 액세스하여 data races 가 발생하는 것을 막기 위한 방법입니다.

#### swift 는 기본적으로 atomic operation 을 지원하지 않습니다.
그렇기 때문에 직접 구현해야하는 데 방법은 다음과 같습니다.

- Lock: 리소스에 여러개의 thread 가 접근하지 못하도록 하는 간단한 방법입니다.(그러나 Lock 은 thread 를 sleep/wakup 시키는 등 많은 자원 및 시간을 소모합니다.) thread 는 리소스에 접근할때 lock 상태인지 확인하고, lock 상태가 아니면 리소스에 접근 후 lock 상태로 만듭니다. 그리고 작업이 완료된 후 unlock 상태로 변경합니다. 만약 리소스에 접근했는데 lock 상태라면 기다립니다. sleep/wakeup 를 반복하며 lock 상태인지 아닌지를 체크하게 됩니다. 사용 예를 아래와 같습니다.

``` swift
let lock = NSLock()
var count: Int {
	set {
		lock.lock()
		_count = newValue
		lcok.unlock()
	}
}
```

- SpinLock: 보호해야할 작업의 단위가 작다면 SpinLock 을 사용할 수 있습니다. Lock 보다 조금 더 많은 자원을 사용하지만 빠르게 작업을 수행할 수 있습니다. 하지만 iOS 에서 SpinLock 은 허용되지 않습니다. 대신 비슷한 개념인 Quality of Service(QoS) 가 있습니다. QoS 를 사용하면 우선순위가 낮은 thread 는 전혀 실행되지 않을 수도 있습니다. 

- Mutex: Lock 과 비슷한 개념이지만 역시 swift 에서는 사용할 수 없습니다. C 의 pthread_mutex 로 사용할 수 있습니다.

- Synchroinzed: Objective-C 에서는 @synchronized 라는게 있었는데요, 이건 Mutex 를 쉽게 사용하는 것 같은 방법입니다. 하지만 역시나 swift 에서는 제공하지 않고 Objective-C 의 feature 인 objc_sync_enter() 메서드를 호출해야 합니다.

``` swift
let lock = self
var count: Int {
	set {
		objc_sync_enter(lock)
		_count = newValue
		objc_sync_exit(lock)
	}
}
```

- Concurrency Queues Dispatching: Mutex, Synchronized 가 모두 제공되지 않는 swift 에서는 DispatchQueue 를 사용하는것이 매우 중요해졌습니다. 작업들을 동일한 queue 에 담고, queue 들을 synchronously 하게 사용하면 mutext 와 유사한 효과를 얻을 수 있으나 컨텍스트 생성 및 변경에 너무 많은 시간을 소모한다는 단점이 있습니다. 만약 rendering frame rate 가 떨어진다면 다른 방법을 사용해야 합니다.

- Dispatch Barriers: GCD 를 사용한다면 또 다른 옵션이 있습니다. 바로 Dispatch Barrier 입니다. 보호하고자 하는 리소스를 barrier block 으로 만들어서 보호할 수 있습니다. 

``` swift
let isolationQueue = DispatchQueue(label:"com.anonymous.isolation", attributes: .conccurent)
var count: Int {
	set {
		isolationQueue.async(flags: .barrier) {
			self._count = newValue
		}
	}
	get {
		return isolationQueue.sync{
			return _count
		}
	}
}
```

- Semaphore: thread 동기화에 대한 상호 배타성을 지원하는 자료구조입니다. counter, FIFO queue, wait(), signal() 로 구성되어 있습니다. thread 가 보호된 리소스에 접근하려고 할때 마다 Semaphore 의 wait() 메서드를 호출합니다. Semaphore 는 counter 가 0 이 될때까지 줄이고, 그때까지 thread 를 접근시킬 수 있습니다. 그렇지 않으면 thread 를 queue 에 저장합니다. thread 가 보호된 resource 에서 벗어나려고 할 때, Semaphore 의 signal() 메서드를 호출합니다. 그러면 Semaphore 는 우선 queue 에 대기중인 thread 가 있는지 확인해서 대기중인 thread 가 있다면 wakeup 시킵니다. 그러면 다시 동작하게 된 thread 는 접근하는 thread 가 없는 resource 에 접근할 수 있게 됩니다. 그렇지 않다면 counter 를 1 증가시킵니다. iOS 에서는 DispatchSemaphore 를 사용해 이런 작업을 수행할 수 있습니다.

``` swift
let s = DispatchSemaphore(value: 1)
var count: Int {
	set {
		_ = s.wait(timeout: DispatchTime.distantFurture)
		_count = newValue
		s.signal()
	}
}
```

- Trampoline: 마지막으로 가장 쉬워서 계속 쓰고만싶은 꼼수가 있습니다. thread 를 확인하는 방법인데... 자주 사용하면 협업하는 사람들을 혼란에 빠뜨릴 수 있습니다. 

``` swift
func setMyValue(_ value: Int) {
	if ! Thread.isMainThread {
		DispatchQueue.main.async {
			setMayValue(value)
		}
	}
}
```

[link](https://medium.com/flawless-app-stories/basics-of-parallel-programming-with-swift-93fee8425287)




* * *
# About Memory
메모리는 3가지 파트로 구성되어 있습니다.
1. Stack: 계산 및 함수에서 사용하는 로컬 변수들이 저장되는 공간입니다.
2. Heap: data 가 동적으로 할당되는 곳입니다. 예를 들어, 새로운 객체 생성시 heap 에 해당 객체에 대한 메모리가 할당됩니다. heap 에 존재하는 모든 것들은 생명주기가 있습니다.
3. Global Data: global variables, string constants, type metadata 등..

- Value Type
    : 변수 할당시 stack 에 저장됩니다.
    : 다른 변수에 할당될 때 값이 복사됩니다.(copy by value)
    : 복사될 때 변수들이 분리되어 하나를 변경해도 다른 것들에는 영향이 없습니다.
    : heap 에 저장되지 않기 때문에 reference counting 도 필요 없습니다.
    : 다만 property 가 reference type 인 경우 문제가 있습니다.


- Reference Type
    : 인스턴스 생성시 reference 는 stack, 실제 값과 reference counting 은 heap 에서 처리됩니다. 
    : 변수에 할당시 reference 가 하나 더 stack 에 생성되고, heap 에 있는 실제 값을 참조하면서 reference counting 이 증가합니다.

- ibooks: how arc works
    : unsafe, Manual Memory Management 에서 찾아보면 알 수 있다.

- autoreleasePool
    : auto release pool 은 여전히 swift 에 존재합니다.
    : swift 에서 loop 돌면서 objc 객체를 생성하면 해당 loop 영역이 종료되는 시점에도 메모리 해제가 되지 않는다. 그럴때는 loop 블럭 내부에 autoreleasepool 을 생성해 줘야 깔끔하게 해제된다.




* * *
# 기본 타입들
- class, struct(Int, Float, Double, Bool, String, Character, Array, Dictionary, Set ..), enum, tuple, optional, closure ...

- Value Type: struct, enum, tuple
    - Copy Semantics: Deep Copy. 다른 변수에 할당시 새로운 인스턴스가 생성되어 전달됩니다.
    - identity 가 아닌 value 가 중요합니다. 각 변수는 value 에 의해 구분되어야 하므로 Equtable 을 준수해야 합니다.
    - thread safe 합니다.
    - copy 는 정해진 시간(constant time) 안에 완료됩니다. 단 property 가 reference type 인 경우 예를 들어 String, Array, Set, Dictionary 등은 constant time + reference copy time 이 소요됩니다.
    - 대신 COW(Copy On Write) 를 지원하므로 속도 저하를 보완합니다. (변수에 할당시 실제 복사가 일어나는 것이 아니라 할당된 변수에 변경이 일어나는 시점에 복사가 일어납니다.)
    - let 으로 선언시 property 들도 immutable 입니다.

- Reference Type: class, closure
    - Copy Semantics: Shallow Copy. 다른 변수에 할당시 해당 인스턴스의 포인터 주소값만 전달되어 원본을 참조합니다.
    - identity 가 중요합니다.
    - let 으로 선언시 property 들은 mutable 입니다.
    - Deep Copy 를 구현하고 싶으면 해당 클래스가 NSObject 를 상속받고, NSCopying 를 준수해야 합니다. Objective-C 에서처럼 copy(with:) 를 구현하는 거죠
    - 또는 Copyable 같은 Protocol 을 선언하여 해당 protocol 에서 copy 하는 메서드를 구현하거나, 클래스를 Builder 나 Decorator 패턴을 적용한 것처럼 자기 자신 타입을 파라미터로 받는 private 생성자를 두고 copy 메서드에서 해당 생성자를 사용해 return 하는 방법도 있습니다. 하지만 Apple 에서는 참조타입에 대한 copy 를 권장하지 않습니다. 만약 copy 되어야 한다면 struct 로 구현해야 하는 것이 아닌지 더 따져봐야 합니다.

- 데이터 전달시 원본 데이터 자체가 수정되어 각 화면에 반영되어야 한다면 참조 타입이어도 괜찮을 수 있지만 그렇지 않은 경우에는 데이터가 변경되면 문제가 발생하므로 상황에 따라 데이터 타입을 적절히 결정해야 합니다.





* * *
# Swift Perfomance
위에서 설명한 메모리 + Value vs Reference 를 모두 고려해야 합니다.

- 성능에 영향을 미치는 3가지
    1. 메모리 할딩이 stack 인지, heap 인지
    2. reference counting 이 필요하지 않은지, 필요한지
    3. method dispatch 가 static 인지, dynamic 인지(메서드 호출을(참조를) compile time 에 하는지, run time 에 하는지)

- heap 할당의 문제
    : 할당시 빈 곳을 찾고 관리하는 것은 복잡한 과정이 필요합니다.
    : 이 과정은 thread safe 해야 하기 때문에 lock 등 synchronization 동작은 성능의 저하를 가져옵니다.
    : 반면 stack 할당은 stack 포인터 변수값만 변경하는 정도입니다. ([stack pointer 참조](http://hyem2.tistory.com/entry/%EC%8A%A4%ED%83%9D%ED%8F%AC%EC%9D%B8%ED%84%B0))

- heap 할당 줄이기
``` swift
enum Color { case red, gree, blue }
enum Theme { case eat, stay, play }

var cache = [String: UIImage]()

func makeMapMarker(color: Color, theme: Theme, selected: Bool) -> UIImage {
	// 함수가 loop 안에서 빈번하게 호출되는 경우 key 생성시 heap 에 할당이 되므로 성능에 저하가 생깁니다.
	let key = "\(color):\(theme):\(selected)"
	if let image = cache[key] { return image }
}

// 위의 코드를 아래와 같이 바꾸어 heap 을 사용하지 않고 stack 만을 사용하므로 성능을 개선할 수 있습니다.
struct Attribute: Hashable {
	var color: Color
	var theme: Theme
	var selected: Bool
}

var cache = [Attribute: UIImage]()

func makeMapMarker(color: Color, theme: Theme, selected: Bool) -> UIImage {
	// 함수가 loop 안에서 빈번하게 호출되는 경우 key 생성시 heap 에 할당이 되므로 성능에 저하가 생깁니다.
	let key = Attribute(color: color, theme: theme, selected: selected)
	if let image = cache[key] { return image }
}
```

- reference counting 의 문제
    : 변수 copy 할 때마다 실행되므로 매우 빈번하게 실행됩니다.
    : 그러나 가장 큰 문제는 count 를 atomic 하게 늘리고 줄여야하므로 결국 thread safe 하게 동작해야 하는 것입니다.

- method dispatch (static)
    : compile time 에 메소드의 실제 코드 위치를 안다면 run time 에 찾는 과정 없이 바로 해당 코드 주소로 점프할 수 있습니다. 컴파일러의 최적화, method inlining 이 가능합니다.
    : method inlining
        - 효과가 있다고 판단되는 경우 compile 시점에 method 호출 부분에 method 내용을 붙여 넣습니다.
        - call stack 의 overhead 를 줄임으로써 CPU icache(instruction(명령어)-cache) 나 register(처리해야할 명령어를 저장하는 역할) 를 효율적으로 쓸 가능성이 있습니다. ([참조](https://namu.wiki/w/%EC%BA%90%EC%8B%9C%20%EB%A9%94%EB%AA%A8%EB%A6%AC))
        - compiler 의 추가 최적화가 가능합니다.(최근 method 들이 작아지는 추세이므로 더더욱 기회가 많고, 특히나 loop 안에서 호출되는 경우 큰 효과를 볼 수 있습니다.)

- method dispatch (dynamic)
    1. reference semantics 에서의 다형성(Polymorphism)    
         - super class 타입으로 생성된 sub class 들의 override 된 메서드 호출시 하위 클래스들 중 어느 클래스에서 호출된 것인지 어떻게 확인할 수 있을까요? Type Metadata 를 통해 확인할 수 있는데요. VWT(Value Witness Table) 이라는 것이 있는데 이 안에 vtable 및 allocating, copying, destroying 에 대한 기본 연산을 제공합니다. 그래서 이 VWT 안에 있는 vtable 을 통해 어떤 하위 클래스의 인스턴스가 메서드를 호출했는지 해당 vtable 에 저장된 메서드의 주소를 찾아서 호출을 해줍니다.    
         - 실제 Type 을 compile time 에 알 수 없으므로 run time 에 해당 메서드의 주소를 찾아야하므로 compiler 가 최적화를 하지 못해 성능 저하를 불러올 수 있습니다.    
    2. Objective-C 에서의 method dispatch    
         - Message sending 방식입니다.    
         - loop 안에서 빈번하게 메서드 호출이 일어나는 경우 성능저하를 불러올 수 있습니다.  

         ```swift
         [anObject doMethod: aParameter];
         // 위의 경우 아래와 같이 동적으로 해당 메서드를 찾아서 호출합니다.
         objc_msgSend(anObject, @selector(doMethod:), aParameter);
         ```

    3. Static Disaptch 로 강제하는 방법    
         - final, private 등을 쓰는 버릇을 들입니다.    
             : 해당 메서드, 프로퍼티 등은 상속되지 않으므로 static 하게 처리가 가능합니다.    
         - dynamic 사용을 자제합니다.    
         - Objc 연동을 최소화합니다.    
         - 빌드 설정에서 WMO(Whole Module Optimzation: 빌드시 모든 파일을 분석하여 static dispatch 로 변환 가능한지 등을 판단하여 최적화, 빌드시 상당히 느리므로 debug 모드에서는 사용하지 않는 것이 좋습니다. Xcode7 에서는 불안정하여 사용을 권장하지 않았습니다. 이후 버전에 대해서는 확인이 필요합니다.) 옵션을 사용합니다.    

- 성능에 영향을 미치는 3가지
    1. memory allocation: *stack* or heap
    2. reference counting: *no* or yes
    3. method dispatch: *static* or dynamic     

- 성능 개선을 위한 추상화 기법
    - class: final, private 사용으로 method dispatch 를 static 하게 할 수 있습니다. (heap, yes, dynamic 을 heap, yes, static 로 개선시킬 수 있습니다.)
    
    - struct: property 로 reference type 을 가지고 있는 경우 copy 를 할 경우 reference type 의 properteis 수 만큰 reference counting 이 발생합니다. 이 경우 enum 등 value type 으로 대체 가능한 것들은 최대한 대체하고, 불가능한 것들은 하나의 class 로 몰아서 가능한 reference counting 횟수를 줄일 수 있는 방안을 모색해야 합니다.
    (String 은 struct 로 value semantics 이지만 내부 storage 로 class 를 가지고 있으므로 copy 시 reference counting 이 동작합니다. Array, Dictionary 등도 마찬가지 입니다.)

    - protocol type: value type 에서의 다형성을 구현한 경우, class 와 달리 할당 메모리 사이즈가 제각각인데 어떻게 하나의 대표 타입으로 stack 에 메모리를 할당할 수 있을까요? 그리고 class 의 상속을 통한 경우라면 인스턴스의 메서드를 호출할 때 vtable 을 이용하면 되는데 protocol 의 경우 어떻게 특정 value type 의 인스턴스 메서드를 호출할 수 있을까요?
        - Existential Container: protocol type 의 실제 값을 넣고 관리하는 구조체라고 생각하면 됩니다. stack 에 생성됩니다.
            - value buffer(3 words - 1 words 는 32bit cpu 에서는 32bit, 64bit cpu 에서는 64bit 입니다.) + fixed size(Metadata type 을 저장하는 공간) 로 구성되어 있습니다.
            - 그렇기 때문에 properties 가 3개 이하인 경우 value buffer 에 해당 값을 저장하면 되지만, 3개를 초과하는 경우 value buffer 에 하나의 reference 를 생성하고 실제 값들은 heap 영역에 생성하게 됩니다.
        
        - VWT(Value Witness Table): Existential Container 생성/해제를 담당하는 인터페이스입니다. allocate, copy, destruct, deallocate 메서드들로 구성되어 있고, protocol 을 conform 하는 type 마다 모두 가지고 있습니다. Existential Container value buffer 다음 첫 번째 fixed size 영역에 위치합니다.
             - 인스턴스를 복사하는 경우 allocate 메서드가 호출되고, properties 를 확인하여 value buffer 에 저장할지 reference 를 생성하고 실제 값을 heap 영역에 저장할지 결정합니다.
             - 그 다음 copy 메서드가 호출되어 properties 들을 복사합니다.
             - copy 가 완료된 뒤에는 destruct, deallocate 메서드가 차례로 호출되며 메모리를 해제합니다.
        
        - PWT(Protocol Witness Table): protocol type 의 method dispatch 를 위해 추상 메서드를 구현한 메서드에 대한 데이터를 저장하는 구조체로 protocol type 을 conform 하는 type 마다 가지고 있습니다. Existential Container VWT 다음 영역에 위치합니다.
        
        - 결과적으로 value type 이므로 값 전체가 복사되는데, 3 words 를 넘기지 않으면 Existential Container 생성 후 값을 복사하고, 3 words 를 넘기는 경우 heap 에 메모리 할당 후 해당 heap 을 복사하게 됩니다. heap 에 할당된 값들이 복사되므로 reference counting 이 발생하지 않습니다. copy 할 때마다 heap 을 복사하므로 큰 성능 저하를 불러옵니다. 성능 개선을 위해 indirect storage 를 적용합니다. 하나의 class 에 properties 를 몰아 넣고, 해당 class 를 property 로 취하는 방식입니다. 이렇게 되면 heap 복사보다는 성능 비용이 저렴한 referenece counting 을 발생시켜서 성능을 개선할 수 있지만 copy 된 인스턴스의 property 변경시 해당 property 의 reference 에 접근해 값을 변경하는 것이므로 원본의 값도 함께 변경되는 문제가 발생합니다. 이때는 COW 를 직접 구현하므로써 문제를 해결할 수 있습니다. (isKnownUniquelyReferenced(:) 메서드를 사용해 파라미터로 전달된 type 이 하나의 강한 참조만 가지고 있는지의 여부를 반환하는 함수입니다. ) 

        - 3 words 이하는 stack, no, dynamic(PWT), 초과는 heap, no(value type 인 경우. referenece type 인 경우 yes), dynamic(PWT) 입니다.

        - 초과인 경우 indirect storage 사용시 heap, yes, dynamic(PWT) 으로 성능을 개선시킬 수 있습니다.

        - copy 만 하는 경우 성능은 class 와 같고, 변경하는 경우에만 COW 하기 때문에 전체적인 성능 저하를 최소화합니다. (String, Array, Dictionary 등도 이런 방식으로 value semantics 를 구현합니다.)

    - generic type: generic method 에서 generic type 파라미터 는 정적 다형성이기 때문에 run time 에 값이 변경되지 않습니다. 그렇기 때문에 compile time 에 이미 정해진 type 에 대한 method dispatch 를 VWT, PWT 등을 이용하여 수행합니다. 하지만 성능 개선을 위해 각 type 별 메서드를 따로 구현하면 어떨까하는 생각을 가질 수 있지요. 그렇게 하면 복잡한 Existential Container 를 사용하지 않아도 되고 성능도 좋아지며 method dispatch 도 static 하게되어 inlining 이 가능해집니다(compiler 최적화 가능). 하지만 그렇게 한다면 뭐하러 generic method 를 구현할까요? 고맙게도 이런 상황에서는 compiler 가 알아서 이런 작업을 수행해줍니다. 이것을 Generic Specialization 이라고 합니다. final, private 등을 사용하거나 WMO 설정을 사용하면 됩니다.
    	- 3 words 이하: 특수화 되지 않은 경우 stack, no, dynamic(PWT), 특수화된 경우 stack, no, static
        - 3 words 초과: 특수화 되지 않은 경우 heap, no, dynamic(PWT)
        - class type: 특수화된 경우 heap, yes, dynamic(vtable)

- 결론
    - Objective - C 에 비해 큰 성능 향상이 있습니다.
    - 하지만 Value, Reference, Protocol type 등의 성격을 고려해야 그 혜택을 제대로 누릴 수 있습니다.
    - 성능 최적화를 고려해야하는 경우는 
        1. 렌더링 관련 로직 등 반복적으로 빈번히 호출되는 경우
        2. 서버 환경에서의 대용량 데이터 처리하는 경우 등이 있습니다.
    - struct 는 value semantic 이 필요한 경우, class 는 identity, oop, objective-c 와의 연동이 필요한 경우, generic 은 정적 다형성이 가능한 경우, protocol 은 동적 다형성이 필요한 경우에 사용하여 성능 최적화를 구현해야 합니다.



* * *
# Design Pattern
## Class Diagram
- open arrow head with solid line: Inheritance. reading this as 'inherits from', 'is a'
- open arrow head with dotted line: Impletments Protocol, reading this as 'conforms to'
- plain arrow head with solid line: Property, Assosiation, reading this as 'has a', has one or more expression = 1...*
- plain arrow head with dotted line: Uses, Dependency
    1. 약한 참조인 property 또는 delegate 인 경우
    2. property 로 저장되지 않고 메서드의 파라미터로 전달되는 경우
    3. IBAction 과 같이 느슨한 연결이거나 callback 인경우

## Creational Pattern(생성 패턴)
- Abstract Factory, Builder, Factory Method, Prototype, Singleton

### Singleton
- 클래스에 대해 단 하나의 인스턴스만을 제공합니다.
- 물리적 혹은 개념적으로 유니크하게 매핑되는 경우 싱글톤으로 만드는게 좋습니다.
- 스태틱 펑션만 존재하는 클래스(유틸리티 펑션의 모음 클래스) 과 싱글턴의 차이?
    : 상태 보관이 필요하면 싱글톤, 아니면 유틸리티 클래스
    : 유틸리티 클래스. 함수 호출시 사이드 이펙트가 없다면 어느정도의 디펜던시를 감수하더라도 사용할 만하다.

### Singleton Plus
- Singleton 과 마찬가지로 기본적으로 static 한 인스턴스도 제공하고, 사용자가 필요에 따라 인스턴스를 생성할 수 있는 interface 를 제공합니다. 예를 들면 FileManager 처럼 default property 로 singleton 인스턴스에 접근해 사용하거나, 직접 생성해 사용할 수도 있는 거지요.

### Factory Method
- 일련의 클래스들 중 하나에서 객체를 인스턴스화하는 기능을 제공합니다.
- 공통의 수퍼 클래스나, 프로토콜을 준수하는 일련의 클래스들 중 runtime 시 필요로 하는 클래스를 사용할 수 있도록 도와줍니다.

### Builder
- 인스턴스 생성시 필요한 복잡한 작업들을 간소화하도록 도와줍니다.
- 인스턴스에 다양한 프로퍼티가 존재할 때 특정 프러퍼티들을 설정하므로써 특성이 다른 인스턴스를 쉽게 생성해낼 수 있습니다.
- 복잡한 인스턴스 생성을 한 번에 하는 대신 step-by-step 으로 생성하고자 할 때 사용합니다.

## Structural Pattern(구조 패턴)
- Adaptor, Bridge, Composite, Decorator, Facade, Flyweight, MVC, MVVM, Proxy

### Adaptor
- interface 가 상이한 클래스간 호환성을 위해 Wrapper 를 생성하여 클래스간 소통할 수 있도록 합니다.
- 이미 구현이 완료된 이후 third party library 를 사용하는 등의 상황 발생시 적용할 수 있습니다.

### Composite
- 개별 객체들과 객체의 조합을 동일한 방식으로 다룰 수 있도록 해줍니다.
- 간단하게 Tree 자료구조, OS 의 파일 시스템을 예로 들 수 있습니다.
    - Tree: Node, Leaf 로 구성되며 각 Leaf 들은 개별적인 Node 들입니다.
    - 파일 시스템: 파일, 디렉토리 또는 둘의 조합으로 이루어져 있습니다.

### Decorator
- 인스턴스의 동작을 확장하거나 수정하는데 사용됩니다.
- swift 에서는 extension, delegation 등을 예로 들 수 있습니다.

### Facade
- 내부 구현을 숨기고 간결한 interface 를 제공하여 사용의 편의성을 높여줍니다.

### MVC
- 가장 많이 사용되고 특히 UIKit 에서 상당한 비중을 차지하는 패턴입니다. 
    - Model: data 를 뜻하며 struct 나 간단한 class 로 구성됩니다.
    - View: 화면에 보여지는 컨트롤 등을 뜻합니다.
    - Controller: model 과 view 를 중계하는 역할입니다. 하나 이상의 model 과 view 를 가질 수 있습니다. model 과 view 에 대한 강한 참조를 가지며 양쪽 모두에 direct 로 접근할 수 있습니다. 하지만 model 과 view 는 controller 에 대해 약한 참조를 가져야 합니다. 그렇지 않으면 strong reference cycle 에 빠지게 됩니다. property observing 을 통해 model 과 통신하고, IBAction 을 통해 view 와 통신합니다.

### MVVM
- MVC 로 개발을 하다보면 model 과 view 가 증가함에 따라 점점 controller 가 해야할 일들이 많아지게되며 코드량도 증가하게 됩니다. 흔히 이런 경우 MVC 를 Massive View Controller 라고 장난삼아 부르게 되죠. 이러한 문제를 해결하기 위해 controller 의 role 을 최대한 줄이며 해당 기능을 ViewModel 이라는 개체로 옮겨서 Model-View-ViewModel 이라고 부르게 됩니다.
    - Model, View 는 MVC 와 동일합니다.
    - View model: model 의 정보를 view 에서 원하는 방식으로 값으로 변경하는 역할을 합니다.


### Proxy
- 복잡한 객체를 단순하게 표현해야 할 때 사용됩니다. 
- 목적에 따라 수많은 종류가 있습니다. 객체의 접근 권한을 제어하기 위한 보호 프록시도 있고, 객체 생성 비용이 큰 경우를 처리하기 위한 가상 프록시, 원격 객체에 대한 접근을 제어하는 원격 프록시 등이 있습니다.
- 객체 생성 비용이 큰 경우 실제 객체가 필요한 순간까지 생성을 연기하고 단순한 객체로 그것을 대신 나타냅니다. 이 간단한 객체를 복잡한 객체에 대한 프록시라고 합니다.


## Behavioral Pattern(행동 패턴)
- Chain of responsibility, Command, Interpreter, Iterator, Mediator, Memento, Observer, Strategy, State, Template, Visitor

### Command
- sender 와 receiver 사이에 완전한 decoupling 을 달성할 수 있도록 해줍니다.
- sender 는 receiver 의 interface 에 대해 알지 못하며 request 를 호출할 뿐입니다.

### Iterator
- 객체들의 그룹에서 요소들을 탐색할 수 있도록 도와줍니다. 
- swift 에서는 Sequence protocol 을 준수하여 쉽게 구현할 수 있습니다.(또는 Collection protocol 을 준수하여 좀 더 많은 기능을 구현할 수 있습니다.)

### Memento
- 객체를 이전 상태로 복원할 수 있는 기능을 제공해줍니다.
- 객체의 원본 상태 그대로를 가지는 originator 를 가지고, 외부로 스냅샷을 제공하는 클래스(memento)를 추가합니다. caretaker 를 통해 이전상태를 복원할 수 있습니다.
- originator: Codable 을 준수하는 모델 객체
- memento: Data 객체
- caretaker: decoder, encoder 를 가지고 저장/복원하는 manager 객체

### Observer
- 어떤 객체의 상태가 바뀌면 관련된 모든 객체들이 자동으로 갱신되도록 객체들간의 링크를 정의합니다.
- 주로 MVC 와 함께 사용됩니다. view controller 가 observer 가 되고, model 이 subject 가 되어 view controller 의 type 이 무엇이든 상관하지 않고 서로 소통할 수 있습니다.
- swift 에서 일대다 옵저버는 notification, kvo, 일대일 옵저버는 delegate 가 있습니다.
    - kvo 를 사용하기 위해서는 NSObject 를 상속받아 Objective-C 레이어에 접근해야 한다는 단점이 있습니다. 하지만 직접 Observable Wrapper 를 구현해서 사용해도 무방합니다.(구현방법이 복잡하므로 그냥 NSObject 상속받고 kvo 사용하는게 정신 건강에 이로울듯 합니다.)
    - delegate 패턴을 사용하면 대규모 클래스를 분할하거나, 일반적이고 재사용 가능한 component 를 생성할 수 있습니다. UIKit 전체에서 공통적으로 보여지는 패턴으로 애플은 data 를 준비하기 위한 -DataSource, data 를 전달 받거나, event 관련된 처리를 하는 -Delegate 로 나누어 구현하였습니다.
    - delegate 는 매우 유용하지만 과용하면 너무 많은 delegate 들이 생성되는 문제가 발생합니다. 이런 경우 해당 개체가 너무 많은 기능을 담고 있는 것은 아닌지 검토해서 가능하다면 기능을 쪼개는 것이 좋습니다. 그리고 delegate 가 너무 작은 기능을 담당해서 그 수가 많아진 것은 아닌지도 검토해볼 필요가 있습니다. 그렇다면 용도에 맞게 다시 기능을 분류하고 delegate 들을 통합할 필요가 있습니다.

### Strategy
- 객체들에 서로 다른 행위가(알고리즘이) 적용되어야 할 때 사용합니다.
- 행위(알고리즘)의 집합을 정의하고 이들을 필요에 따라 교체할 수 있도록 구현합니다.
- 클라이언트와 행위를(알고리즘을) 서로 독집적으로 만듭니다.
- protocol 을 이용하여 구현할 경우 delegate 와 유사해 보이지만, delegate 와 다르게 protocol 을 준수하는 객체들의 집합을 이용하여 runtime 에 쉽게 변경 가능하다는 차이점이 있습니다.

### State
- 객체가 내부 상태(Context)에 따라 서로 다른 방식으로 동작하도록 합니다.
- Context 의 request 가 호출될 때마다 메시지를 처리하는 State 에 위임됩니다.
- State interface 는 모든 구체화된 상태들에 대한 공통 interface 를 정의하여 특정 상태와 관련된 모든 동작을 캡슐화합니다.
- Context 의 state 가 변경되면 해당 변경과 관련된 구체화된 state 를 가지게 됩니다.




* * *
# Initializer
### 지정/편의 이니셜라이저(Designated/Convenience Initializer)
- 지정 이니셜라이저는 필요에 따라 부모클래스의 이니셜라이저를 호출할 수 있으며, 이니셜라이저가 정의된 클래스의 모든 프로퍼티를 초기화해야 하는 임무를 갖고 있다. 
하나 이상 정의될 수 있다. 만약 조상클래스에서 지정 이니셜라이저가 자손클래스의 지정 이니셜라이저 역할을 충분히 수행할 수 있다면, 자손클래스는 지정 이니셜라이저를 갖지 않을 수도 있다.

- 편의 이니셜라이저는 초기화를 좀 더 손쉽게 도와주는 역할을 한다. 편의 이니셜라이저는 지정 이니셜라이저를 자신 내부에서 호출한다. 
필수 요소는 아니지만 클래스 설계자의 의도대로 외부에서 사용되길 원하거나 인스턴스 생성 코드를 작성할 때 수고를 덜고자 할때 유용하게 사용할 수 있다.
convenience 지정자를 init 키워드 앞에 명시해주면 된다.

### 클래스의 초기화 위임
- 자식클래스의 지정 이니셜라이저는 부모클래스의 지정 이니셜라이저를 반드시 호출해야한다
- 편의 이니셜라이저는 자신이 정의된 클래스의 다른 이니셜라이저를 반드시 호출해야한다
- 편의 이니셜라이저는 궁극적으로는 지정 이니셜라이저를 반드시 호출해야한다

### 2단계 초기화
스위프트의 클래스 초기화는 2단계를 거친다. 1단계는 클래스에 정의된 각각의 저장 프로퍼티에 값이 할당된다. 모든 저장 프로퍼티들의 초기 상태가 결정되면 2단계로 진입한다. 2단계에서는 저장 프로퍼티들이 커스터마이징될 기회를 얻는다. 그 후 비로소 새로운 인스턴스가 사용될 준비가 된다.
2단계 초기화는 프로퍼티가 초기화되기 전에 프로퍼티 값에 접근하는 것을 막아 초기화를 안전하게 할 수 있도록 해준다. 또, 다른 이니셜라이저가 프로퍼티의 값을 실수로 변경하는 것을 방지할 수도 있다.
스위프트 컴파일러는 2단계 초기화를 오류없이 처리하기 위해 4가지 안전확인(safty-checks)한다
- 자식클래스의 지정 아니셜라이저가 부모클래스의 지정 이니셜라이저를 호출하기 전에 자신의 프로퍼티를 모두 초기화 하였는지 확인한다
- 자식클래스의 지정 이니셜라이저는 상속받은 프로퍼티 값을 할당하기 전에 반드시 부모클래스의 이니셜라이저를 호출해야한다
- 편의 이니셜라이저는 자신의 클래스에 정의된 프로퍼티를 포함하여 그 어떤 프로퍼티라도 값을 할당하기 전에 다른 이니셜라이저를 호출해야한다
- 초기화 1단계를 마치기 전까지 이니셜라이저는 인스턴스 메서드를 호출할 수 없다. 또 인스턴스 프로퍼티 값을 읽어들일 수도 없다. self 프로퍼티를 자신의 인스턴스를 나타내는 값으로 활용할 수도 없다.

#### 1 단계
- 클래스가 지정 또는 편의 이니셜라이저를 호출
- 그 클래스의 새로운 인스턴스를 위한 메모리가 할당됨. 메모리는 아직 초기화되지 않은 상태
- 지정 이니셜라이저는 클래스에 정의된 모든 저장 프로퍼티가 값을 가지고 있는지 확인. 현재 클래스 부분까지의 저장 프로퍼티를 위한 메모리가 초기화 됨.
- 지정 이니셜라이저는 부모클래스의 이니셜라이저가 같은 동작을 수행할 수 있도록 초기화를 양도함
- 부모클래스는 상속 체인을 따라 최상위 클래스에 도달할 때까지 이 작업(1 단계 초기화 과정)을 반복함

최상위 클래스에 도달했을 때, 모든 저장 프로퍼티가 값을 가진 것이 확인되면 해당 인스턴스의 메모리는 모두 초기화된 것이다. 이로써 1단계가 완료된다.

#### 2 단계
- 최상위 클래스로부터 최하위 클래스까지 상속 체인을 따라 내려오면서 지정 이니셜라이저들이 인스턴스를 제각각 커스터마이징하게 된다. 이 단계에서는 self 를 통해 프로퍼티 값을 수정할 수 있고, 인스턴스 메서드를 호출하는 등의 작업을 진행할 수 있다.
- 마지막으로 각각의 편의 이니셜라이저를 통해 self 를 통한 커스터마이징 작업을 진행할 수 있다.


### 이니셜라이저 상속 및 재정의
만약 부모클래스의 이니셜라이저와 동일한 이니셜라이저를 자식클래스에서 사용하고 싶다면 자식클래스에서 부모의 이니셜라이저와 동일한 이니셜라이저를 구현해야 한다.
부모클래스와 동일한 지정 이니셜라이저를 자식클래스에서 구현해주려면 재정의해야 한다. 
부모클래스의 편의 이니셜라이저와 동일한 이니셜라이저를 자식클래스에 구현할 때에는 override 키워드를 붙여주지 않는다. 자식클래스에서 부모클래스의 편의 이니셜라이저를 호출할 수 없기때문에 재정의할 필요가 없다 


### 이니셜라이저 자동 상속
자식클래스에서 프로퍼티 기본값을 모두 제공한다고 가정할때, 
- 자식클래스에서 별도의 지정 이니셜라이저를 구현하지 않는다면, 부모클래스의 지정 이니셜라이저가 자동으로 상속된다 
- 만약 위의 규칙에 따라 자식클래스에서 부모클래스의 지정 이니셜라이저를 자동으로 상속받는 경우 또는 부모클래스의 지정 이니셜라이저를 모두 재정의하여 부모클래스와 동일한 지정 이니셜라이저를 모두 사용할 수 있는 상황이라면 부모클래스의 편의 이니셜라이저가 모두 자동으로 상속된다.

```swift
class Person {
  var name: String
  func init(name: String) { self.name = name }
  convenience init() { self.init(name: “Unknown") }
}

// 지정/편의 이니셜라이저가 모두 자동으로 상속된다.
class Student: Person {
  var major: String = “Swift"
}

class Student2: Person {
  var major: String
  convenience init(major: String) {
    self.init()
    self.major = major
  }
  override convenience init(name: String) {
    self.init(name: name, major: “Unknown")
  }
  init(name: String, major:String) {
    self.major = major
    super.init(name: name)
  }
}

// 부모클래스의 편의 이니셜라이저 자동 상속
let a = Person()
let b = Student2(major: “Swift”)
```

### 요구 이니셜라이저
required 수식어를 클래스의 이니셜라이저 앞에 명시해주면 이 클래스를 상속받은 자식클래스에서 반드시 해당 이니셜라이저를 구현해주어야 한다.
상속받을 때 반드시 재정의되어야 하는 이니셜라이저 앞에 required 수식어를 붙여준다. 자식클래스에서 요구 이니셜라이저를 재정의할 때는 override 대신 required 를 사용한다.
```swift
class Person {
  var name: String
  required init() {
    self.name = “Unknown”
  }
}

class Student: Person {
  var major: String = “Unknown”
  //자신의 이니셜라이저 구현
  init(major: String) {
    self.major = major
    super.init()
  }
  required init() {
    self.major = “Unknown”
  super.init()
}
```





* * *
# UIViewController
### Displaying UIView at runtime
1. storyboard 로부터 view 에 대한 정보를 획득한 후 view 를 객체화
2. outlets, actions 연결
3. viewController.view 로 root view 설정
4. awakeFromNib 메서드 호출(호출시 viewController 의 trait collection 이 비어있고, ui 들이 정확한 위치를 잡지 못할 수 있다.)
5. viewDidLoad 메서드 호출. add/remove views, modify layout constraints, load data for views 수행

#### Before Displaying onscreen(UIKIt gives you some chance to prepare)
1. viewWillAppear 메서드 호출로 화면 표시가 임박했음을 알림
2. 이때 추가적으로 updates the layout of the views
3. 화면 표시
4. viewDidAppear 메서드 호출

add/remove views, modify size/position 등 layout 관련 변경 발생시 UIKit 은 layout 이 dirty 하다고 marking, 다음 UI update cycle 에 해당 UI 를 갱신한다.


### Managing View Layout
size/position 등 layout 관련 변경 발생시 UIKit 은 layout 을 변경한다. view 가 auto layout 을 사용한다면 해당 constraint 를 기준으로 update 하고, 인접한 UI 들도 UIKit 의 도움으로 해당 update 에 적절한 반응을 할 수 있다.

아래와 같이 UIKit 은 알림을 통해 layout process 진행 중 추가적인 layout 관련 작업을 수행할 수 있도록 도와준다.

1. 필요시 viewController 의 trait collection 과 views 를 update
2. viewController.viewWillLayoutSubviews 메서드 호출
3. viewController.containerViewWillLayoutSubviews 메서드 호출
4. viewController.view.layoutSubviews 메서드 호출하여 새로운 layout constraint 적용. view 의 hierachy 를 순회하며 하위 view.layoutSubviews 를 호출.
5. 새로운 layout constraint 적용
6. viewController.viewDidLayoutSubviews 메서드 호출
7. viewController.containerViewDidLayoutSubviews 메서드 호출

viewWillLayoutSubviews/viewDidLayoutSubviews 메서드에서 추가적으로 layout process 에 영향을 줄 수 있는 작업을 진행할 수 있다. viewWillLayoutSubviews 에서 add/remove views, update size/position for views, update constraint... 등을 수행할 수 있고, viewDidLayoutSubviews 에서는 table/collection view data 를 reload 하거나, 다른 view 의 content 를 update 그리고 최종적으로 view 의 size/position 을 조정할 수 있다.

[ainmation & transitioning 관련 영상](https://youtu.be/Of4flwvlYz4)

#### tips for managing layout effectively
- Use Auto Layout: 다양한 사이즈의 화면 대응
- Take advantage of the top and bottom layout guide: 항상 view 가 보이도록 도와줌. 상단은 navi/status bar, 하단은 tab/tool bar 를 고려한 값을 제공함
- Remember to update constraint when adding/removing views
- Remove constraints tempoarly while animating your view controller's views: 애니메이션 완료 후 변경된 constraint 를 다시 적용해라

#### some implmentations
- adding a child view controller to your content
``` swift
func displayContentController(content: UIViewController) {
	addChildViewController(content)
	content.view.frame = frameForContentController()
	addSubview(currentClientView)
	content.didMoveToParentViewController(self)
}
```

- removing a child view controller
``` swift
func hideContentController(content: UIViewController) {
	content.willMoveToParentViewController(nil)
	content.view.removeFromSuperview()
	content.removeFromParentViewController()
}
```

- transitioning between two child view controllers
``` swift
func cycle(from oldVC: UIViewController, to newVC: UIViewController) {
	oldVC.willMoveToParentViewController(nil)
	addChildViewController(newVC)

	newVC.view.frame = newViewStartFrame()
	let endFrame = oldViewEndFrame()

	transition(from: oldView, to: newView, duration: 0.25, options: nil, animations: {
		newVC.view.frame = oldVC.view.frame
		oldVC.view.frame = endFrame
		}, completion: {
			oldVC.removeFromParentViewController()
			newVC.didMoveToParentViewController(nil)
			})
}
```

- UIViewControllerTransitioningDelegate 를 준수하는 개체를 통해 UIViewControllerAnimatedTransitioning 을 준수하는 present, dismiss 를 위한 animation 을 구현하여 화면 전환시 UIViewControllerTransitioningDelegate 객체를 통해 커스터마이징된 애니메이션을 사용해 transition 을 구현함.

- [UIPercentDrivenInteractiveTransition 사용하는 경우](https://stackoverflow.com/questions/42192127/custom-interactive-transition-animation)

- restoring view controllers at launch time
 : for UI base, in Interface Builder set Restoratin ID

``` swift
ViewController: UIStateRestoring {
	override func encodeRestorableStateWithCoder(coder: NSCoder) {
		if let petId = petId {
			coder.encodeInteger(petId, forKey: "petId")
		}
		...
		super.encodRestorableStateWithCoder(coder)
	}

	override func decodeRestorableStateCoder(coder: NSCoder) {
		petId = coder.decodeInteger("petId")
		...
		super.decodeRestorableStateCoder(coder)
	}

	override func applicationFinishedRestoringState() {
		guard let petId = petId else { return }
		currentPet = MatchedPetsManager.shared.petForId(petId)
	}
}
AppDelegate {
	func application(application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
		return true
	}

	func application(application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
		return true
	}
}
```

### change onrientation with single view
- project 설정에서 device orientation 을 portrait 전용으로 설정합니다.
- AppDelegate 에서 아래와 같은 코드를 작성해 줍니다.

``` swift
protocol CanRotateVC {}

func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    if let rootVC = topViewController(for: window?.rootViewController) {
        if rootVC is CanRotateVC {
            return .allButUpsideDown
        }
    }
    return .portrait
}

private func topViewController(for rootViewController: UIViewController?) -> UIViewController? {
    guard let rootVC = rootViewController else {
        return nil
    }
    if rootVC.isKind(of: UITabBarController.self) {
        return topViewController(for: (rootVC as! UITabBarController).selectedViewController)
    } else if rootVC.isKind(of: UINavigationController.self) {
        return topViewController(for: (rootVC as! UINavigationController).visibleViewController)
    } else if rootVC.presentedViewController != nil {
        return topViewController(for: rootVC.presentedViewController)
    } else {
        return rootVC
    }
}

class ViewController: UIViewController, CanRotateVC {

}
```

[link](http://www.jairobjunior.com/blog/2016/03/05/how-to-rotate-only-one-view-controller-to-landscape-in-ios-slash-swift/)


### handle orientation
- viewController 의 shouldAutorotate 가 true 인 경우 아래의 메서드를 override 하는 방식으로 제어할 수 있습니다.

``` swift
override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
	if UIDevice.current.orientation.isLandscape {
		print("Landscape")
	} else {
		print("Portrait")
	}
}
```

- 내장 카메라 애플리케이션 처럼 기본 layout 은 변경하지 않고 버튼들 과 내부 상태만 변경하려면 shouldAotorotate 는 false 로 변경하고, notification 을 등록하여 제어합니다.

``` swift
override func viewDidLoad() {
	...
	NotificationCenter.default.addObserver(self, selector: #selector(handleRotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
}

deinit {
	NotificationCenter.default.removeObserver(self)
}

func handleRotate() {
	if UIDevice.current.orientation.isLandscape {
		print("Landscape")
	} else {
		print("Portrait")
	}
}
```

[link](https://stackoverflow.com/questions/38894031/swift-how-to-detect-orientation-changes)




* * *
# UIView
### The View Drawing Cycle
UIView 는 요청이 있는 경우에 그려지는 on-demand drawing model 사용해서 content 를 표현한다. view 가 screen 에 처음 나타나면 system 이 content 를 그리도록 요청한다. system 은 view 의 시각적인 표현을 위해 사용할 목적으로 스냅샷을 캡쳐한다(captured in an underlying bitmap). 만약 view 의 content 을 변경하지 않는다면 view 의 drawing code 는 다시 호출되지 않을 것이다. 스냅샷은 view 와 관련된 작업에서 재사용된다. 만약 content 를 변경하게 되면 setNeedsDisplay, setNeedsDisplay(:) method 를 호출하여 system 에 알려주고 기존 스냅샷을 무효화한 후 다음 drawing 기회가 왔을 때 redraw 할 수 있도록 한다. system 은 current run loop 가 종료될 때까지 대기하는데 그로인해 여러 view 들에 대한 변경을 동시에 진행할 수 있는 기회가 제공되고 이런 동작이 반복된다.

view 의 geometry 가 변경되는 경우에는 자동으로 redraw 하지 않는다. view 의 contentMode property 에 따라 geometry 에 대해 어떻게 대응할지 정해지는데, 기본 설정값은 캡쳐된 스냅샷을 재사용하여 확장하거나 위치를 다시 잡는 방식으로 동작한다.

> - view 를 update 하는 몇 가지..(Drawing and Print Guide for iOS 에서 발췌)
>    1. view 의 일부를 안보이게 하던 다른 view 의 이동 및 제거가 발생하는 경우
>    2. hidden 되어 있던 view 를 다시 보여지도록 하는 경우
>    3. view 를 scroll 해서 화면 안팎으로 이동시키는 경우
>    4. setNeedsDisplay(), setNeedsDisplay(:) 를 호출하는 경우

- setNeedsDisplay()
    : 호출한 view 의 전체 영역을 다음 drawing cycle 에 redraw 하도록 marking
- setNeedsDisplay(:)
    : 호출한 view 의 영역 중, 전달받은 rect 만큼만 다음 drawing cycle 에 redraw 하도록 marking
- setNeedsLayout()
    : 호출한 view 의 layout 을 다음 update cycle 에 update 하도록 요청
- layoutIfNeeded()
    : 호출한 view 의 layout 을 즉시 update
- layoutSubviews()
    : 기본 constraint 를 적용해서 subviews 의 layout 을 update 한다. subviews 원하는대로 동작하지 않는 경우 override 할 수 있으며 subviews 의 frame 을 직접 설정할 수 있다. draw(:) 와 마찬가지로 직접호출하면 안되고, setNeedsLayout(), layoutInfNeeded() method 를 호출해야 한다.
- displayIfNeeded()
    : CALayer 에만 존재. 일반적으로 호출할 필요가 없으며, setNeedsDisplay() method 호출만으로 충분하다.


> 두 method 모두 native drawing technologies(UIKit 또는 Core Graphics) 로 렌더링 된 view 에서만 동작한다. OpenGL 을 지원하는 CAEAGLLayer 를 지원하는 개체에서는 무시된다.
> ex) ``` swift
>     // 아래와 같이 layer class 를 CAEAGLLayer 로 하고 해당 기능을 사용한다면 setNeedsDisplay, setNeedsDisplay(:) 호출은 무시된다.
>     override class var layerClass: AnyClass -> {
>         return CAEAGLLayer.self 
>     }
>     ```



### Creating and Configuring View Objects
- viewController 와 연관되지 않은 nib 파일에서 view 를 디자인했다면 NSBundle, UINib 클래스로 부터 view 를 생성해야 한다.

- alpha, hidden, opaque: opacity(불투명도)와 연관된 properties. alpha, hidden 은 직접 opacity 를 변경하고, opaque 는 true 인 경우 해당 view 객체 하부에 존재하는 view 는 전혀 표시되지 않기때문에 불필요한 compositing 작업이 감소하게되어 성능을 향상시킬 수 있다.

- bounds, frame, center, transform: size, position 과 연관된 properties. center, frame 은 parent 와 연관된 position 을 나타내는데 frame 은 size 정보도 가지고 있다. bounds 는 자신의 좌표체계에서의 visible content area 이다. transform 은 view 를 이동시키거나 애니메이트 시키는 복잡한 작업에 사용된다.

- autoresizingMask, auroresizesSubviews: view 와 subviews 에 영향을 주는 automatic resizing behavior 이다. autoresizingMask 는 parent 의 bounds 가 변경될 시 어떻게 반응해야하는지를 제어한다. autoresizesSubviews 는 자신의 subviews 를 resize 하는지의 여부를 제어한다.

- contentMode, contentStretch, contentScaleFactor: view 안에 담긴 content 를 어떻게 렌더링하는지에 대한 behavior 이다. contentMode, contentStretch 는 자신의 width, height 변경시 content 를 어떻게 처리할지 결정한다. contentScaleFactor 는 high - resolution screen 을 위해 drawing behavior 를 커스터마이징해야할 때만 사용한다.

- gestureRecognizers, userInteractionEnabled, multipleTouchEnabled, exclusiveTouch: touch event 에 영향을 주는 property 이다. gestureRecognizers 는 attatched 된 gesture recognizer 들을 저장하고 있다. 자세한 사항은 Event Handling Guide for iOS 를 확인할 것.

- backgroundColor, subviews, drawRect, layer: 실제 content 들을 관리하는 property, method 이다. 
(For simple views, you can set a background color and add one or more subviews. The subviews property itself contains a read-only list of subviews, but there are several methods for adding and rearranging subviews. For views with custom drawing behavior, you must override the drawRect: method.
For more advanced content, you can work directly with the view’s Core Animation layer. To specify an entirely different type of layer for the view, you must override the layerClass method.)



### Creating and Managing a View Hierarchy
- bringSubviewToFront, sendSubviewToBack, exchangeSubviewAtIndex:withSubviewAtIndex: 메서드를 사용하는게 remove, reinsert 하는 것 보다 빠르다.

- subview 가 parent 의 범위를 벗어날 때 clipsToBounds 를 명시적으로 true 로 설정하지 않으면 벗어난 범위까지 전부 draw 되므로 주의.(view.layer.masksToBounds 도 동일한 효과)

- view 추가시 programmatically 생성한다면 loadView 메서드에 코드를 추가한다. viewDidLoad 메서드에서는 코드로 생성하건 nib 으로 생성하건 상관없이 view 를 추가할 수 있다.

- view 를 hide 하는 방법은 hidde 시키거나, alpha 를 0 으로 만드는 것. hidden 시키더라도 여전히 resizing 및 layout 과 관련된 작업에 참여하고 있고 다만 touch event 를 수신하지 않는다. 만약 first responder 인 view 를 hidden 시킨다면 명시적으로 first responder 를 resign 시켜줘야 한다. 일정 시간 이후 다시 view 를 표시해야 하는 경우라면 hidden 시키는 것이 편리하다. 보여지지 않는 view 가 animating 되야 한다면 alpha 를 변경해야 한다. hidden 은 animatable property 가 아니라서 어떤 변경이든 즉시 적용된다.

- 모든 view 는 translate, scale, rotate 을 적용시킬 수 있는 CGAffineTransform 을 transform property 로 가진다. 기본 설정은 view 의 appearance 를 변경하지 않는 identity transform 으로 되어 있다. transform 적용 순서에 따라 결과물은 달라질 수 있다. 회전 후 이동시키는 것과, 이동 후 회전 시키는 것은 결과값이 다르다.

- 이벤트 처리시 view 간 좌표계 변환이 필요한 경우 아래와 같은 method 를 활용한다.
    - convert(CGPoint, to: UIView?), convert(CGRect, to: UIView?)
    - convert(CGPoint, from: UIView?), convert(CGRect, from: UIView?)

- layout 변경에 준비하기. 아래와 같은 상황에 layout 이 변경된다.
    - view.bounds 의 size 가 변경될 때
    - interface orientation 이 변경되어 root view 의 bounds 가 변경될 때
    - view 의 layer 와 연관된 Core Animation sublayers 가 변경되는 경우
    - setNeedsLayout, layoutIfNeeded method 가 호출되는 경우

- 각 view 들은 content 의 표시 및 애니메이션을 관리하는 Core Animation layer 를 가진다. 상황에 따라 layer 에 직접 작업해야할 수 있다.

- drawRect 정의하기
   - 일반적인 view 를 표시할 수 없는 경우 마지막 수단으로써 drawRect 메서드를 재정의 한다.
   - drawRect 에서는 그리기 작업만 수행한다. 가능한 빨리 그리고 종료해야 한다. drawRect 가 자주 호출되는 경우 그리는 code 를 최적화하고 가능한 적게 그리도록 작업을 수행해야 한다.
   - 기본 화면에 대한 정보는 UIGraphicsGetCurrentContext 메서드로부터 받아올 수 있다.

- animation 가능한 property
    - frame, bounds, center, transform, alpha, backgroundColor, contentStretch


### Animation
- UIView.animate, 
- UIViewPropertyAnimator: [interactively animating](https://youtu.be/JPD3KGgYanI?t=3m54s), [interruptible animations](https://youtu.be/JPD3KGgYanI?t=6m44s)


### CALayer vs UIView
UIView 는 layout 이나 touch 이벤트 처리와 같은 많은 작업을 처리하지만 drawing 이나 animation 을 직접 처리하지는 못합니다. 그러한 작업들은 CoreAnimation 에게 위임합니다. UIView 는 사실 CALayer 의 Wrapper 라 말할 수 있습니다. UIView 의 bounds 를 설정하면, 해당 view 는 자신의 layer.bounds 를 설정합니다. 만약 UIView 의 layoutIfNeeded 를 호출한다면, 호출은 root layer 로 전달됩니다. UIView 는 내부에 root CALayer 를 가지고 하위 layer 들을 포함할 수 있습니다.

아래 링크 참고
[link](https://www.raywenderlich.com/169004/calayer-tutorial-ios-getting-started)

[위의 예제 검증을 위한 테크토크 영상](https://youtu.be/3HgIi1NedWA)

### Core Graphics
[이미지 그리는 예제 링크](https://youtu.be/SJtEJOoNvtI?t=1m45s)





* * *
# Array
- Swift 에서 Array 는 다음과 같은 목표를 가집니다.
1. non-class 타입의 subscipt get/set 에 대해 C 배열과 같은 성능
2. NSArray <--> Array<AnyObject> 변환이 가능해야 하고, 전환시 추가 메모리 할당 없이 O(1) 의 성능을 내야 함
3. 배열을 스택처럼 사용해야 함, append 는 amortized O(1), popBack 은 O(1) 의 성능을 내야 함. 목표 1에서도 밝혔듯이 std::vector 와 같은 layout 을 적용하여 실제 저장된 요소 뒤로 여분의 메모리를 가짐

- Swift 에서 Array 는 참조/값 타입을 지원합니다.
    - ContiguousArray<Element>: C 배열 성능이 필요할 때 사용합니다. 각 요소가 항상 메모리의 연속된 블록에 저장되며, 배열의 저장된 요소가 값 타입일 때 ContiguousArray 와 성능이 동일합니다. 배열의 요소들이 참조타입일 때는 완전히 연속적으로 메모리에 저장하지 않고 NSArray 에 저장합니다.
    - Array<Element>: Element 가 class 타입인 경우 효과적인 변환을 위해 최적화되어 있습니다. ContiguousArray 가 아닌 잠재적으로 비연속적인 임의의 NSArray 의 지원을 받을 수 있습니다. Element 가 non-class 타입인 경우 ContiguousArray<Element> 와 같은 성능을 보여줍니다.
    - ArraySlice<Element>: Array 또는 ContiguousArray 의 일부분이며, arr[n...n-1] 과 같이 뽑아낼 수 있습니다. ArraySlice 는 항상 연속적인 저장 공간과 C 배열과 같은 성능을 가집니다. 원본 Array 또는 ContiguousArray 의 메모리를 공유하고 있으므로 일시적인 계산시 사용을 추천하며, 수명을 길게 늘이는 것을 권장하지 않습니다.

[link](http://minsone.github.io/programming/swift3-arrays-design-summary)



* * *
* * *
고참 개발자를 위한 인터뷰 대책
* * *
* * *
What is an iOS application and where does your code fit into it?
================================================================

## 애플리케이션이란?

단순하게 보면 시스템이 메인 쓰레드에 런 루프 하나 생성하는 것이지요. 하지만 시스템은 애플리케이션으로 다양한 이벤트를 전달하고 애플리케이션은 앱 델리게이트를 통해 이벤트에 부합하는 메서드를 호출 또는 notification 을 사용하여 알려줍니다. 아래의 그림처럼 말이죠. <br /><br />
[Handling alert-base interruptions] <br />
<img src="https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Art/event_draw_cycle_a_2x.png" alt="Processing events in the main run loop" width="550px"> <br /><br />
[Handling alert-base interruptions] <br />
<img src="https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Art/app_interruptions_2x.png" alt="Handling alert-base interruptions" width="550px"> <br /><br />
[Transitioning from the background to foreground] <br />
<img src="https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Art/app_enter_foreground_2x.png" alt="Transitioning from the background to foreground" width="550px"> <br /><br />

이러한 프로세스를 활용해 우리가 필요로 하는 기능을 제공할 수 있습니다.
* * *



## 앱의 라이프 사이클

앱의 기본적인 상태 전환 시퀀스는 아래와 같습니다. <br /><br />
<img src="https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Art/high_level_flow_2x.png" alt="State changes in an iOS app" width="350px"> <br /><br />
앱이 실행되어 종료되기까지 foreground, background 상태 전환을 포함해 알기 쉽게 표현되었습니다.


아래 그림은 앱이 실행된 후 foreground 로 진입시의 시퀀스를 보여줍니다. <br /><br />
<img src="https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Art/app_launch_fg_2x.png" alt="Launching an app into the foreground" width="550"> <br /><br />
 
- 앱이 실행되면 당연하게도 화면을 구성하기 위한 초기화를 진행합니다. 이때 커스텀 객체들의 초기화도 함께 진행해야 하는데, 만약 우리의 앱이 상태 복원을 지원한다면 `application(_ willFinishLaunchingWithOptions:)` 메서드에서 이전 상태로 화면을 구성하도록 코드를 작성해야 합니다. 혹시라도 `application(_ willFinishLaunchingWithOptions:)` 메서드에서 커스텀 객체들의 초기화를 마무리하지 못했다면 `application(_ didFinishLaunchingWithOptions:)` 메서드에서도 초기화를 할 수 있는 마지막 찬스를 제공하니 조바심은 금물! 😉

- 'WithOptions:' 가 조금 거슬릴 것입니다. 대체 무슨 옵션이냐.. API 를 확인해보면 
``` swift
// 아래와 같이 많은 키값이 존재합니다. 제가 사용해 본 2가지만 언급하도록 하지요. 나머지는 문서와 구글을 이용하세요 🙄
static let bluetoothPeripherals: UIApplicationLaunchOptionsKey
static let cloudKitShareMetadata: UIApplicationLaunchOptionsKey
static let location: UIApplicationLaunchOptionsKey
static let newsstandDownloads: UIApplicationLaunchOptionsKey

// push notification 과 관련된 값을 확인하여 적절한 대응을 할 수 있습니다.
static let remoteNotification: UIApplicationLaunchOptionsKey

static let shortcutItem: UIApplicationLaunchOptionsKey
static let sourceApplication: UIApplicationLaunchOptionsKey
// 사용자가 앱을 실행할때 특정 url 과 연계한 action 을 취했다면(기기에 존재하는 특정 파일을 열 때 우리 앱을 선택한 경우 등..)
// 앱 실행과 동시에 해당 url 로 접근하여 작업을 수행할 수 있습니다.
static let url: UIApplicationLaunchOptionsKey

static let userActivityDictionary: UIApplicationLaunchOptionsKey
static let userActivityType: UIApplicationLaunchOptionsKey
```

- 애플은 앱이 시동시 빠르게 화면을 표시하길 원합니다. 그게 무슨말이냐 하면, 그동안의 wwdc 영상에서도 찾아보면 'app startup time' 등 뭐 비슷한 단어로 제목이 달린 세션이 존재하는데요. 이 영상들에서도 계속 강조하는게 앱 시동시 가급적 작업을 하지 않아야 된다는 것입니다. 작업이 추가되면 당연히 초기화하는 등 시간을 잡아먹게 되고 결국 앱의 UI 가 표시되는 시간이 늦어진다는 거죠. 만약 앱 시동시 이미지를 로드하여 사용자에게 보여줘야 한다면 해당 작업을 메인 쓰레드가 아닌 백그라운드 쓰레드에서 비동기적으로 진행하도록 코드를 작성해야 합니다. 그렇지 않다면 이미지가 모두 로드될 때까지 화면은 멈춰버리겠죠. 아주 당연한 이야기입니다. 만약 개발중 앱 시동이 느려졌다면 메인 쓰레드에 부하가 걸렸는지 확인해 보세요.

- 참 위에서 언급한것과 연계해서 추가할 이야기가 있습니다. iOS 는 앱 시동 시간이 5초 이내에 완료되지 않으면 오동작한다고 판단해서 앱을 종료시킬 수도 있습니다. 참고하세요 🤟.  


아래 그림은 앱이 foreground 에서 background 로 상태 전환시의 시퀀스를 보여줍니다. <br /><br />
<img src="https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Art/app_bg_life_cycle_2x.png" alt="Moving from the foreground to the background" width="550"> <br /><br />

- alert 등에 의해 `applicationWillResignActive()` 메서드가 호출되어 앱이 잠시동안 통제불가 상태가 되는 경우는 주의해야할 사항이 많습니다.
    - 메인 쓰레드에서 동작하는 작업들을 모두 중단해야 합니다. 가급적 백그라운드에서 동작하는 필수적이지 않은 반복적인 작업들도 멈춰야 합니다.
    - 당연하게도 새로운 작업도 시작하지 않아야 합니다.
    - 필수적이지 않은 작업에 대한 dispatch/operation queue 를 보류시켜야 합니다.(단, 네트워크 작업 등은 background 상태에서도 계속 할 수 있습니다.)
    - 데이터 및 상태와 연관된 정보들을 저장해야 합니다.
    - 게임 앱이라면 일시정지 모드! 영상 플레이백중 이라면 일시정지!(단 AirPlay 인 경우는 예외)

- 반대로 `applictaionDidBecomeActive()` 메서드에서는 모든 상태를 반전시켜야 합니다. 그래야 앱이 제대로 동작하겠죠?

- `applicationDidEnterBackground(:)` 메서드도 호출되면 해야할 일이 많습니다. 
    -  불필요한 메모리를 해제하여 전체적인 기기의 가용 메모리를 높이도록 노력해야 합니다.(기기의 가용 메모리와 앱의 성능은 직접적인 연관관계에 있습니다.) 
    - 그리고 저장되지 않은 앱 상태와 상관이 있는 데이터들을 저장해야 합니다. suspended 상태에 있다가 시스템에 의해 종료되는 경우 데이터를 저장할 방법이 없습니다. (background 에서 작업중인 경우를 제외하고 suspended 상태에서 시스템에 의해 앱이 종료되는 경우 memory warning 이 전달되지 않기 때문이죠 🤦) 
    - 메서드가 종료되면 시스템은 앱 전환 및 멀티태스킹 애니메이션에서 사용할 스냅샷을 캡쳐합니다. 만약 background 로 진입시 사용자 정보 등 민감한 정보가 노출되고 있는 상태라면 메서드가 종료되기 전 화면을 조작하여 정보 노출을 방지할 수 있습니다.(앱이 깨어날 때는 조작된 화면을 원복시키는것 잊지 마시구요 👮)

- 가능하다면 필수적인 정보들의 저장은 `applicationWillResignActive()`, `applicationDidEnterBackground(:)` 에서 진행하지 말고 적절한 시기에 저장하는게 좋습니다. 

- 위에서 잠시 언급했던것 처럼 suspended 상태로 진입한 이후에는 메모리 상황에 따라 시스템이 앱을 종료시킬 수 있습니다. 애석하게도 앱이 suspended 상태이거나 기기가 reboot 중인 경우엔 `applicationWillTerminate()` 메서드가 호출되지 않습니다. 백그라운드 지원 앱이 백그라운드로 작업중인 경우에만 호출됩니다. 그렇기때문에 데이터를 저장하는 시점으로 사용하기엔 적절하지 않아요 💣.

- 시스템은 메모리 관리를 위해 app delegate 의 `applicationDidReceiveMemoryWarning(:)`, viewController 의 `didReceiveMemoryWarning()` 이 호출할 수 있습니다. 해당 메서드들이 호출되면 즉시 불필요한 메모리를 제거하는 등의 작업을 수행해야 하죠. 그렇지 않으면 역시나 앱이 종료될 수 있습니다 🤦. 그 외 notification center 를 통해 `UIApplicationDidReceiveMemoryWarningNotification` 이 전달되므로 앞의 메서드들에서와 같이 대응할 수 있습니다. 그리고 dispatch source 중 DISPATCH_SOURCE_TYPE_MEMORYPRESSURE 를 이용해 메모리 경고 단계를 체크하여 상태별로 메모리를 관리할 수도 있습니다.(일반적인 경우에는 사용할 일이 없을 듯 합니다. 게임처럼 다양한 매핑소스가 로드된 경우, 경고 단계가 낮을 때는 중요하지 않은 오브젝트의 소스를 해제할 수는 있을거 같기는 한데... 메모리 경고가 떴다는건 뭐 이미 요단강을 건넌것과 비슷한 거죠 🧟)


**["App Programming Guide for iOS" 더 잘 번역된 블로그](http://rhammer.tistory.com/94)**

**[Application Life Cycle 관련 stanford 강의 링크](https://youtu.be/_ffOdODpDSk)**
**[ViewController Life Cycle 관련 stanford 강의 링크](https://youtu.be/HQrXM2zUPvY)**



* * *
* * *
What features of Swift do you like or dislike? Why?
===================================================

고참 개발자라 함은 무릇 가장 최신 버전의 swift 에 대해 잘 파악하고 있어야 합니다.(이전 버전과의 차이점도 알고 있다면 짱짱맨 😀)
괜찮은 회사들은 개발자가 swift 의 강한 타입 제약, 언어의 함수형 프로그래밍 특징 그리고 마음에 드는 것과 그렇지 않은 것에 대해 토론할 수 있을정도의 역량을 갖추고 있길 기대합니다. 애플 개발자 사이트를 방문해 보신 분들이라면 참고할만한 문서의 양을 봐서 아시겠지만 그 양이 정말 방대하죠... 그렇기 때문에 모든 것을 다 알고 있다는 것은 사실 불가능에 가깝다고 생각합니다. 그렇기 때문에 swift 모든 버전 전반적으로 통용되고 최신 버전에서 개선된 특징 정도는 필수로 이해하고 있어야 합니다. 예를 들자면 프로토콜, 옵셔널, 제네릭, 참조 vs. 값 타입 등등
그리고 개발자 본인이 생각하기에 불편해서 개선이 필요하다고 생각하는 부분도 이야기 할 수 있어야 하죠.
네 그렇습니다... 보통 일이 아니죠. 하지만 고참 개발자의 길이란 그런 것이겠죠 😣
* * *

## 장점
1. #### 프로토콜(Protocol)
    - java, obj-c 를 접해보신 분들이라면 interface 를 사용해서 개발해 보셨을 겁니다. swift 의 프로토콜은 그와 유사한 개념입니다. 특정 역할을 수행하기 위해 메서드, 프로퍼티 및 기타 요구사항 등을 정의만 합니다. 실제 구현은 해당 프로토콜을 준수하는 구현체로 위임하기 때문이죠. 이제부터 다른 언어들과의 차이점이 생기는데요. swift 프로토콜의 초기구현을 지원합니다. 이게 무슨말이냐~ 하면
    
    ``` swift
    protocol Popable {
        associatedtype Element
        var elements: [Element] {get set}
        mutating func append(_ el: Element)
        mutating func pop() -> Element?
    }

    extension Popable {
        mutating func append(_ el: Element) {
            elements.append(el)
        }
    
        mutating func pop() -> Element? {
            return elements.popLast()
        }
    }

    struct Stack: Popable {
        typealias Element = Int
        var elements = [Element]()
    }
    ```

    - 위와 같이 Popable 을 선언하고 해당 프로토콜을 구현체 없이 확장함으로써 초기구현을 할 수 있습니다. 그러면 실제로 Popable 을 채택하여 준수하는 Stack 이라는 값 타입은 Popable 의 요구사항인 `append(_:)`, `pop()` 을 구현하지 않고 그냥 사용만 하면 되는거죠. 뭐 별거 없죠? 하지만 다른 언어와의 이런 차이점이 swift 의 특징인 프로토콜 지향 프로그래밍이 가능하도록 해주는 근간입니다.
    다른 언어에서는 무기명 타입으로 원시타입이라 불리는 Int, Double, String, Bool 등이 swift 에서는 기명 타입인 값 타입으로 구현되어 있기 때문에 초기구현을 사용하여 해당 타입에 기능을 추가할 수도 있습니다. 아래처럼 말이죠.
    
    ``` swift
    extension Int {
        func factorial() -> Int {
            var n = self
            var result = 1
            while n > 0 {
                result *= n
                n -= 1
            }
            return result
        }
    }
    let factorialOfFour = 4.factorial()
    ```

    - 좀 근사하지 않나요? 위의 확장을 추가하면 모든 Int 타입은 자기 자신의 factorial 을 구할 수 있습니다 😉 (단 Int 에 저장할 수 있는 값의 한계때문에 20 보다 큰 정수에 대한 factorial 은 계산할 수 없습니다 😑)
    
    - oop 에서는 슈퍼 클래스가 하위 클래스들이 가져야할 기본적인 요구사항을 구현하고 하위 클래스들이 각자의 목적에 따라 추가 요구사항을 구현하는 방식으로 설계됩니다. 그래서 하위 클래스들은 초기화시 무조건 슈퍼 클래스의 생성자를 호출해야하고 이로 인해 일관된 초기화를 제공하지요. 그렇다보니 계층이 깊어지면 조금만 부주의해도 슈퍼 클래스가 요구하는 적절한 초기화 설정을 보장하지 못하고 낭패를 보는 상황을 맞이할 수도 있습니다. 하지만 pop 에서는 각각의 프로토콜은 기능을 위주로 모듈화하여 해당 프로토콜을 채택하는 타입으로 하여금 해당 기능의 기능을 구현하도록 강제합니다. 그렇기 때문에 계층과 상관없이 간결하게 해당 기능을 충족시킬 수 있습니다.(초기 구현을 해놓는다면 단순하게 채택만 하더라도 해당 기능을 사용할 수 있게 되는거죠 🤩)

    - oop 에서는 하위 클래스들은 단 하나의 슈퍼 클래스만 상속받을 수 있다보니 슈퍼 클래스가 pop 에 비해 비대해지고 불필요한 기능들도 많이 가지게 됩니다. 하지만 pop 에서는 여러개의 프로토콜을 동시에 채택할 수 있기 때문에 코드의 재사용성이 높아지고 기능들의 모듈화가 명확해집니다.
    - 제네릭과 함께 사용한다면 단일 타입이 아닌 어떠한 타입에도 대응 가능한 유연한 코드의 작성이 가능해집니다. 그렇다보니 간결하고 추상적인 표현이 가능해집니다.

2. 제네릭
    - 위에서도 잠시 설명했지만 제네릭은 특정 타입에 종속되지 않고 유연한 코드를 작성할 수 있게 해줍니다. 여러 타입에 대응할 수 있기 때문에 코드의 중복을 줄일 수 있으며 추상적인 표현이 가능합니다.

    ``` swift
    protocol Popable {
        associatedtype Element
        var elements: [Element] {get set}
        mutating func append(_ el: Element)
        mutating func pop() -> Element?
    }

    struct Stack<T>: Popable {
        var elements = [T]()
    
        func printSelf() {
            for item in elements {
                print("elements = \(item)")
            }
        }

        subscript(_ index: Int) -> T? {
            if index < elements.count {
                return elements[index]
            }
            return nil
        }
    }

    // for-in 문에서 Iterator 를 이용하고 싶다면 Sequence 를 준수하여 Iterator 를 반환할 수 있도록 구현해야 합니다.
    extension Stack: Sequence {
        func makeIterator() -> AnyIterator<T> {
            return AnyIterator(IndexingIterator(_elements: self.elements))
        }
    }

    var intStack = Stack<Int>()
    intStack.append(1)
    intStack.append(7)
    intStack.printSelf() // 1, 7
    
    for element in intStack {
        print("looping: \(element * 2)") // looping: 2, 14
    }

    // Stack 은 Sequence 를 채택했기 때문에 map, flatMap, filter, reduce 등을 추가 구현 없이 사용할 수 있습니다 :)
    let mapped = intStack.map{ $0 * 2 }
    print("mapping: \(mapped)") // mapping: [2, 14]
    
    print("pop: \(intStack.pop()!)") // 7
    intStack.printSelf() // 1
    
    var stringStack = Stack<String>()
    stringStack.append("a")
    stringStack.append("b")
    stringStack.printSelf() // a, b
    print("pop: \(stringStack.pop()!)") // b
    stringStack.printSelf() // a
    ```

    - 프로토콜에서 사용한 샘플에 제네릭을 추가해보면 이런식으로 됩니다. 제네릭을 사용하지 않았다면 IntStack: Popable, StringStack: Popable 이렇게 만들어야 했겠지만 제네릭을 이용해 하나의 스트럭트로 해결했습니다. 당연게도 동작도 동일하게 잘 합니다 😀

3. 옵셔널
    - 단어의 뜻에서 나타나듯 '상태가 있을 수도, 없을 수도 있는' 상태를 감싸는 컨테이너 또는 컨텍스트라고 할 수 있습니다. 옵셔널은 모나드(Monad)의 개념을 차용한 것입니다. 
    - 변수 선언시 '?' 를 사용하면 해당 변수는 값이 없을 수도 있다는 의미이고, '!' 를 사용하면 변수는 항상 값을 가진다는 의미입니다. 하지만 선언시 '!' 는 무슨일이 있어도 값이 들어있다고 100% 확신하는 경우에도 가급적 사용하지 않는것이 정신건강에 이롭습니다.
    - 옵셔널인 값과 아닌 값은 엄격하게 다른 타입으로 인식하기 때문에 컴파일러가 에러를 발생시킵니다. 덕분에 신경쓰지 않아도 자연스럽게 오류를 잡을 수 있어요. 하지만 컴파일러 에러도 발생하지 않도록 수련이 되어 있어야 고참 개발자라 할 수 있겠죠?
    - 값 반환시에는 '!' 를 사용해서 강제로 값을 뽑아올 수 있습니다. 하지만 위에서 언급한 것처럼 사용하지 않는 것이 좋습니다. run time 에 무슨 일이 발생할지 모르기 때문이죠.
    - 대신 옵셔널 체이닝을 통해 값이 있을지 없을지 모르는 경우에도 변수의 값 조회, 메서드의 호출을 연쇄적으로 할 수 있게 해줍니다.

    ``` swift
    let optionalValue = OptionalValue("ListType")
    if let element = optionalValue.value?.elements?.popLast() {
        print(element.rawValue)
    }
    ```

    - 위의 샘플에서처럼 optionalValue 의 value 가 옵셔널이고, 그 안에 있는 프로퍼티도 배열의 옵셔널인 경우 연쇄적으로 value 를 조회하고, elements 를 조회하고, popLast() 를 호출할 수 있습니다. nil 이 반환될 수 있음을 전제로 조회/호출하기 때문에 어딘가에서 nil 이 반환된다면 해당 옵셔널 체인은 nil 을 반환하게 되고 if 문을 벗어납니다. 그렇지 않고 성공적으로 popLast() 가 호출되어 element 에 할당되게 되면 if 문 안에서는 옵셔널이 벗겨진 채로 element 를 사용할 수 있습니다. 그리고 이런 과정을 if let binding 이라고 부릅니다. 만약 바인딩한 값이 변경될 수 있다면 if let 대신 if var 를 사용할 수 있습니다. if let/var 와 유사한 문법을 가지는 guard let/var 도 있습니다.(guard 문은 빠른 탈출이라고도 부릅니다. 그 이유는 함수 내에서 guard 문이 사용되고 만약 실패시 해당 함수를 그대로 return 하기 때문입니다. 아래의 코드처럼 말이죠.)

    ``` swift
    func foo() {
        guard let element = optionalValue.value?.elements?.popLast() else {
            return
        }
        print(element.rawValue)
        ...
        // do something
    }
    
    ```

    - 그리고 옵셔널은 enum 타입이라 case 로 some(<T>), none 을 가집니다. 그렇기 때문에 당연히 switch-case 문에서 패턴 매칭을 통해 값을 추출할 수도 있습니다.
    - 이외에도 flatMap 을 사용해 값을 뽑아올 수도 있습니다. 옵셔널의 flatMap 은 값을 확인하여 nil 이 아닌 경우에 값을 추출하여 transform 클로져의 반환값으로 전달하는 함수입니다. 옵셔널 변수 하나에 사용하기 보다는 주로 Sequence 를 준수하는 타입에서 유용하게 사용되는데 사용법은 아래와 같습니다.(각 타입별 flatMap, map 메서드는 api 를 확인해보세요~ )

    ``` swift
    let words = ["123", "eight", "-10", "3.14"]
    print(words) // ["123", "eight", "-10", "3.14"]
    // map 을 사용하면 transform 함수에서 반환하는 타입을 원소로 하는 배열을 반환합니다.
    let numbers = words.map{ Int.init($0) }
    print(numbers) // [Optional(123), nil, Optional(-10), nil]
    // filter 를 사용하면 transform 함수에서 반환하는 Bool 값이 true 인 경우, 해당 원소들만 포함하는 배열을 반환합니다.
    let filteredNumbers = numbers.filter{ $0 != nil }
    print(filteredNumbers) // [Optional(123), Optional(-10)]
    // 다시 한 번 map 을 사용해 옵셔널에서 값을 추출 후 배열을 반환합니다.
    let mappedNumbers = filteredNumbers.map{ $0! }
    print(mappedNumbers) // [123, -10]
    
    // flatMap 을 사용하면 위의 과정이 아래와 같이 한 번에 해결됩니다.
    // Int.int(:)? 에서 실패한 경우 nil 이 반환되면 해당 원소는 포함하지 않고, 변환된 값이 nil 이 아닌 경우, 옵셔널에서 값을 추출하여 해당 값을 포함한 배열을 반환합니다.
    let flatmappedNumbers = words.flatMap{ Int.init($0) }
    print(flatmappedNumbers) // [123, -10]
    ```

    - 마지막으로 nil 병합 연산자(nil Coalescing operator) 를 통한 값 추출이 있습니다. 옵셔널이 nil 이라면 대체 값을, 값이 있다면 추출된 값을 반환합니다.

    ``` swift
    // optionalString 이 nil 이라면 "string" 을 result 에 할당하고
    // optionalString 에 값이 있다면 추출된 값을 result 에 할당합니다.
    let result = optionalString ?? "string"
    ```


4. 함수형 프로그래밍
    - 스위프트에서 함수를 일급객체로 취급합니다.
    - 일급객체라 함은 아래와 같은 특징을 가진 녀석들을 말합니다.
        1. 전달인자로 전달할 수 있다.
        2. 동적 프로퍼티 할당이 가능하다.
        3. 변수나 데이터 구조 안에 담을 수 있다.
        4. 반환 값으로 사용할 수 있다.
        5. 할당할 때 사용된 이름과 관계없이 고유한 객체로 구별할 수 있다.

        ``` swift
        typealias MyComparator = (Int, Int) -> Bool
        // 4번 충족
        func getComparator() -> MyComparator {
            return {(lhs: Int, rhs: Int) in 
                return lhs > rhs
            }
        }
        // 2번 충족
        var comparator = getComparator()
        // 5번 충족
        print(comparator is MyComparator)
        var intArray = [3, 5, 1, 22]
        // 배열 안에 comparator 를 담아두는 변수가 있을텐데 이것이 3번을 충족, 그리고 1번 충족
        intArray = intArray.sort(by: comparator)
        ```

    - 스위프트는 이러한 특징때문에 함수형 프로그래밍이 가능합니다. 하지만 우리의 코드는 기본적으로 UIKit 과 함께 동작하기 때문에 순수하게 연속된 함수의 호출만으로는 프로그래밍이 불가능합니다. UIKit 에 종속된 녀석들은 대부분 Objective-C 로 동작하며 이들은 함수형 프로그래밍을 염두에 두고 설계되지 않았기 때문이죠. 그렇기 때문에 UI 와 연관되지 않은 비지니스 로직에서 자료 구조들을 map, flatMap, filter, reduce 등과 연계하여 함수형 프로그래밍을 잠깐 맛 볼 수 있습니다. 그 외에 직접 currying 기법이 적용되도록 함수를 설계하여 사용해도 되긴 하지만 적응하기 전까지는 꽤나 시간이 걸릴 듯 합니다.

    ```swift
    // 함수로 전달되는 파라미터는 해당 함수가 반환하는 함수 안에서 연산되고 해당 함수가 반환됩니다.
    func plus(_ num: Int) -> (Int) -> Int {
        return { num + $0 }
    }
    // 그러면 아래처럼 currying 기법을 사용한 표현을 사용할 수 있죠.
    // 하지만 이렇게 간단한 함수가 아닌 복잡한 함수의 경우 가독성을 생각해서 함수 이름 및 사용법을 설계해야 합니다. 
    // 꽤나 적응이 필요한 부분입니다.
    print(plus(3)(7)))
    ```

([swift 에서의 함수형 프로그래밍을 나름 이해할 수 있을만큼 해석한 링크](https://academy.realm.io/kr/posts/tryswift-rob-napier-swift-legacy-functional-programming/))


* * *   
## 단점
1. String 이 BidirectionalCollection(> Collection > Sequence) 을 준수하는 타입이다 보니 문자열 중간에서 sub string 을 하려고 할 때 불편한 부분이 있습니다. sub string 을 시작할 index, 종료할 index(String.Index(Sequence.Index 로 부터..)) 를 모두 계산해서 subscript 에 range 로 만들어서 전달해야 하는데 가독성도 떨어지고 이래저래 불편합니다. 다행히 스위프트 4 버전 들어서 NSRange 와 브릿징하여 동작할 수 있도록 api 가 개선되었으나 여전히 불편한 부분은 있습니다. 특히나 정규식 관련해서는 모두 swift 쪽으로 넘어오지 않았기 때문에 코드가 깔끔하지 못합니다.

``` swift
let str = "hello, world!"
let range = NSMakeRange(2, 4)
let subStr = (NSString(string: str).substring(with: range))
print("subStr: \(subStr)")
let regExp = try? NSRegularExpression(pattern: "[,]{1}", options: NSRegularExpression.Options.caseInsensitive)
let found = regExp?.rangeOfFirstMatch(in: str, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, str.count-1))
print("found: \(found)(is NSRange = \(found! is NSRange))")
```

([Squence, Collection 에 대한 설명 링크](https://academy.realm.io/kr/posts/try-swift-soroush-khanlou-sequence-collection/))
([swift 문자열과 NSRange 혼용 법에 대한 링크](https://soooprmx.com/archives/6749))


2. 스위프트는 아직 바이너리 안정성이 확보되어 있지 않습니다. 덕분에 버전이 올라갈 때마다 하위 호환성 때문에 크고 작은 문제들이 발생합니다. 그래서 오픈 소스를 사용하는 경우 의존성 관리 도구인 cocoapod(라이브러리 추가가 자동! 하지만 빌드 셋팅을 조작 당함!), karthage(라이브러리 빌드까지만 자동으로 해주고 프로젝트에 직접 추가해야함) 등을 사용할때, 사용중인 라이브러리 배포자가 새로운 버전에 대한 대응을 늦게 한다면 아찔한 상황이 발생할 수도 있습니다. 어쨌든 애플은 이런 문제 때문에 하위 호환성을 위해 바이너리가 만들어질 때, 작은 런타임을 같이 말아 넣도록 했습니다. 그 런타임이 하위 호환성을 보장할 수 있도록 중간다리 역할을 하는 것이죠.




* * *
* * *
How is memory management handled on iOS?
========================================
요즘의 애플리케이션들은 메모리 관리가 매우 중요합니다. 특히 iOS 앱은 메모리와 다른 하드웨어 및 시스템의 제약이 있어서 더욱 그러하죠. 이런 이유로  여러가지 유형으로 묻는 질문 중 하나입니다. ARC, MRC, Reference Type, Value Type 등이 있습니다. 
* * *

## ARC
- 스위프트의 Auto Reference Count 는 Objective-C 의 그것과 같은 컨셉으로 동작합니다. (컴파일 타임에 레퍼런스 카운팅을 끝내고 객체들의 life time 을 정해 놓습니다. 가비지 컬렉터는 런타임시에 사용하지 않는 객체를 추적 관리하므로 추가적인 리소스를 사용해야 합니다.)
[ARC vs CG](https://medium.com/computed-comparisons/garbage-collection-vs-automatic-reference-counting-a420bd4c7c81)

- ARC 는 컴파일 타임에 참조 타입의 인스턴스가 메모리에 생성된 순간부터 해당 인스턴스에 대한 강한 참조를 추적하여, 해당 인스턴스가 변수/상수/프로퍼티에 할당되거나 해제될때 카운트를 증가시키거나 감소시킵니다. 해당 인스턴스의 레퍼런스 카운트가 0 으로 떨어져서 더 이상 해당 인스턴스에 대한 참조가 없다고 판단될 때 메모리에서 해제됩니다. 

- ARC 는 값 타입에 대해서는 레퍼런스 카운트를 증가시키거나 감소시키지 않습니다. 값 타입의 인스턴스는 변수/상수/프로퍼티에 할당될 때 복사본이 전달되기 때문입니다.

- 강한 참조 사이클이 생성되면 해당 사이클에 들어 온 인스턴스들은 메모리가 해제되지 않아 메모리 leak 이 발생합니다. 예를 들어 아래의 코드는 사람이 배우자를 만나 연예를 하고 결혼하여 아이를 낳는 일생을 축약한 것인데요 덜덜덜 어쨌든 결혼을 하면 서로 속박하면서 절대로 떨어지지 않게 됩니다. 뭐 어떻게 보면 집착이라고도 할 수 있겠죠... combine(::) 함수를 보면 combine 성공시 서로를 강한 참조 사이클로 묶어 버립니다. 덕분에 해당 Human 구현체의 인스턴스들은 메모리에서 해제되지 않는 불상사가 생기게 됩니다. 실제로 문제가 되는것을 눈으로 확인할 수 있는데요. 앱을 실행한 후 좌측 네비게이터의 디버그 세션에서 디버그 메모리 그래프 버튼을 누르면 아주 깔끔하게 메모리 leak 이 발생한 것을 확인할 수 있습니다.

- 이런 강한 참조를 해결하는 방법은 2가지가 있습니다. attatched 프로퍼티를 약한 참조인 `weak var attatched: Human?` 으로 변경해야 하거나, 미소유 참조인 `unowned var attatched: Human` 으로 변경하면 됩니다.

- weak 는 레퍼런스 카운팅을 하지 않겠다는 뜻이고, 해당 프로퍼티에 할당된 인스턴스의 레퍼런스 카운트가 0 으로 떨어지면 자동으로 nil 처리되기 때문에 var 이어야 하고 또한 옵셔널이어야 합니다. 

- unowned 도 레퍼런스 카운팅을 하지 않겠다는 것은 같지만 weak 와 반대로 절대로 옵셔널이면 안됩니다. 그래서 var/let 어떤 식으로 선언해도 상관이 없습니다. 해당 프로퍼티에 할당된 인스턴스의 레퍼런스 카운트가 0 으로 떨어지더라도 자동으로 nil 처리되지는 않습니다. 그렇기 때문에 참조하고 있던 인스턴스가 메모리에서 해제된 이후 다시 해당 프로퍼티에 접근하면 nil 객체 참조로 인해 앱이 강제종료 됩니다. 즉 참조할 인스턴스가 절대로 nil 이 되지 않는다는 확신이 있는 경우에만 사용을 고려해 볼 수 있습니다.

- 이 외에도 강한 참조 사이클은 참조 타입인 클로저에서도 발생할 수 있습니다. 클로저가 참조 타입의 프로퍼티인 경우 해당 클로저 안에서 인스턴스를 강한 참조하기 때문인데요. 이를 방지하기 위해 클로저에는 캡쳐 리스트라는 것을 제공하여 참조 타입을 결정하는 규칙을 적용시킬 수 있습니다. 아래에서 badCase 메서드는 closure 에서 강한 참조 사이클에 빠지는 예제이고, badCase2 메서드는 캡쳐 리스트를 사용하기는 했으나 self 의 참조 타입을 unowned 로 변경하여 SomeClass 의 인스턴스가 nil 이 된 이후 해당 closure 가 호출되는 경우에 대한 예제이며, goodCase 메서드는 캠쳐 리스트로 self 참조 타입을 weak 로 변경하여 앞의 2가지 문제를 해결하는 예제입니다.

``` swift
typealias SomeClosure = (Int, Int) -> Int
class SomeClass {
    var a: Int = 1, b: Int = 2
    var anotherClass:AnotherClass
    func badCase() {
        // capture list 를 사용하지 않는 경우 강한 참조 사이클에 빠집니다.
        let badClosure: SomeClosure = {
            print("badClosure")
            return self.a + self.b + $0 + $1
        }
        anotherClass.doSomething(badClosure)
    }
    
    func badCase2() {
        // capture list 에서 unowned 를 사용할 경우 해당 클로저가 실제로 사용되는 순간에 self 가 nil 이 아니라는
        // 보장이 없으므로 앱이 강제 종료될 수 있으므로 사용을 지양하는 편이 좋습니다.
        let badClosure: SomeClosure = { [unowned self] in
            print("badClosure")
            return self.a + self.b + $0 + $1
        }
        anotherClass.doSomething(badClosure)
    }
    
    func goodCase() {
        // capture list 를 사용한 경우 강한 참조 사이클에 빠지지 않습니다.
        // 그리고 weak 로 받은 this 에 대한 guard let 바인딩을 통해 nil 인지 확인하기 때문에
        // 앱이 강제 종료되지 않고도 다른 작업을 수행할 수 있습니다.
        let goodClosure: SomeClosure = { [weak this = self] in
            // 당장은 번거로워 보이지만 이 클로저가 언제 어디에서 호출되어 강제 종료가 발생할지 모르니 
            // 이렇게 처리 하는게 정신 건강에 좋습니다.
            guard let this = this else {
                print("have no closure's owner")
                return $0 + $1
            }
            return this.a + this.b + $0 + $1
        }
        anotherClass.doSomething(goodClosure)
    }
    
    init(another: AnotherClass) {
        self.anotherClass = another
    }
}

class AnotherClass {
    var todo: SomeClosure?
    func doSomething(_ closure:@escaping SomeClosure) {
        todo = closure
    }
    func execution() {
        print(todo!(3, 4)) // 10
    }
}

struct Test {
    enum Case {
        case strong, unowned, weak
    }
    
    private var testCase: Case?
    private var someClass: SomeClass?
    private var anotherClass: AnotherClass?
    
    init() {
        anotherClass = AnotherClass()
        someClass = SomeClass(another: anotherClass!)
    }
    
    mutating func execute(_ testCase: Case) {
        self.testCase = testCase
        switch self.testCase! {
        case .strong:
            testStrong()
        case .unowned:
            testUnowned()
        case .weak:
            testWeak()
        }
    }
    
    mutating private func makeNilAndCallClosure() {
        print("someClass = nil")
        if self.testCase! != .weak {
            someClass = nil
        }
        anotherClass!.execution()
        
        print("call execution")
        if self.testCase! == .weak {
            someClass = nil
        }
        anotherClass!.execution()
        anotherClass = nil
    }
    
    mutating private func testStrong() {
        someClass!.badCase()
        makeNilAndCallClosure()
    }
    
    mutating private func testUnowned() {
        someClass!.badCase2()
        makeNilAndCallClosure()
    }
    
    mutating private func testWeak() {
        someClass!.goodCase()
        makeNilAndCallClosure()
    }
}

func testClosure() {
    var test = Test()
    // 강한 순환 사이클
    test.execute(.strong)
//    강제 종료 발생
//    test.execute(.unowned)
//    정상 동작
//    test.execute(.weak)
}
```

- 연산 프로퍼티에 클로저를 할당한 경우 해당 프로퍼티를 초기화하고 나면 해당 클로저는 사라지기 때문에 당연히 @noescape 이고 내부에서 사용하는 self 는 캡쳐시 unowned 로 동작합니다. 위의 HomoSapiense 의 scientificName 처럼 말이죠.


**[Memory Management 에 관한 standford 강의 링크](https://youtu.be/HQrXM2zUPvY?t=1h2m58s)**








* * *
* * *
What do you know about singletons? Where would you use one and where would you not?
===================================================================================

## 장점

- 싱글톤 클래스는 몇 번을 요청해도 항상 동일한 객체를 반환합니다. 즉 싱글톤 객체란 애플리케이션 전반에 걸쳐 단 하나만 존재하는 클래스의 인스턴스를 말합니다. 코코아 프레임워크에서는 싱글톤을 매우 중요하게 생각하는데요. 우선 우리가 프로젝트 생성 후 가장 먼저 만나게되는 UIApplication 자체가 애플리케이션에 단 하나만 존재하는 싱글톤 객체이죠 소오름.(그 외에 NotificationCenter.default, UserDefaults.standard, FileManager.default 등이 있습니다.)

- 현재 애플에서 지원을 중단한 듯한 "Cocoa Fundermental Guides" 에서는 싱글톤 객체를 반환하는 팩토리 메서드의 명명법은 "shared" + ClassType 라고 합니다만... swift 의 API 를 확인해보면 UIApplication 같은 경우에는 UIApplication.shared 라고 class computed property 로 선언되어 있습니다. 

- 싱글톤은 간단하게 구현(Objective-C 보다 훨씬 더 간결하게 구현할 수 있게 되었습니다.)해서 쉽게 사용할 수 있지만 anti-pattern 이라는 비난을 받기도 하죠. 그 이유는 단 하나의 객체를 이곳 저곳에서 직접적으로 접근하여 사용하다보니 특정 값에 변동이 생긴다면 예상하지 못한 버그가 발생할 수도 있고, 그로 인해 의도치 않게 해당 값 또는 상태에 의존하게 되기 때문입니다. 그렇기 때문에 애플은 싱글톤 객체를 일종의 컨트롤 센터로 만들어서 싱글톤 클래스의 서비스를 관리하도록 구현하였습니다.

- 아래는 간단한 싱글톤의 예입니다.

``` swift
class MySingleton {
    static let shared = MySingleton()
    var routeOfViews = [String]()
    private init() {}
}

// 각 화면에 진입할 때 마다 routeOfViews 에 화면 이름을 저장합니다.
MySingleton.shared.routeOfViews.append(String(describing: self).components(separatedBy: ".").last!)
```


## 단점

- 하지만 이러한 편리함 때문에 정말 필요에 의한 사용이 아닌 마치 뭐든 추가할 수 있는 전역 창고따위로 생각할 수도 있습니다. 불필요한 의존성이 단순히 개발 편의를 위해 주입된다는건 좀 아니죠...

- 또 이런 특성때문에 점점 사용 범위가 넓어지고, 결국 어디에서 사용되는지 추적하는 것이 힘들어질 지경에 이르기도 하죠. 만약 해당 싱글턴을 제거해야 한다면? ㅡ,.ㅡ;;;;

- 싱글톤이 다른 싱글톤을 참조하고 있는 경우, 참조 당하는 싱글톤의 기능이 수정되면 참조하는 싱글톤에 문제가 생길 수 있고, 결국 프로젝트 전반에 걸쳐 문제가 발생할 수 있습니다.


[Singleton is good 관련 참고 영상 링크](https://cocoacasts.com/what-is-a-singleton-and-how-to-create-one-in-swift/)

[Singleton is bad 관련 참고 영상 링크](https://cocoacasts.com/are-singletons-bad/)

[전역 상수 사용시 lazy 처리에 대한 링크](https://outofbedlam.github.io/swift/2016/03/04/Lazy/)

[@noescape 에 대해 잘 설명된 링크](https://krakendev.io/blog/hipster-swift)



<메모리 관련>
ibooks: how arc works
: unsafe, Manual Memory Management 에서 찾아보면 알 수 있다.

auto release pool 은 여전히 swift 에 존재한다.
swift 에서 loop 돌면서 objc 객체를 생성하면 해당 loop 영역이 종료되는 시점에도 메모리 해제가 되지 않는다. 그럴때는 loop 블럭 내부에 autoreleasepool 을 생성해 줘야 깔끔하게 해제된다.

iboulet으로 스토리보드와 xib 코드 묶은 후 didSet { 해당 ui 에 대한 초기값을 설정할 수도 있다. }


<싱글톤>
물리적 혹은 개념적으로 유니크하게 매핑되는 경우 싱글톤으로 만드는게 맞을 수 있다.

스태틱 펑션만 존재하는 클래스(유틸리티 펑션의 모음 클래스) 과 싱글턴의 차이?
상태 보관이 필요하면 싱글톤, 아니면 유틸리티 클래스
유틸리티 클래스. 함수 호출시 사이드 이펙트가 없다면 어느정도의 디펜던시를 감수하더라도 사용할 만하다.





* * *
* * *
What design patterns are commonly used in iOS apps?, What are the design patterns besides common Cocoa patterns that you know of?
=================================================================================================================================

"iOS 앱에서 흔히 사용되는 디자인 패턴은 무엇입니까?" 이 질문은 어쩌면 초급 개발자를 제외한 모든 등급의 개발자들에게 물어보는 질문일 것입니다. iOS 개발자로서 iOS 플랫폼에서 흔히 사용되는 기술, 구조, 디자인 패턴에 익숙해야 합니다.

iOS 애플리케이션 개발시 흔하게 사용되는 전형적인 패턴들은 Cocoa, Cocoa Touch, Objective-C, Swift 문서에 잘 나타나 있습니다. 이러한 패턴은 모든 iOS 개발자들이 익혀야 합니다. 문서에 나타나는 패턴은 MVC, Singlton, Delegate, Observer 등이 있습니다.

간혹 MVC 만 언급하는 사람들이 있는데... 그런 모든 iOS 개발자들이 알고 있는 내용을 대답으로 듣고싶어하는 인터뷰어는 없습니다... 이 질문은 iOS 전반에 대해 얼마나 잘 알고 있는지 확인하기 위한 질문입니다.

* * *


## MVC
- Cocoa 의 근간이 되는 핵심 패턴중 하나입니다.  화면 설계를 위해 파일 생성시 기본으로 제공되는 패턴이죠. 오브젝트를 일반적인 역할에 따라 분류(model, view, controller)하고, 그 역할에 따라 코드를 완전히 분리하도록 도와줍니다.
    - Model: data 와 data 를 제어할수 있는 코드를 포함합니다.
    - View: model 의 시각적 표현을 담당하고, 사용자와 애플리케이션이 소통할 수 있도록 해주는 코드를 포함합니다.
    - Controller: 모든 일을 제어하는 중개자 역할을 합니다. model 의 data 에 접근하여 view 를 표시하고, 이벤트를 수신하고, 필요에 따라 data 를 조작합니다.

- 각 개체가 자신이 해야할 작업만 수행할 수 있도록 해야합니다. 가능하면 model 에서 수행해야 할 기능을 view 나 controller 에 구현하지 마세요!

- 가능한 한 프로젝트 내에 Model, View, Controller 그룹을 생성하여 그 안에 파일을 생성하는게 좋습니다.

![MVC in Cocoa](함ttps://developer.apple.com/library/content/documentation/General/Conceptual/DevPedia-CocoaCore/Art/model_view_controller_2x.png)

- 자매품으로 MVP(Model-View-Presenter: MVC 에서의 M-V 간 의존성을 줄이기 위해..), MVVM(Model-View-ViewModel: MVP 에서 V-P 간 의존성 조차 줄이기 위해.. ) 등이 있습니다.
> [MVC vs MVP vs MVVM 관련 링크](http://blog.naver.com/PostView.nhn?blogId=itperson&logNo=220840607398&parentCategoryNo=&categoryNo=92&viewDate=&isShowPopularPosts=true&from=search)

**[Multiple MVC 에 대한 standford 강의 링크](https://youtu.be/HQrXM2zUPvY?t=39m37s)**



## Singleton
- 프로젝트에서 특정 기능에 맵핑된 단 하나의 연결점이 필요한 경우 사용합니다. 예를 들어, Network 통신시 하나의 연결점을 두고, 그 안에서 serial 하게 통신을 연결 시킨다거나 하는 작업 등에 유용합니다. 다만 애플리케이션이 종료되기 전까지 메모리에 상주하기 때문에 불필요하게 메모리를 잡아먹지 않도록 잘 관리해야 합니다. 

- 앞에서 언급한 기기의 제약이 있는 경우가 아니고 side effect 가 발생하지 않게 함수를 설계한다면 꼭 Singleton 패턴을 사용하지 않고 static 한 순수한 함수들을 모아 놓은 Utility type 을 생성하는 것이 대안이 될 수 있습니다.(가급적 무의미한 의존성 주입은 자제해야죠)

``` swift
class Singleton {
    // static 변수로 선언하면 lazy 하게 동작합니다. 그러므로 실제 호출이 있기 전에 메모리에 올라가지 않습니다.
    // let 은 기본적으로 thread-safe 하므로 dispatch_once_t 같은 처리를 하지 않아도 됩니다.
    static let shared = Singleton()
    /*
    만약 초기 설정이 필요하다면 closure 로 구현하면 됩니다.
    static let shared: Singleton = {
        let _shared = Singleton()
        _shared.property = 100
        // do something more...
        return _shared
        }()
    */
    var property: Int = 0
    private init(){}
}
```


## Facade
- 복잡한 개체들에 대한 하나의 인터페이스를 제공해야하는 경우 사용합니다. 아래는 간단한 예입니다.

``` swift
struct OrderPart {
    func order(name: String, count: Int) -> Receipt {}
}
struct CookingPart {
    func cook(name: String, count: Int) -> Food {}
}
struct ServePart {
    func serve(food: Food, count: Int, tableNo: Int) -> Service {}
}

// 식당에서 주문시 고객은 음식만 주문하면 됩니다.
// 나머지는 식당이 알아서 진행하고 음식과 영수증을 고객에게 전달하면 되는거죠
struct Restaurant {
    private(set) var manager = OrderPart()
    private(set) var shef = CookingPart()
    private(set) var waiter = ServePart()

    func orderFood(name: String, count: Int, tableNo: Int) -> (Service, Receipt) {
        let receipt = manager.order(name: name, count: count)
        let food = shef.cook(name: name, count: count)
        let service = waiter.serve(food: food, count: count, tableNo: tableNo)
        return (service, receipt)
    }
}

let restaurant = Restaurant()
let result = restuarant.orderFood(name: "Burger", count: 1, tableNo: 5)
print("\(result.0), \(result.1)") // "free smile", ["food": "Burger", "count": "1", "total": "6.7"]
```


## Decorator
- 어떤 개체의 원래 특성을 바꾸지 않고 동적으로 역할 및 책임을 추가하는 패턴입니다. 어떤 개체를 감싸는 wrapper 로써 감싼 개체에 새로운 기능을 제공하는 인터페이스를 추가하는 방식으로 구현합니다.

- Objective-C 의 category, Swift 의 extension 은 기능의 수평 확장으로 서브 클래스를 추가하지 않고 새로운 행동을 추가할 수 있다는 점이 유사합니다. 하지만 category, extension 은 컴파일 타임의 정적 바인딩이고, 확장되는 클래스 인스턴스를 캡슐화하지 않는 등의 차이점이 있습니다. 그래도 swift 의 extension 은 서브 클래스를 추가하지 않고, 구현하기 쉬우며, 가볍다는 장점이 있죠. (더 멋진건 원본 코드가 없어도 기능을 확장할 수 있다는 것입니다. 즉, UIView, UIImage 등에도 커스텀 함수를 추가하여 기능을 확장할 수 있다는 뜻입니다.)

- 클래스의 정의가 감추어져 있거나 서브 클래스를 생성할 수 없는 경우, 클래스의 기능 확장을 위해 많은 수의 서브 클래스가 필요한 경우 사용하면 유용합니다.

- 객체 지향 설계 원칙 중 하나인 Open-Closed Principle 에 부합합니다.(확장에는 열려있고, 수정에는 닫혀있는...)

[샘플 코드 링크](samples/ChickenSeller.swift)



### Delegation
- delegation 도 decorator 중 하나입니다. UIKit 에서 매우 빈번하게 사용되고 있죠. UITableView, UICollectionView, UITextView, UIWebView... 등 모두 delegation 을 이용해 서브 클래스를 추가하지 않고 기능을 확장합니다. UITableView 를 예로 들어보면 UITableView 는 UITableViewDelegate 를 통해 controller 와 통신을 하여 cell 선택시에 대한 전반적인 작업을 수행합니다. UITableViewDataSource 를 이용해서는 tableView 의 section, row 에 표시되어야 할 model 들에 접근하여 화면을 구성합니다. 

- 아래 링크는 delegation 을 이용한 샘플입니다. 전체적인 구조가 매끄럽지는 않지만 샘플에서처럼 커피숍만 만들거나, 쇼핑몰 혹은 특정 건물 내에 커피숍을 추가로 개점할 때 커피숍을 위한 클래스를 추가하지 않고 해당 건물에 CoffeeCenter 를 설치하고 DripCoffeeDelegate, DripCoffeeDataSource 를 준수하도록 구현하면 됩니다. 

[샘플 코드 링크](samples/CoffeeShop.swift)



## Adapter
- 이미 구현되어 있는 참조/값 타입들의 상이한 인터페이스를 서로 소통할 수 있는 인터페이스로 동작할 수 있게 도와주는 패턴입니다.

- 코드를 수정할 수 없는 third-party 의 코드를 사용하기 편하게 조정하거나, 사용하기 불편하거나 호환되지 않는 api 를 사용하고자 할 때 사용할 수 있습니다.

- swift 에서는 protocol 을 이용해 위와 같은 상황에 대처할 수 있습니다.

[샘플 코드 링크](samples/Adapter.swift)



## Factory Method
- 런타임에 생성할 타입을 정할 수 있도록 정확한 타입을 명시하지 않으면서 타입의 생성자를 대신하는 메서드를 사용하는 패턴입니다.

- 하나의 프로토콜을 따르는 여러 타입이 있고, 런타임에서 적절한 타입을 인스턴스화하기 위해 선택해야 하는 문제를 해결하기 위해 설계되었습니다.

[샘플 코드 링크](samples/Factory.swift)



## Command
- 실행할 작업을 나타내는 개체를 구현하는 패턴입니다. 일반적으로 여러 개의 동작을 수행해야 하는 개체가 있고, 수행해야 할 동작을 런타임 단계에서 선택해야 하는 경우 사용할 수 있습니다.
- 사용자에게 구체적인 내부 구현을 숨기고 실행 중지/재실행 기능을 추가하도록 설계할 수 있습니다.

``` swift
protocol DoorCommand {
    func execute()
}

struct DoorOpenCommand: DoorCommand {
    private(set) var door: String
    init(_ door: String) {
        self.door = door
    }
    func execute() {
        print("\(door) is open")
    }
}

struct DoorCloseCommand: DoorCommand {
    private(set) var door: String
    init(_ door: String) {
        self.door = door
    }
    func execute() {
        print("\(door) is open")
    }    
}

class Door {
    private(set) var openCommand: DoorCommand
    private(set) var closeCommand: DoorCommand

    init(openCommand: DoorCommand, closeCommand: DoorCommand) {
        self.openCommand = openCommand
        self.closeCommand = closeCommand
    }

    func updateOpenCommand(_ command: DoorCommand) {
        self.openCommand = command
    }

    func updateCloseCommand(_ command: DoorCommand) {
        self.closeCommand = command
    }

    func open() {
        openCommand.execute()
    }

    func close() {
        closeCommand.execute()
    }
}

func testCommand() {
    let doorName = "Elite"
    let openCommand = OpenCommand(doorName)
    let closeCommand = CloseCommand(doorName)
    let door = Door(openCommand: openCommand, closeCommand: closeCommand)
    door.open()
    door.close()
}
```



## Builder 
- 초기 설정 값이 많은 개체를 생성할때, 개체 생성을 담당하는 클래스를 별도로 분리하여 서로 다른 초기 설정이 적용된 개체를 동일한 생성 공정을 통해 제공할 수 있도록 합니다.

- 아래의 샘플 코드는 불필요하게 타입이 많아지는 것을 방지하기 위해 builder 의 역할을 CarBuilderClosure 로 설계하였습니다.

``` swift
class CarBuilder {
    var name: String?
    var color: String?
    var seats: Int?
    var hp: Float?
    var torque: Float?
    
    typealias CarBuilderClosure = (CarBuilder) -> Void
    init(_ builderClosure: CarBuilderClosure) {
        builderClosure(self)
    }
}

struct Car {
    let name: String
    let seats: Int
    var color: String
    var hp: Float
    var torque: Float
    
    init?(_ builder: CarBuilder) {
        guard let name = builder.name, let color = builder.color, let seats = builder.seats, let hp = builder.hp, let torque = builder.torque else {
            return nil
        }
        self.name = name
        self.color = color
        self.seats = seats
        self.hp = hp
        self.torque = torque
    }
}

extension Car: CustomStringConvertible {
    var description: String {
        return "\(name), \(color) color, \(seats) seats, \(hp)hp, \(torque)kg/m"
    }
}


func testBuilder1() {
    let coupeBuilder = CarBuilder { (builder) in
        builder.name = "C200 Coupe"
        builder.color = "Silver"
        builder.seats = 4
        builder.hp = 189.0
        builder.torque = 36.7
    }
    
    let benzC200Coupe = Car(coupeBuilder)
    print(benzC200Coupe)

    let conceptCar = Car(CarBuilder({
        $0.name = "Performance Concept"
        $0.color = "White"
        $0.seats = 5
    }))!
    print(conceptCar)
}
```

[샘플 코드 링크](samples/Builder.swift)



## Template
- 기본 알고리즘을 가지고 있는 개체가 실제 구현을 서브 클래스로 위임하는 패턴으로, swift 에서는 UIViewController 를 예로 들 수 있습니다.

- 아래 샘플 코드에서는 자동차 시동 절차를 간단히 구현해 보았습니다. 2010년 전까지만 해도 스마트키 보다 일반 키가 일반적이었고, 그래서 시동시 키를 키박스에 꼽아 돌리는 방식으로 시동을 걸었죠. 그 이후 스마트 키가 널리 보급되면서 시동 버튼을 눌러서 시동하게 되고, 전기차의 경우 엔진이 아닌 모터를 구동시키게 되었습니다. 정확한 내부 절차를 모르기 때문에 제가 생각하는 절차를 하나 만들고 각 시동 타입별로 서브 클래스를 만들어 구현해 보았습니다.

[샘플 코드 링크](samples/Template.swift)





* * *
* * *
Could you explain and show examples of SOLID principles?
==========================================================

SOILD 원칙은 그 자체만으로도 큰 이야기꺼리 입니다.



구조체와 클래스를 개발하고자 한다면, 마이클 패더스(Michael Feathers)가 주창한 SOLID 원칙을 준수해야 한다. SOLID 는 객체지향 디자인과 프로그래밍을 설명하기 위한 다섯 가지 원칙으로 다음과 같은 내용을 담고 있다.
; 단일 책임 원칙(Single Responsibility Principle) - 하나의 클래스는 오직 단 하나의 책임만 부담해야 한다.
(함수, 클래스, 모듈 등등 모두 각자 자신이 해야할 일만 해야한다.)

; 개방과 폐쇄의 원칙(Open Closed Principle) - 소프트웨어는 확장이라는 측면에서는 개방돼 있어야 하고, 수정이라는 측면에서는 폐쇄돼 있어야 한다.
(extension 으로 수평적 기능 추가를 한다.)

; 리스코프 대체 원칙(Liskov Substitution Principle) - 특정 클래스에서 분화돼 나온 클래스는 원본 클래스로 대체 가능해야 한다.

; 인터페이스 세분화 원칙(Interface Segregation Principle) - 개별적인 목적에 대응할 수 있는 여러 개의 인터페이스가 일반적인 목적에 대응할 수 있는 하나의 인터페이스보다 낫다.
(프로토콜 지향 프로그래밍)

; 의존성 도치(역전)의 원칙(Dependency Inversion Principle) - 구체화가 아닌 추상화를 중시한다. 
(factory pattern 에서처럼 외부에서 의존성을 주입시켜 의존 여부를 명확하게 하면 단위 테스트 하기도 편리해진다. 의존성이 있는 객체를 클래스 내부에서 만들어 버리면 테스트할 때 굉장히 불편해진다. [factory pattern sample 링크](samples/Factory.swift))


[관련 영상 링크](https://youtu.be/d1eA-r_Cd2Y)





* * *
* * *
What options do you have for implementing storage and persistence on iOS?
===========================================================================

iOS 에서 데이터를 저장하고 사용하는 방법에 대해 어느정도나 이해하고 있는지 묻는 질문입니다.

- In-memory arrays, dictionaries, sets, and other data structures
  : 추후 다시 사용하지 않아도 되는 데이터를 빠르게 저장하기에 좋습니다.

- NSUserDefaults/Keychain
  : key-value 방식으로 저장되며 KeyChain 은 보안이 적용됩니다.

- File/Disk storage
  : NSFileManager 를 이용해 실제로 데이터를 파일로 저장하는 방식입니다.

- Core Data and Realm
  : 데이터 베이스를 간편하게 이용할 수 있도록 도와주는 프레임워크입니다.

- SQLite
  : 관계형 데이터 베이스로 복잡한 쿼리를 사용해야 할때 유용하며, Core Data 나 Realm 이 SQLite 를 대체할 수 없을 것입니다.

* * *


## in memory arrays, dictionaries, sets 그리고 다른 데이터 구조를 
- 내장 데이터 구조 및 커스텀 데이터 구조를 이용해 데이터를 저장, 읽기, 수정이 가능합니다.
- 메모리에 존재하는 값들이기 때문에 빠르게 동작할 수 있지만 복원이 불가능합니다.


## KeyChain
- 애플리케이션에서 사용되는 비밀번호를 저장하는 암호화된 저장소입니다.
- 시스템의 root 권한만 가지면 KeyChain 에 저장된 암호들에 접근이 가능합니다. 덕분에 사용자는 여러개의 암호를 모두 외우지 않아도 되므로 편리하죠.
- KeyChain은 각 애플리케이션에서 저장한 정보를 가지고 올 때 Provisioning profile 별로 사용 경로를 구분하기 때문에 동일한 애플리케이션이라 하더라도 개발 단계에서 profile 이 변경되면 기존에 저장해 둔 정보를 사용하지 못하는 단점이 있습니다.
- KeyChain 의 장점은 보안입니다. 그렇기 때문에 보안 유지가 필요한 정보는 KeyChain 에 저장하는 것이 좋습니다.
- 보안이 뛰어나다는 장점은 있으나 github 에 KeyChain Dumper 같은 오픈 소스가 있으니 완벽하게 보호되는 것은 아닙니다. 다만 운영체제에서 지원하는 저장소이므로 일반적인 저장소보다 안전하다는 뜻입니다.


## UserDefaults
- 가볍고 제약이 많은 딕셔너리 형태의 데이터 베이스입니다. 그러므로 너무 큰 값을 저장하기에 적합하지 않습니다.
- 앱 launching 시 일종의 'settings' 처럼 사용하기 좋은 아주 작은 데이터베이스라고 생각할 수 있습니다. 
- 무엇을 저장할 수 있느냐하면~ 바로 Property List 데이터만 저장할 수 있습니다.

``` swift
let defaults = UserDefaults.standard

// 3.1415 는 Double 타입이므로 property list 에 저장할 수 있습니다.
defaults.set(3.1415, forKey: "pi") 
// [Int] = Array + Int 조합이므로 property list 에 저장할 수 있습니다.
defaults.set([1, 2, 3, 4, 5]], forKey: "My Array") 
// key 에 저장된 데이터를 지웁니다.
defaults.set(nil, forKey: "Some Setting") 

if !defaults.syncronize() {
    // 저장에 실패하는 경우 값들을 다시 확인해서 저장해야합니다.
}

//'pi' 에 저장된 Double 값을 가져옵니다.
defaults.double(forKey: "pi")
// 'Some Setting' 에 저장된 Array 를 가져옵니다.
// 만약 nil 이 반환된다면 해당 키에 저장된 값은 Double 이 아닌 것입니다.
defaults.array(forKey: "Some Setting")

```

- share, action, today extention 사용시엔 standard 가 아닌 새로운 저장소를 생성해서 사용해야 합니다. [extension 개발 가이드 링크](https://developer.apple.com/library/content/documentation/General/Conceptual/ExtensibilityPG/ExtensionOverview.html#//apple_ref/doc/uid/TP40014214-CH2-SW2)



> ### Property List
> - 번들 실행에 대한 필수적인 정보를 저장하고 있있으며 UTF-8 로 인코딩된 XML 형식의 파일입니다.
> - Array, Dictionary, String, Data, Number(Int, etc) 들의 조합입니다.
> - swift4 부터는 Codable 을 이용해 쓰고, 읽을 수 있습니다.
>
> [Property List 참고 링크](https://developer.apple.com/library/content/documentation/General/Reference/InfoPlistKeyReference/Articles/AboutInformationPropertyListFiles.html)


## Archiving and Codable
- 가벼운 데이터를 저장하기 위한 방법입니다.
- old mechanism: NSCoder
    - 아래의 두 함수를 구현해서 Dictionary 형태의 corder 에 데이터를 저장하고 읽어들일 수 있게됩니다.
        - `func encode(with aCoder: NSCoder)`
        - `init(coder: NSCoder)`
    - 데이터를 저장할 때는 NSCoder 를 준수하는 타입의 인스턴스를 NSKeyedArchiver 를 이용해 저장하고, 읽어들일 때는 NSKeyedUnarchiver 를 이용하면 됩니다.
- new mechanism: Codable
    - 기본적으로 NSCoder 와 비슷하게 동작하지만 특정 함수를 구현하지 않아도 됩니다. Swift 가 자동으로 해주기 때문이죠. 
    - Swift standard type 만 저장할 수 있습니다. 만약 non-standard type 을 저장해야 한다면 NSCoder 를 사용해서 저장해야 합니다.
    - Swift standard type 으로는 String, Bool, Int, Optional, Array, Set, Data, Date, URL, Calendar, CGFloat, AffineTransform, CGRect, IndexPath, NSRange ... 등이 있습니다.
    - JSON 이나 Property List 로 컨버팅할 수 있습니다.

[참고 링크](https://github.com/bankart/Persistence)



## FileSystem
- iOS 시스템은 unix 이기 때문에 기본적인 unix 와 동일하게 동작합니다. 모든 파일을 볼 수 없도록 보호되어 있죠. 그렇기 때문에 애플리케이션은 자신이 접근할 수 있는 공간이 따로 존재합니다. 'sandbox' 라 불리우는 공간입니다.
- 'sandbox' 는 애플리케이션 자신 이외에는 접근할 수 없기 때문에 보안성(security, privacy)이 뛰어나고, 애플리케이션 삭제시 같이 삭제되기 때문에 뒷처리도 깔끔합니다.
- 'sandbox' 에는 아래와 같은 장소들이 포함됩니다.
    - Application directory: storyboard, jpgs, 등등 파일이 저장되어 있는 곳이며 읽기만 가능합니다.
    - Documents directory: 사용자에의해 생성된 언제나 접근할 수 있는 영구적인 저장소입니다.
    - Application Support directory: 사용자가 직접적으로 접근할 수 없는 영구적인 저장소입니다.
    - Caches directory: 임시 파일들을 저장하는 장소입니다.(iTunes 를 통해서 백업되지 않습니다.)
    - ...
- 파일 시스템에 접근하는 방법은 아래와 같습니다.

``` swift
// url 메서드의 구조 및 사용법은 아래와 같습니다.
let url: URL = FileManager.default.url(
    for directory: FileManager.SearchPathDirectory.documentDirectory, // 예를 들어 document directory 로 설정했습니다.
    in domainMask: .userDomainMask // iOS 에서는 무조건 .userDomainMask 입니다.
    appropriateFor: ni // 파일 대체시에만 의미가 있는 파라미터입니다.
    create: true // directory 가 존재하지 않으면 생성하도록 하는 파라이터입니다.
    )
// 사용 가능한 directory 로는 FileManager.SearchPathDirectory.documentDirectory, .applicationSupportDirectory, .cachesDirectory 등이 있습니다.
```


## CoreData
- 큰 데이터를 저장해야 하거나 데이터를 효과적으로 검색해야 할 때 사용합니다.
- 복잡한 쿼리 문법을 공부할 필요가 없고, 프레임워크가 제공하는 api 만 사용하면 됩니다.
- 객체지향 데이터 베이스로 iOS 에서 매우 강력한 프레임워크입니다.
- 데이터 베이스로부터 실제 객체를 뽑아내는 방법을 제공합니다.
- 코어 데이터의 본질은 라이프 사이클, 검색, 영속성 기능을 가지는 객체 그래프 관리자(object graph manager) 입니다.
    - 객체 A 를 B 와 연결할 수 있고, 해당 연결은 영속적으로 동기화 됩니다. A 에서 연결을 변경하면 B 가 업데이트 되면서 그에 따른 알림을 발생시킵니다.
    - 한 쪽에서 삭제하는 경우 연결 체인을 타고 모두 삭제되도록 할 수도 있고, nullify 시켜서 해당 객체만 삭제할 수도 있습니다.
- 일반적인 데이터 베이스들과는 다르게 코어 데이터는 명시적으로 저장하지 않으면 in memory 형태로 사용이 가능합니다.
- 검색을 위한 다른 처리는 필요없고, 객체들이 생성된 이후 연결된 객체들이 있다면 하나의 객체에만 접근하더라도 추가적인 fetch 없이 연결을 타고 넘어가며 접근이 가능합니다.
- 코어 데이터 객체들은 완전한 Objective-C 객체이기 때문에 변경 및 관리가 가능합니다. 서브 클래싱을 통해 커스터마이징된 동작을 수행할 수도 있습니다.
- 객체가 생성되어 메모리에 올라와 있기 때문에 빠르게 동작할 수 있지만 그렇기 때문에 삭제를 위한 동작을 위해서도 해당 데이터를 메모리에 올린 이후에 삭제를 해야하는 번거로움이 있습니다.
- 많은 데이터가 객체화되어 있는 경우 메모리 관리에 신경 써야 합니다.

**[CoreData 에 관한 standford 강의 링크](https://youtu.be/ssIpdu73p7A?t=5m9s)**
**[CoreData 에도 constraint 가 추가되었음](https://stackoverflow.com/questions/21130427/how-to-add-unique-constraints-for-some-fields-in-core-data)**


## Sqlite
- 로컬 저장소에 항상 최신의 데이터를 저장할 수 있도록 도와줍니다.
- 관계형 데이터 베이스라고 불리우지만 CoreData 처럼 실제 연결된 객체로 뽑아내줄 수는 없습니다.
- 기능 확장이 어렵고 단순하게 데이터만 저장할 수 있습니다.
- 검색시 모든 데이터가 객체화되어 메모리에 올라와 있는 코어 데이터에 비해 느릴 수 밖에 없습니다. 대신 필요한 만큼만 메모리에 로드하므로 효율적입니다.
- 삭제 및 업데이트시엔 코어 데이터 보다 sqlite 가 더 빠를 수 있습니다. 

**[SQLite 영상 링크](https://www.youtube.com/watch?v=c4wLS9py1rU)**


## Cloud Kit
- 클라우드에 존재하는 데이터 베이스로 아주 기본적인 동작만 수행할 수 있습니다.
- 네트워크 상태에 따라 데이터 베이스로의 접근이 느리거나 불가능 할 수 있으므로 구현시 주의해야 합니다.
- Cloud Kit Dashboard 라는 웹사이트를 이용해 모델을 추가, 삭제, 수정 할 수 있습니다.
- 데이터 베이스에 RecordType(CoreData 의 Entity 같은 개념), Fields(CoreData 의 attribute 같은 개념) 등을 추가하면 자동으로 스키마가 생성된다는 장점이 있습니다.
- 애플리케이션에서 클라우드에 접근하기 위해서는 사용자가 iCloud 에 로그인되어 있어야 한다는 단점이 있습니다.
spring 2015-16 lecture 에 자세히 설명함
**[CloudKit 에 관한 standford 강의 링크](https://youtu.be/_ffOdODpDSk?t=42m8s)**


## UIDocument
**[UIDocument 에 관한 standford 강의 링크](https://youtu.be/ckCjIJbxYLY?t=54m10s)**

## UIDocumentBrowserViewController


## Realm
**[Realm 공식 페이지 링크](https://realm.io/kr/docs/swift/latest/)**

**[Realm + Codable 링크](https://medium.com/@swiftthesorrow/realm-codable-part-1-7629b9a1493a)**

**[Realm CRUD 영상 링크](https://www.youtube.com/watch?v=hC6dLLbfUXc)**





* * *
* * *
What options do you have for implementing networking and HTTP on iOS?
=========================================================================

요즘은 대부분의 앱들이 외부로부터 데이터를 받아오기 위해 네트워킹을 사용합니다. 그렇기 때문에 iOS 개발자들은 네트워킹 레이어를 구현하기 위해 어떤 기능을 사용할 수 있는지 알아야 합니다.

고전적이지만 잘 동작하는 URLSession 을 이용하는 방법이 있으나 delegation 을 잘 이해하고 구현하지 않으면 사용하기 까다로울 수 있습니다. 그래서 Alamofire/AFNetworking 등의 오픈소스 라이브러리를 이용하는 방법도 있습니다. 
고참 개발자라면 단순히 네트워킹만 신경 써서는 안됩니다. 데이터를 시리얼라이징하고 그 데이터를 모델 객체로 맵핑하는 등의 작업도 함께 구현해야 합니다.


## URLSession
- 데이터를 로딩해서 그 결과에 따라 UI 를 조작하거나, 기기에 저장하거나 또는 데이터를 업로드 한다면 URLSession 을 이용해서 작업할 수 있습니다.
- URLSession.shared 로 접근해서 상황에 맞는 task(URLSessionDataTask, UploadTask, DownloadTask, StreamTask) 를 사용할 수 있도록 편의 메서드를 제공합니다. 하지만 애플리케이션이 주기적으로 업로드/다운로드 등의 작업을 수행하고 해당 작업들을 관리해야 한다면 URLSessionDelegate(URLSessionDataDelegate + URLSessionTaskDelegate + URLSessionDownloadDelegate) 를 준수하는 (혹은 필요한 protocol 만 준수하는) 매니저 개체를 구현해야 하는데 각 프로토콜 메서드들이 정확하게 어떤 일을 수행하는지 파악하지 못한다면 구현하기 까다로울 수 있습니다.
- 기본적으로 global(.background) queue 에서 동작해야하고 UI 와 연계하는 부분에서는 main queue 에서 동작해야하므로 주의해야 합니다.
[애플 개발자 문서 링크](https://developer.apple.com/documentation/foundation/url_loading_system#//apple_ref/doc/uid/10000165i)


## Alamofire/ObjectMapper/AlamofireObjectMapper
- 역시나 번거로운 작업에서 벗어나게 해주는 오픈소스 라이브러리가 있습니다. 대부분의 네트워킹 기능을 구현해 두었습니다.(유사한 Objective-C 라이브러리로는 AFNetworking 이 있습니다.)
- 심지어 사용도 간편하고 json 데이터를 손쉽게 모델 객체로 변환시켜 줍니다. 다만 맵핑될 데이터 구조를 nested 하게 구현해줘야 하는 번거로움은 있습니다.
- 단순하게 json 파싱만 사용하려면 SwiftyJson 라이브러리를 사용하는것이 편합니다.


[Alamofire 이용시 URLSession 으로 인한 boilerplate 가 제거되는 샘플 링크](http://hyesunzzang.tistory.com/49)





* * *
* * *
How and when would you need to serialize and map data on iOS?
=================================================================
네트워크를 통해 데이터를 업로드/다운로드 하거나, 저장소에 저장하고자 할때 상황에 맞는 작업을 수행할 수 있는지 물어보는 질문입니다.

## Codable(Encodable/Decodable)/JSONEncoder/Decoder, NSKeyedArchiver/Unarchiver, FileManager
- restful api 를 이용해 json/xml 형식의 데이터를 업로드/다운로드 하는 경우 모델 개체가 Codable 을 준수해야 합니다.
- 다운로드한 데이터를 기기에 저장하기 위해서도 Codable 은 준주해야 합니다. NSKeyedArchiver/Unarchiver 와 FileManager 를 이용해 기기에 모델 개체들을 저장하고 복원할 수 있습니다.


## ObjectMapper/SwiftyJson
- ObjectMapper: 다운로드한 json 데이터를 모델 객체로 변환해주는 라이브러리 입니다. 맵핑될 데이터 구조를 nested 하게 구현해줘야 하는 번거로움은 있습니다.
- SwiftyJson: json 데이터를 한 번에 dictionary 로 변환해 줍니다.
- Mantle: Objective-C 에서의 ObjectMapper 같은 라이브러리 입니다.


## NSManagedObject(use CoreData)
- 다운 받은 데이터가 이미지 등 용량이 큰 데이터라면 CoreData 를 이용해 기기에 저장할 수 있습니다.
- 모델 개체 그대로 저장하고 복원해서 사용할 수 있는 장점이 있으나 boilerplate 가 많고, 제대로 사용하기 어렵다는 단점이 있죠.
- CoreStore, SugarRecorde 등 CoreData 를 조금 더 사용하기 쉽게 해주는 라이브러리도 있습니다.





* * *
* * *
What are the options for laying out UI on iOS?
===================================================

## 인터페이스를 배치하는 방법(AutoLayout vs Frame based Layout)
- 인터페이스를 배치하는 방법은 크게 3가지가 있습니다.
    - 코드로 인터페이스를 구성하는 방법
    - 코드로 인터페이스 구성 후 autoresizing mask 를 이용해 외부의 변경으로 부터 일정부분 응답을 자동화하는 방법
    - autolayout 를 이용하는 방법

## CGRect/Frame
<img src="https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/AutolayoutPG/Art/layout_views_2x.png" alt="frame based layout" width="350px"> <br />

- 화면이 원 사이즈였을때는 기본적으로 view 의 frame(super 에서의 self 의 좌표값), bounds(self 내부의 좌표값) 를 조작하여 화면 구성을 했습니다. 하지만 점점 화면 사이즈가 세분화되면서 모든 화면을 대응하기 위해 CGRect 를 이용하는 것은 비효율적이 됐습니다. 그래도 view 의 위치 이동 및 사이즈 변경 애니메이션의 경우 요긴하게 사용될 수 있습니다.
- 서로 영향을 끼치는 view 간 위치 또는 사이즈의 변화가 발생하면 코드로 각 view 들의 위치, 사이즈를 다시 계산해서 반영해야 하므로 비효율적입니다.

## Autolayout
<img src="https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/AutolayoutPG/Art/layout_constraints_2x.png" alt="autolayout" width="350px"> <br />
- iOS6 이후 발표된 Autolayout 은 각 view 에 적용된 constraint 를 기준으로 동적인 좌표 및 사이즈 계산이 이루어지는 시스템입니다. (실제로 많이 사용하게 된 시기는 iPhone6+ 가 발표된 2014년 이후 입니다.)
- 서로 영향을 끼치는 view 간 위치 또는 사이즈의 변화가 발생하면 constraint 를 기준으로 모두 자동으로 좌표 및 사이즈가 변경됩니다.
- interface builder 로 쉽게 적용할 수 있으나 협업시 문제가 발생할 수 있습니다.(xib 파일 내부는 xml 구조로 되어 있기 때문에 하나의 파일에 여러개의 화면이 존재하여 각 화면 개발자가 동시에 해당 파일 수정시 svn, git 등 형상관리 툴에서 쉽게 충돌이 발생합니다.)


## SnapKit/ComponentKit
- interface builder 로의 화면 구성은 협업시 문제가 발생하고, 코드로 autolayout 을 적용하자니 코드가 너무 길어지니 SnapKit 같은 autolayout 을 쉽게 적용하기 위한 일종의 DSL(Domain Specific Language) 이 라이브러리로 배포되어 사용됩니다. 가독성도 뛰어나고 코드도 상당히 적으며 깔끔합니다.

[interface build, code 로 적용한 autolayout, snapkit 적용 비교 링크](https://m.blog.naver.com/PostView.nhn?blogId=tmondev&logNo=220690677856&proxyReferer=https%3A%2F%2Fwww.google.co.kr%2F)




* * *
* * *

How would you optimize scrolling performance of dynamically sized table or collection views?
============================================================================================

인터뷰시 중요한 질문 중 하나는 바로 테이블 뷰 스크롤 퍼포먼스에 대한 질문입니다.

테이블 뷰에서의 자주 겪는 큰 이슈는 스크롤링 퍼포먼스에 대한 것이고 제대로 대응하기가 어렵습니다. 가장 큰 문제는 cell 의 높이를 계산하는 것입니다. 사용자가 스크롤 할때마다 다음 이 화면에 제대로 표시될 수 있도록 cell 의 높이를 계산해줘야 합니다. frame 기반으로 계산하면 퍼포먼스가 좋지만 정확하게 계산해야 한다는 단점이 있습니다. autolayout 을 사용한다면 각 constraint 에 맞춰 잘 보여지겠지만 autolayout 이 높이를 계산하는게 앞에서처럼 직접 계산하는 것보다 더 많은 시간이 소요되고 스크롤링 퍼포먼스를 떨어뜨리게 됩니다.

그렇기 때문에 frame 기반으로 직접 계산하는 것이 퍼포먼스를 위해서 좋습니다. 그리고 prototype cell 을 보관하고 있다가 cell 의 높이를 계산할 때 사용합니다. 그 외에 좀 색다르게 접근해 볼 수도 있는데 ASDK(Texture) 와 같은 오픈 소스 라이브러리를 사용하는 것입니다. ASDK 는 background thread 에서 cell 의 높이를 계산하도록 최적화되어 뛰어난 성능을 발휘합니다.


## views
- paque 활성화: transparency 로 인해 불필요한 영역이 draw 되는 것을 방지합니다.( UIColor.clear, gradient 등 배제 )
- clipsToBounds 활성화: 자신의 영역을 벗어나는 부분은 draw 하지 않도록 합니다.
- 불필요한 CALayer 사용 자제: shadow 등의 효과를 주면 연산에 많은 시간이 걸리므로 지양하는 것이 좋습니다.

> 가급적 rendering 에 많은 자원이 소비되지 않도록 하는 것이 좋습니다.


## image
- background 로 이미지 로딩 후 cache 하여 사용합니다.


## scrollView, collectionView
- prefetch delegate 사용: 보여지고 있지 않은 cell 에 대해서 전처리 작업을 진행합니다.
- cell size 계산: cell layout 잡을 때 사용하는 padding, inset 값 등 기본 적용되는 값들을 보관하고 있다가 size 계산시 참고하고, 이미지/문자열 사이즈를 계산해서 size 계산을 합니다.


## Cell 의 content 구조가 복잡한 경우
- autolayout 으로 구조를 잡았는데 performance 가 떨어지는 경우 content 를 구성하는 개체의 layoutSubviews() 메서드를 override 하여 내부적으로 직접 좌표를 잡아주는 것이 성능을 개선할 가능성이 있습니다.
- 혹은 반대의 경우도 있을 수 있으므로 시간을 들여 테스트 해가면서 최상의 performance 를 구현해야 합니다.
- 아니면 dummy cell 을 하나 두고 content 를 설정한 후 sizeToFit() 메서드를 호출하여 자체적으로 크기를 계산하게 한 후 그 값을 cell size 로 사용하는 방법도 있습니다.
- 위의 방법들로도 해결되지 않을만큼 cell content 가 복잡하고 이미지가 크다면 해당 content 들을 슬라이스하여 작은 cell 단위로 만들어 표시하는 것도 하나의 방법입니다. content 의 구조도 슬라이스가 가능해야 하며 특히나 디자이너의 도움이 필요한 방법입니다.

> cell 의 layout 이 간단하면 tableView.rowHeight 에 UITableViewAutomaticDimension 를 설정하고, tableView.estimatedRowHeight 프로퍼티를 사용해서 기본값을 설정하면 됩니다. 그리고 collectionView 의 layout 을 지정하는 UICollectionViewFlowLayout 객체의 itemSize 에 UICollectionViewFlowLayoutAutomaticSize 를 설정하고, estimatedItemSize 프로퍼티를 사용해서 기본 값을 설정해 사용해도 됩니다. delegate method 로도 있으니 취향에 따라 사용하시면 됩니다. ( cell.contentView 를 기준으로 constraint 를 잡아줘야 동작합니다.)





* * *
* * *
How would you execute asynchronous tasks on iOS?
====================================================

## Operation
- DispatchQueue.global 을 객체 지향적으로 wrapping 한 클래스 입니다. 간단하게 block 형식으로 사용할 수도 있으나 주로 subclassing 하여 사용하게 됩니다.
- OperaionQueue 도 기본적으로 GCD 와 같은 FIFO 로 동작하지만 operation 간 의존관계를 형성하여 실행 순서를 지정할 수도 있습니다.
- Operation 을 subclassing 할 때 queuePriority 를 override 하지 않으면 기본 .normal 이 되는데, 동일 Queue 내에서 작업의 우선순위를 높이고 싶다면 .high 또는 .veryHigh 로 override 해야 합니다.
- GCD 와 마찬가지로 OperationQueue.main 은 UI 갱신을 위해 사용 합니다.
- BlockOperation 으로 간단히 작업시 operation 간 우선순위를 조절하고 싶다면 qualityOfService 프로퍼티를 변경하면 됩니다. GCD 에서 background queue 생성시에 사용하는 값을 그대로 사용할 수 있습니다. 하부에서 작동하는게 GCD 이기 때문에 해당 dispatchqueue 의 qos 를 변경한다고 생각하면 되겠습니다.

[NSOperation 사용 예를 잘 설명해 놓은 사이트 링크](http://www.knowstack.com/swift-concurrency-nsoperation-nsoperationqueue/)
[NSOperation 을 사용해서 이미지 로드하는 예제 링크](https://www.raywenderlich.com/76341/use-nsoperation-nsoperationqueue-swift)
[NSOperation 관련 글 번역해 놓은 블로그 링크](http://theeye.pe.kr/archives/2470)


## GCD
- 추가적인 구현이 필요없기 때문에 Operation 보다 자주 사용됩니다.
- DispatchQueue.main 은 주로 UI 갱신용으로 사용되는 queue 입니다. 그외에 

[GCD 사용 예를 잘 설명해 놓은 사이트 링크](http://www.knowstack.com/swift-3-1-concurrency-operation-queue-grand-central-dispatch/)
[RWDevCon 2017 iOS Concurrency Tutorial Youtube 링크](https://youtu.be/uxOrFvz0RXw)
[Thread Sanitizer 에 대한 애플 문서 링크]https://developer.apple.com/documentation/code_diagnostics/thread_sanitizer


## RxSwift/ReactiveCocoa




* * *
* * *
How do you manage dependencies?
===================================

모든 iOS 프로젝트들은 dependency 관리가 중요합니다. 이 질문은 dependency 문제를 어느정도까지 인지하고 있으며 어떻게 해결하는지를 측정하기 위한 질문입니다.

## CocoaPods/Carthage/SPM
third party library 를 사용하기 위해 단순하게 소스를 프로젝트로 복사만 한다면 swift 버전이 변경될 때마다 해당 버전으로 update 된 소스를 찾아서 다시 복사해야하는 불편함과 빠르게 대응할 수 없는 불안함을 간직한 상태로 지내야 합니다. 대부분의 인기있는 오픈 소스들은 swift 버전이 올라가면 빠르게 대응을 해주기 때문에 버전관리 툴을 사용하면 가능한 빠른 시간 안에 해당 소스를 업데이트 받을 수 있습니다. 그리고 오픈소스가 다른 오픈소스에 디펜던시가 있는 경우 해당 오픈소스도 함께 받아지므로 더욱 편리합니다. 또 라이센스 정보도 모두 받아지기 때문에 일일이 작성하지 않아도 됩니다.

### CocoaPods
CocoaPods 는 배포된 버전 별로 check out 해서 사용하며, 기존 프로젝트에 자동으로 말려들어가게 됩니다. 

### Carthage
누군가 프로젝트 파일을 수정하는게 마음에 들지 않는다면 단순하게 소스를 받아서 빌드만 할 수 있게 해주는 Carthage(swift 로 만들어진 tool) 를 사용할 수 있습니다. 프로젝트에 자동으로 삽입되지 않기 때문에 각 소스들에 혹시 문제가 있더라도 프로젝트는 정상적으로 빌드가 됩니다. 

> CocoaPods, Carthage 두 가지 툴에 모두 배포되는 오픈 소스들도 있고, 각 툴에서만 배포되는 소스도 있기 때문에 사용하고자 하는 소스에 맞춰 골라 사용하면 됩니다. 

### Swift Package Manager
swift 3.0 과 함께 애플은 SPM(Swift Package Manger) 라는 배포 툴을 발표했습니다. swift 코드를 관리하고 배포할 수 있는 툴입니다. 코드를 배포하는 입장이라면 공부해볼 필요가 있을 것 같습니다.

> 애플은 스스로도 앞으로 swift 가 해결해야할 일중 하나로 SBI(Swift Binary Interface) 안정성을 꼽고 있습니다. swift 4.0 으로 업데이트할 때 너무 많은 interface 가 변했기 때문에 당시 마이그레이션하는데 상당히 고생했다고...





* * *
* * *
How do you debug and profile things on iOS?
===============================================

누구도 완벽한 코드를 작성할 수는 없습니다. 개발자들은 때때로 성능향상 또는 메모리 누수를 해결하기 위해 debug 를 수행합니다.

가장 흔하게 사용되는 디버깅 방법은 print 와 breakpoint 입니다. breakpoint 를 설정하면 해당 코드의 상황을 분석할 수 있습니다. 
또 코드의 결점을 미리 파악해서 수정할 수 있도록 도와주는 XCTest 를 사용할 수도 있고, 조금 더 깊게 들어가면 Instruments 를 사용할 수도 있습니다.

## print
변수 및 객체의 description 을 출력하여 디버그 하는 가장 보편적인 방법입니다.

## breakpoint
문제가 될것으로 예상되는 코드 블럭에 breakpoint 를 설정하여 런타임시 무슨 일이 벌어지는지 확인해볼 수 있습니다.
- Condition, Action, Debugger Command, Log Message, Shell Command, Ignore N Times Before Stopping, Generic BreakPoints 등 꽤 디테일한 방법으로 debugging 해볼 수 있습니다.
[관련 링크](https://marcosantadev.com/xcode-advanced-breakpoint-usages/)

## assert
debug 모드로 빌드시 코드가 정상 동작해야 하는 상황이 아니라면 애플리케이션을 종료시킴으로써 문제가 발생함을 확인할 수 있습니다.

## precondition
기본 기능은 assert 와 동일하나 debug/release 모드 모드에서 애플리케이션을 종료시킵니다.

## Instruments
- Activity Monitor: CPU, memory, disk, network 사용량 통계를 확인할 수 있습니다. CPU 를 고르게 사용하고 있는지 메모리 사용량은 적절한지 등을 분석할 수 있습니다.

- Time Profiler: 코드의 실행 시간을 분석해줍니다.

- Allocation: 가상 메모리 및 heap 의 프로세스를 추적하여 클래스의 이름을 제공하고 선택적으로 오브젝트에 대한 retain/release 기록을 제공합니다.

- Leaks: 일반적인 메모리 사용량을 측정하고, 누수된 메모리를 확인하며, 클래스별 메모리 할당에 대한 통계와 모든 살아있는 메모리 및 누수된 블록에 대한 메모리 주소 이력을 제공합니다.

일반적으로 위의 4가지 정도가 가장 많이 사용되며, UI performance 확인을 위해 Core Animation 템플릿을 사용하기도 합니다.
그러나 Xcode 에서도 꽤나 잘 분석을 해주므로 어느정도는 해결이 가능합니다. Activity Monitor, Leaks 같은 경우는 Instruments 못지 않게 정보를 제공해 줍니다.

[Standford 영상 링크](https://youtu.be/m_0buWQRqSY)

## Thread Sanitizer
- runtime 시 특정 메모리에 대한 data races 가 발생하는지, thread 누수가 있는지 확인할 수 있습니다.




* * *
* * *
Do you have TDD experience? How do you unit and UI test on iOS?
===============================================================

TDD 는 production 코드를 작성하기 전에 실패하는 case 코드를 먼저 작성하는 기술입니다. 테스트 주도 구현 및 설계는 production 코드를 더도 말고 덜도 말고, 딱 해당 case 를 통과할 수 있는만큼만 구현할 수 있도록 도와줍니다.
적응하는데 시간이 걸리고, 가시적인 결과가 바로 나타나지도 않지만 계속 하다보면 점차 빠르게 개발할 수 있도록 도와줍니다.
TDD 는 코드의 변경이나 리팩토링이 발생했을 때 특히나 진가를 발휘합니다. 왜냐하면 그동안 진행한 테스트 코드들을 통해 변경되지 않는 코드들은 정상적으로 동작한다는 확신을 얻을 수 있기 때문입니다.

XCTest/Quick/Nimble


## XCTest
실패하는 테스트 케이스 작성 -> 통과하도록 구현 -> 성능 향상을 위한 리팩토링, 이 과정을 Red-Green-Refactor cycle 이라고 부릅니다. 각 테스트 케이스마다 공통으로 사용할 만한 것들은 setUp 메서드에서 생성해 놓습니다. 테스트 클래스의 멤버변수 같은 것들 말이죠. 그리고 테스트 종료시 생성된 객체들을 해제하는 등의 작업을 tearDown 메서드에서 수행합니다.

- Unit Test
    - 테스트 케이스 내부에서 loop 를 돌면서 테스트하는 것은 지양해야 합니다. 어떤 index 에서 fail 이 발생하는지 한 번에 알아보기 힘들기 때문입니다. 
    - 코드의 어느 부분에서 문제가되는지 확인하기 어려운 경우에는 "Test Failure Breakpoint" 를 추가하여 실패하는 케이스의 변수/데이터 값들을 분석할 수 있습니다.

- UI Test
    - 먼저 XCUIApplication 객체를 생성합니다. 이 녀석은 테스트할 애플리케이션이라고 생각하면 됩니다.
    - 애플리케이션 객체에는 대표적인 UI Component 들에 접근할 수 있는 프로퍼티, 메서드에 접근하여 테스트를 진행할 수 있습니다.
    - 테스트 케이스를 잘 작성하면 자동화가 가능합니다.
``` swift
// 애플리케이션 받아오기
let app = XCUIApplication()
// collectionView 에 접근하기
let collectionView = app.collectionViews.firstMatch
// collectionView 의 cell 갯수 확인
XCAssertEqual(collectionView.cell.count, 10)
// collectionView 의 5 번째 cell 잡고 swipe up 하기
collectionView.cells.element(boundBy: 5).swipeUp()
```

그러나 iOS UI 개발에 있어서 세세한 테스트 케이스의 작성은 현실적으로 힘든 점이 있습니다. model 이나 business logic 의 경우라면 Unit 테스트 케이스를 작성할만 하지만 일반적인 UI 에 맞춰 케이스를 작성한다는건 꽤나 지루하고 고통스러운 작업이겠죠...

[RWDevcon UI Testing 및 Accessibility 를 자세히 설명하는 영상 링크(목소리와 발음으로 추측컨데.... WWDC 2017 Building Visually Rich User Experiences 에서 강연한 여자인 듯 함)](https://youtu.be/NrHSZgbQ7_k)

## Quick/Nimble
CXTest 를 기반으로 만들어진 테스트 환경을 제공합니다. 테스트를 위해 새로운 클래스를 만들때 QuickSpec 을 상속받아야 하는 번거로움이 있지만 테스트 케이스가 직관적이며 함수형으로 작성할 수 있습니다.



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

그러나 iOS UI 개발에 있어서 세세한 테스트 케이스의 작성은 현실적으로 힘든 점이 있습니다. model 이나 business logic 의 경우라면 Unit 테스트 케이스를 작성할만 하지만 일반적인 UI 에 맞춰 케이스를 작성한다는건 꽤나 지루하고 고통스러운 작업이겠죠...

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
- ibooks: how arc works
    : unsafe, Manual Memory Management 에서 찾아보면 알 수 있다.

- autoreleasePool
    : auto release pool 은 여전히 swift 에 존재한다.
    : swift 에서 loop 돌면서 objc 객체를 생성하면 해당 loop 영역이 종료되는 시점에도 메모리 해제가 되지 않는다. 그럴때는 loop 블럭 내부에 autoreleasepool 을 생성해 줘야 깔끔하게 해제된다.




* * *
# 기본 타입들
- class, struct(Int, Float, Double, Bool, String, Character, Array, Dictionary, Set ..), enum, tuple, optional




* * *
# Design Pattern
## Creational Pattern(생성 패턴)
- Abstract Factory, Builder, Factory Method, Prototype, Singleton

### Singleton
- 클래스에 대해 단 하나의 인스턴스만을 제공합니다.
- 물리적 혹은 개념적으로 유니크하게 매핑되는 경우 싱글톤으로 만드는게 좋습니다.
- 스태틱 펑션만 존재하는 클래스(유틸리티 펑션의 모음 클래스) 과 싱글턴의 차이?
    : 상태 보관이 필요하면 싱글톤, 아니면 유틸리티 클래스
    : 유틸리티 클래스. 함수 호출시 사이드 이펙트가 없다면 어느정도의 디펜던시를 감수하더라도 사용할 만하다.

### Factory Method
- 일련의 클래스들 중 하나에서 객체를 인스턴스화하는 기능을 제공합니다.
- 공통의 수퍼 클래스나, 프로토콜을 준수하는 일련의 클래스들 중 runtime 시 필요로 하는 클래스를 사용할 수 있도록 도와줍니다.

### Builder
- 인스턴스 생성시 필요한 복잡한 작업들을 간소화하도록 도와줍니다.
- 인스턴스에 다양한 프로퍼티가 존재할 때 특정 프러퍼티들을 설정하므로써 특성이 다른 인스턴스를 쉽게 생성해낼 수 있습니다.


## Structural Pattern(구조 패턴)
- Adaptor, Bridge, Composite, Decorator, Facade, Flyweight, Proxy

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
- swift 에서는 Collection protocol 을 준수하여 쉽게 구현할 수 있습니다.

### Memento
- 객체를 이전 상태로 복원할 수 있는 기능을 제공해줍니다.
- 객체의 원본 상태 그대로를 가지는 originator 를 가지고, 외부로 스냅샷을 제공하는 클래스(memento)를 추가합니다. caretaker 를 통해 이전상태를 복원할 수 있습니다.

### Observer
- 어떤 객체의 상태가 바뀌면 관련된 모든 객체들이 자동으로 갱신되도록 객체들간의 링크를 정의합니다.
- swift 에서 일대다 옵저버는 notification, kvo, 일대일 옵저버는 delegate 가 있습니다.

### Strategy
- 객체들에 서로 다른 알고리즘이 적용되어야 할 때 사용합니다.
- 알고리즘의 집합을 정의하고 이들을 필요에 따라 교체할 수 있도록 구현합니다.
- 클라이언트와 알고리즘을 서로 독집적으로 만듭니다.

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

### CALayer vs UIView
UIView 는 layout 이나 touch 이벤트 처리와 같은 많은 작업을 처리하지만 drawing 이나 animation 을 직접 처리하지는 못합니다. 그러한 작업들은 CoreAnimation 에게 위임합니다. UIView 는 사실 CALayer 의 Wrapper 라 말할 수 있습니다. UIView 의 bounds 를 설정하면, 해당 view 는 자신의 layer.bounds 를 설정합니다. 만약 UIView 의 layoutIfNeeded 를 호출한다면, 호출은 root layer 로 전달됩니다. UIView 는 내부에 root CALayer 를 가지고 하위 layer 들을 포함할 수 있습니다.

아래 링크 참고
[link](https://www.raywenderlich.com/169004/calayer-tutorial-ios-getting-started)





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



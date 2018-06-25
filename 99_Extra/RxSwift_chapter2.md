# Chapter 2: Observable

### What is an observable?
- Observable, Observable Sequence, Sequence 등의 단어가 Rx 에서 동일한 뜻으로 사용되는 것을 볼 수 있습니다. 실제로 모두 같은 뜻이며, 종종 다른 언어 개발자가 "Stream" 이라고 표현하지만(같은 의미이긴 합니다.) RxSwift 에서는 Sequence 라고 합니다. 

- Observable 은 특별한 능력이 있는 시퀀스입니다. 그중 가장 중요한 것은 비동기적이라는 것입니다. Observable 은 일정 시간동안 방출하는 이벤트를 참조하는 프로세스라고 할 수 있습니다. 이벤트는 number 또는 커스텀 타입의 인스턴스를 값으로 담고 있거나 tap 과 같이 인식된 gesture 를 담고 있을 수 있습니다.

- 이것을 가장 잘 이해할 수 있는 방법중 하나는 marble 다이어그램을 이용하는 것입니다.

<img src="rx_img/marble_diagram_0.png" width="400px"><br>

- 왼쪽에서 오른쪽으로 표시된 화살표는 시간을 나타냅니다. 그리고 숫자는 시퀀스의 요소를 나타냅니다. 1번 부터 순차적으로 방출된 것을 표현한 것이지만 어느정도의 시간이 흘렀는지는 알 수 없습니다. Observable 의 생명주기 어느 시점에서나 방출할 수 있기때문이죠.


### Lifecycle of Observable
- Observable 이 요소를 방출시키면 next 이벤트로 동일한 요소가 방출됩니다.

- 아래의 marble 다이어그램은 위의 다이어그램과 다르게 오른쪽 끝에 관찰이 끝남을 표시하는 세로바가 있습니다.

<img src="rx_img/marble_diagram_1.png" width="400px"><br>

- 위의 observable 은 3 번의 tap 이벤트를 방출시킨 후 종료됩니다. 종료되었으므로 이것을 completed 이벤트라고 부릅니다. 위의 다이어그램은 예를 들자면, tap 한 view 가 dismiss 되었을 수도 있습니다. 중요한 것은 observable 이 종료되었고, 더이상 이벤트를 방출시키지 않는다는 점입니다. 이 경우는 일반적인 종료상황이라고 할 수 있습니다. 반대로 아래의 다이어그램과 같이 뭔가 잘못되는 경우도 있을 수 있습니다.

<img src="rx_img/marble_diagram_2.png" width="400px"><br>

- 위의 다이어그램은 에러가 방출한 경우입니다. 붉은색 x 표시로 에러가 방출했음을 알 수 있죠. observable 은 에러를 담고있는 error 이벤트를 방출시킵니다. 정상적으로 종료된 complete 이벤트와는 다릅니다. error 이벤트를 방출시킨 경우에도 observable 은 종료되고 더이상 이벤트를 방출시키지 않습니다. (observable 에서 에러 방출시 chaining 으로 연결된 모든 것들이 멈추게 된다. 에러 방출시 처방이 있음 찾아볼 것)


### Quick Recap
- observable 은 요소를 담고있는 next 이벤트를 방출시킵니다. error 이벤트가 방출되어 종료되거나, complete 이벤트가 방출되어 종료될 때까지 지속될 수 있습니다.

- observable 이 종료되면 더이상 이벤트가 방출되지 않습니다.

``` swift
public enum Event<Element> {
	case next(Element)
	case error(Swift.Error)
	case completed
}
```

- 위의 예와같이 RxSwift 에서 Event 는 enumeration 의 case 로 표현됩니다. .next 는 Element 의 인스턴스를 담고있고, .error 는 Swift.Error 를 담고 있지만 completed 는 아무것도 담지 않고 이벤트를 종료시킵니다.

``` swift
let one = 1, two = 2, three = 3
// 단 하나의 요소만 포함하는 observable 을 생성할 때는 Observable 의 type 함수인 just 함수를 사용합니다.
let observable: Observable<Int> = Observable<Int>.just(one)
// Rx 의 함수들은 operators 로 간주됩니다. 위에서는 하나의 요소만 포함하는 operator 였다면 
// 아래는 여러개의 요소를 포함하는 observable 을 생성하는 예입니다.
let observable2 = Observable.of(one, two, three)
```

- 여러개의 Int 를 지정하기 때문에 observable2 는 [Observable<Int>] 라고 생각할 수 있지만 추론된 유형을 확인해보면 Observable<Int> 입니다. playground 파일에서 Option + click 하여 확인해보세요. api 를 확인해보면 Observable.of(_ elements: Int..., scheduler: ImmediateSchedulerType = default) -> Observable<Int> 로 되어 있고, elements 는 갯수가 정해지지 않은 파라미터로 정의되어 있습니다.(variadic parameter) 로 정의되어 있습니다.

- 만약 observable 배열을 생성하고 싶다면 `let observable2 = Observable.of([one, two, three])` 처럼 사용하면 됩니다. 물론 just operator 도 파라미터를 배열로 전달해도 됩니다. 좀 이상하지만 배열 하나만 전달되므로 결국 배열이라는 단 하나의 요소만 포함하는 observable 을 생성하게 됩니다.

- 그 외에 from operator 를 사용해서 observable 을 생성할 수 있습니다. 사용예는 아래와 같습니다.
``` swift
let observable4 = Observable.from([one, two, three])
```

- from operator 는 배열의 요소들로부터 개별 유형의 인스턴스를 생성합니다. from operator 는 파라미터로 배열만 전달받습니다.


### Subscribing to observables
- iOS 개발자라면 NSNotificationCenter 에 익숙할 수도 있을겁니다. observer 에게 RxSwift 의 observable 과는 다른 notification 을 broadcast 합니다. 아래는 키보드 프레임 변경에 대한 notification 을 제어하는 예제입니다.

``` swift
let observer = NotificationCenter.default.addObserver(
	forName: .UIKeyboardDidChangeFrame,
	object: nil,
	queue: nil
) { notification in
    // handle receiving notification
}
```

- RxSwift 의 observable 을 구독하는 것은 addObserver() 대신 subscribe() 를 사용하면 됩니다. 개발자들이 흔히 NotificationCenter.default 싱글턴 인스턴스를 사용하지만 Rx 의 observable 은 각각 다 다른 객체입니다.

- 더 중요한 것은 observable 은 subscriber 를 가지기 전까지 이벤트를 방출시키지 않는다는 점입니다. observable 의 실체는 시퀀스라는 것을 기억하십시오. observable 을 구독하는 것은 swift standard library 의 Iterator 에서 next() 함수를 호출하는 것과 같습니다.

``` swift
let sequence = 0..<3
var iterator = sequence.makeIterator()
while let n = iterator.next() {
	print(n)
	/*
	0, 1, 2
	*/
}
```

- observable 을 구독하는 것은 위의 예제보다 더 간단합니다. observable 이 방출하는 이벤트마다 다른 핸들러를 추가할 수도 있습니다. 

``` swift
let one = 1, two = 2, three = 3
let observable = Observable.of(one, two, three)

// trailing closure 를 사용하여 간단히 구독할 수 있습니다.(모든 이벤트가 출력됩니다.)
observable.subscribe {
	print(event)
}
/*
next(1), next(2), next(3), completed
*/


// event 는 optional 인 element 를 가지고 있어서 값을 추출하여 사용해야 합니다.(element 가 있는 경우에만 출력됩니다.)
observable.subscribe { event in
    if let element = event.element {
        print(element)
    }
}
/*
 1 2 3
 */


// .next 이벤트를 명시적으로 구독하여 내부 element 에 보다 쉽게 접근할 수 있습니다.(다른 이벤트는 무시합니다.)
observable.subscribe(onNext: { element in
   print(element)
)
/*
1 2 3
*/


// 비어있는 observable 도 생성할 수 있습니다. 타입을 추론할 수 없는 경우 특정 타입 유형으로 정의해줘야 하는데 
// empty 인 경우 Void 가 적절합니다.
// 즉시 종료되는 observable 을 return 하고 싶거나, 비어있는 observable 을 의도적으로 만들고싶을 때 사용할 수 있습니다.
// 구독하고 싶은 이벤트를 명시적으로 전달해줘야 해당 이벤트를 제어할 수 있습니다.
let observable = Observable<Void>.empty()
observable
.subscribe(
    onNext: { element in
        print(element)
},
    onCompleted: {
        print("completed")
})
/*
 completed
 */


// .never operator 는 empty 와 달리 아무것도 방출시키지 않고, 절대 종료되지도 않는 observable 을 만들 수 있습니다.
// 아래 예제는 아무것도 출력되지 않습니다. 그렇다면 동작하는지는 어떻게 알 수 있을까요? Challenge section 에서 살펴보겠습니다.
let observable = Observable<Any>.never()
observable
.subscribe(
    onNext: { element in
        print(element)
},
    onCompleted: {
        print("completed")
})

```

- 지금까지는 명시적으로 변수에 담아둔 observable 로 작업했지만 다양한 범위의 값에서 observable 을 생성할 수도 있습니다.

``` swift
// .range operator 로 start 값 부터 count 개의 요소를 가지는 순차적인 observable 을 생성합니다.
let observable = Observable<Int>.range(start: 1, count: 10)
observable
.subscribe( onNext: { i in
	// n 번째까지의 피보나치 수열을 출력합니다.
	let n = Double(i)
	let fibonacci = Int(((pow(1.61803, n) - pow(0.61803, n)) / 2.23606).rounded())
	print(fibonacci)
})
```

- 피보나치 수열을 구하는 코드를 구하는 더 좋은 방법이 있으나 그건 chapter 7 "Transforming Operators" 에서 배우도록 하겠습니다.



### Disposing and terminating
- observable 은 구독되기 전까지 아무것도 하지 않는다는 것을 기억하세요. 구독하는 행위가 트리거가 되어 .error, .completed 이벤트가 방출되어 종료되기 전까지 이벤트를 방출시킵니다. 구독을 취소하여 observable 을 종료시킬 수도 있습니다.

``` swift
let observable = Observable.of("A", "B", "C")
// observable 을 구독하면 Disposable 이 반환되어 subscription 변수에 저장됩니다.
let subscription = observable.subscribe { event in print(event) }
```

- 명시적으로 구독을 종료하려면 `subscription.dispose()` dispose() 를 호출하면 observable 은 이벤트 방출을 멈춥니다.

- subscription 을 관리하는 것이 지루하다면 DisposeBag 타입을 사용하면 됩니다. dispose bag 은 disposables(.disposed(by:) 를 사용하여 추가된) 을 보관합니다. 그리고 dispose bag 이 메모리에서 해제될 때, 각 disposable 의 dispose() 를 호출합니다. 

``` swift
// dispose bag 생성
let disposeBag = DisposeBag()
// observable 생성 후 구독(이벤트 방출시 element 출력) 및 반환된 disposable 의
// dispose(by:) 를 사용하여 disposeBag 에 보관시킵니다.
Observable.of("A", "B", "C")
.subscribe {
	print($0)
}
.dispose(by: disposeBag)
```

- 위와 같은 패턴을 가장 많이 사용하게 될텐데, observable 생성 및 구독 후 즉시 dispose bag 에 담는 행위는 직접 수동으로 disposable 을 관리하여 메모리 누수가 방출하는 것을 방지해주기 때문이죠.(혹시 수동으로 관리하더라도 구독후 반환되는 disposable 을 사용하지 않았다면 컴파일러가 경고를 띄우기 때문에 걱정하지 않아도 되긴 합니다.)

- 이전 예제들에서 .next 이벤트의 요소를 이용해 observable 을 생성했지만, 모든 이벤트를 subscribers 에게 전달하는 또 다른 방법으로 create operator 가 있습니다.

- create operator 는 subscribe 라는 하나의 파라미터만 전달받습니다. subscribe 의 역할은 observable 에 대한 구독 요청에 대한 구현을 제공하는 것입니다. 즉, subscriber 에게 방출될 모든 이벤트를 정의합니다. subscribe 파라미터는 AnyObserver 를 전달받고 Disposable 을 반환하는 escaping closure 입니다. AnyObserver 는 observable 시퀀스에 값 추가를 수월하게 하는 제네릭 타입이며 이는 subscriber 에게 방출됩니다.

``` swift
Observable<String>.create{ observer in
  // observer 에 편의 메서드인 onNext() 를 사용해 .next 이벤트를 추가합니다. 
  // (on(.next(_:)) 의 편의 메서드가 onNext() 입니다.
  observer.onNext("1")
  // 역시 편의 메서드인 onCompleted() 를 사용해 .completed 이벤트를 추가합니다.
  observer.onCompleted()
  // 다른 .next 이벤트를 추가합니다.
  observer.onNext("?")
  // disposable 을 반환합니다.
  return Disposables.create()
}
.subscribe(
  onNext: { print($0) },
  onError: { print($0) },
  onCompleted: { print("Completed") },
  onDisposed: { print("Disposed") }
)
.disposed(by: disposeBag)
/*
 1, Completed, Disposed
 */
```

- 위의 예제에서 "?" 가 출력되지 않은 이유는 create operator 의 subscribe 파라미터로 전달된 closure 의 구현내용을 확인하면 알 수 있습니다. .next 호출 후 .completed, .disposed 가 호출되어 완료 처리가 되었기 때문에 이후 방출된 이벤트는 동작하지 않는 것이죠.

- 위의 예제에 오류를 추가해보겠습니다.

``` swift
enum MyError: Error {
	case anError
}

Observable<String>.create{ observer in
  observer.onError(MyError.anError)
}
/*
 anError
 Disposed
 */
```

- .complete, .error 이벤트가 방출되지 않거나, disposeBag 에 담지 않는다면 어떻게 될까요? 위의 예제에서 onError, onCompleted, disposed(by:) 부분을 주석처리 한다면? 넵 메모리 누수 당첨입니다! 이렇게 되면 해당 observable 은 dispose 되지 않기때문에 절대로 종료되지 않습니다.


### Creating observable factories
- observable 을 생성하고 subscriber 를 기다는 것 대신 observable factories 를 생성하고 각 subscriber 에게 새로운 observable 을 제공하는 것이 가능합니다.

``` swift
let disposeBag = DisposeBag()
var flip = false
let factory: Observable<Int> = Observable.deferred {
	flip = !flip
	if flip {
		return Observable.of(1, 2, 3)
	} else {
		return Observable.of(4, 5, 6)
	}
}

for _ in 0...3 {
	factory.subscribe(onNext: {
		print($0, terminator: "")
	})
	.disposed(by: disposeBag)
	print()
}
/*
 123, 456, 123, 456
 */
```

- 위의 예제에서 factory 는 외관상 일반 observable 과 구별되지 않습니다. loop 안에서 factory 를 subscribe 할 때마다 flip 값이 변하므로 서로 다른 observable 이 반환되어 출력됩니다.


### Using Traits
- traits(특성) 는 일반 observable 보다 행동의 범위가 좁은 observable 입니다. 선택적으로 사용하면 됩니다. traits 의 목적은 우리가 만든 코드나 API 의도를 사용자로하여금 더 명확하게 전달하는 것입니다. traits 가 적용된 컨텍스트는 코드를 더욱 직관적으로 만들어줍니다. 

- RxSwift traits 에는 Single, Maybe, Completable 이렇게 3가지가 있습니다.
    - Single: .success(value) 또는 .error 이벤트를 방출시킵니다. .success(value) 는 사실 .next 와 .completed 의 조합입니다. 이건 데이터를 다운로딩하거나 디스크에서 읽어들일 때와 같이 성공 후 값을 산출하거나 실패하는 등 일회성 프로세스에 유용합니다. 
    - Completable: .completed, .error 이벤트 둘 중 한가지만 방출시킵니다. 아무런 값도 방출하지 않습니다. 파일 쓰기같은 성공, 실패만 확인해야하는 작업에 사용할 수 있습니다.
    - Maybe: Single 과 Completable 을 섞어 놓은 것입니다. .success(value), .completed, .error 중 하나의 이벤트를 방출시킵니다. 성공하거나 실패할 수 있고, 성공할 경우 선택적으로 값을 반환해야한다면 Maybe 를 사용할 수 있습니다.

``` swift
let disposeBag = DisposeBag()

enum FileReadError: Error {
	case fileNotFound, unreadable, encodingFailed
}

func loadText(from name: String) -> Single<String> {
	return Single.create { single in
		// create 메서드의 subscribe closure 는 disposable 을 반환해야 하므로
		// 반환할 disposable 을 생성합니다.
		let disposable = Disposables.create()

		// 파일이 존재하는 path 에 대한 값을 받아오거나 single 에 파일 경로를 찾지 못했다는 error 를 담고 
		// disposable 을 반환합니다.
		guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
			single(.error(FileReadError.fileNotFound))
			return disposable
		}

		// 파일로부터 data 를 받아오거나 single 에 파일을 읽어들일 수 없다는 error 를 담고 disposable 을 반환합니다.
		guard let data = FileManager.default.contents(atPath: path) else {
			single(.error(FileReadError.unreadable))
			return disposable
		}

		// data 를 string 으로 converting 하여 contents 에 담거나 single 에 encoding 에러를 담고 
		// disposable 을 반환합니다.
		guard let contents = String(data: data, encoding: .utf8) else {
			single(.error(FileError.encodingFailed))
			return disposable
		}

		// 위에서 contents 에 string 이 담겼다면 single 에 contents 를 포함하는 success 를 담고 
		// disposable 을 반환합니다.
		single(.success(contents))
		return disposable
	}
}

loadText(from: "Copyright")
.subscribe {
	switch $0 {
		case .success(let string):
		  print(string)
		case .error(let error):
		  print(error)
	}
}
.disposed(by: disposeBag)
```


### Challenges
1. Perform side effects
    - never operator 예제에서는 아무것도 출력되지 않았습니다. 그건 subscription 을 dispose bags 에 추가하기 전이었기 때문입니다. 하지만 만약 dispose bags 에 추가했다면, subscriber's 의 onDispose 핸들러에서 메세지가 출력되는 걸 확인할 수 있었을 것입니다. 작업중 observable 에 영향을 끼치지 않고 side work 를 수행하고자 할때 유용한 operator 가 또 있습니다. 
    
    - do operator 는 side effects 를 삽입할 때 사용할 수 있습니다. 즉, 어떤식으로든 방출된 이벤트에 변경을 발생시키지 않고 일을 처리하는 핸들러라는 말입니다. do 는 그냥 chain 의 다음 operator 로 그냥 이벤트를 전달시킵니다. do 는 실제로 subscribe 를 하는 것은 아니지만 onSubscribe 핸들러도 포함합니다.
    
    - do operator 의 정의는 다음과 같습니다. `do(onNext:onError:onCompleted:onSubscribe:onDispose)` 핸들러를 모두 제공하거나 일부만 제공해도 됩니다. 

2. Print debug info
- debug operator 는 observable 의 모든 이벤트에 대한 정보를 출력할 수 있습니다. 몇 가지 선택적인 파라미터가 있는데 그중 아마도 코드 라인별 특정 문자열을 출력할 수 있는 파라미터가 가장 유용할 것입니다. debug 가 여러 위치에 추가되어 호출되는 복잡한 Rx chain 에서 해당 파라미터는 출력된 각각의 문자열을 구분짓는데 도움이 될 수 있습니다.








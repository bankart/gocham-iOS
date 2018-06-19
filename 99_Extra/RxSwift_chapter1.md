RxSwift
=======

# Chapter 1: Hello RxSwift!

[ RxSwift 를 가장 잘 설명하는 문장 ]
- RxSwift 는 관측 가능한 시퀀스 및 기능 스타일 연산자를 사용하여 비동기 및 이벤트 기반 코드를 구성하는 라이브러리로, 스케줄러를 통한 매개 변수화된 실행을 허용합니다.

- 기본적으로 RxSwift 는 코드를 새로운 데이터에 반응시키고 순차적으로 분리하여 처리함으로써 비동기식 프로그램 개발을 단순화합니다.


## RxSwift 의 비동기식 프로그래밍을 이해하기 위한 문구 설명
- 상태(특히 변경 가능한 상태의 공유)
    : 여러 비동기적인 컴포넌트들 간에 발생하는 상태의 공유는 여러가지 문제를 일으킵니다.

- 명령형 프로그래밍
    : 명령문을 사용하여 프로그램의 상태를 변경하는 프로그래밍 패러다임으로, 애플리케이션이 '언제', '어떻게' 해야하는지 명령어로 정확하게 알려줍니다. 위에서 언급한 상태가 공유되는 경우라면 코드 작성이 매우 복잡해질 수 있습니다.
``` swift
// 명령형 프로그래밍의 문제는 아래와 같이 구현된 경우, 각 함수들이 어떤 일을 하는지에, 
// 의도한 순서대로 정확하게 호출되었는지도 알 수 없다는 것입니다. 
// 누군가 무의식적으로 함수 호출 순서를 변경했을 수도 있습니다.
override func viewDidAppear(_ animated: Bool) {
  super.viewDidAppear(animated)
  setupUI()
  connectUIControls()
  createDataSource()
  listenForChanges()
}
```

- Side effects
    : 대부분의 부작용은 위에서 언급한 2가지 경우로부터 파생됩니다. 
    : 코드가 작성된 범위를 벗어난 곳에서의 상태 변경은 부작용을 야기시킵니다. 예를 들어 위의 예제에서 connectUIControls() 함수는 아마 UI 구성요소에 event handler 를 추가하는 등의 동작을 수행할 것입니다. 함수가 view 의 상태를 변경하게 된다면 함수 호출 이전과 이후 앱의 행동이 다른 방식으로 동작하는 부작용이 발생할 수 있습니다.
    : 데이터를 저장하거나, text field 의 문자열을 변경하는 경우도 부작용을 야기시킬 수 있습니다. 결과적으로 부작용을 통제된 방식으로 해결해야 합니다. 어떤 코드가 부작용을 발생시키고, 단순하게 데이터를 처리하고 출력하는지 결정하고 통제하므로써 문제를 해결할 수 있습니다.

- RxSwift 는 다음 두 가지 방법으로 이러한 문제를 해결하려고 합니다.
    - 선언적 코드
        - 명령형 프로그래밍에서 우리는 원하는대로 상태를 변경할 수 있고, 함수형 코드에서는 부작용이 발생하지 않습니다. RxSwift 는 명령형/함수형 코드의 최상의 측면을 결합시킨 것입니다.
        - 선언적 코드를 사용하여 동작의 일부를 정의할 수 있고, RxSwift 는 관련된 이벤트가 있을 때마다 이러한 동작을 실행하고 작업할 수 있는 불변의 격리된 데이터 입력을 제공합니다. 즉 변경 불가능한 데이터로 작업하면서 순차적이고 결정론적인 방식으로 코드를 실행할 수 있습니다.

        이벤트가 발생하는 상황의 진입점이 다양한데 Observable 로 wrapping 하여 이벤트의 흐름을 만들어 

    - 반응성 시스템
        - 다소 추상적인 용어로 대부분 아래와 같은 특성을 따릅니다.
        - Responsive: 항상 UI 를 최신으로 업데이트하여 최신 상태를 유지합니다.
        - Resilient: 각 동작들은 개별적으로 정의되고 오류를 유연하게 복원할 수 있습니다.
        - Elastic: 코드는 다양한 작업부하를 처리하며, 종종 lazy full-driven data 수집, 이벤트 조절 및 리소스 공유와 같은 기능을 구현합니다.
        - Message driven: 구성 요소들은 메시지 기반 통신을 사용하여 개선된 재사용 성과 격리 기능을 개선하고, 클래스의 라이프 사이클과 구현을 분리합니다.


## RxSwift 의 기초
- 지난 10년간 웹 애플리케이션은 비동기적인 UI 들의 관리라는 문제에 봉착했고, 서버사이드 언어에서도 반응형 시스템이 필수가 되었습니다. 이런 문제들을 해결하기 위해 노력하던 마이크로소프트는 2009년 .NET 기반 Reactive Extensions 를 발표했습니다. 그 후 2012년 오픈소스로 전환하여 다른 언어 및 플랫폼이 동일한 기능을 재연할 수 있도록 Rx 가 크로스 플랫폼 표준이 되었습니다.
오늘날 RxJS, RxKotlin, Rx.Net, RxScala, RxSwift 등이 동일한 기능을 동일한 API 로 구현하기 위해 노력하고 있습니다. 궁극적인 지향점은 iOS 개발자가 RxSwift 로 애플리케이션을 개발했다면 RxJS 를 사용하는 웹 프로그래머와 편하게 로직에 대해 논의할 수 있게되길 바랍니다.

- RxSwift 는 전통적으로 필수적인 Cocoa 코드와 순수 기능 코드 사이의 적절한 위치를 찾습니다. 수정 불가능한 코드 정의를 사용하여 비동기적으로 입력 부분을 결정적이고 구성 가능한 방식으로 처리함으로써 이벤트에 대응할 수 있습니다.

- Rx 의 심볼은 전기 뱀장어이며, Rx 프로젝트는 'Volta' 라고 불립니다.


### Observable
- Observable<T> 클래스는 Rx 코드의 기반을 제공합니다. 데이터 T 의 변경 불가능한 스냅샷을 '전달'할 수 있는 이벤트의 시퀀스를 비동기적으로 생성할 수 있습니다. 간단히 말해 다른 클래스가 내보내는 값을 시간에 따라 / 지속적으로(overtime: 야근, 초과근무, 잔업) 구독할 수 있습니다.

- ObservableType 프로토콜(Observable 이 준수하는)은 매우 단순합니다. Observable 은 3가지 타입의 이벤트를 내보낼 수 있습니다.(Observer 는 수신할 수 있습니다.)
    - next event: 최신(또는 다음) 데이터 값을 전달하는 이벤트입니다. 이것은 observer 들이 값을 수신하는 방법입니다.
    - completed event: 이벤트 시퀀스가 성공적으로 종료되는 이벤트입니다. 즉 Observable 의 생명 주기가 성공적으로 완료되었으며, 다른 이벤트를 발생시키지 않는다는 것을 의미합니다.
    - error event: Observable 이 에러와 함께 종료되었으며, 다른 이벤트를 발생시키지 않습니다.

- Observable 에서 내보낼 수 있는 3가지 이벤트에 대한 이 단순한 내용이 Rx 의 모든 것입니다. 이는 매우 보편적이기 때문에 가장 복잡한 응용 프로그램의 로직도 만들 수 있습니다.

- 위의 내용은 Observable 또는 Observer 의 성격에 대해 어떠한 가정도 하지 않기 때문에, 이벤트 순서를 사용하는 것이 궁극적인 분리를 위한 관행입니다. 클래스간 커뮤니케이션을 위해 delegate 프로토콜을 사용하거나, closure 를 주입할 필요가 없습니다.

#### Finite observable sequences
- 어떤 obvervable 시퀀스들은 0, 1 또는 더 많은 값을 발생시키며, 마지막 지점에서 성공 또는 에러와 함께 종료됩니다.

- iOS 애플리케이션에서 인터넷을 통해 파일을 다운받는 코드를 살펴보면
   - 우선 다운로드를 시작하고 들어오는 데이터를 관찰합니다.
   - 그리고 들어오는 데이터 조각들을 반복적으로 수신합니다.
   - 네트워크 연결이 종료되면 다운로드를 멈추고 연결은 에러와 함께 타임아웃이 됩니다.
   - 또는 파일의 모든 데이터를 다운로드하고 성공적으로 종료됩니다.

- 위의 작업 순서의 전형적인 observable 생명주기로 서술해보면 아래와 같습니다.

``` swift
API.download(file: "http://www...")
.subscribe(onNext: { data in
	//... append data to temporary file
}, 
onError: { error in
	//... display error to user
},
onCompleted: {
	//... use downloaded file
})
```



- API.download(file:) 함수는 네트워크를 통해 들어오는 Data 값들을 발생시키는 Observable<Data> 의 인스턴스를 반환합니다.
- onNext closure 를 제공하여 다음 이벤트를 구독합니다. 위의 예제에서는 디스크의 임시공간에 data 를 추가하도록 설계되었습니다.
- onError closure 를 제공하여 에러를 구독합니다. closure 내부에서 error.localizedDescription 을 표시할 수 있습니다.
- 마지막으로 완료 이벤트는 onCompleted closure 를 제공하여 구독할 수 있습니다. closure 내부에서 새로운 view controller 를 표시하여 다운로드된 파일을 표시하는 등의 작업을 수행할 수 있습니다.


#### Infinite observable sequences
- 성공적으로 또는 에러와 함께 종료되는 다운로드와 비슷한 활동과 달리 단순히 무한한 observable 시퀀스들이 있습니다. 종종 UI 이벤트들은 무한히 관찰해야 합니다. 예를 들어, 애플리케이션이 기기 회전에 반응해 봅시다.
    - class 에서 NotificationCenter 에 UIDeviceOrientationDidChange notification 을 등록해야합니다.
    - 그리고 기기 회전을 제어할 callback 을 제공하여 기기의 정확한 orientation 을 캐치하고 최신 값과 연관된 대응을 해야합니다.

- 이런 orientation 의 변화 시퀀스는 기기가 회전하는 한 지속됩니다. 또한 시퀀스는 사실상 무한대이므로 시작할 때 항상 초기값을 가집니다. 사용자가 기기를 회전시키지 않는다는 것이 이벤트의 시퀀스가 종료되었다는 것을 의미하지 않습니다. 다만 이벤트가 발생되지 않는 것 뿐입니다.

``` swift
UIDevice.rx.orientation
.subscribe(onNext: { current in 
	switch current {
		case .landscape:
		  //... re-arrange UI for landscape
		case .portrait:
		  //... re-arrange UI for portrait
	}
})
```

- UIDevice.rx.orientation 은 Observable<Orientation> 을 생성하는 가상 제어속성이기 때문에(이런 이벤트는 해당 observable 에서 절대 이벤트가 발생되지 않음) onError, onCompleted 파라미터는 skip 해도 됩니다.



### Operators
- ObservableType 과 Observable 클래스 구현에는 보다 복잡한 로직을 구현하기 위해 비동기 작업을 추상화하는 많은 메서드가 포함되어 있습니다. 이러한 방법은 분해도가 높기 때문에 대부분 연산자라고 합니다. 연산자들은 주로 비동기 입력을 사용하고 사이드 이펙트를 일으키지 않으며 오로지 출력만 하므로 퍼즐조각처럼 쉽게 맞출 수 있고, 보다 큰 그림을 만들 수 있습니다.

- 예를 들어 수학표현을 살펴봅시다. (5 + 6) * 10 - 2. 명확하고 결정론적인 방법으로 미리 정의된 순서에 의해 \*, (), +, - 연산자를 입력된 각 파트에 적용하고 결과를 문제가 해결될 때까지 표현식에 따라 계속 처리할 수 있습니다.

- 비슷한 방식으로 Observable 에 의해 발생된 확정적인 입력 및 출력 값이 표현식에 따라 해결될 때까지 Rx 연산자를 적용하여 처리할 수 있습니다.

- 다음은 몇 가지 일반적인 Rx 연산자를 사용하여 이전 예제를 보정한 것입니다.
``` swift
UIDevice.rx.orientation
.filter { value in
  return value != .landscape
}
.map { _ in
  return "Portrait is the best!"
}
.subscribe(onNext: { string in 
  showAlert(text: string)
})
```


### Schedulers
- Rx 의 dispatch queue 에 해당합니다. 스테로이드제 처럼 만능이고 사용하기 훨씬 쉽습니다.(아마 부작용 없이 스테로이드제를 사용하는 것과 같다는 표현인듯...)

- 이미 정의되어 있는 스케쥴러가 99% 의 use case 를 커버하므로 스케쥴러를 커스터마이징할 필요는 없을 것입니다.

- 이책의 초반 반 정도는 Observable 을 전반적인 기초를 배우기 때문에 스케쥴러를 사용할 일이 없습니다. 그만큼 스케줄러는 강력합니다.

- 예를 들어 GCD 를 사용해, 지정된 queue 에서 코드 실행을 직렬화하는 SerialDispacthQueueScheduler 를 이용해 next 이벤트를 관찰하도록 지정할 수 있습니다. ConcurrentDispatchQueueScheduler 를 사용하면 코드를 동시에 실행시킬 수 있습니다. OperationQueueScheduler 는 지정된 NSOperationQueue 을 사용할 수 있도록 지정할 수 있습니다.

- RxSwift 는 고맙게도 한 번의 구독으로 여러 작업을 서로 다른 스케줄러에서 처리할 수 있게 해주어 최고의 퍼포먼스를 발휘할 수 있습니다.



## 애플리케이션의 구조
- RxSwift 는 앱의 구조를 전혀 변경하지 않는다는 것은 언급할 가치가 있습니다. 앱 구조와 상관없이 주로 이벤트, 비동기 데이터 시퀀스 및 범용 통신을 다룹니다.

- 애플 개발자 문서에 정의된 대로 MVC 구조를 사용하여 Rx 애플리케이션을 만들 수도 있고, 원한다면 MVP, MVVM 구조를 선택하여 구현할 수도 있습니다. 이런 경우 RxSwift 가 단방향 데이터 흐름 구조를 설계하는데 도움을 줄 수 있습니다.



## RxCocoa
RxSwift 는 일반적인 Rx API 를 구현하였습니다. 그렇기 때문에 Cocoa 또는 UIKit 에 특화된 클래스에 대해 전혀 알지 못합니다. RxCocoa 는 Cocoa, UIKit 개발에 특히 도움이 되는 클래스들을 모두 포함하는 동반자같은 라이브러리입니다. 

``` swift
toggleSwitch.rx.isOn
.subscribe(onNext: { enabled in 
  print( enabled? "it's ON" : "it's OFF")
})
```



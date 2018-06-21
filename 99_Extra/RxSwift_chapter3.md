# Chapter 3: Subjects

- 지금까지 observable 을 어떻게 만들고, 구독하고, 작업이 완료됐을 때 어떻게 처리하는지 등에 대해 배웠습니다. observable 은 RxSwift 의 아주 기본적인 부분이지만 애플리케이션 개발시 일반적으로 새로운 값을 런타임에 수동으로 observable 로 감싸고 subscribers 로 방출해야하는 일이 필요하므로 꼭 알아야 하는 부분이죠. 그런데 우리가 원하는 것은 observable 이면서 observer 의 역할을 동시에 수행할 수 있는 녀석입니다. 그런 녀석을 subject 라고 부릅니다.


### Getting started

- 아래의 예제에서 알 수 있듯이 타입의 이름이 아주 적절합니다. 왜냐하면 신문 발행자와 비슷하게 정보를 전달받고 아마도 구독자들에게 전달하기 전 정보를 수정하고 구독자에게 출판하기 때문입니다. 

``` swift
// 생성된 subject 는 String 타입이기 때문에 문자열만 출판할 수 있습니다. 초기화 된 후 뭔가 수신할 수 있습니다. 
let subject = PublishSubject<String>()
// 아래와 같이 코드를 작성하면 subject 에 새로운 문자열을 추가할 수 있습니다. 하지만 아직 아무것도 출력되지 않습니다.
// 아직 observer 가 없기 때문이죠
subject.onNext("Is anyone listening?")

// 이전 챕터의 마지막에서 했던 것과 같은 방식으로 .next 이벤트 에서 string 을 출력하는 subscription 을 생성했습니다. 
// 하지만 여전히 아무것도 출력되지 않습니다. 곧 다양한 주제들을 공부하며 알아보겠습니다.
let subscriptionOne = subject
.subscribe(onNext: { string in 
	print(string) 
})
```

- 위의 예제에서 일어나는 일은 PublishSubject 가 현재의 subscriber 에게만 방출된다는 것입니다. 그렇기 때문에 subscribe 되기 전에 무언가 추가되었다면, 해당 값을 얻어올 수 없습니다. 

- 위이 예제 마지막에 `subject.on(.next("1"))` 를 추가하면 "1" 이라는 문자열이 출력됩니다. subscribe operator 와 동일한 형식으로 on(.next(:)) 으로 새로운 .next 이벤트를 subject 에 추가할 수 있습니다. 축약형식으로 `subject.onNext("2")` 이렇게 사용해도 됩니다.


### What are subjects?
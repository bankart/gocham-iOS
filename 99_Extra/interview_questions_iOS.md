

* general
	* 마지막으로 작업해봤던 iOS version은 어떻게 되시나요? 해당 version에서 좋았던 부분과 그 이유는?
* swift
	* 스위프트에서 좋아하는 부분과, 그렇지 않은 부분은? 왜인가?
		* optional
		* functional programming
	* iOS에서의 메모리 관리는 어떻게 이뤄지나?
		* ARC, MRC, autoreleasepool {}
		* Unsafe[Raw][Mutable]Pointer, Unmanaged
	* POP란? 왜 Value type이 좋은가? Struct vs Class 선택 기준?
		* method dispatching
	* initialization : 2phase init, required, convinence, 
	* Array.append() 복잡도, Array vs. NSArray, Array/ContiguouseArray/ArraySlice
* UIKit
	* iOS app의 정의, 우리작 작성한 코드는 어디에 위치하게되는가? (무슨역할을 담당하나)
		* Application life cycle
		* Thread vs. runloop
	* UIViewController life cycle - 메모리 워닝 연계
	* 무한 스크롤 collection view
	* orientation 제한 로직
	* autolayout - safeArea 
	* CALayer vs. UIView
	* IB, Storyboard 
	* UIViewController 간의 전환 에니메이션 구현 어떻게?
		* UIViewControllerAnimatedTransitioning, UIPercentDrivenInteractiveTransition
* OOP 설계
	* 싱글턴에대하 알고있나? 어떤때 사용해보았고, 어떤 경우 사용하지 않았는지?
* 유틸
	* 어떻게 디펜던시 관리는 하는지? 왜 필요한지?
		* third party library depency managing
		* swift와 ABI 
	* TDD - agile
	* RxSwift
	
5. delegate와 KVO의 다른점에 대해 설명해 보라.

6. iOS앱에서 주로 사용되는 디자인 패턴은?


- 즉석 검색 문제 : go lang - API 홈페이지를 제대로 찾는지?


---
* autoreleasepool {} in swift

* Array.append() 함수 알고리즘
	* 복잡도: Amortized O(1) over many additions. (capacity alloction 전략이 exponential strategy)
	* O(1) : capa에 여유가 있고, storage를 다른 instance와 공유하지 않을 때 
	* O(N) : append하기 전에 allocation이 필요하거나, 다른 copy와 공유하고 있을 때 (COW)
	* Unspecified : 브릿지된 NSArray 객체를 storage로 사용할 때 (element가 value 타입이 아닌 경우)

* 언제 Value type을 선택할 것인가?
	* 특정 타입 생성의 가장 중요한 목적이 간단한 몇 개의 값을 캡슐화하려는 것인 경우
	* 캡슐화한 값을 구조체의 인스턴스에 전달하거나 할당할 때 참조가 아닌 복사를 하는 것이 타당할 경우
	* 구조체에 의해 저장되는 모든 프로퍼티가 참조가 아닌 복사가 타당한 벨류타입인경우
	* 기존의 타입에서 가져온 프로퍼티나 각종 기능을 상속할 필요가 없는 경우
> 그 외에는 class를 사용하라.
> In practice, this means that most custom data constructs should be "class" not structures.

* Array 와 NSArray의 차이점
	* 요소의 타입제한 
	* struct vs class

* Swift 배열 
	* Array
		* 메모리 영역은 인접 블록에 저장된다.
		* @objc 프로토콜 or class인 경우 NSArray 스토리지로서의 인접 블록에 저장된다.
	* ContiguousArray
		* NSArray와 브릿징을 지원하지 않음. 
		* @objc, class의 경우 대신 더 효율적인/안정적인 퍼포먼스 보장
	* ArraySlice


* Closer capture list 동작에 대한 질문

```swift
var a = 0
var b = 0
let closure = { [a] in
    print(a, b)
}

a = 10
b = 10
closure()  // 0, 10
```

closure expression은 기본적으로 주변 scope의 상수와 변수를 strong reference한다.
위의 예처럼 value type를 캡쳐하면 클로져 내부에서 상수로 복사 캡쳐된다.
참조 타입이면 똑같음(strong), 대신 weak, unowned를 사용하여 메모리 ownership을 정리할 수 있다.

* Escaping Closures
클로져를 펑션의 인자로 넘길 때 표시하는 것으로, default @nonescaping (self없이 멤버 억세스 사용가능)
해당 함수의 리턴전에 클로저를 실행해야한다. (멤버 변수에 담으면 안됨)

기본적으로 @escaping 


* ARC
    * 동작 원리?
	* strong referece cycle
		* class to class
			* property 2 optional : weak
			* 1property optional, the other is not : unowned
					* unowned(unsafe) 성능상의 이유등으로 런타임시 safety cheack를 끈다. 
					* 해제된 객체 접근 시 
						* unowned -> SIGABRT, "Fatal error: Attempted to read an unowned reference but the object was already deallocated"
						* unowned(unsafe) -> EXC_BAD_ACCESS
					
			* both property not optional : unowned references and Implicityly Unwrapped Optional properties
		* class to closure
			* capture list

* swift initializer behavior
	* two phase initializing : 무엇인지, 그리고 왜?
		* obj-c도 비슷 단 모든 변수가 nil or 0으로 초기화된 상태로 시작


* delegate와 KVO의 다른점에 대해 설명해 보라.
> iOS에서의 서로다른 메시징 패턴 타입에 대한 지식을 묻는 질문이다.

기대하는 대답: 
둘 다 객체 사이의 관계를 맺는 방법이다.  Delegation(위임)은 1대1 관계로 delegate protocol을 구현한 객체와 그 객체를 활용하여 protocol에 정의된 메시지를 보내는 객체로 구성된다. KVO는 다대다(many-to-many) 관계로, 한 객체가 메시지를 브로드캐스트하면 그 메시지를 수신하고 반응하는 하나 또는 여러개의 객체들로 구성된다. KVO는 protocol에 의존하지 않으며 reactive programming(RxSwift, ReactiveCocoa, ..)의 기본적인 블록(기초)가 된다.


* iOS앱에서 주로 사용되는 디자인 패턴은?

기대하는 대답:
iOS 앱 개발에 일반적으로(Typical commonly)  사용되는 패턴은, 애플이 자신들의 Cocoa, Cocoa Touch, Objective-C, swift 문서에서 옹호하고 있다. MVC, Singleton, Delegate, Observer 등이다.









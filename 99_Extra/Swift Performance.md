
* 성능에 영향을 미치는 세 가지
	* Memory Allocation: Stack or Heap
	* Reference Counting: No or Yes
	* Method dispatch: Static or Dynamic

---

* Heap 할당 문제
	* 할당 시에 빈 곳을 찾고 관리하는 것은 복잡한 과정이 필요
	* 과정이 thread safe해야 하므로 lock 등의 동기화 동작으로 인해 성능 저하
	* 반면 Stack 할당은 단순히 스택포인터 변수 값만 바꿔주는 정도

* Reference Counting 문제
	* 변수를 복사할 때마다 실행되는 등 자주 실행됨
	* thread safe하게 카운트를 Atomic하게 증감해야 함

* Method Dispatch (Static)
	* 컴파일러의 최적화, 메서드 인라이닝 가능
		* 컴파일 시점에 메서드 실제 코드 위치를 안다면 실행 중 찾는 과정 없이 그 주소로 점프 가능
	* 메서드 인라이닝
		* 컴파일 시점에 메소드 호출 부분에 메소드 내용을 붙여넣음 (효과가 있다고 판단되는 경우에만)
		* Call stack 오버헤드 줄임
		* CPU icache나 레지스터를 효율적으로 쓸 가능성 -컴파일러의 추가 최적화 가능
		* 최근 메소드들이 작으므로 더더욱 기회가 많음
		* 루프 안에서 불리는 경우 큰 효과

* Method Dispatch (Dynamic)
	* Reference 시맨틱스에서의 다형성은 컴파일 타임에 어떤 클래스의 메서드인지 알 수 없으며 런타임에서만 파악 가능
	* 실제 Type을 컴파일 시점에서 알 수 없으므로 코드 주소를 런타임에 찾아야 함
	* 따라서 컴파일러가 최적화를 못하므로 속도 저하 요소

* static dispatch로 강제하기
	* final, private를 쓰면 해당 메서드와 프로퍼티는 상속되지 않으므로 static하게 처리 가능
	* dynamic 사용 줄이기
	* Objc 연동 최소화
	* WMO(whole module optimization): 빌드 시에 모든 파일을 한번에 분석하여 static dispatch 변환 가능성 판단하여 최적화 하나 몹시 느리고 안정화가 안되므로 사용에 주의 필요

----
Swift 추상화 기법들과 성능
* Class
	* class는 성능 상관 없이 레퍼런스 시맨틱스가 필요할 때 사용
	* final class는 class 보다 고성능

|                    | class             | final class |
| ------------------ | ----------------- | ----------- |
| Memory Allocation  | Heap              | Heap        | 
| Reference Counting | Yes               | Yes         |
| Method Dispatch    | Dynamic (V-Table) | Static      |

* Struct
	* 참조 타입이 없는 struct는 고성능
	* 참조 타입이 있는 struct는 성능 저하
		* 내부 storage로 class 타입을 가지면 복사시 reference counting이 동작함
	* 따라서 값의 제한이 가능하면 enum 등의 Value type으로 변경하고 다수의 class들을 하나로 합쳐서 성능 개선

|                    | 참조 타입없는 struct | 참조 타입을 가진 struct | 참조 타입이 많은 struct |
| ------------------ | ------------------- | ---------------------- | ---------------------- |
| Memory Allocation  | Stack               | Stack                  | Stack                  |
| Reference Counting | NO                  | Yes                    | MANY!!!                |
| Method Dispatch    | Static              | Static                 | Static                 |


* Protocol 
	* 코드 없이 API만 정의함
	* Objective C의 protocol, Java의 Interface 매우 유사함
	* Value type인 struct에도 적용 가능: Value semantics에서의 다형성
	* 값 관리는 Existential Container로
	* Copy 동작: Value 타입이므로 값 전체가 복사됨
	* 3 words 이하 Copy: 단순히 새로운 Existential container에 전체가 복사됨
	* 3 words 이상 Copy: 새로운 Existential container 생성하고 값 전체가 새로운 Heap할당 후 복사됨

* Existential Container 
	* protocol type의 실제 값을 넣고 관리하는 구조
	* 프로토콜을 통한 다형성을 구현하기 위한 목적으로 사용
	* 성능은 class 사용과 유사
		* 초기화 시 Heap 할당
		* Dyamic dispatch (class: V-Table / protocol: PWT)
	* Value Witness Table(VWT)
		* Existential container의 생성/해제를 담당하는 인터페이스

|                    | 작은 크기의 Protocol Type | 큰 크기의 Protocol Type      | 큰 크기의 Protocol Type(with Indirect Storage) |
| ------------------ | ------------------------ | ---------------------------- | --------------------------------------------- |
| Memory Allocation  | Stack                    | MANY!- Copy시 마다           | Heap                                         |
| Reference Counting | NO                       | No(class 프로퍼티가 있을 때만) | Yes                                         |
| Method Dispatch    | Dynamic (PWT)            | Dynamic (PWT)                | Dynamic (PWT)                                |


* Generics Type
	* Generic 특수화: 컴파일러가 실행
	* 더 효과를 보려면 WMO(Whole Module Optimization) 이용
	* WMO 사용이 완전하지 않으므로 주의 필요
	* 정적 다형성: 컴파일 시점에 부르는 곳마다 타입이 정해져 있고 런타임에 바뀌지 않으므로 특수화가 가능함

|                    | 특수화 되지 않은 Generics | 특수화되지 않은 Generics | 특수화된 Generics (struct) |특수화된 Generics (class) |
|                    | (작은 크기 Protocol )     | (큰 사이즈의 Protocol)  |                            |                         |
| ------------------ | ------------------------ | ------------------------ | ------------------------- | ----------------------- |
| Memory Allocation  | Stack                    | MANY!(copy할 때마다)     | Stack                     | Heap                    |
| Reference Counting | NO                       | NO(class 프로퍼티있을 때) | NO                       | Yes                     |
| Method Dispatch    | Dynamic(PWT)             | Dynamic(PWT)             | Static                   | Dynamic(V-Table)        |



----

Summary

* Swift의 성능
	* Objective-C에 비해 큰 향상이 있었으나 Value 타입과 Protocol 타입 등의 성격을 고려해야 함
	* 성능 최적화를 고려해야하는 경우의 예
		* 렌더링 관련 로직 등 반복적으로 매우 빈번히 불리는 경우
		* 서버 환경에서의 대용량 데이터 처리
	* 추상화 기법의 선택
		* Struct: 엔티티 등 Value 시맨틱이 맞는 부분
		* Class: Identity가 필요한 부분, 상속등의 OOP, Objective-C
		* Generics: 정적 다형성으로 가능한 경우
		* Protocol: 동적 다형성이 필요한 경우
	* 고려할 수 있는 성능 최적화 기법들
		* Struct에 클래스 타입의 Property가 많으면
			* enum, struct등 Value type으로 대체
			* Reference counting 줄임
		* Protocol Type을 쓸 때 대상이 큰 struct면
			* Indirect storage로 struct 구조 변경
			* Mutable해야하면 Copy-on-Write 구현
		* Dynamic method dispatch를 static하게
			* final, private의 생활화
			* dynamic 사용 최소화
			* Objc 연동 최소화 하기
			* 릴리즈 빌드에 WMO 옵션 적용 고려 (주의!)

참고 자료

* WWDC 2016 Session 416: Understanding Swift Performance
* WWDC 2015 Session 409: Optimizing Swift Performance
* WWDC 2015 Session 414: Building Better Apps with Value Types in Swift

---

> from WWDC2017 session 402 what's new in swift 


* Predictable Performance

```swift

// Unpredictable Performance in Swift 3protocol Ordered {	func precedes(_ other: Ordered) -> Bool}
func testSort(_ values: inout [Ordered]) { 	values.sort { $0.precedes($1) } }

```

Struct size가 3 word를 초과하면 성능이 매우 느려짐 
(위 코드 예에서 struct size 3word까지는 2정도 걸리던 시간이 4word에서는 19까지 치솟음)

* Existential Containers	* Implementation of a value of unknown type
	* Inline value buffer: currently three words 
	* Large values stored on the heap	* Heap allocation is slow


* COW Existential Buffers
	* Swift now uses copy-on-write (COW) reference-counted existential buffers Copied only when modified while not 	* uniquely referenced	* Avoids expensive heap allocations

(위 코드 예에서 struct size 3word까지는 2정도 걸리던 시간이 4word에서는 4까지 치솟음)

* Faster Generic Code	* Specialization: compiler generates code for specific types	* Not always possible: unspecialized generic code is also important Stack allocation of generic buffers








# Memory Safety

* Swift에서는 메모리관리를 자동으로해주기 때문에 일반적으로는 신경쓸 필요가 없다.
* 그러나 어떤 상황에서 메모리 접근 conflict가 발생할 수 있을지 그리고 어떻게 코딩을 해야 conflict를 피할 수 있는지 알아야 한다.

## 메모리 접근 시 발생하는 Conflict란?

> 여기서의 conflict는 concurrent 나 multithread 상황에서 발생하는 문제가 아니라, 
> 싱글 thread 상황에서 발생하는 문제를 이야기함. 

### 메모리 접근의 특징

> 하나의 메모리 위치에 여러 개의 접근이 동시에 일어나면 예측할 수 없거나 모순적인 동작이 발생할 수 있음.
> (unpredictable or inconsistent behavior) 

* 메모리 conflict 접근 범주에서(domain) 중요한 3가지 특징
	* 읽고, 쓰는 접근
	* 접근 시간 (duration of access)
	* 접근하는 메모리의 위치

* 두 개의 접근이 다음과 같은 상황일 때 conflict 발생
	* 최소 하나의 접근이 쓰기 접근
	* 같은 메모리 위치에 접근
	* 접근 시간이 겹침 (Their duration overlap)

* 즉각적인 접근과 Long-term 접근(instantaneous access vs. long-term access)
	* 즉각적인 접근 : 접근 시작과 끝 사이에 다른 코드가 실행될 수 없음
		* 자연적으로 두 즉각적인 접근은 동시에 일어날 수 없음
		* 대부분의 메모리 접근은 즉각적임
	* Long-term 접근 : 접근 시작과 끝 사이에 다른 코드가 실행될 수 있음
		* 다른 Long-term 접근이나 즉각적인 접근과 "접근 시간 겹침"이 발생할 수 있음
		* 접근 시간 겹침은 주로 함수/메소드의 in-out 파라메터 사용 혹은 structure의 mutating 메소드 사용 시 나타남

### In-Out 파라메터 사용 시 conflict 접근

* 함수는 가지고 있는 모든 in-out 파라메터들에 대한 long-term 쓰기 접근을 함.
* in-out 파라메터의 쓰기 접근은 다른 non in-out 파라메터들이 평가된(evaluated) 뒤 시작되고, 전체 함수 실행 후 끝남.
	* 여러개의 in-out 파라메터를 가졌다면, 쓰기 접근의 시작 순서는 파라메터 표시된 순서와 같다.
	  (If there are multiple in-out parameters, the write accesses start in the same order as the parameters appear)
* 이런 long-term 쓰기 특성 때문에 함수안에서 in-out 파라메터로 넘겨진 original 변수를 접근할 수 없음

```swift
var stepSize = 1

func incrementInPlace(_ number: inout Int) {
	number += stepSize
}

incrementInPlace(&stepSize)

// Error: conflicting accesses to stepSize
```

* 같은 이유로 하나의 변수를 한 함수의 여러개의 in-out 파라메터에 전달하는 것도 conflict를 발생시킴

> 연산자도 함수이기 때문에 in-out 파라메터들에 대해 long-term 쓰기 접근을 하게되므로 유의해야함


### 메소드에서 self 사용 시의 conflict 접근 (Conflicting Access to self in Methods)

* structure에서의 mutating 메소드는 함수 실행 시간동안 self에 대한 쓰기 접근을 함
* 따라서 mutating 메소드가 in-out 파라메터를 갖는 경우, 그 파라메터에 자기자신이 전달되면 conflict 발생

### 프로퍼티 사용 시 conflict 접근 (Conflicting Access to Properties)

* 값 타입들은 가지고 있는 어느 하나의 벨류(프로퍼티)라도 변경되면 전체가 변경되게됨. (COW)
* 하나의 프로퍼티에 대한 읽기, 쓰기 접근을 하는 것은 전체 값에 대한 읽기, 쓰기 접근을 필요로 함.
	* 하나의 tuple의 값 두 개를 두 개의 in-out 파라메터를 갖는 함수에 전달하면 conflict 발생
	* 하나의 struct의 프로퍼티 두 개를 두 개의 in-out 파라메터를 갖는 함수에 전달하면 conflict 발생
		* struct가 global 변수일 때 발생
		* struct가 local 변수이면 compiler가 해결 해줌 (The compiler can prove that memory safety is preserved because the two stored properties don't interact in any way.)

* Memory safety is the desired guarantee, but exclusive access is a stricter requirement than memory safety
* 다음과 같은 경우에 컴파일러가 접근 시간이 겹치는 문제를 해결해 줄 수 있음
	* computed 프로퍼티나 class 프로퍼티가 아닌 오직 stored 프로퍼티만 접근했을 경우
	* structure가 global이 아닌 local 변수에 담긴 값일 경우
	* structure가 escaping된 closure에 캡쳐되지 않은 경우
 * 컴파일러가 접근의 안정성을 확보하지 못할 경우 접근을 허용하지 않을 것임.


---

[소유권 선언서](https://github.com/apple/swift/blob/master/docs/OwnershipManifesto.md)

## Introduction
"소유권(ownership)"을 swift에 추가하는 것은 개발자에게 많은 도움을 줄 수 있는 주요 기능(major feature)임.


### Problem statement
Swift에서 널리 사용되는 값타입의 copy-on-wirte는 일반적으로 성공적이다. 
그러나 다음과 같은 단점도 존재한다.
* Reference counting과 uniqueness testing 은 간접비용을 유발한다. (impose some overhead)
* Reference counting은 대부분의 경우 결정론적(deterministic) 성능을 제공한다, 그러나 성능을 분성하거나 예측하기에는 여전히 복잡하다.
* 값을 아무때나 복사할 수 있게 하기위해서 "escape"하면 기저의(underlying) 버퍼가 힙에 할당되게 된다. 스텍할당이 훨씬 효율적이지만 값의 escape 시도를 막거나 최소한 알아차릴 수 있는 능력이 필요하게 된다. 

The ability to copy a value at any time and thus "escape" it forces the underlying buffers to generally be heap-allocated. Stack allocation is far more efficient but does require some ability to prevent, or at least recognize, attempts to escape the value


Certain kinds of low-level programming require stricter performance guarantees. Often these guarantees are less about absolute performance than predictable performance. For example, keeping up with an audio stream is not a taxing job for a modern processor, even with significant per-sample overheads, but any sort of unexpected hiccup is immediately noticeable by users.

Another common programming task is to optimize existing code when something about it falls short of a performance target. Often this means finding "hot spots" in execution time or memory use and trying to fix them in some way. When those hot spots are due to implicit copies, Swift's current tools for fixing the problem are relatively poor; for example, a programmer can fall back on using unsafe pointers, but this loses a lot of the safety benefits and expressivity advantages of the library collection types.

We believe that these problems can be addressed with an opt-in set of features that we collectively call ownership.

What is ownership?

Ownership is the responsibility of some piece of code to eventually cause a value to be destroyed. An ownership system is a set of rules or conventions for managing and transferring ownership.

Any language with a concept of destruction has a concept of ownership. In some languages, like C and non-ARC Objective-C, ownership is managed explicitly by programmers. In other languages, like C++ (in part), ownership is managed by the language. Even languages with implicit memory management still have libraries with concepts of ownership, because there are other program resources besides memory, and it is important to understand what code has the responsibility to release those resources.

Swift already has an ownership system, but it's "under the covers": it's an implementation detail that programmers have little ability to influence. What we are proposing here is easy to summarize:

We should add a core rule to the ownership system, called the Law of Exclusivity, which requires the implementation to prevent variables from being simultaneously accessed in conflicting ways. (For example, being passed inout to two different functions.) This will not be an opt-in change, but we believe that most programs will not be adversely affected.

We should add features to give programmers more control over the ownership system, chiefly by allowing the propagation of "shared" values. This will be an opt-in change; it will largely consist of annotations and language features which programmers can simply not use.

We should add features to allow programmers to express types with unique ownership, which is to say, types that cannot be implicitly copied. This will be an opt-in feature intended for experienced programmers who desire this level of control; we do not intend for ordinary Swift programming to require working with such types.

These three tentpoles together have the effect of raising the ownership system from an implementation detail to a more visible aspect of the language. They are also somewhat inseparable, for reasons we'll explain, although of course they can be prioritized differently. For these reasons, we will talk about them as a cohesive feature called "ownership".



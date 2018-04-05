# What is an iOS application and where does your code fit into it?
*iOS 애플리케이션이란 무엇이며 당신의 코드는 어디에 들어갑니까?*
우리가 만드는 애플리케이션은 결국 거대한 실행 루프에 불과하다. 
사용자가 이벤트를 발생시키기 전에 전화 수신, push notification, 홈 버튼 누름 그외 다른 앱 생명 주기 이벤트에 의해 중단될 수 있다.
이것은 단순히 사용자가 앱 아이콘을 누를 때마다 실행되는 실행 루프가 아닌 좀 더 높은 수준으로 추상화된 UIApplication, AppDelegate 으로
개발을 하는 것이다.

* * *


* * *


The App Life Cycle
==================

The Main Fuction
----------------

 iOS 앱도 다른 C 베이스 언어들과 마찬가지로 'main' 함수가 시작점이다. 다만 iOS 앱에서는 'main' 함수를 직접 작성하지 않아도 된다. 
Xcode 가 프로젝트 생성시 기본으로 생성해준다. 예외적인 상황이 아니라면 수정할 필요가 없다.
('main' 함수가 하는 일은 그저 UIKit 프레임워크로 제어권을 넘기는 것 뿐이다.)
*swift 에서는 main 함수가 없다... 문서가 업데이트 되지 않았음*

``` swift
int main(int argc, char * argv[]) {
  @autoreleasePool {
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
  }
}
```

 'UIApplicationMain' 함수는 앱의 코어 오브젝트 생성, 사용 가능한 storyboard 파일에서 user interface 로딩,
custom code 호출(초기화가 필요한 경우를 지원하기 위해) 그리고 앱의 run loop 실행을 위한 프로세스를 제어한다.

* * *
The Structure of an App
-----------------------
 시작되는 동안 '` UIApplicationMain(_:_:_:_:)`' 함수는 몇개의 핵심 오브젝트를 생성하고 앱을 실행시킨다. 
모든 iOS 앱의 중심은 UIApplication 이다. UIApplication은 시스템과 다른 객체들 간의 상호작용을 돕는다.
아래의 그림은 대부분의 iOS 앱에서 볼 수 있는 객체간 역할 수행 모식도다.(model-view-controller 구조)
- <img src="https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Art/core_objects_2x.png" alt="Key objects in an iOS app" width="550px">

* * *
### UIApplication, UIApplicationDelegate 의 역할
- UIApplication: 이벤트 루프와 상위수준 앱 동작을 관리한다. 그리고 사용자가 지정한 custom 객체 등으로 
  앱간 전환 및 몇몇 특별한 이벤트(push notification 등등)를 전달해준다. subclassing 은 안됨.
- UIApplicationDelegate: custom code 의 핵심! UIApplication 객체와 연계하여 앱 상태 전환 및 많은 상위수준 
  앱 이벤트를 제어할 수 있도록 해준다. 앱 내에서 유일하게 언제든 접근할 수 있는 유일한 객체이므로 종종
  앱의 초기 데이터 구조를 설정하는데 사용된다.
- UIWindow: 대부분의 앱은 하나의 window 를 갖지만 간혹 외부 디스플레이를 위해 window 를 추가하기도 한다. 
  화면 호스팅 외에 UIApplication 과 함께 view, view controller 로 이벤트를 전달하는 역할도 한다.

* * *
The Main Run Loop
-----------------
 앱의 메인 런 루프는 모든 사용자 이벤트를 처리한다. UIApplication 객체는 앱 최초 실행시 메인 런 루프를 설정하고, 
이벤트 처리 및 화면 업데이트를 제어할때 사용한다. 메인 런 루프는 앱의 메인 쓰레드에서 동작한다. 이렇게 하면 
사용자 이벤트를 전달받은 순서대로 처리된다.
 아래 그림은 메인 런 루프에서 이벤트가 어떻게 처리되는지 보여준다. UIApplication 객체는 이벤트를 가장 먼저
수신해서 수행할 작업을 결정한다. 터치 이벤트는 일반적으로 메인 윈도우로 보내지고, 메인 윈도우는 터치가 발생한 화면에 이벤트를 보낸다.
- <img src="https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Art/event_draw_cycle_a_2x.png" alt="Processing events in the main run loop" width="550px">

* * *
Excution States for Apps
------------------------
 시스템에서 발생하는 작업에 대한 응답으로 앱의 상태가 전환된다. 예를 들어, 사용자가 홈 버튼을 누르거나, 전화가 걸려 오거나,
다른 간섭이 발생하면 현재 실행중인 앱의 상태가 전환된다. 
### 앱 상태
- Not running: 앱이 아직 실행되기 전 이거나 시스템에 의해 종료된 상태.
- Inactive: 앱은 foreground 에 실행됐지만 아직 이벤트가 수신되지 않은 상태.(다른 상태로 전환되기 전 잠시동안 유지되는 상태)
- Active: 앱이 foreground 에서 실행되고 이벤트도 수신된 상태.(앱의 일반적인 상태)
- Background: 앱이 background 로 진입하고 코드가 실행중인 상태. 대부분의 앱들은 suspended 되기 전 잠시동안만 유지된다.
- Suspended: 앱이 background 에 있지만 코드가 실행중이지 않은 상태(보류). 시스템에서 이 상태로 진입시 알려주지 않으며 자동으로 이 상태로 전환된다.
  메모리에는 상주하지만 어떤 코드도 동작하지 않는다. 만약 메모리가 부족해지면 시스템은 foreground 에서 동작하는 앱들을 위해 공지없이 
  대기 상태의 앱을 메모리에서 삭제할 수도 있다.


 아래 그림은 앱의 상태 전환 경로를 보여준다.
- <img src="https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Art/high_level_flow_2x.png" alt="State changes in an iOS app" width="350px"> 

* * *

 대부분의 상태 전환은 delegate 객체의 함수 호출에 의해 수반된다. 이 함수들을 이용하여 상태 전환시 적절한 대응을 할 수 있다. 
- `application(_ willFinishLaunchingWithOptions:)`: 앱 최초 실행시 상태 전환에 맞는 동작을 수행할 수 있다.
- `application(_ didFinishLaunchingWithOptions:)`: 초기화가 마무리되고 앱이 화면에 표시되기 직전 호출된다.
- `applicationDidBecomeActive()`: 앱이 foreground 에 표시될 것임을 알려준다. 마지막 준비 단계로 사용된다.
- `applicationWillResignActive()`: foreground 에서 전환될 것임을 알려준다. 비활성화 상태로 진입할 때 사용된다.
- `applicationDidEnterBackground()`: 앱이 backgroud 에서 동작중이고 언제든 대기 상태로 진입할 수 있음을 알려준다.
- `applicationWillEnterForeground()`: 앱이 background 에서 foreground 로 상태 전환할 예정임을 알려준다. 하지만 아직 active 상태는 아니다.
- `applicactionWillTerminate()`: 앱이 종료될 것임을 알려준다. 만약 suspended 상태라면 호출되지 않는다.

* * *
App Termination
---------------
 앱은 앱이 사용자 정보를 저장하거나 필수적인 작업을 완료할때까지 기다리지 않고 종료될 수 있으므로 꼭 이에 대비해둬야 한다.
 시스템 입장에서 앱의 종료는 일반적인 앱의 생에 중 일부일 뿐이다. 시스템이 앱을 종료시키는 이유는 메모리가 부족하기 때문이며 이는 
사용자에 의해 다른 앱이 실행되기 때문고, 그외에 앱이 오동작하거나 적시에 응답하지 않는 경우에도 종료시킨다.
 앱이 suspended 상태에서는 앱에 공지없이 종료시킨다. 만약 앱이 background 에서 작업을 수행중이라면 
`applicationWillTerminate()` 함수를 통해 알려준다. 하지만 기기가 reboot 중이라면 이 함수는 호출되지 않는다.
 사용자가 멀티테스킹 화면에서 명시적으로 앱을 종료시킨다면 suspended 상태에서와 마찬가지로 공지없이 종료된다.

* * *
Threads and Concurrency
-----------------------
 시스템은 앱의 메인 쓰레드에 생성하고, 앱은 필요에 따라 부가적인 작업 수행을 위해 쓰레드를 추가 생성할 수 있다. 
 iOS 앱에서는 직접 쓰레드를 생성하는 것보다 더 나은 GCD 라는 인터페이스를 제공한다. 시스템이 쓰레드를 관리하게 하면
작성해야 할 코드가 간결해지고, 코드의 정확성을 보장하며, 전반적인 성능 개선을 제공한다.

### 쓰레드 및 동시성을 생각할 때 고려해야할 것들
- 화면 작업시, Core Animation, 기타 UIKit 클래스들은 통상적으로 꼭 메인 쓰레드에서 동작해야 하는데 몇 가지 예외는 있다.
  (예를 들어, 종종 이미지 조작은 background 쓰레드에서 동작한다.) 하지만 미심적은 부분이 있다면 메인 쓰레드에서 작업해야 한다.
- 수행 시간이 긴 작업(잠재적으로 작업 시간이 길어질 수 있는 작업)들은 background 쓰레드에서 동작해야 한다.
  네트워크 연결, 파일 접근, 대량의 데이터 처리와 관련된 작업시엔 GCD 를 이용해 비동기적으로 작업해야 한다.
- 앱 실행 시점엔 작업들은 가급적 메인 쓰레드에서 수행해서는 안된다. 실행시엔 가능한 빠르게 화면을 표시하는게 중요하기 때문에 
  화면 구성을 위한 작업만 메인 쓰레드에서 수행되야 한다. 그 외의 작업들은 비동기적으로 수행되야 하며 결과는 사용자가 준비되는 대로
  가능한 빨리 표시된다.


[더 잘 번역된 블로그](http://rhammer.tistory.com/94)

* * *
Background Execution
=======================
 사용자 위치 트래킹 앱, 음악 앱, 백그라운드로 컨텐츠를 다운 받는 앱 등 background 상태에서 장시간 머물러야 할 경우가 있다.

* * *
Executing Finite-Length Tasks
-----------------------------
 앱이 background 로 전환시엔 가급적 빨리 대기상태로 들어가려고 함이다. 만약 상태 전환시 중간에 작업을 수행하고 싶다면
UIApplication 객체의 함수인 `beginBackgroundTask(withName:expirationHandler:)` 또는 
`beginBackgroundTask(expirationHandler:)` 을 이용해 약간의 작업수행 시간을 얻을 수 있고, 작업이 완료되면
`endBackgroundTask(_ identifier:)`: 함수를 호출하여 시스템에 작업이 완료된 것을 알려줘야 한다.

* * *
Downloading Content in the Background
-------------------------------------
 NSURLSession 을 사용해 background 로 컨텐츠를 다운 받는 경우

* * *
Implementing Long-Running Tasks
-------------------------------
 더 긴 시간동안 background 에서 동작하고 싶으면 몇 가지 사용자 인증을 받아야 한다.
- 음악 플레이어같이 background 에서 음성 컨텐츠를 재생하는 앱(audio)
- background 에서 음성 녹음을 하는 앱(audio)
- 네비게이션 같은 사용자의 위치 정보를 계속 사용해야 하는 앱(location)
- VoIP 를 지원하는 앱(voip)
- 주기적으로 새로운 컨텐츠를 다운 받아야 하는 앱(fetch)
- 외부 악세사리로부터 주기적으로 업데이트를 받아야 하는 앱(external-accessory)

*background 작업을 지원하는 앱 선언*
 앱의 info.plist 파일에 UIBackgroundModes 를 추가하고 값을 설정해줘야 한다.
- Audio and AirPlay: audio
- Location updates: location
- Voice over IP: voip
- Newsstand downloads: newsstand-content
- External accessory communication: external-accessory
- Use Bluetooth LE accessories: bluetooth-central
- Acts as a Bluetooth LE accessory: bluetooth-peripheral
- Background fetch: fetch
- Remote notifications: remote-notification

* * *
Opting Out of Background Execution
-------------------------------------------------------------
 아예 background 실행을 지원하지 않으려면 info.plist 에 UIApplicationExitsOnSuspend 키를 명시적으로 추가해야 한다.
이렇게 하면 active - inactive 사이에 background, suspend 상태가 동작하지 않는다.
사용자가 홈 버튼을 누르면 `applicationWillTerminate()` 함수가 호출된다. 앱이 정리되어 main thread 를 탈출할때까지 약 5초가 걸린다.



Strategies for Handling App State Transition
============================================
 시스템은 앱이 각 상태에 따라 다른 반응을 하길 기대한다. 상태 전환 발생시 시스템은 앱 객체에 전달되고 UIApplicationDelegate protocol 이
이를 감지하여 상태 전환시 적절한 반응을 하도록 한다.
***
* * *
What to Do at Launch Time
-------------------------
 앱 런치시(background, foreground 진입시도 마찬가지) 앱은 delegate 의 `application(_:willFinishLaunchWithOptions:)`, 
`application(_:didFinishLaunchWithOptions:)` 함수는 아래와 같은 일을 한다.
- 앱이 왜 실행됐는지 확인을 위해 launch options 딕셔너리에 저장된 컨텐츠를 확인하여 적절한 반응을 한다.
- 앱에 중요한 데이터 구조를 초기화 한다.
- 앱의 윈도우와 화면들을 표시하기 위한 준비를 한다.
 - OpenGL ES 를 사용하는 경우 drawing 환경을 준비하기 위해 이 함수들을 사용하면 안된다. 대신 
   `applicationDidBecomeActive(:)` 함수 호출뒤로 drawing 코드를 옮겨야 한다.
 - 윈도우는 `application(_:willFinishLaunchWithOptions:)` 함수에서 표시해라. UIKit 은 
   `application(_:didFinishLaunchWithOptions:)` 함수가 return 될 때까지 윈도우가 보여지지 않도록 지연시킨다.
   (Show your app window from your application:willFinishLaunchingWithOptions: method. UIKit delays making the window visible until after the application:didFinishLaunchingWithOptions: method returns.)
 
 앱 런치시 시스템은 자동으로 스토리보드 파일을 로드하여 초기 뷰 컨트롤러를 로드한다. 상태 복원을 지원하는 앱은 
`application(_:willFinishLaunchWithOptions:)`, `application(_:didFinishLaunchWithOptions:)` 함수 호출 이전
상태로 화면을 복원한다. 
 `application(_:willFinishLaunchWithOptions:)` 함수를 사용하면 앱의 윈도우를 표시하고 상태 복원을 
수행해야 할지 결정한다. `application(_:didFinishLaunchWithOptions:)` 함수를 사용하면 앱 화면을 최종적으로 조정 한다.
 두 함수는 가능한 5초 이내로 화면이 표시되도록 가볍게 동작해야 한다. 그렇지 않으면 시스템은 앱을 종료시킨다. 앱 시동 시간을
늦출만한 작업들은 추가 쓰레드에서 수행해야 한다.

* * *
The Launch Cycle
----------------
 아래 그림은 앱이 실행된 후 foreground 로 진입시 발생하는 이벤트 절차를 보여준다.
- <img src="https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Art/app_launch_fg_2x.png" alt="Launching an app into the foreground" width="550">

 앱이 background 로 시작될 때(보통 몇 개의 background 이벤트 처리를 위해)는 위의 그림과는 약간 다르다.
- <img src="https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Art/app_launch_bg_2x.png" alt="Launching an app into the background" width="550">

 앱이 foreground, background 로 실행시 UIApplication 객체의 applicationState 프로퍼티를 확인하여
`application(_:willFinishLaunchWithOptions:)` 함수와 `application(_:didFinishLaunchWithOptions:)` 함수중 
어떤걸 호출할지 결정한다. foreground 로 실행시 이 프로퍼티는 UIApplicationStateInactive, background 로 실행시는
UIApplicationStateBackground 값을 가진다. 이 차이를 이용하여 delegate 함수의 실행시 행위를 조절할 수 있다.
##### url 을 열 수 있는 상태로 앱이 실행된다면 위의 그림들과는 또 다른 절차를 따른다. 자세한 내용은 다음 링크로 확인하라.
[링크](https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Inter-AppCommunication/Inter-AppCommunication.html#//apple_ref/doc/uid/TP40007072-CH6-SW13)

* * *
What to Do When Your App is Interrupted Temporarily
---------------------------------------------------
 얼럿에 의한 차단은 잠시동안 앱을 제어하지 못하도록 한다. 앱은 foreground 상태로 동작중이지만 시스템으로부터 터치 이벤트를 전달받지 못한다.
(그럼에도 불구하고 알림이나 가속도계 이벤트 같은 다른 타입의 이벤트들은 전달된다.) 이런 변화에 대응하고 싶으면 
`applicationWillResignActive(:)` 함수는 아래와 같은 동작을 해야 한다.
- 데이터 및 상태와 연관된 정보를 저장한다.
- timer 및 다른 주기적인 동작을 멈춘다.
- 메타데이터 쿼리를 멈춘다.
- 새로운 작업을 시작하지 않는다.
- 영상 플레이백을 일시정지한다.(단 AirPlay 인 경우는 예외로 한다.)
- 게임 앱인 경우 일시정지 상태로 진입시킨다.
- OpenGL ES frame rate 를 감소시킨다.
- 필수적이지 않은 작업에 대한 dispatch/operation queue 를 보류시킨다.(네트워크 작업이나 시간에 민감한 작업들은 inactive 상태에서 계속할 수 있다.)

 앱이 다시 활성화되면 `applicationDidBecomeActive(:)` 함수가 `applicationWillResignActive(:)` 함수에서 정지시킨 모든 상태들을 역전시킨다.
단 게임 앱의 경우 사용자가 다시 시작하지 않으면 일시정지 상태로 남아있는다. 
 만약 파일 작업을 하고 있었다면 `applicationWillResignActive(:)` 함수에서 모든 파일을 close 해야하고, `applicationDidBecomeActive(:)` 함수에서
다시 open 해야 한다.
##### 사용자 정보는 항상 적절한 시기에 저장해야 한다. 앱 상태 전환시 강제로 저장시킬 수도 있으나 그것 보다는 사용자 정보를 관리하는 화면이 해제될때 저장시키는 것이 더 적절하다.

* * *
Responding to Temporary Interruptions
-------------------------------------
 얼럿에 의한 차단 제어는 아래 그림과 같이 이루어 진다.
- <img src="https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Art/app_interruptions_2x.png" alt="Launching an app into the background" width="550">

* * *
What to Do When Your App Enters the Foreground
----------------------------------------------
 background 에서 foreground 로 상태 전환은 아래 그림과 같이 이루어 진다.
- <img src="https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Art/app_enter_foreground_2x.png" alt="Launching an app into the background" width="550">

* * *
What to Do When Your App Enters the Background
----------------------------------------------
 foreground 에서 background 로 상태 전환시 `applicationDidEnterBackground(:)` 함수는 아래와 같은 동작을 해야 한다.
- 함수가 return 되면 시스템은 앱의 화면을 전환 애니메이션용 이미지로 캡쳐한다. 만약 민감한 정보 또는 숨겨져야할 정보가 표시되고 있다면 함수가 return 되기 전에 화면을 조작해야한다.
  (자세한 사항은 [링크](https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/StrategiesforHandlingAppStateTransitions/StrategiesforHandlingAppStateTransitions.html#//apple_ref/doc/uid/TP40007072-CH8-SW27) 확인)
- 앱의 상태와 관련된 정보를 저장해야 한다. background 진입전 중요한 사용자 정보는 이미 저장되어 있어야 한다. background 전환시는 앱의 마지막 상태 정보를 저장한다.
- 필요하다면 메모리를 확보해라. 더이상 필요하지 않은 임시 저장된 데이터를 제거하고, 애플리케이션의 메모리 공간을 줄일 수 있는 간단한 정리를 해라
  (자세한 사항은 [링크](https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/StrategiesforHandlingAppStateTransitions/StrategiesforHandlingAppStateTransitions.html#//apple_ref/doc/uid/TP40007072-CH8-SW28) 확인)

 `applicationDidEnterBackground(:)` 함수는 작업 종료를 위해 약 5초간 시간을 가진다. 그 이상 시간이 걸리면 시스템은 앱을 종료시킨다. 그 이상 시간이 걸리는 작업은
 `beginBackgroundTask(expirationHandler:)` 함수를 사용해라.

* * *
The Background Transition Cycle
-------------------------------
 사용자가 홈버튼을 누르거나, 전원버튼으로 앱을 sleep/wakeup 시키거나, 시스템이 다른 앱을 실행시키는 등의 일들은 앱의 상태를 foreground -> inactive -> background 로 전환시킨다.
foreground 에서 background 로 상태 전환은 아래 그림과 같이 이루어 진다.
- <img src="https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Art/app_bg_life_cycle_2x.png" alt="Moving from the foreground to the background" width="550">

* * *
Prepare for the App Snapshot
----------------------------
 앱은 background 진입 후 스냅샷을 생성한다. 이와 마찬가지로 멀티테스킹 화면을 위해 백그라운드 작업중 앱이 깨어날 때 변경사항이 업데이트된 스냅샷을 생성할 수 있다.
시스템은 멀티태스킹 화면에서 이 스냅샷을 이용할 수 있다.


* * *
Use Memory Efficiently
======================
앱은 가능한 적은 메모리를 사용해야하는데 그 이유는 기기에 가용한 메모리와 앱의 성능 사이에는 직접적인 상관관계가 있기 때문이다.
***

* * *
Observe Low-Memory Warnings
---------------------------
시스템이 앱으로 메모리 부족 경고를 보내면 즉시 대응해야 한다. 경고는 앱에서 더이상 사용하지 않는 메모리를 제거할 기회를 제공한다. 경고에 대응하는 것은 매우 중요하다. 왜냐하면 만약 대응을 제대로 하지 못하면 앱이 종료될 것이기 때문이다.
app delegate 의 applicationDidReceiveMemoryWarning, view controller 의 didReceiveMemoryWarning, UIApplicationDidReceiveMemoryWarningNotification 노티피케이션, DISPATCH_SOURCE_TYPE_MEMORYPRESSURE 형식의 dispatch source 를 이용하여 경고에 대응 할 수 있다.
(이중 DISPATCH_SOURCE_TYPE_MEMORYPRESSURE 는 유일하게 메모리 부족의 정도를 확인할 수 있다.)
경고를 받은 즉시 핸들러에서는 캐시 및 이미지를 삭제하고, 사용하지 않는 큰 데이터는 기기에 저장하고 메모리에서는 삭제하는 등의 적절한 대응을 즉시 시행해야 한다.
데이터 모델이 만약 Purgeable 리소스들을 포함하고 있다면 해당 리소스들의 매니져 객체에 UIApplicationDidReceiveMemoryWarningNotification 을 등록하여 직접 대응할 수 있다. 이렇게 하면 app delegate 의 메서드에서 따로 처리하지 않아도 된다.
(Purgeable Resources 란 Metal framework 의 GPU Resources 등 메모리에서 빠르게 처리해야하는 데이터를 말한다.)




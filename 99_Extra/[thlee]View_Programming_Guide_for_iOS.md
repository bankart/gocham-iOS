View Programming Guide for iOS
==============================
## The View Drawing Cycle
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






* * *
## Creating and Configuring View Objects
- viewController 와 연관되지 않은 nib 파일에서 view 를 디자인했다면 NSBundle, UINib 클래스로 부터 view 를 생성해야 한다.

- alpha, hidden, opaque: opacity(불투명도)와 연관된 properties. alpha, hidden 은 직접 opacity 를 변경하고, opaque 는 true 인 경우 해당 view 객체 하부에 존재하는 view 는 전혀 표시되지 않기때문에 불필요한 compositing 작업이 감소하게되어 성능을 향상시킬 수 있다.

- bounds, frame, center, transform: size, position 과 연관된 properties. center, frame 은 parent 와 연관된 position 을 나타내는데 frame 은 size 정보도 가지고 있다. bounds 는 자신의 좌표체계에서의 visible content area 이다. transform 은 view 를 이동시키거나 애니메이트 시키는 복잡한 작업에 사용된다.

- autoresizingMask, auroresizesSubviews: view 와 subviews 에 영향을 주는 automatic resizing behavior 이다. autoresizingMask 는 parent 의 bounds 가 변경될 시 어떻게 반응해야하는지를 제어한다. autoresizesSubviews 는 자신의 subviews 를 resize 하는지의 여부를 제어한다.

- contentMode, contentStretch, contentScaleFactor: view 안에 담긴 content 를 어떻게 렌더링하는지에 대한 behavior 이다. contentMode, contentStretch 는 자신의 width, height 변경시 content 를 어떻게 처리할지 결정한다. contentScaleFactor 는 high - resolution screen 을 위해 drawing behavior 를 커스터마이징해야할 때만 사용한다.

- gestureRecognizers, userInteractionEnabled, multipleTouchEnabled, exclusiveTouch: touch event 에 영향을 주는 property 이다. gestureRecognizers 는 attatched 된 gesture recognizer 들을 저장하고 있다. 자세한 사항은 Event Handling Guide for iOS 를 확인할 것.

- backgroundColor, subviews, drawRect, layer: 실제 content 들을 관리하는 property, method 이다. 
(For simple views, you can set a background color and add one or more subviews. The subviews property itself contains a read-only list of subviews, but there are several methods for adding and rearranging subviews. For views with custom drawing behavior, you must override the drawRect: method.
For more advanced content, you can work directly with the view’s Core Animation layer. To specify an entirely different type of layer for the view, you must override the layerClass method.)


* * *
## Creating and Managing a View Hierarchy
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






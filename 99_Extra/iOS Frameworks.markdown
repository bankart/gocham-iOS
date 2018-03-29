[iOS Frameworks @ passiblemobile](https://possiblemobile.com/2016/08/ios-frameworks-part-2-build-and-ship/)
## iOS Frameworks

#### New Project
* **Cocoa Touch Framework:** This project builds a dynamic framework which will be loaded by one or more of your app targets and dynamically-linked at run time.
* **Cocoa Touch Library:** This project builds a binary which can be statically-linked to your app, which means that the binary is copied and linked at compile time.

For clarity, let’s go over a few definitions.

* **Dynamic Framework:** When we talk about a dynamic framework, we’re referring to the product of the Cocoa Touch Framework template which is intended to be dynamically-linked to our app.
* **Static Framework:** Note that the Xcode templates do not offer a “Static Framework” option. When we talk about static frameworks, we mean the result of taking a Cocoa Touch Library and packaging it as a framework.
* **Universal Static Framework:** The universal static framework expands a static framework by concatenating multiple binaries, each for a different architecture, into one binary so a single package can be distributed for use by more than one system architecture.

#### Dynamic Frameworks
* 2014 WWDC [Building Modern Frameworks](https://developer.apple.com/videos/play/wwdc2014/416/) session에서 처음 소개되었고, iOS8부터 사용가능함.
* 그러나 Swift의 ABI stability가 확보되지 않았기 때문에 binary framework을 사용하는 것은 위험함.
* runtime vs. buildtime,앱을 dynamic frameworks로 나누면
	* build time을 줄여주는 장점이 있으나,
	* app startup time을 늘리게 됨 
	* Apple은 target을 6개정도로 제한하는 것을 추천함 
	* [WWDC 2016 Optimizing App Startup Time](https://developer.apple.com/videos/play/wwdc2016/406/)

#### Universal Static Frameworks
* 매우 중요하고 활용도 높은 framework은 Objective-C base의 univesrsal static framework으로 만드는 것을 추천함
* Dropbox가 swift SDK를 2015/05 내놨다가 하위 호환성 문제로 크게 까이고 2016년 8월에 Objective-C버전을 다시 내어놓음.

#### CocoaPods, Carthage, SPM(swift package manager)



[Swift compatibility @ apple's blog](https://developer.apple.com/swift/blog/?id=2)
#### App Compatibility
* (2014년 여름 기준) iOS8, OS X Yosemite 뿐만 아니라 iOS7, OS Mavericks도 지원된다. Package에 small Swift runtime library가 추가되기 때문에 (by Xcode) 과거, 현재, 미래의 OS에서 일관성있는 Swift가 실행될 수 있다.
	* libswift*.dylib (Core, Darwin, Foundation, UIKit,...)

#### Binary Compatibility 
* Swift 언어는 계속 진화하고 있고 binary interface 또한 바뀌고 있다. 안정성을 위해 app의 모든 components는 같은 version의 Xcode로 build되어야 한다. 
* 특히 third party ***binary*** frameworks 사용 시 조심하여야 함
* (2014년 기준) 1,2년 뒤 binary interface가 안정화되면, Swift runtime은 host OS의 일부가 될 것이고 이런 제약이 사라질 것이다. (현재 기준 Swift4.0 - 2017년말에 계획되어있음)

> ABI : Application Binary Interface

#### Source Compatibility
* (2014년 기준) Swift는 계속 진화하고, 우리(애플)은 Xcode에 migrate tool을 제공할 것이다. =_='




 

* Apple이 CPU Architecture 변화에 유동적으로 대응하기 위해 만든 LLVM IR의 일종이다.
	* Architecture 독립적이지 않음!!
	* App submit 후 apple server에 의해 machine code로 재 컴파일될 수 있다.
		* Re-optimze 가능하다. (이게 당장 이득을 볼 수 있는 내용)
	* WatchOS, TVOS에서는 필수적으로 사용해야한다.
		* iOS는 default enabled이나 필수는 아니다.
	* (하위 호환성을 위해..maybe) Architecture별 __LLVM section이 말려들어간다. 
		* 즉 universal binary인 경우 arch별 여러벌의 bitcode section이 추가된다는 이야기.
	* bitcode는 all or nothing, 즉 application에서 link되는 모든 library(framework)에서 bitcode가 사용되어야 적용가능하다. 



* bitcode is only packed on ```archive``` build for iphoneos sdk
* bitcode is an intermediate LLVM IR compiled by Xcode, and is arch-dependent, not like the java bytecode, so every slice need its own bitcode section.
  Since it's a intermediate code, so apple can use it to optimize to the final machine code in the future without uploading a new version, this is the main purpose 

```
// bitcode 확인 시 arch를 명시적을 입력해야
otool -arch arm64 -l myLipoOutput.a


// to check whether bitcode is included, 
// if you don't specify the arch parameter, there will be no __LLVM, 
// since otool just print one host arch(simulator).
otool -l -arch arm64 <yourframework_binary> | grep __LLVM 
```
---

[링크](http://stackoverflow.com/questions/31486232/how-do-i-xcodebuild-a-static-library-with-bitcode-enabled)

Bitcode는 compile-time feature임. (Not a link-time feature)
bitcode enabled로 빌드된 모든 .o file이 "__bitcode"라는 추가적인 section을 가지게 됨 (otool로 확인가능)

Xcode에서 일반적인 빌드를 수행하게되면 빌드 flag ```-fembed-bitcode-marker``` 가 켜지게 됨.
이는 실제 컨텐츠가 없는 최소크기의 embeded bitcode section을 추가하게하는데, 
빌드 과정의 속도 저하없이 bitcode 연관된 aspects를 테스트하기 위해 사용하게된다.
실제 bitcode content는 archive build 시 추가되게 된다. 이 때 ```-fembed-bitcode``` 옵션이 사용됨.

정리하면 
1. If you are not using Xcode, please manually add -fembed-bitcode command line option.
2. When using Xcode, bitcode is only produced during archive build, not debug or release build.


[https://forums.developer.apple.com/message/7038](https://forums.developer.apple.com/message/7038)

```
ENABLE_BITCODE=YES with build action =>
	* BITCODE_GENERATION_MODE=marker
ENABLE_BITCODE=YES with archive action =>
	* BITCODE_GENERATION_MODE=bitcode
=marker: -fembed-bitcode-marker is passed to the compiler
=bitcode: -fembed-bitcode is passed to the compiler

Setting BITCODE_GENERATION_MODE=bitcode explicitly enables embedding full bitcode for build action
```

----

### `*.bcsymbolmap` files

* Required for mapping bitcode with dSYM files.
* Must be included in the archive if you check on both "Include app symbols for..." and "Include bitcode" when you validate or upload to iTC

> The archive did not contain <DVTFilePath:0x7f88ca959ef0:'${Path}.xcarchive/BCSymbolMaps/${name}.bcsymbolmap'> as expected.


### [Xcode Help]

**Bitcode**
Bitcode is an intermediate representation of a compiled program. 
Apps you upload to iTunes Connect that contain bitcode will be compiled and linked on the App Store. 
Including bitcode will allow Apple to re-optimize your app binary in the future without the need to submit a new version of your app to the App Store.

For iOS apps, bitcode is the default, but optional. For watchOS and tvOS apps, bitcode is required. 
If you provide bitcode, all apps and frameworks in the app bundle (all targets in the project) need to include bitcode.

Xcode hides your app’s symbols by default, so they are not readable by Apple. 
When you upload your app to iTunes Connect, you have the option of including symbols. 
Including symbols allows Apple to provide crash reports for your app when you distribute your app using TestFlight or distribute your app through the App Store. 
If you’d like to collect and symbolicate crash reports yourself, you don’t have to upload symbols. 
Instead, you can download the bitcode compilation dSYMs files after you distribute your app.



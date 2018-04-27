View Controller Programming Guide for iOS
============================================

## Displaying UIView at runtime
1. storyboard 로부터 view 에 대한 정보를 획득한 후 view 를 객체화
2. outlets, actions 연결
3. viewController.view 로 root view 설정
4. awakeFromNib 메서드 호출(호출시 viewController 의 trait collection 이 비어있고, ui 들이 정확한 위치를 잡지 못할 수 있다.)
5. viewDidLoad 메서드 호출. add/remove views, modify layout constraints, load data for views 수행

### Before Displaying onscreen(UIKIt gives you some chance to prepare)
1. viewWillAppear 메서드 호출로 화면 표시가 임박했음을 알림
2. 이때 추가적으로 updates the layout of the views
3. 화면 표시
4. viewDidAppear 메서드 호출

add/remove views, modify size/position 등 layout 관련 변경 발생시 UIKit 은 layout 이 dirty 하다고 marking, 다음 UI update cycle 에 해당 UI 를 갱신한다.



* * *
## Managing View Layout
size/position 등 layout 관련 변경 발생시 UIKit 은 layout 을 변경한다. view 가 auto layout 을 사용한다면 해당 constraint 를 기준으로 update 하고, 인접한 UI 들도 UIKit 의 도움으로 해당 update 에 적절한 반응을 할 수 있다.

아래와 같이 UIKit 은 알림을 통해 layout process 진행 중 추가적인 layout 관련 작업을 수행할 수 있도록 도와준다.

1. 필요시 viewController 의 trait collection 과 views 를 update
2. viewController.viewWillLayoutSubviews 메서드 호출
3. viewController.containerViewWillLayoutSubviews 메서드 호출
4. viewController.view.layoutSubviews 메서드 호출하여 새로운 layout constraint 적용. view 의 hierachy 를 순회하며 하위 view.layoutSubviews 를 호출.
5. 새로운 layout constraint 적용
6. viewController.viewDidLayoutSubviews 메서드 호출
7. viewController.containerViewDidLayoutSubviews 메서드 호출


viewWillLayoutSubviews/viewDidLayoutSubviews 메서드에서 추가적으로 layout process 에 영향을 줄 수 있는 작업을 진행할 수 있다. viewWillLayoutSubviews 에서 add/remove views, update size/position for views, update constraint... 등을 수행할 수 있고, viewDidLayoutSubviews 에서는 table/collection view data 를 reload 하거나, 다른 view 의 content 를 update 그리고 최종적으로 view 의 size/position 을 조정할 수 있다.


### tips for managing layout effectively
- Use Auto Layout: 다양한 사이즈의 화면 대응
- Take advantage of the top and bottom layout guide: 항상 view 가 보이도록 도와줌. 상단은 navi/status bar, 하단은 tab/tool bar 를 고려한 값을 제공함
- Remember to update constraint when adding/removing views
- Remove constraints tempoarly while animating your view controller's views: 애니메이션 완료 후 변경된 constraint 를 다시 적용해라


* * *
### some implmentations
- adding a child view controller to your content
``` swift
func displayContentController(content: UIViewController) {
	addChildViewController(content)
	content.view.frame = frameForContentController()
	addSubview(currentClientView)
	content.didMoveToParentViewController(self)
}
```

- removing a child view controller
``` swift
func hideContentController(content: UIViewController) {
	content.willMoveToParentViewController(nil)
	content.view.removeFromSuperview()
	content.removeFromParentViewController()
}
```

- transitioning between two child view controllers
``` swift
func cycle(from oldVC: UIViewController, to newVC: UIViewController) {
	oldVC.willMoveToParentViewController(nil)
	addChildViewController(newVC)

	newVC.view.frame = newViewStartFrame()
	let endFrame = oldViewEndFrame()

	transition(from: oldView, to: newView, duration: 0.25, options: nil, animations: {
		newVC.view.frame = oldVC.view.frame
		oldVC.view.frame = endFrame
		}, completion: {
			oldVC.removeFromParentViewController()
			newVC.didMoveToParentViewController(nil)
			})
}
```

- restoring view controllers at launch time
 : for UI base, in Interface Builder set Restoratin ID
``` swift
ViewController: UIStateRestoring {
	override func encodeRestorableStateWithCoder(coder: NSCoder) {
		if let petId = petId {
			coder.encodeInteger(petId, forKey: "petId")
		}
		...
		super.encodRestorableStateWithCoder(coder)
	}

	override func decodeRestorableStateCoder(coder: NSCoder) {
		petId = coder.decodeInteger("petId")
		...
		super.decodeRestorableStateCoder(coder)
	}

	override func applicationFinishedRestoringState() {
		guard let petId = petId else { return }
		currentPet = MatchedPetsManager.shared.petForId(petId)
	}
}
AppDelegate {
	func application(application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
		return true
	}

	func application(application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
		return true
	}
}
```

 - for code base... adopt UIViewControllerRestoration. 코드 생략...


### Displaying a view controller using a segue
![Figure 9-4](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_displaying-view-controller-using-segue_9-4_2x.png)


### Customizing the Transion Animations
[assoiated link](https://www.raywenderlich.com/170144/custom-uiviewcontroller-transitions-getting-started)

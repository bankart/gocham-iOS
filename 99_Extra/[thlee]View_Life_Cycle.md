View/ViewController Life Cycle
==============================

### [use view with storyboard]

- view controller
    - present >>
        1. init(coder:)
        2. awakeFromNib()
        3. loadView()
        4. viewDidLoad()
        5. viewWillAppear
        6. viewDidAppear

    - dismiss >>
        1. viewWillDisappear
        2. viewDidDisappear
        3. deinit

- view
    - present >>
        1. init(coder:)
        2. awakeFromNib()
        3. draw

    - dismiss >>
        1. deinit



### [use view with code]

- view controller
    - present >>
        1. init(nibName:bundle:) - NibName: nil, Bundle: nil
        2. loadView()
        3. viewDidLoad()
        4. viewWillAppear
        5. viewDidAppear

    - dismiss >>
        1. viewWillDisappear
        2. viewDidDisappear
        3. deinit

- view
    - present >>
        1. init(frame:)
        2. draw

    - dismiss >>
        1. deinit



* * *
viewWillAppear 와 viewDidAppear 사이에 viewWillLayoutSubviews, viewDidLayoutSubviews method 가 호출되어 layout 을 설정함





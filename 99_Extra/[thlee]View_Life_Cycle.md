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









ViewController loadView()
ViewController viewDidLoad()
ViewController viewWillAppear
make label
set label.backgroundColor
set label.translatesAutoresizingMaskIntoConstraints
    TestCell init(frame:)
add label to TestCell
set label.constraint >>>
set label.constraint <<<
make label
set label.backgroundColor
set label.translatesAutoresizingMaskIntoConstraints
    TestCell init(frame:)
add label to TestCell
set label.constraint >>>
set label.constraint <<<
make label
set label.backgroundColor
set label.translatesAutoresizingMaskIntoConstraints
    TestCell init(frame:)
add label to TestCell
set label.constraint >>>
set label.constraint <<<
make label
set label.backgroundColor
set label.translatesAutoresizingMaskIntoConstraints
    TestCell init(frame:)
add label to TestCell
set label.constraint >>>
set label.constraint <<<
make label
set label.backgroundColor
set label.translatesAutoresizingMaskIntoConstraints
    TestCell init(frame:)
add label to TestCell
set label.constraint >>>
set label.constraint <<<
make label
set label.backgroundColor
set label.translatesAutoresizingMaskIntoConstraints
    TestCell init(frame:)
add label to TestCell
set label.constraint >>>
set label.constraint <<<
make label
set label.backgroundColor
set label.translatesAutoresizingMaskIntoConstraints
    TestCell init(frame:)
add label to TestCell
set label.constraint >>>
set label.constraint <<<
make label
set label.backgroundColor
set label.translatesAutoresizingMaskIntoConstraints
    TestCell init(frame:)
add label to TestCell
set label.constraint >>>
set label.constraint <<<
ViewController viewWillLayoutSubviews()
ViewController viewDidLayoutSubviews()
ViewController viewDidAppear
ViewController viewWillLayoutSubviews()
ViewController viewDidLayoutSubviews()
ViewController viewWillLayoutSubviews()
ViewController viewDidLayoutSubviews()






destination is TestViewController
TestViewController loadView()
TestViewController viewDidLoad()
add button to TestViewController
make button
    TestButton setNeedsDisplay()
set button.translatesAutoresizingMaskIntoConstraints
set button.title
    TestButton setNeedsLayout()
set button.backgroundColor
set button.addTarget(:::)
    TestButton didMoveToSuperview()
set button.constraint >>>
set button.constraint <<<
ViewController viewWillDisappear
TestViewController viewWillAppear
TestViewController viewWillLayoutSubviews()
    TestButton setNeedsLayout()
    TestButton setNeedsLayout()
    TestButton setNeedsLayout()
TestViewController viewDidLayoutSubviews()
TestViewController viewWillLayoutSubviews()
TestViewController viewDidLayoutSubviews()
TestViewController viewDidAppear
ViewController viewDidDisappear





    TestButton setNeedsLayout()
    TestButton setNeedsLayout()
TestViewController viewWillDisappear
ViewController viewWillAppear
ViewController viewDidAppear
TestViewController viewDidDisappear
TestViewController dimissed
TestViewController deinit
    TestButton didMoveToSuperview()
    TestButton.deinit





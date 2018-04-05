//
//  CoffeeShop.swift
//  SwiftAndProtocolOrientedProgramming
//
//  Created by taehoon lee on 2018. 3. 29..
//  Copyright © 2018년 taehoon lee. All rights reserved.
//

import Foundation

/// 커피 추출을 위한 프로토콜
protocol DripCoffeeDelegate: class {
    /// 커피 가루를 선택해 커피를 추출합니다.
    func drip(_ powder: CoffeePowder) -> Coffee
    /// 커피가 진하면 물을 추가해 희석할 수 있습니다.
    func dilute(_ coffee: Coffee, amountOfWater: Float) -> Coffee?
}

/// 커피 추출 준비를 위한 프로토콜
protocol DripCoffeeDataSource: class {
    /// 커피 가루의 수
    func numberOfCoffeePowders() -> Int
    /// 커피 추출을 위한 도구
    func equipments() -> [String]
    /// 커피 가루 생성
    func coffeePowder(index: Int) -> CoffeePowder
    /// 이미 있는 가루에서 amount 만큼 사용
    func coffeePowder(index: Int, amount: Float) -> CoffeePowder
    /// DripCoffeeDelegate 의 drip(_:) 에서 사용되는 커피 생성용 메서드
    func coffee(index: Int) -> Coffee?
    /// DripCoffeeDelegate 의 dilute(_::) 에서 사용되는 커피 희석용 메서드
    func coffee(index: Int, size: Coffee.Size) -> Coffee?
}

/// 커피 가루
class CoffeePowder {
    /// 로스팅 정도
    enum RoastLevel: String {
        case everGreen, lightGreen, gray, brown, darkBrown
    }
    
    var name: String
    var countryOfOrigin: String
    var roastLevel: RoastLevel
    var amount: Float
    
    init(name: String, countryOfOrigin: String, roastLevel: RoastLevel, amount: Float) {
        self.name = name
        self.countryOfOrigin = countryOfOrigin
        self.roastLevel = roastLevel
        self.amount = amount
    }
    
    /// 커피 추출시 컵 사이즈에 맞춰 가루 용량을 줄임
    func use(size: Coffee.Size) -> CoffeePowder {
        amount -= CoffeeCenter.UnitConverter.coffeeAmount(of: size)
        return self
    }
    
    /// 커피 추출시 사용된 용량에 맞춰 가루 용량을 줄임
    @discardableResult
    func use(amount: Float) -> CoffeePowder {
        self.amount -= amount
        return self
    }
    
    /// 모자란 커피 가루 추가
    func add(amount: Float) -> CoffeePowder {
        self.amount += amount
        return self
    }
}

extension CoffeePowder: CustomStringConvertible {
    var description: String {
        return "\n name: \(name), countryOfOrigin: \(countryOfOrigin), roastLevel: \(roastLevel.rawValue), amount: \(amount)"
    }
}


/// 커피
class Coffee {
    /// 커피 컵 사이즈
    enum Size: String {
        case short, tall, large, grande
    }
    
    var powder: CoffeePowder
    var size: Size
    var volume: Float
    var iced: Bool
    var isDiluted: Bool = false
    
    init(powder: CoffeePowder, size: Size, iced: Bool) {
        self.powder = powder
        self.size = size
        self.iced = iced
        self.volume = CoffeeCenter.UnitConverter.coffeeVolume(of: self.size)
    }
}

extension Coffee: CustomStringConvertible {
    var description: String {
        return "\n name: \(powder.name), size: \(size.rawValue), volume: \(volume), iced: \(iced), isDiluted: \(isDiluted)"
    }
}


/// 커피 가루 생성을 위한 팩토리
class CoffeeFactory {
    /// 아래의 3가지 원두만 취급함
    static let coffees = ["Brazil Santos": CoffeePowder.RoastLevel.brown,
                          "Kenya AA": CoffeePowder.RoastLevel.darkBrown,
                          "Costa Rica": CoffeePowder.RoastLevel.brown]
    
    private static func roasting(_ name: String, level: CoffeePowder.RoastLevel) -> CoffeePowder? {
        var powder: CoffeePowder?
        for (key, value) in coffees {
            if key == name {
                powder = CoffeePowder(name: key, countryOfOrigin: key.components(separatedBy: " ").first!, roastLevel: value, amount: 500.0)
                break
            }
        }
        return powder
    }
    
    /// 원두를 선택하면 roasting(_::) 메서드를 이용해 커피 가루를 만들어 반환
    static func coffeePowder(_ name: String) -> CoffeePowder? {
        return roasting(name, level: .everGreen)
    }
    
    /// 커피 가루로 커피 한잔 생성
    static func coffee(_ powder: CoffeePowder, size: Coffee.Size, iced: Bool) -> Coffee {
        return Coffee(powder: powder, size: size, iced: iced)
    }
}


/// DripCoffeeDelegate, DripCoffeeDataSource 를 이용해 커피 추출을 위한 작업을 진행하는 곳
class CoffeeCenter {
    /// 커피 컵 사이즈와 커피 가루, 커피 용량 변환을 위한 utility
    struct UnitConverter {
        static func coffeeSize(of amount: Float) -> Coffee.Size {
            if amount <= 40.0 {
                return .short
            } else if amount > 40.0 && amount <= 50.0 {
                return .tall
            } else if amount > 50.0 && amount <= 60.0 {
                return .large
            } else {
                return .grande
            }
        }
        
        static func coffeeAmount(of size: Coffee.Size) -> Float {
            switch size {
            case .short: return 40.0
            case .tall: return 50.0
            case .large: return 60.0
            case .grande: return 80.0
            }
        }
        
        static func coffeeVolume(of size: Coffee.Size) -> Float {
            switch size {
            case .short: return 230.0
            case .tall: return 320.0
            case .large: return 380.0
            case .grande: return 450.0
            }
        }
    }
    
    weak var delegate: DripCoffeeDelegate?
    weak var dataSource: DripCoffeeDataSource?
    private var equipments:[String]?
    private let minimumCoffeePowderCapacity: Float = 100.0
    private let reloadCoffeePowderCapacity: Float = 600.0
    
    /// 커피 추출 준비
    func ready() {
        guard let _ = dataSource?.numberOfCoffeePowders() else {
            print("have no coffee powders!")
            return
        }
        equipments = dataSource!.equipments()
    }
    
    /// 커피 추출
    func makeCoffee(powder: CoffeePowder, size: Coffee.Size, iced: Bool) -> Coffee? {
        print("커피 추출 준비")
        guard let delegate = delegate else {
            print("커피 추출 실패")
            return nil
        }
        let coffee = delegate.drip(powder)
        coffee.iced = iced
        return coffee
    }
    
    func reloadCoffeePowdersIfNeeded(_ coffeePowders: inout [CoffeePowder]) {
        coffeePowders = coffeePowders.map{
            if $0.amount < minimumCoffeePowderCapacity {
                print("\($0.name) 가루 모자람. (amount = \($0.amount)) 가루 추가! + \(reloadCoffeePowderCapacity)")
                return $0.add(amount: reloadCoffeePowderCapacity)
            } else {
                return $0
            }
        }
    }
    
}

/// 커피숍
class CoffeeShop {
    
    private var coffeePowders = [CoffeePowder]()
    private weak var center: CoffeeCenter?
    private var orderedInfo: (size: Coffee.Size, iced: Bool)?
    
    init(_ coffeeCenter: CoffeeCenter) {
        print("커피숍 개점")
        self.center = coffeeCenter
        self.center?.dataSource = self
        self.center?.delegate = self
        
        for (coffeeName, _) in CoffeeFactory.coffees {
            addCoffee(coffeeName)
        }
        
        center?.ready()
    }
    
    func showCoffeeList() -> [CoffeePowder] {
        return coffeePowders
    }
    
    func order(_ powder: CoffeePowder, size: Coffee.Size, iced: Bool) -> Coffee? {
        print("커피 주문: \(powder.name), size: \(size.rawValue), iced: \(iced)")
        orderedInfo = (size: size, iced: iced)
        return center?.makeCoffee(powder: powder, size: size, iced: iced)
    }
    
    /// 커피 가루 추가
    private func addCoffee(_ name: String) {
        print("커피 가루 준비중")
        if let powder = CoffeeFactory.coffeePowder(name) {
            coffeePowders.append(powder)
        }
        print("커피 가루 준비 완료")
    }
    
    private func checkCount(index: Int) {
        guard index < coffeePowders.count else {
            fatalError()
        }
    }
    
    private func checkCenter(fn:(CoffeeCenter) -> Void) {
        if let center = center {
            fn(center)
        }
    }
    
    private func usePowder(_ powderIndex: Int, amount: Float) -> CoffeePowder {
        print("커피 가루 찾는중...")
        let powder = coffeePowders[powderIndex]
        usePowder(powder, amount: amount)
        return powder
    }
    
    private func usePowder(_ powder: CoffeePowder, amount: Float) {
        print("커피 가루 사용중...")
        checkCenter {
            $0.reloadCoffeePowdersIfNeeded(&coffeePowders)
        }
        powder.use(amount: amount)
    }
    
}

extension CoffeeShop: DripCoffeeDelegate {
    func drip(_ powder: CoffeePowder) -> Coffee {
        var coffee: Coffee?
        print("커피 추출 시작")
        for i in 0..<coffeePowders.count {
            if coffeePowders[i].name == powder.name {
                coffee = self.coffee(index: i)
                break
            }
        }
        print("커피 추출 완료!")
        return coffee!
    }
    
    func dilute(_ coffee: Coffee, amountOfWater: Float) -> Coffee? {
        return nil
    }
}

extension CoffeeShop: DripCoffeeDataSource {
    func numberOfCoffeePowders() -> Int {
        print("커피숍에 준비된 커피 가루 종류: \(coffeePowders.count)")
        return coffeePowders.count
    }
    
    func equipments() -> [String] {
        return ["dripper", "dripPaper", "plask", "dripPod"]
    }
    
    func coffeePowder(index: Int) -> CoffeePowder {
        checkCount(index: index)
        print("커피 가루 찾는중...")
        return coffeePowders[index]
    }
    
    func coffeePowder(index: Int, amount: Float) -> CoffeePowder {
        checkCount(index: index)
        return usePowder(index, amount: amount)
    }
    
    func coffee(index: Int) -> Coffee? {
        checkCount(index: index)
        guard let orderedInfo = orderedInfo else {
            return nil
        }
        let powder = self.coffeePowder(index: index)
        usePowder(powder, amount: CoffeeCenter.UnitConverter.coffeeAmount(of: orderedInfo.size))
        let coffee = CoffeeFactory.coffee(powder, size: orderedInfo.size, iced: true)
        coffee.size = orderedInfo.size
        coffee.iced = orderedInfo.iced
        self.orderedInfo = nil
        return coffee
    }
    
    func coffee(index: Int, size: Coffee.Size) -> Coffee? {
        checkCount(index: index)
        return nil
    }
}


func testCoffeeShop() {
    print()
    let coffeeCenter = CoffeeCenter()
    let coffeeShop = CoffeeShop(coffeeCenter)
    var menu = coffeeShop.showCoffeeList()
    print()
    print("menu: \(menu)")
    if let dripCoffee = coffeeShop.order(menu[0], size: .tall, iced: true) {
        print(dripCoffee)
    }
    for _ in 0...6 {
        if let dripCoffee = coffeeShop.order(menu[1], size: .grande, iced: true) {
            print(dripCoffee)
        }
    }
    print()
    menu = coffeeShop.showCoffeeList()
    print("menu: \(menu)")
    print()
}

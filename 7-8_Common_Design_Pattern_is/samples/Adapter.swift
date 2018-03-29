//
//  Adapter.swift
//  SwiftAndProtocolOrientedProgramming
//
//  Created by taehoon lee on 2018. 3. 29..
//  Copyright © 2018년 taehoon lee. All rights reserved.
//

import Foundation

class LocalCoffeeShop {
    func roasting(_ beanName: String) {}
    func makeCoffee(_ kind: String) {}
    func wash() {}
    func order(_ beanName: String, company: String) {}
}

class JuiceShop {
    func pickFruit(_ fruitName: String) {}
    func grindFruit(_ kind: String) {}
    func wash() {}
    func order(_ fruitName: String, company: String) {}
}


protocol DrinkShop {
    func orderDrink(_ drinkName: String)
    func prepareDrink(_ kind: String)
    func wash()
    func order(_ productName: String, company: String)
}

class CoffeeShopAdapter: DrinkShop {
    let coffeeShop: LocalCoffeeShop
    init(_ coffeeShop: LocalCoffeeShop) {
        self.coffeeShop = coffeeShop
    }
    
    func orderDrink(_ drinkName: String) {
        coffeeShop.makeCoffee(drinkName)
    }
    func prepareDrink(_ kind: String) {
        coffeeShop.roasting(kind)
    }
    func wash() {
        coffeeShop.wash()
    }
    func order(_ productName: String, company: String) {
        coffeeShop.order(productName, company: company)
    }
}

class JuiceShopAdapter: DrinkShop {
    let juiceShop: JuiceShop
    init(_ juiceShop: JuiceShop) {
        self.juiceShop = juiceShop
    }
    
    func orderDrink(_ drinkName: String) {
        juiceShop.grindFruit(drinkName)
    }
    func prepareDrink(_ kind: String) {
        juiceShop.pickFruit(kind)
    }
    func wash() {
        juiceShop.wash()
    }
    func order(_ productName: String, company: String) {
        juiceShop.order(productName, company: company)
    }
}

class DrinkMarket {
    enum DrinkType {
        case coffee, juice
    }
    
    private lazy var coffeeShop: CoffeeShopAdapter = {
        return CoffeeShopAdapter(LocalCoffeeShop())
    }()
    
    private lazy var juiceShop: JuiceShopAdapter = {
        return JuiceShopAdapter(JuiceShop())
    }()
    
    func getCurrentShop(_ drinkType: DrinkMarket.DrinkType) -> DrinkShop {
        return (drinkType == .coffee) ? coffeeShop : juiceShop
    }
    
    func orderDrink(_ drinkType: DrinkMarket.DrinkType, drinkName: String) {
        let shop = getCurrentShop(drinkType)
        shop.prepareDrink(drinkName)
        shop.orderDrink(drinkName)
    }
    
    func washCups() {
        coffeeShop.wash()
        juiceShop.wash()
    }
    
    func orderProduct(_ productName: String, company: String) {
        coffeeShop.order(productName, company: company)
        juiceShop.order(productName, company: company)
    }
}


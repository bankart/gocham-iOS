//
//  ChickenSeller.swift
//  SwiftAndProtocolOrientedProgramming
//
//  Created by taehoon lee on 2018. 3. 29..
//  Copyright © 2018년 taehoon lee. All rights reserved.
//

import Foundation

protocol Food {
    func getStyle() -> FoodStyle
    func getIngredients() -> String
    func getCost() -> Float
}

enum FoodStyle {
    case raw, fried, boiled, steamed
}

class Chicken: Food {
    private let costPrice: Float = 1.0
    private var style: FoodStyle
    init(style: FoodStyle) {
        self.style = style
    }
    
    func getStyle() -> FoodStyle {
        return style
    }
    
    func getIngredients() -> String {
        return "Chicken"
    }
    
    private func evaluateCost(_ style: FoodStyle) -> Float {
        var sellingPrice: Float
        switch style {
        case .raw:
            sellingPrice = costPrice * 1.15
        case .fried:
            sellingPrice = costPrice * 1.75
        case .boiled:
            sellingPrice = costPrice * 2.0
        case .steamed:
            sellingPrice = costPrice * 2.25
        }
        return sellingPrice
    }
    
    func getCost() -> Float {
        return evaluateCost(style)
    }
}

class ChickenDecorator: Food {
    let decorator: Food
    let ingredientsSeparator = ", "
    
    required init(_ decorator: Food) {
        self.decorator = decorator
    }
    
    func getStyle() -> FoodStyle {
        return decorator.getStyle()
    }
    
    func getIngredients() -> String {
        return decorator.getIngredients()
    }
    
    func getCost() -> Float {
        return decorator.getCost()
    }
}

class SoySauceChicken: ChickenDecorator {
    required init(_ decorator: Food) {
        super.init(decorator)
    }
    
    override func getStyle() -> FoodStyle {
        return super.getStyle()
    }
    
    override func getIngredients() -> String {
        return super.getIngredients() + ingredientsSeparator + "Soy Sauce"
    }
    
    override func getCost() -> Float {
        return super.getCost() * 1.15
    }
}

class SpicyGalicChicken: ChickenDecorator {
    required init(_ decorator: Food) {
        super.init(decorator)
    }
    
    override func getStyle() -> FoodStyle {
        return super.getStyle()
    }
    
    override func getIngredients() -> String {
        return super.getIngredients() + ingredientsSeparator + "Spicy Red Pepper Sauce & Galic"
    }
    
    override func getCost() -> Float {
        return super.getCost() * 1.45
    }
}

func testDecorator() {
    let chicken = Chicken(style: .fried)
    print("chicken - cost: \(chicken.getCost()), ingredients: \(chicken.getIngredients())")
    let soySauceChicken = SoySauceChicken(chicken)
    print("soySauceChicken - cost: \(soySauceChicken.getCost()), ingredients: \(soySauceChicken.getIngredients())")
    let spicyGalicChicken = SpicyGalicChicken(chicken)
    print("spicyGalicChicken - cost: \(spicyGalicChicken.getCost()), ingredients: \(spicyGalicChicken.getIngredients())")
}

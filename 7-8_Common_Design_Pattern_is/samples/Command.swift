//
//  Command.swift
//  SwiftAndProtocolOrientedProgramming
//
//  Created by taehoon lee on 2018. 3. 29..
//  Copyright © 2018년 taehoon lee. All rights reserved.
//

import Foundation

protocol DrinkCommand {
    mutating func drink()
    mutating func refill(_ amount: Float)
    mutating func drinkUp()
}

struct CoffeePrototype: DrinkCommand {
    mutating func drink() {
        print("\(#function) hot!!")
    }
    mutating func refill(_ amount: Float) {
        print("\(#function) need more caffein")
    }
    mutating func drinkUp() {
        print("\(#function) hot!!!!!!! and bitter!!!")
    }
}

struct JuicePrototype: DrinkCommand {
    mutating func drink() {
        print("\(#function) cold!!")
    }
    mutating func refill(_ amount: Float) {
        print("\(#function) need more fresh juice")
    }
    mutating func drinkUp() {
        print("\(#function) cold!!!!!!! and got a headache!!!")
    }
}

struct DrinkCore {
    private var hotDrinkCommand: DrinkCommand
    private var coldDrinkCommand: DrinkCommand
    init(hotDrinkCommand: DrinkCommand, coldDrinkCommand: DrinkCommand) {
        self.hotDrinkCommand = hotDrinkCommand
        self.coldDrinkCommand = coldDrinkCommand
    }
    
    mutating func thirsty(needIce: Bool) {
        if needIce {
            coldDrinkCommand.drink()
        } else {
            hotDrinkCommand.drink()
        }
    }
    
    mutating func thirstyMore(needIce: Bool) {
        if needIce {
            coldDrinkCommand.drinkUp()
            coldDrinkCommand.refill(300.0)
        } else {
            hotDrinkCommand.drinkUp()
            hotDrinkCommand.refill(300.0)
        }
    }
}

func testCommand2() {
    let coffeCore = CoffeePrototype()
    let juiceCore = JuicePrototype()
    var drinkCore = DrinkCore(hotDrinkCommand: coffeCore, coldDrinkCommand: juiceCore)
    drinkCore.thirsty(needIce: true)
    drinkCore.thirstyMore(needIce: false)
}

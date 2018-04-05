//
//  Builder.swift
//  DesignPattern
//
//  Created by taehoon lee on 2018. 3. 30..
//  Copyright © 2018년 taehoon lee. All rights reserved.
//

import Foundation

protocol VehicleBuilder {
    var name: String {get}
    var power: Float {get}
    var fuel: String {get}
    var capacity: Int {get}
    var kind: String {get}
}

class SuvBuilder: VehicleBuilder {
    var name: String = "SUV"
    var power: Float = 260.0
    var fuel: String = "gasoline"
    var capacity: Int = 7
    var kind: String = "land"
}

class SpeedBoatBuilder: VehicleBuilder {
    var name: String = "Boat"
    var power: Float = 320.0
    var fuel: String = "diesel"
    var capacity: Int = 12
    var kind: String = "water"
}

class AirPlainBuilder: VehicleBuilder {
    var name: String = "AirPlain"
    var power: Float = 15_000.0
    var fuel: String = "diesel"
    var capacity: Int = 120
    var kind: String = "sky"
}

class Vehicle {
    var name: String
    var power: Float
    var fuel: String
    var capacity: Int
    var kind: String
    init(_ builder: VehicleBuilder) {
        name = builder.name
        power = builder.power
        fuel = builder.fuel
        capacity = builder.capacity
        kind = builder.kind
    }
}

extension Vehicle: CustomStringConvertible {
    var description: String {
        return "\(name), \(capacity), \(kind), \(fuel), \(power)"
    }
}

func testBuilder0() {
    let suv = Vehicle(SuvBuilder())
    print(suv)
    let boat = Vehicle(SpeedBoatBuilder())
    print(boat)
    let airplain = Vehicle(AirPlainBuilder())
    print(airplain)
}




class CarBuilder {
    var name: String?
    var color: String?
    var seats: Int?
    var hp: Float?
    var torque: Float?
    var isPerformanceModel: Bool?
    
    typealias CarBuilderClosure = (CarBuilder) -> Void
    init(_ builderClosure: CarBuilderClosure) {
        builderClosure(self)
    }
}

struct Car {
    let name: String
    let seats: Int
    var color: String
    var hp: Float
    var torque: Float
    var isPerformanceModel: Bool
    
    init?(_ builder: CarBuilder) {
        guard let name = builder.name, let color = builder.color, let seats = builder.seats else {
            
            return nil
        }
        self.name = name
        self.color = color
        self.seats = seats
        self.hp = builder.hp ?? -1
        self.torque = builder.torque ?? -1
        self.isPerformanceModel = builder.isPerformanceModel ?? false
    }
}

extension Car: CustomStringConvertible {
    var description: String {
        return "\(name), \(color) color, \(seats) seats, \(hp)hp, \(torque)kg/m"
    }
}


func testBuilder1() {
    let coupeBuilder = CarBuilder { (builder) in
        builder.name = "Mercedes Benz C200 Coupe"
        builder.color = "Silver"
        builder.seats = 4
        builder.hp = 189.0
        builder.torque = 36.7
    }
    
    let benzC200Coupe = Car(coupeBuilder)!
    print(benzC200Coupe)
    
    let conceptCar = Car(CarBuilder({
        $0.name = "Performance Concept"
        $0.color = "White"
        $0.seats = 5
    }))!
    print(conceptCar)
}



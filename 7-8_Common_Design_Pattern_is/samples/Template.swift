//
//  Template.swift
//  DesignPattern
//
//  Created by taehoon lee on 2018. 3. 31..
//  Copyright © 2018년 taehoon lee. All rights reserved.
//

import Foundation

class EngineStartProcedure {
    
    func execute() {
        keyOn()
        turnToStart()
        fuelInjection()
        burst()
        spinningCylinder()
    }
    
    func keyOn() {
        preconditionFailure("must override from concreate sub class")
    }
    
    func turnToStart() {
        preconditionFailure("must override from concreate sub class")
    }
    
    func fuelInjection() {
        preconditionFailure("must override from concreate sub class")
    }
    
    func burst() {
        preconditionFailure("must override from concreate sub class")
    }
    
    func spinningCylinder() {
        preconditionFailure("must override from concreate sub class")
    }
}


class OldFashionCarEngineStartProcedure: EngineStartProcedure {
    override func keyOn() {
        print("push the 'break pedal'")
        print("your key on the 'key box'")
    }
    
    override func turnToStart() {
        print("turn your key on to the 'engine start' ")
    }
    
    override func fuelInjection() {
        print("fuel flow to the engine")
    }
    
    override func burst() {
        print("explosion")
    }
    
    override func spinningCylinder() {
        print("engine is started")
    }
}

class BrandNewCarEngineStartProcedure: EngineStartProcedure {
    override func keyOn() {
        print("push the 'engine start' button once")
    }
    
    override func turnToStart() {
        print("push the 'break pedal'")
        print("push the 'engine start' button one more")
    }
    
    override func fuelInjection() {
        print("fuel flow to the engine")
    }
    
    override func burst() {
        print("explosion")
    }
    
    override func spinningCylinder() {
        print("engine is started")
    }
}

class ElectronicCarEngineStartProcedure: BrandNewCarEngineStartProcedure {
    override func fuelInjection() {
        print("electrocity flow to the motor")
    }
    
    override func burst() {
        print("system on")
    }
    
    override func spinningCylinder() {
        print("mortor is ready")
    }
}


func testTemplate() {
    print("key used car")
    let oldCarEngineStartProcedure = OldFashionCarEngineStartProcedure()
    oldCarEngineStartProcedure.execute()
    
    print("smart key used car")
    let newCarEngineStartProcedure = BrandNewCarEngineStartProcedure()
    newCarEngineStartProcedure.execute()
    
    print("smart key used electornic car")
    let electroniCarEngineStartProcedure = ElectronicCarEngineStartProcedure()
    electroniCarEngineStartProcedure.execute()
}



//
//  Factory.swift
//  SwiftAndProtocolOrientedProgramming
//
//  Created by taehoon lee on 2018. 3. 30..
//  Copyright © 2018년 taehoon lee. All rights reserved.
//

import Foundation


protocol Employee {
    func identity() -> String
    func skill() -> [String: String]
    func career() -> [String: String]
}

enum EmployeeType {
    case developer, designer, driver
}

class Developer: Employee {
    func identity() -> String {
        return "iOS Developer"
    }
    func skill() -> [String: String] {
        return ["language": "objective-c, swift, javascript, css, angularJS, actionScript"]
    }
    func career() -> [String: String] {
        return ["company0": "flash developer", "company1": "ios developer"]
    }
}

class Designer: Employee {
    func identity() -> String {
        return "Car Designer"
    }
    func skill() -> [String: String] {
        return ["program": "photoshop, illustrator, cad"]
    }
    func career() -> [String: String] {
        return ["company0": "intern", "company1": "car seat designer"]
    }
}

class Driver: Employee {
    func identity() -> String {
        return "Racing Car Driver"
    }
    func skill() -> [String: String] {
        return ["license": "normal, circuit special"]
    }
    func career() -> [String: String] {
        return ["company0": "compact"]
    }
}

class HeadHunter {
    private func makeDeveloper() -> Employee {
        return Developer()
    }
    
    private func makeDesigner() -> Employee {
        return Designer()
    }
    
    private func makeDriver() -> Employee {
        return Driver()
    }
    
    func findEmployees(_ employeeType: EmployeeType) -> Employee {
        switch employeeType {
        case .developer:
            return makeDeveloper()
        case .designer:
            return makeDesigner()
        case .driver:
            return makeDriver()
        }
    }
    
    static func get(_ employeeType: EmployeeType) -> Employee {
        let headHunter = HeadHunter()
        return headHunter.findEmployees(employeeType)
    }
}

func testFactory() {
    print("\(#function)")
    let headHunter = HeadHunter()
    let developer = headHunter.findEmployees(.developer)
    print("\(developer.identity()), \(developer.skill()), \(developer.career())")
    let designer = headHunter.findEmployees(.designer)
    print("\(designer.identity()), \(designer.skill()), \(designer.career())")
    
    let driver = HeadHunter.get(.driver)
    print("\(driver.identity()), \(driver.skill()), \(driver.career())")
}

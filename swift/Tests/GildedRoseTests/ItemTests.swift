//
//  File.swift
//  
//
//  Created by Thomas Valera on 26/09/2021.
//

@testable import GildedRose
import XCTest

class ItemTests: XCTestCase {

    func testInit() {
        let tests: [(name: String, sellIn: Int, quality: Int)] = [
            ("Hello", 1, -2),
            ("World", 0, 0),
            ("Hello World!", -3, 4)
        ]
        
        tests.forEach { test in
            let item = Item(name: test.name, sellIn: test.sellIn, quality: test.quality)
            XCTAssertEqual(item.name, test.name)
            XCTAssertEqual(item.sellIn, test.sellIn)
            XCTAssertEqual(item.quality, test.quality)
        }
    }
    
    func testDescription() {
        let tests: [(item: Item, description: String)] = [
            (Item(name: "Hello", sellIn: 1, quality: -2), "Hello, 1, -2"),
            (Item(name: "World", sellIn: 0, quality: 0), "World, 0, 0"),
            (Item(name: "Hello World!", sellIn: -3, quality: 4), "Hello World!, -3, 4")
        ]
        
        tests.forEach { test in
            XCTAssertEqual(test.item.description, test.description)
        }
    }

    static var allTests = [
        ("testInit", testInit),
        ("testDescription", testDescription),
    ]
}


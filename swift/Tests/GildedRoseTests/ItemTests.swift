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
    
    func testItemType() {
        let tests: [(item: Item, itemType: Item.ItemType)] = [
            (Item(name: "Standard", sellIn: 0, quality: 0), .standard),
            (Item(name: "", sellIn: 0, quality: 0), .standard),
            (Item(name: "This could be any name", sellIn: 0, quality: 0), .standard),
            
            (Item(name: "Aged Brie", sellIn: 0, quality: 0), .aging),
            (Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 0, quality: 0), .legendary),
            (Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 0, quality: 0), .pass),
            (Item(name: "Conjured Mana Cake", sellIn: 0, quality: 0), .conjured)
        ]
        
        tests.forEach { test in
            let itemType = test.item.itemType
            let expectedItemType = test.itemType
            
            switch (itemType, expectedItemType) {
            case (.standard, .standard),
                 (.aging, .aging),
                 (.legendary, .legendary),
                 (.pass, .pass),
                 (.conjured, .conjured):
                XCTAssertTrue(true)
                
            default:
                XCTFail("ItemType mapping fail, expected: \(expectedItemType) but received \(itemType)")
            }
        }
    }
    
    func testQualityType() {
        let tests: [(item: Item, qualityType: Item.QualityType)] = [
            (Item(name: "Standard", sellIn: 1, quality: 0), .decreasing(value: 1)),
            (Item(name: "", sellIn: 0, quality: 0), .decreasing(value: 1)), // last day
            (Item(name: "This could be any name", sellIn: -1, quality: 0), .decreasing(value: 2)), // passed
            
            (Item(name: "Aged Brie", sellIn: 1, quality: 0), .increasing(value: 1)),
            (Item(name: "Aged Brie", sellIn: 0, quality: 0), .increasing(value: 1)), // last day
            (Item(name: "Aged Brie", sellIn: -1, quality: 0), .increasing(value: 2)), // passed
            
            (Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 1, quality: 10), .fixed(value: 10)),
            (Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 0, quality: 30), .fixed(value: 30)),
            (Item(name: "Sulfuras, Hand of Ragnaros", sellIn: -1, quality: 78), .fixed(value: 78)),
            
            (Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 20, quality: 19), .increasing(value: 1)), // default
            (Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 10, quality: 20), .increasing(value: 1)), // 10 days
            (Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 9, quality: 20), .increasing(value: 2)), // exactly 9 days
            (Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 7, quality: 21), .increasing(value: 2)), // inside 10-5 days range
            (Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 5, quality: 22), .increasing(value: 2)), // 5 days
            (Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 4, quality: 22), .increasing(value: 3)), // exactly 4 days
            (Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 1, quality: 23), .increasing(value: 3)), // inside 5-0 days range
            (Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: -1, quality: 24), .fixed(value: 0)), // just passed
            (Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: -10, quality: 25), .fixed(value: 0)), // passed
            
            (Item(name: "Conjured Mana Cake", sellIn: 1, quality: 0), .decreasing(value: 2)),
            (Item(name: "Conjured Mana Cake", sellIn: 0, quality: 0), .decreasing(value: 2)), // last day
            (Item(name: "Conjured Mana Cake", sellIn: -1, quality: 0), .decreasing(value: 4)), // passed
            
        ]
        
        tests.forEach { test in
            let qualityType = test.item.qualityType
            let expectedQualityType = test.qualityType
            
            switch (qualityType, expectedQualityType) {
            case (.decreasing(let value), .decreasing(let expectedValue)):
                XCTAssertEqual(value, expectedValue, "\(test.item.name) QualityType .decreasing mapping fail, expected value: \(expectedValue) but received value \(value)")
                
            case (.increasing(let value), .increasing(let expectedValue)):
                XCTAssertEqual(value, expectedValue, "\(test.item.name) QualityType .increasing mapping fail, expected value: \(expectedValue) but received value \(value)")
                
            case (.fixed(let value), .fixed(let expectedValue)):
                XCTAssertEqual(value, expectedValue, "\(test.item.name) QualityType .fixed mapping fail, expected value: \(expectedValue) but received value \(value)")
                
            default:
                XCTFail("QualityType mapping fail, expected: \(expectedQualityType) but received \(qualityType)")
            }
        }
    }
    
    func testUpdate() {
        let tests: [(item: Item, sellIn: Int, quality: Int)] = [
            // Standard items
            (Item(name: "Standard", sellIn: 10, quality: 20), 9, 19),
            (Item(name: "Standard", sellIn: 1, quality: 20), 0, 19), // last day
            (Item(name: "Standard", sellIn: 0, quality: 20), -1, 18), // just passed
            (Item(name: "Standard", sellIn: -3, quality: 20), -4, 18), // passed
            (Item(name: "Standard", sellIn: -3, quality: 0), -4, 0), // passed minimum quality

            // Aged Brie
            (Item(name: "Aged Brie", sellIn: 2, quality: 0), 1, 1), // default
            (Item(name: "Aged Brie", sellIn: 1, quality: 10), 0, 11), // last day
            (Item(name: "Aged Brie", sellIn: 0, quality: 12), -1, 14), // just passed
            (Item(name: "Aged Brie", sellIn: -10, quality: 12), -11, 14), // passed
            (Item(name: "Aged Brie", sellIn: -10, quality: 50), -11, 50), // passed with max quality reached

            // Sulfuras
            (Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 10, quality: 80), 10, 80), // default
            (Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 1, quality: 80), 1, 80), // last day
            (Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 0, quality: 80), 0, 80), // just passed
            (Item(name: "Sulfuras, Hand of Ragnaros", sellIn: -10, quality: 80), -10, 80), // passed

            // Backstage passes
            (Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 20, quality: 19), 19, 20), // default
            (Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 11, quality: 20), 10, 21), // 11 days
            (Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 10, quality: 20), 9, 22), // exactly 10 days
            (Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 7, quality: 21), 6, 23), // inside 10-5 days range
            (Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 6, quality: 22), 5, 24), // 6 days
            (Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 5, quality: 22), 4, 25), // exactly 5 days
            (Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 1, quality: 23), 0, 26), // inside 5-0 days range
            (Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 0, quality: 24), -1, 0), // just passed
            (Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: -10, quality: 25), -11, 0), // passed
            
            (Item(name: "Conjured Mana Cake", sellIn: 10, quality: 20), 9, 18),
            (Item(name: "Conjured Mana Cake", sellIn: 1, quality: 20), 0, 18), // last day
            (Item(name: "Conjured Mana Cake", sellIn: 0, quality: 20), -1, 16), // just passed
            (Item(name: "Conjured Mana Cake", sellIn: -3, quality: 20), -4, 16), // passed
            (Item(name: "Conjured Mana Cake", sellIn: -3, quality: 0), -4, 0), // passed minimum quality
        ]
        
        tests.forEach { test in
            test.item.update()
            XCTAssertEqual(test.item.sellIn, test.sellIn, "Failed sellIn \(test.item.name). Expected: \(test.sellIn), received: \(test.item.sellIn)")
            XCTAssertEqual(test.item.quality, test.quality, "Failed quality \(test.item.name). Expected: \(test.quality), received: \(test.item.quality)")
        }
    }

    static var allTests = [
        ("testInit", testInit),
        ("testDescription", testDescription),
    ]
}


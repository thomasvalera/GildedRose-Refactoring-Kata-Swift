@testable import GildedRose
import XCTest

class GildedRoseTests: XCTestCase {
    func testInit() {
        // Empty
        var gildedRose = GildedRose(items: [])
        XCTAssertEqual(gildedRose.items.count, .zero)
        
        // One
        gildedRose = GildedRose(items: [Item(name: "", sellIn: 0, quality: 0)])
        XCTAssertEqual(gildedRose.items.count, 1)
        
        // More
        gildedRose = GildedRose(items: [
            Item(name: "", sellIn: 0, quality: 0),
            Item(name: "", sellIn: 0, quality: 0),
            Item(name: "", sellIn: 0, quality: 0),
            Item(name: "", sellIn: 0, quality: 0)
        ])
        XCTAssertEqual(gildedRose.items.count, 4)
    }
    
    func testUpdateQuality() {
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
        ]
        
        let items = tests.map { test in
            test.item
        }
        
        let gildedRose = GildedRose(items: items)
        gildedRose.updateQuality()
        
        tests.forEach { test in
            XCTAssertEqual(test.item.sellIn, test.sellIn, "Failed sellIn \(test.item.name). Expected: \(test.sellIn), received: \(test.item.sellIn)")
            XCTAssertEqual(test.item.quality, test.quality, "Failed quality \(test.item.name). Expected: \(test.quality), received: \(test.item.quality)")
        }
    }
    
    func testUpdateQuality_conjured() {
        let tests: [(item: Item, sellIn: Int, quality: Int)] = [
            // Standard items
            (Item(name: "Conjured Mana Cake", sellIn: 10, quality: 20), 9, 18),
            (Item(name: "Conjured Mana Cake", sellIn: 1, quality: 20), 0, 18), // last day
            (Item(name: "Conjured Mana Cake", sellIn: 0, quality: 20), -1, 16), // just passed
            (Item(name: "Conjured Mana Cake", sellIn: -3, quality: 20), -4, 16), // passed
            (Item(name: "Conjured Mana Cake", sellIn: -3, quality: 0), -4, 0), // passed minimum quality
        ]
        
        let items = tests.map { test in
            test.item
        }
        
        let gildedRose = GildedRose(items: items)
        gildedRose.updateQuality()
        
        tests.forEach { test in
            XCTAssertEqual(test.item.sellIn, test.sellIn, "Failed sellIn \(test.item.name). Expected: \(test.sellIn), received: \(test.item.sellIn)")
            XCTAssertEqual(test.item.quality, test.quality, "Failed quality \(test.item.name). Expected: \(test.quality), received: \(test.item.quality)")
        }
    }
    
    static var allTests = [
        ("testInit", testInit),
        ("testUpdateQuality", testUpdateQuality),
    ]
}

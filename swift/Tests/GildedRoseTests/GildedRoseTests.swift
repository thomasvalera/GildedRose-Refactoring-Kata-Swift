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
            (Item(name: "Standard", sellIn: 10, quality: 20), 9, 19),
            (Item(name: "Aged Brie", sellIn: 2, quality: 0), 1, 1),
            (Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 10, quality: 80), 10, 80),
            (Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 20, quality: 19), 19, 20),
            (Item(name: "Conjured Mana Cake", sellIn: 10, quality: 20), 9, 18),
        ]
        
        let items = tests.map { test in
            test.item
        }
        
        let gildedRose = GildedRose(items: items)
        gildedRose.updateItems()
        
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

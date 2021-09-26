public class GildedRose {
    var items: [Item]
    
    public init(items: [Item]) {
        self.items = items
    }
    public func updateItems() {
        for item in items {
            updateSellIn(item)
            updateQuality(item)
        }
    }
    
    private func updateSellIn(_ item: Item) {
        guard item.name != "Sulfuras, Hand of Ragnaros" else {
            return
        }
        
        item.sellIn -= 1
    }
    
    private func updateQuality(_ item: Item) {
        guard item.name != "Sulfuras, Hand of Ragnaros" else {
            return
        }
        
        if item.name == "Aged Brie" {
            item.quality += item.sellIn < 0 ? 2 : 1
        } else if item.name == "Backstage passes to a TAFKAL80ETC concert" {
            if item.sellIn < 0 {
                item.quality = 0
            } else if item.sellIn < 5 {
                item.quality += 3
            } else if item.sellIn < 10 {
                item.quality += 2
            } else {
                item.quality += 1
            }
        } else {
            item.quality -= item.sellIn < 0 ? 2 : 1
        }
        
        let upperBounded = min(item.quality, 50)
        let bounded = max(upperBounded, 0)
        item.quality = bounded
    }
}

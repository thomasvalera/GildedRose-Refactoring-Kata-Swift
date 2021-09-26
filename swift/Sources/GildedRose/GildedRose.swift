public class GildedRose {
    var items: [Item]
    
    public init(items: [Item]) {
        self.items = items
    }
    
    public func updateQuality() {
        for i in 0 ..< items.count {
            
            // If Aged Brie or Backstage
            if (items[i].name == "Aged Brie" || items[i].name == "Backstage passes to a TAFKAL80ETC concert") {
                
                // If quality not max
                if (items[i].quality < 50) {
                    
                    // Increment
                    items[i].quality = items[i].quality + 1
                    
                    // If backstage
                    if (items[i].name == "Backstage passes to a TAFKAL80ETC concert") {
                        // If < 11 days left and quality not max, increment
                        if (items[i].sellIn < 11 && items[i].quality < 50) {
                            items[i].quality = items[i].quality + 1
                        }
                        
                        // If < 6 days and quality not max, increment
                        if (items[i].sellIn < 6 && items[i].quality < 50) {
                            items[i].quality = items[i].quality + 1
                        }
                    }
                }
            } else if (items[i].name != "Sulfuras, Hand of Ragnaros"){
                // If not sulfuras
                // If quality bigger than zero, decrease
                if (items[i].quality > 0) {
                    items[i].quality = items[i].quality - 1
                }
            }
            
            // Decrease sellIn except for Sulfuras
            if (items[i].name != "Sulfuras, Hand of Ragnaros") {
                items[i].sellIn = items[i].sellIn - 1
            }
            
            // If sellIn passed
            if (items[i].sellIn < 0) {
                if (items[i].name == "Aged Brie") {
                    if (items[i].quality < 50) {
                        // If Aged Brie: Increase again for a double increase
                        items[i].quality = items[i].quality + 1
                    }
                } else if (items[i].name == "Backstage passes to a TAFKAL80ETC concert") {
                    // If backstage: Make quality 0
                    items[i].quality = items[i].quality - items[i].quality
                } else if (items[i].quality > 0 && items[i].name != "Sulfuras, Hand of Ragnaros"){
                    // If not Sulfuras: decrease quality again for a double decrease
                    items[i].quality = items[i].quality - 1
                }
            }
        }
    }
}

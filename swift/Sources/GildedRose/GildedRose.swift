public class GildedRose {
    var items: [Item]
    
    public init(items: [Item]) {
        self.items = items
    }
    
    public func updateItems() {
        items.forEach { $0.update() }
    }
}

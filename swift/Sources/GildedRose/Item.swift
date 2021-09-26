public class Item {
    public var name: String
    public var sellIn: Int
    public var quality: Int
    
    public init(name: String, sellIn: Int, quality: Int) {
        self.name = name
        self.sellIn = sellIn
        self.quality = quality
    }
}

extension Item: CustomStringConvertible {
    public var description: String {
        return self.name + ", " + String(self.sellIn) + ", " + String(self.quality);
    }
    
}

extension Item {
    // MARK: - Enums
    private enum Constants {
        static let minimumQuality = 0
        static let maximumQuality = 50
        
        static let depreciationRateDefault = 1 // The default rate at which an item depreciates
        static let depreciationRateExpired = depreciationRateDefault * 2 // The rate at which an expired item depreciates
        
        static let passDoubleAppreciation = 2 // The rate at which a pass appreciates when in double range
        static let passTripleAppreciation = 3 // The rate at which a pass appreciates when in triple range
        
        static let passDoubleAppreciationRange = 5...9 // The range in which passes get a double appreciation
        static let passTripleAppreciationRange = 0...4 // The range in which passed get a triple appreciation
        
        static let conjuredMultiplier = 2 // The depreciation multiplier for conjured items
    }
    
    enum ItemType {
        case standard
        case aging
        case legendary
        case pass
        case conjured
    }

    enum QualityType {
        case decreasing(value: Int)
        case increasing(value: Int)
        case fixed(value: Int)
    }

    // MARK: - Public Properties
    var itemType: ItemType {
        switch name {
        case "Aged Brie":
            return .aging
            
        case "Sulfuras, Hand of Ragnaros":
            return .legendary
            
        case "Backstage passes to a TAFKAL80ETC concert":
            return .pass
            
        case "Conjured Mana Cake":
            return .conjured
            
        default:
            return .standard
        }
    }
    
    var qualityType: QualityType {
        switch itemType {
        case .standard:
            return .decreasing(value: sellIn < 0 ? Constants.depreciationRateExpired : Constants.depreciationRateDefault)
            
        case .aging:
            return .increasing(value: sellIn < 0 ? Constants.depreciationRateExpired : Constants.depreciationRateDefault)
            
        case .legendary:
            return .fixed(value: quality)
            
        case .pass:
            guard sellIn >= 0 else {
                return .fixed(value: 0)
            }
            
            if Constants.passDoubleAppreciationRange.contains(sellIn) {
                return .increasing(value: Constants.passDoubleAppreciation)
                
            } else if Constants.passTripleAppreciationRange.contains(sellIn) {
                return .increasing(value: Constants.passTripleAppreciation)
                
            } else {
                return .increasing(value: Constants.depreciationRateDefault)
            }
            
        case .conjured:
            let rate = sellIn < 0 ? Constants.depreciationRateExpired : Constants.depreciationRateDefault
            return .decreasing(value: rate * Constants.conjuredMultiplier)
            
        }
    }
    
    // MARK: - Public Functions
    public func update() {
        // Update sellIn
        switch itemType {
        case .legendary:
            break
            
        default:
            sellIn -= 1
        }
        
        // Update quality
        switch qualityType {
        case .fixed(let value):
            quality = value
            
        case .increasing(let value):
            quality = boundQuality(quality + value)
            
        case .decreasing(let value):
            quality = boundQuality(quality - value)
        }
    }
    
    // MARK: - Private Functions
    private func boundQuality(_ quality: Int) -> Int {
        let upperBounded = min(quality, Constants.maximumQuality)
        let bounded = max(upperBounded, Constants.minimumQuality)
        return bounded
    }
}

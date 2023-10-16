import Foundation

// MARK: - Stocke
struct Stocke: Codable {
    let chart: Chart
}

// MARK: - Chart
struct Chart: Codable {
    let result: [StockResult]
    let error: JSONNull?
}

// MARK: - Result
struct StockResult: Codable {
    let meta: Meta
    let timestamp: [Int]
    let indicators: Indicators
}

// MARK: - Indicators
struct Indicators: Codable {
    let quote: [Quote]
    let adjclose: [Adjclose]
}

// MARK: - Adjclose
struct Adjclose: Codable {
    let adjclose: [Double]
}

// MARK: - Quote
struct Quote: Codable {
    let quoteOpen, high, low: [Double]
    let volume: [Int]
    let close: [Double]

    enum CodingKeys: String, CodingKey {
        case quoteOpen = "open"
        case high, low, volume, close
    }
}

// MARK: - Meta
struct Meta: Codable {
    let currency, symbol, exchangeName, instrumentType: String
    let firstTradeDate, regularMarketTime, gmtoffset: Int
    let timezone, exchangeTimezoneName: String
    let regularMarketPrice, chartPreviousClose: Double
    let priceHint: Int
    let currentTradingPeriod: CurrentTradingPeriod
    let dataGranularity, range: String
    let validRanges: [String]
}

// MARK: - CurrentTradingPeriod
struct CurrentTradingPeriod: Codable {
    let pre, regular, post: Post
}

// MARK: - Post
struct Post: Codable {
    let timezone: String
    let start, end, gmtoffset: Int
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

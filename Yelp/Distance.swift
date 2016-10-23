enum Distance: Double {
    
    static let count = 5
    static var values: [Distance] {
        return [Distance.automatic, Distance.one, Distance.two, Distance.three, Distance.four]
    }
    
    var meters: Double {
        return self.rawValue * 1609.34
    }
    
    var description: String {
        switch self {
        case .automatic:
            return "Auto"
        case .one:
            return "0.3 miles"
        case .two:
            return "1 mile"
        case .three:
            return "5 miles"
        case .four:
            return "20 miles"
        }
    }
    
    case automatic = 0.0
    case one = 0.3
    case two = 1
    case three = 5
    case four = 20
}

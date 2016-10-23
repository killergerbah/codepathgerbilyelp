enum Sort: Int {
    
    static let count = 3
    static var values: [Sort] {
        return [Sort.bestMatch, Sort.distance, Sort.highestRated]
    }
    
    var description: String {
        switch self {
        case .bestMatch:
            return "Best Match"
        case .distance:
            return "Distance"
        case .highestRated:
            return "Highest Rated"
        }
    }
    
    case bestMatch = 0
    case distance
    case highestRated
}

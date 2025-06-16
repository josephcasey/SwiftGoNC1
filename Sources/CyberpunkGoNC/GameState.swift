import SwiftUI
import Foundation
#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

// MARK: - Game Models
struct District: Identifiable, Codable {
    let id = UUID()
    let name: String
    let boundaries: [CGPoint]
    var units: [String: [Unit]] = [:]
    var dominantGang: String?
    var center: CGPoint {
        // Calculate centroid of boundaries
        let sumX = boundaries.reduce(0) { $0 + $1.x }
        let sumY = boundaries.reduce(0) { $0 + $1.y }
        return CGPoint(
            x: sumX / CGFloat(boundaries.count),
            y: sumY / CGFloat(boundaries.count)
        )
    }
}

struct Unit: Identifiable, Codable {
    let id = UUID()
    let type: UnitType
    let gangId: String
}

enum UnitType: String, CaseIterable, Codable {
    case solo = "solo"
    case techie = "techie"
    case netrunner = "netrunner"
    case drone = "drone"
    
    var displayName: String {
        switch self {
        case .solo: return "Solo"
        case .techie: return "Techie"
        case .netrunner: return "Netrunner"
        case .drone: return "Drone"
        }
    }
}

struct Gang: Identifiable, Codable {
    let id: String
    let name: String
    let color: Color
    
    private enum CodingKeys: String, CodingKey {
        case id, name, colorComponents
    }
    
    init(id: String, name: String, color: Color) {
        self.id = id
        self.name = name
        self.color = color
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        let components = try container.decode([Double].self, forKey: .colorComponents)
        color = Color(red: components[0], green: components[1], blue: components[2])
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        
        // Convert Color to components for encoding using cross-platform approach
        #if canImport(UIKit)
        let uiColor = UIColor(color)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        try container.encode([Double(red), Double(green), Double(blue)], forKey: .colorComponents)
        #else
        // For macOS, use NSColor
        let nsColor = NSColor(color)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        nsColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        try container.encode([Double(red), Double(green), Double(blue)], forKey: .colorComponents)
        #endif
    }
}

// MARK: - Game State
class GameState: ObservableObject {
    @Published var districts: [District] = []
    @Published var gangs: [Gang] = []
    @Published var currentRound: Int = 1
    @Published var currentPhase: String = "Planning"
    @Published var selectedDistrict: District?
    
    init() {
        setupInitialGame()
    }
    
    private func setupInitialGame() {
        // Initialize gangs with cyberpunk colors
        gangs = [
            Gang(id: "maelstrom", name: "Maelstrom", color: .red),
            Gang(id: "tyger_claws", name: "Tyger Claws", color: .blue),
            Gang(id: "voodoo_boys", name: "Voodoo Boys", color: .green),
            Gang(id: "valentinos", name: "Valentinos", color: .pink),
            Gang(id: "animals", name: "Animals", color: .orange),
            Gang(id: "scavs", name: "Scavs", color: .yellow)
        ]
        
        // Initialize districts with Night City boundaries
        districts = [
            District(name: "Watson", boundaries: [
                CGPoint(x: 116, y: 39), CGPoint(x: 887, y: 36), CGPoint(x: 893, y: 211),
                CGPoint(x: 866, y: 254), CGPoint(x: 721, y: 307), CGPoint(x: 629, y: 313),
                CGPoint(x: 571, y: 473), CGPoint(x: 516, y: 506), CGPoint(x: 245, y: 500),
                CGPoint(x: 98, y: 353), CGPoint(x: 98, y: 64), CGPoint(x: 119, y: 43)
            ]),
            District(name: "Westbrook", boundaries: [
                CGPoint(x: 629, y: 309), CGPoint(x: 983, y: 312), CGPoint(x: 985, y: 819),
                CGPoint(x: 944, y: 816), CGPoint(x: 655, y: 645), CGPoint(x: 634, y: 573),
                CGPoint(x: 519, y: 501), CGPoint(x: 568, y: 473), CGPoint(x: 632, y: 309),
                CGPoint(x: 983, y: 312)
            ]),
            District(name: "City Center", boundaries: [
                CGPoint(x: 58, y: 501), CGPoint(x: 517, y: 501), CGPoint(x: 629, y: 573),
                CGPoint(x: 655, y: 642), CGPoint(x: 517, y: 814), CGPoint(x: 483, y: 826),
                CGPoint(x: 445, y: 837), CGPoint(x: 412, y: 837), CGPoint(x: 378, y: 821),
                CGPoint(x: 350, y: 791), CGPoint(x: 337, y: 742), CGPoint(x: 69, y: 755),
                CGPoint(x: 25, y: 698), CGPoint(x: 23, y: 540), CGPoint(x: 56, y: 499)
            ]),
            District(name: "Heywood", boundaries: [
                CGPoint(x: 23, y: 698), CGPoint(x: 66, y: 760), CGPoint(x: 332, y: 744),
                CGPoint(x: 358, y: 801), CGPoint(x: 396, y: 826), CGPoint(x: 442, y: 844),
                CGPoint(x: 486, y: 832), CGPoint(x: 532, y: 808), CGPoint(x: 657, y: 642),
                CGPoint(x: 762, y: 714), CGPoint(x: 460, y: 1088), CGPoint(x: 176, y: 1090),
                CGPoint(x: 56, y: 960), CGPoint(x: 20, y: 993), CGPoint(x: 20, y: 698)
            ]),
            District(name: "Pacifica", boundaries: [
                CGPoint(x: 20, y: 995), CGPoint(x: 51, y: 962), CGPoint(x: 176, y: 1090),
                CGPoint(x: 463, y: 1090), CGPoint(x: 463, y: 1118), CGPoint(x: 691, y: 1331),
                CGPoint(x: 547, y: 1523), CGPoint(x: 20, y: 1520), CGPoint(x: 23, y: 993)
            ]),
            District(name: "Santo Domingo", boundaries: [
                CGPoint(x: 765, y: 714), CGPoint(x: 942, y: 819), CGPoint(x: 988, y: 819),
                CGPoint(x: 1018, y: 816), CGPoint(x: 1018, y: 1525), CGPoint(x: 565, y: 1523),
                CGPoint(x: 706, y: 1323), CGPoint(x: 478, y: 1116), CGPoint(x: 478, y: 1090),
                CGPoint(x: 770, y: 727), CGPoint(x: 768, y: 711)
            ])
        ]
        
        // Add some initial units
        setupInitialUnits()
    }
    
    private func setupInitialUnits() {
        // Add some starting units to demonstrate
        if let watsonIndex = districts.firstIndex(where: { $0.name == "Watson" }) {
            districts[watsonIndex].units["maelstrom"] = [
                Unit(type: .solo, gangId: "maelstrom"),
                Unit(type: .techie, gangId: "maelstrom"),
                Unit(type: .netrunner, gangId: "maelstrom"),
                Unit(type: .drone, gangId: "maelstrom")
            ]
        }
        
        if let westbrookIndex = districts.firstIndex(where: { $0.name == "Westbrook" }) {
            districts[westbrookIndex].units["tyger_claws"] = [
                Unit(type: .solo, gangId: "tyger_claws"),
                Unit(type: .techie, gangId: "tyger_claws"),
                Unit(type: .netrunner, gangId: "tyger_claws"),
                Unit(type: .drone, gangId: "tyger_claws")
            ]
        }
        
        if let pacificaIndex = districts.firstIndex(where: { $0.name == "Pacifica" }) {
            districts[pacificaIndex].units["voodoo_boys"] = [
                Unit(type: .solo, gangId: "voodoo_boys"),
                Unit(type: .techie, gangId: "voodoo_boys"),
                Unit(type: .netrunner, gangId: "voodoo_boys"),
                Unit(type: .drone, gangId: "voodoo_boys")
            ]
        }
    }
    
    // MARK: - Game Actions
    func selectDistrict(at point: CGPoint, in mapSize: CGSize) {
        // Scale the touch point to match the district boundaries
        let scaledPoint = CGPoint(
            x: point.x * (1024 / mapSize.width),
            y: point.y * (1536 / mapSize.height)
        )
        
        selectedDistrict = districts.first { district in
            isPointInPolygon(scaledPoint, polygon: district.boundaries)
        }
    }
    
    private func isPointInPolygon(_ point: CGPoint, polygon: [CGPoint]) -> Bool {
        guard polygon.count > 2 else { return false }
        
        var inside = false
        var j = polygon.count - 1
        
        for i in 0..<polygon.count {
            let xi = polygon[i].x
            let yi = polygon[i].y
            let xj = polygon[j].x
            let yj = polygon[j].y
            
            if ((yi > point.y) != (yj > point.y)) &&
               (point.x < (xj - xi) * (point.y - yi) / (yj - yi) + xi) {
                inside.toggle()
            }
            j = i
        }
        
        return inside
    }
}

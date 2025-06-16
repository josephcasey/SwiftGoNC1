import XCTest
@testable import CyberpunkGoNC

final class CyberpunkGoNCTests: XCTestCase {
    
    func testGameStateInitialization() {
        let gameState = GameState()
        
        // Test that game state initializes correctly
        XCTAssertEqual(gameState.currentRound, 1)
        XCTAssertEqual(gameState.currentPhase, "Planning")
        XCTAssertEqual(gameState.districts.count, 6)
        XCTAssertEqual(gameState.gangs.count, 6)
    }
    
    func testDistrictBoundaries() {
        let gameState = GameState()
        
        // Test that districts have boundaries
        for district in gameState.districts {
            XCTAssertGreaterThan(district.boundaries.count, 2, "District \(district.name) should have at least 3 boundary points")
        }
    }
    
    func testGangInitialization() {
        let gameState = GameState()
        
        // Test that all gangs are properly initialized
        let expectedGangs = ["maelstrom", "tyger_claws", "voodoo_boys", "valentinos", "animals", "scavs"]
        let actualGangIds = gameState.gangs.map { $0.id }
        
        for expectedGang in expectedGangs {
            XCTAssertTrue(actualGangIds.contains(expectedGang), "Missing gang: \(expectedGang)")
        }
    }
    
    func testDistrictSelection() {
        let gameState = GameState()
        
        // Test district selection with Watson district center
        let watsonDistrict = gameState.districts.first { $0.name == "Watson" }
        XCTAssertNotNil(watsonDistrict)
        
        if watsonDistrict != nil {
            let mapSize = CGSize(width: 400, height: 600)
            let touchPoint = CGPoint(x: 200, y: 100) // Approximate center
            
            gameState.selectDistrict(at: touchPoint, in: mapSize)
            
            // Note: This test might need adjustment based on actual coordinate scaling
            XCTAssertNotNil(gameState.selectedDistrict)
        }
    }
    
    func testInitialUnits() {
        let gameState = GameState()
        
        // Test that initial units are placed correctly
        let watsonDistrict = gameState.districts.first { $0.name == "Watson" }
        XCTAssertNotNil(watsonDistrict)
        
        if watsonDistrict != nil {
            let watson = watsonDistrict!
            XCTAssertTrue(watson.units.keys.contains("maelstrom"))
            if let maelstromUnits = watson.units["maelstrom"] {
                XCTAssertEqual(maelstromUnits.count, 4)
            }
        }
    }
}

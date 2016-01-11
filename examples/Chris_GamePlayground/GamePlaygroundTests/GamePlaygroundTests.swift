//
//  GamePlaygroundTests.swift
//  GamePlaygroundTests
//
//  Created by Chris Eidhof on 03-01-16.
//  Copyright © 2016 Chris Eidhof. All rights reserved.
//

import XCTest
import GamePlayground

class DefaultsMock {
    var dictionary: [String:AnyObject] = [:]
}

extension DefaultsMock: Storage {
     func objectForKey(key: String) -> AnyObject? {
        return dictionary[key]
    }
    
     func setObject(object: AnyObject?, forKey key: String) {
        dictionary[key] = object
    }
}

class GamePlaygroundTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoadHealth() {
        let mock = DefaultsMock()
        mock.setObject(42, forKey: "player.health")
        let health = Health(defaults: mock)
        XCTAssertEqual(health.points, 42)
    }
    
    func testSaveHealth() {
        let mock = DefaultsMock()
        let health = Health(defaults: 
            mock)
        health.points = 100
        XCTAssertEqual(mock.objectForKey("player.health") as? Int, 100)
    }
    
    func testIncreaseHealth() {
        let mock = DefaultsMock()
        let health = Health(defaults: mock)
        health.points = 200
        XCTAssertEqual(mock.objectForKey("player.health") as? Int, 200)
    }
    
    func testPlayerName() {
        let mock = DefaultsMock()
        let player = Player(defaults: mock)
        player.name = "Chris"
        XCTAssertEqual(mock.objectForKey("player.name") as? String, "Chris")
    }
    
    func testPlayerHealthInjection() {
        let mock = DefaultsMock()
        let player = Player(defaults: mock)
        player.health.points = 35
        XCTAssertEqual(mock.objectForKey("player.health") as? Int, 35)
    }
    
    func testGameHealthInjection() {
        let mock = DefaultsMock()
        let game = Game(defaults: mock)
        game.player.health.points = 35
        XCTAssertEqual(mock.objectForKey("player.health") as? Int, 35)
    }
}

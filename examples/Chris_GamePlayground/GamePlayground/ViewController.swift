//
//  ViewController.swift
//  GamePlayground
//
//  Created by Chris Eidhof on 03-01-16.
//  Copyright © 2016 Chris Eidhof. All rights reserved.
//

import UIKit

var buttonOffset: CGFloat = 100

class MyButton: UIButton {
    var onClick: () -> () = { _ in () }
    @objc func tapped(sender: AnyObject) {
        onClick()
    }
}

func button(text: String, onClick: () -> ()) -> UIButton {
    let b = MyButton(type: .Custom)
    b.userInteractionEnabled = true
    b.frame = CGRect(x: 0, y: buttonOffset, width: 200, height: 30)
    buttonOffset += b.frame.height + 10
    b.backgroundColor = UIColor.grayColor()
    b.setTitle(text, forState: .Normal)
    b.addTarget(b, action: "tapped:", forControlEvents: UIControlEvents.TouchUpInside)
    b.onClick = onClick
    return b
}

public struct Health {
    public var points: Int = 100
    
    public init(dictionary: [String:AnyObject]) {
        points = (dictionary["points"] as? Int) ?? 100
    }
    
    public func serialize() -> [String:AnyObject] {
        return ["points": points]
    }
}

public struct Player {
    public var name: String = ""
    public var health: Health
}

extension Player {
    public init(dictionary: [String:AnyObject]) {
        let healthDict = dictionary["health"] as? [String:AnyObject]
        health = Health(dictionary: healthDict ?? [:])
        name = (dictionary["name"] as? String) ?? ""
    }
    
    func serialize() -> [String:AnyObject] {
        return ["name": name, "health": health.serialize()]
    }
    
}

public class Game {
    let userDefaults: Storage
    public var player: Player {
        didSet {
            save()
        }
    }

    public init(defaults: Storage = NSUserDefaults.standardUserDefaults()) {
        userDefaults = defaults
        let playerDict = defaults.objectForKey("player") as? [String:AnyObject]
        print(playerDict)
        player = Player(dictionary: playerDict ?? [:])
    }
    
    func save() {
        userDefaults.setObject(player.serialize(), forKey: "player")
    }
    
}

public protocol Storage {
    func objectForKey(key: String) -> AnyObject?
    func setObject(object: AnyObject?, forKey: String)
}

extension NSUserDefaults: Storage { }

class ViewController: UIViewController {
    var game = Game()
    
    override func viewDidLoad() {
        self.view.addSubview(button("Add health point") { [unowned self] in
            self.game.player.health.points += 1
            self.updateLabel()
        })
        
        self.view.addSubview(button("Reset health points") { [unowned self] in
            self.game.player.health.points = 100
            self.updateLabel()
            })

        updateLabel()
    }
    
    func updateLabel() {
        self.navigationItem.title = "\(self.game.player.health.points) health points"
    }
}


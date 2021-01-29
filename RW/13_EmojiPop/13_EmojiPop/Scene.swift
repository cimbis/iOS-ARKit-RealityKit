//
//  Scene.swift
//  13_EmojiPop
//
//  Created by Janis Cimbulis on 22/01/2021.
//

import SpriteKit
import ARKit

public enum GameState {
    case Init
    case TapToStart
    case Playing
    case GameOver
}

class Scene: SKScene {
    
    var gameState = GameState.Init
    var anchor: ARAnchor?
    var emojis = "😁😂😛😝😋😜🤪😎🤓🤖🎃💀🤡"
    var spawnTime : TimeInterval = 0
    var score : Int = 0
    var lives : Int = 10
    
    
    override func didMove(to view: SKView) {
        self.startGame()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if self.gameState != .Playing {
            return
        }
        
        if self.spawnTime == 0 {
            self.spawnTime = currentTime + 3
        }
        
        if self.spawnTime < currentTime {
            self.spawnEmoji()
            self.spawnTime = currentTime + 0.5
        }
        
        self.updateHUD("SCORE: " + String(self.score) + " | LIVES: " + String(self.lives))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch (self.gameState) {
        case .Init:
            break
            
        case .TapToStart:
            self.playGame()
            break
            
        case .Playing:
            checkTouches(touches)
            break
            
        case .GameOver:
            self.stopGame()
            break
        }
    }
    
    func randomCGFloat() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    }
    
    func updateHUD(_ message: String) {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        let viewCtrl = sceneView.delegate as! ViewController
        viewCtrl.hudLabel.text = message
    }
    
    public func startGame() {
        self.gameState = .TapToStart
        self.updateHUD("- TAP TO START -")
    }
    
    public func playGame() {
        self.gameState = .Playing
        self.score = 0
        self.lives = 10
        self.spawnTime = 0
        
        self.addAnchor()
        //        self.removeAnchor()
    }
    
    public func stopGame() {
        gameState = .GameOver
        self.updateHUD("GAME OVER! SCORE: " + String(score))
    }
    
    func addAnchor() {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        if let currentFrame = sceneView.session.currentFrame {
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.5
            let transform = simd_mul(currentFrame.camera.transform, translation)
            self.anchor = ARAnchor(transform: transform)
            sceneView.session.add(anchor: self.anchor!)
        }
    }
    
    func removeAnchor() {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        if self.anchor != nil {
            sceneView.session.remove(anchor: self.anchor!)
        }
    }
    
    func spawnEmoji() {
        let emojiNode = SKLabelNode(text: String(self.emojis.randomElement()!))
        emojiNode.name = "Emoji"
        emojiNode.horizontalAlignmentMode = .center
        emojiNode.verticalAlignmentMode = .center
        
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        
        let spawnNode = sceneView.scene?.childNode(withName: "SpawnPoint")
        spawnNode?.addChild(emojiNode)
        
        emojiNode.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        emojiNode.physicsBody?.mass = 0.01
        
        emojiNode
            .physicsBody?
            .applyImpulse(CGVector(
                dx: -5 + 10 * self.randomCGFloat(),
                dy: 10
            ))
        
        emojiNode
            .physicsBody?
            .applyTorque(-0.2 + 0.4 * self.randomCGFloat())
        
        let spawnSoundAction = SKAction.playSoundFileNamed("SoundEffects/Spawn.wav", waitForCompletion: false)
        let dieSoundAction = SKAction.playSoundFileNamed("SoundEffects/Die.wav", waitForCompletion: false)
        let waitAction = SKAction.wait(forDuration: 3)
        let removeAction = SKAction.removeFromParent()
        
        let runAction = SKAction.run {
            self.lives -= 1
            if self.lives <= 0 {
                self.stopGame()
            }
        }
        
        let sequenceAction = SKAction.sequence([
            spawnSoundAction,
            waitAction,
            dieSoundAction,
            runAction,
            removeAction
        ])
        
        emojiNode.run(sequenceAction)
    }
    
    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if touchedNode.name != "Emoji" {
            return
        }
        
        score += 1
        
        let collectionSoundAction = SKAction.playSoundFileNamed("SoundEffects/Collect.wav", waitForCompletion: false)
        let removeAction = SKAction.removeFromParent()
        let sequenceAction = SKAction.sequence([collectionSoundAction, removeAction])
        
        touchedNode.run(sequenceAction)
    }
}

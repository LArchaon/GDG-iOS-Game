//
//  GameScene.m
//  GDG Game
//
//  Created by Denis on 03/10/2014.
//  Copyright (c) 2014 deniss.kaibagarovs@gmail.com, Denis Kaibagarovs. All rights reserved.
//

#import "GameScene.h"
#import "MathHelper.h"

#define MONSTER_CATEGORY 1
#define ARROW_CATEGORY 2

@interface GameScene () <SKPhysicsContactDelegate> {
    
    // Nodes
    SKSpriteNode    *_playel;
    SKLabelNode     *_scoreLabel;
    
    // Variables
    CFTimeInterval  _lastUpdateTimeInterval;
    NSInteger       _killedMonsters;
    
    // Sounds
    SKAction *_bakckgroundSound;
    SKAction *_arrowShootSound;
    SKAction *_arrowHitSound;
}

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    // Pre-load sounds
    _bakckgroundSound = [SKAction playSoundFileNamed:@"backgroundMusic.wav" waitForCompletion:YES];
    _arrowShootSound = [SKAction playSoundFileNamed:@"arrow.wav" waitForCompletion:NO];
    _arrowHitSound = [SKAction playSoundFileNamed:@"hit.wav" waitForCompletion:NO];
    
    // Play background Music
    [self runAction:[SKAction repeatActionForever:_bakckgroundSound]];
    
    // Create Physic world
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    
    // Add Background
    SKSpriteNode *backgroundNode = [[SKSpriteNode alloc] initWithImageNamed:@"background"];
    backgroundNode.position = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
    [self addChild:backgroundNode];
    
    // Add Score Label
    _scoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"System"];
    [self p_updateScoreLabelWithScore:_killedMonsters];
    _scoreLabel.fontSize = 16;
    _scoreLabel.fontColor = [SKColor whiteColor];
    _scoreLabel.position = CGPointMake(CGRectGetMidX(self.view.frame), self.size.height - _scoreLabel.frame.size.height);
    [self addChild:_scoreLabel];
    
    // Add Player
    _playel = [[SKSpriteNode alloc]initWithImageNamed:@"Player"];
    _playel.position = CGPointMake(_playel.size.width/2,CGRectGetMidY(self.view.frame));
    [self addChild:_playel];
}

- (void)addMonster {
    
    // Create monster
    SKSpriteNode *monster = [[SKSpriteNode alloc] initWithImageNamed:@"Zombie"];
    int minY = monster.size.height/2;
    int maxY = self.size.height - monster.size.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create Physical body
    monster.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:monster.size];
    monster.physicsBody.categoryBitMask = MONSTER_CATEGORY;
    monster.physicsBody.contactTestBitMask = ARROW_CATEGORY;
    
    // Set monster position
    monster.position = CGPointMake(self.size.width + monster.size.width/2, actualY);
    
    // Create actions
    SKAction *actionMove = [SKAction moveTo:CGPointMake(-monster.size.width/2,actualY) duration:4];
    SKAction *actionEnd = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[actionMove,actionEnd]];
    
    // Add monster to view
    [self addChild:monster];
    
    // Run monster action
    [monster runAction:sequence];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // Get location of touch
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    
    // Create arrow
    SKSpriteNode *arrow = [[SKSpriteNode alloc] initWithImageNamed:@"Arrow"];
    arrow.position = _playel.position;
    arrow.zRotation = -M_PI_4;
    
    // Create Physical body
    arrow.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:arrow.size];
    arrow.physicsBody.categoryBitMask = ARROW_CATEGORY;
    arrow.physicsBody.contactTestBitMask = MONSTER_CATEGORY;

    // Calculate end point
    CGPoint endPoint = [MathHelper getPointOnVectorWithStartPoint:arrow.position endPoint:touchLocation offset:1000];
    
    // Create action
    SKAction *actionMove = [SKAction moveTo:endPoint duration:2];
    SKAction *actionEnd = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[actionMove,actionEnd]];
    
    // Add to view
    [self addChild:arrow];
    
    // Run Action
    [arrow runAction:sequence];
    
    // Play Sound
    [self runAction:_arrowShootSound];
}

- (void)p_updateScoreLabelWithScore:(NSInteger)score {
    _scoreLabel.text = [NSString stringWithFormat:@"Your Score - %li ",(long)score];
}

#pragma mark Contact Delegate

- (void)didBeginContact:(SKPhysicsContact *)contact {
    
    // Remove both bodies
    [contact.bodyA.node removeFromParent];
    [contact.bodyB.node removeFromParent];
    
    // Update Score Label
    [self p_updateScoreLabelWithScore:++_killedMonsters];
    
    // Play sound
    [self runAction:_arrowHitSound];
}

#pragma mark Update Delegate

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (currentTime - _lastUpdateTimeInterval > 1) {
        _lastUpdateTimeInterval = currentTime;
        [self addMonster];
    }
}

@end

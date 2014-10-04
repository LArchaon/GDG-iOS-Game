//
//  MathHelper.h
//  GDG Game
//
//  Created by Denis on 03/10/2014.
//  Copyright (c) 2014 deniss.kaibagarovs@gmail.com, Denis Kaibagarovs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MathHelper : NSObject

+ (CGPoint)getPointOnVectorWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint offset:(NSInteger)offset;

@end

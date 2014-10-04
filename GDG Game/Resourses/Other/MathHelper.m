//
//  MathHelper.m
//  GDG Game
//
//  Created by Denis on 03/10/2014.
//  Copyright (c) 2014 deniss.kaibagarovs@gmail.com, Denis Kaibagarovs. All rights reserved.
//

#import "MathHelper.h"

@implementation MathHelper

+ (CGPoint)getPointOnVectorWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint offset:(NSInteger)offset {
    // Get vector
    CGPoint vector = [self p_getVectorFromStartPoint:startPoint andEndPoint:endPoint];
    // Get vector guides
    CGPoint vectorGuides = [self p_getVectorGuidesFromVector:vector];
    // Get Multiplyed vector guides
    vectorGuides = [self p_multiplyVector:vectorGuides byNumber:offset];
    // Calculate end positin by adding vector guides to start point
    CGPoint farAwayPoint = [self p_addVector:vectorGuides toPoint:startPoint];
    // Return far away point
    return farAwayPoint;
}

+ (CGPoint)p_getVectorFromStartPoint:(CGPoint)startPoint andEndPoint:(CGPoint)endPoint {
    return CGPointMake(endPoint.x - startPoint.x, endPoint.y - startPoint.y);
}

+ (CGPoint)p_getVectorGuidesFromVector:(CGPoint)vector {
    NSInteger length = [self p_getVectorLengthFrom:vector];
    return CGPointMake(vector.x/length, vector.y/length);
}

+ (NSInteger)p_getVectorLengthFrom:(CGPoint)vector {
    return sqrt(vector.x * vector.x + vector.y * vector.y);
}

+ (CGPoint)p_multiplyVector:(CGPoint)vector byNumber:(NSInteger)number {
    return CGPointMake(vector.x * number, vector.y * number);
}

+ (CGPoint)p_addVector:(CGPoint)vector toPoint:(CGPoint)point {
    return CGPointMake(point.x + vector.x, point.y + vector.y);
}

@end

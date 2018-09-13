//
//  IDPSNStyleKit.h
//  SimpleNumpad
//
//  Created by 能登 要 on 2015/12/25.
//  Copyright (c) 2015 Irimasu Densan Planning. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface IDPSNStyleKit : NSObject

// iOS Controls Customization Outlets
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* backspaceTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* backspaceWhiteTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* backspaceCreamTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* backspaceBlackTargets;

// Generated Images
+ (UIImage*)imageOfBackspace;
+ (UIImage*)imageOfBackspaceWhite;
+ (UIImage*)imageOfBackspaceCream;
+ (UIImage*)imageOfBackspaceBlack;

@end

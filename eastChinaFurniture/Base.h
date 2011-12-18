//
//  Base.h
//  i3
//
//  Created by liangfei zhou on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Base : UIView

-(void)initApp;

-(id)creatImage:(NSString *)path frame:(CGRect)rect;

-(id)creatImage:(NSString *)path frame:(CGRect)rect event:(SEL)action;

-(id)creatImage:(NSString *)path active:(NSString *)select frame:(CGRect)rect event:(SEL)action;

-(NSString*)getFilePath:(NSString*)fileName;

@end

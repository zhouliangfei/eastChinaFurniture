//
//  Base.m
//  i3
//
//  Created by liangfei zhou on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Base.h"

@implementation Base

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        [self initApp];
    }
    
    return self;
}

-(void)initApp
{
    
}

-(NSString*)getFilePath:(NSString *)fileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@""] ;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return path;
    }
    
    //documents
    
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *directory = [documents objectAtIndex:0];
    
    
    path = [directory stringByAppendingPathComponent:fileName];
    
    //NSLog(@"%@",path);
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return path;
    }
    
    return nil;
}

-(id)creatImage:(NSString *)path frame:(CGRect)rect
{
    UIImage *data = [[[UIImage alloc] initWithContentsOfFile:[self getFilePath:path]] autorelease];

    UIImageView *imgView = [[[UIImageView alloc] initWithFrame:rect] autorelease];
    
    [imgView setImage:data];
    
    return imgView;
}

-(id)creatImage:(NSString *)path frame:(CGRect)rect event:(SEL)action
{
    UIImage *Normal = [[[UIImage alloc] initWithContentsOfFile:[self getFilePath:path]] autorelease];
    
    UIButton *button = [[[UIButton alloc] initWithFrame:rect] autorelease];
    
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button setImage:Normal forState:UIControlStateNormal];
    
    return button;
}

-(id)creatImage:(NSString *)path active:(NSString *)select frame:(CGRect)rect event:(SEL)action
{
    UIImage *Normal = [[[UIImage alloc] initWithContentsOfFile:[self getFilePath:path]] autorelease];
    
    UIImage *Active = [[[UIImage alloc] initWithContentsOfFile:[self getFilePath:select]] autorelease];
    
    UIButton *button = [[[UIButton alloc] initWithFrame:rect] autorelease];
    
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button setImage:Normal forState:UIControlStateNormal];
    
    [button setImage:Active forState:UIControlStateSelected];
    
    button.adjustsImageWhenHighlighted = FALSE;
    
    return button; 
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

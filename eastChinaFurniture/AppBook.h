//
//  AppBook.h
//  eastChinaFurniture
//
//  Created by liangfei zhou on 11-12-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Base.h"

@interface AppBook : Base <UIScrollViewDelegate>
{
    unsigned int current;
    
    unsigned int thumbPage;
    
    unsigned int total;
    
    CGSize thumb;
    
    CGSize photo;
    
    NSMutableArray *config;
    
    UIView *menu;
    
    UIView *subMenu;
    
    UIScrollView *thumbView;
    
    UIScrollView *scrollView;
}

-(void) initBook;

-(void) initMenu;

-(void) initSubMenu;

-(void) creatPage;

-(id)loadJSON:(NSString *)path;

-(void) creatThumb:(UIScrollView *)parent;

//-(void) doubleClick:(UIButton *)button;

-(void) singleClick:(UIButton *)button;

-(void) hiddenMenu:(UIButton *)button;

//-(void) touchClick:(UIButton*)button withEvent:(UIEvent*)event; 

@end

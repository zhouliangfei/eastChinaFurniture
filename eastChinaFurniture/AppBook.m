//
//  AppBook.m
//  eastChinaFurniture
//
//  Created by liangfei zhou on 11-12-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#import "JSON.h"
#import "AppBook.h"

@implementation AppBook

-(void)dealloc
{
    [menu release];
    
    [subMenu release];
    
    [scrollView release];
    
    [thumbView release];
    
    [config release];
    
    [super dealloc];
}

-(void)initApp
{
    thumb = CGSizeMake(127, 167);
    
    photo = CGSizeMake(768, 1024);
    
    NSArray *data = [self loadJSON:@"config.txt"];
    //
    if (data != nil)
    {
        thumbPage = 0;
        
        current = 0;
        
        total = [data count];
        
        //NSLog(@"%d",total);
        
        config = [[NSMutableArray alloc] init];
        
        for (unsigned int i = 0;i<total; i++)
        {
            [config addObject: [data objectAtIndex:i]];
        }
        
        [self initBook];
        
        [self initMenu];
        
        [self initSubMenu];
        
        [self creatPage];
    }
}

-(id)loadJSON:(NSString *)path
{
    NSString *url = [self getFilePath:path];
    
    if(url != nil)
    {
        NSData *file = [[NSData alloc] initWithContentsOfFile:url];
    
        NSString *content = [[NSString alloc] initWithBytes:[file bytes] length:[file length] encoding: NSUTF8StringEncoding];
    
        NSArray *value = [content JSONValue];

        [file release];
    
        [content release];
    
        return value;
    }
    return nil;
}

-(void)initBook
{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, photo.width, photo.height)];
    
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    scrollView.scrollEnabled = TRUE;
    
    scrollView.pagingEnabled = TRUE;
    
    scrollView.clipsToBounds = TRUE;
    
    scrollView.delegate = self;                       //委托
    
    [scrollView setContentSize:CGSizeMake(photo.width*total, photo.height)];
    
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    
    [scrollView setDelaysContentTouches:NO];
    
    [self addSubview:scrollView];
}

-(void)initMenu
{
    menu = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 63)];
    
    menu.backgroundColor = [UIColor colorWithWhite:0xffffff alpha:1];
    
    UIButton *button = [self creatImage:@"gui__btnmenu1.png" active:@"gui__btnmenu2.png" frame:CGRectMake(0, 0, 64, 63) event:@selector(hiddenMenu:)];
    
    button.tag = 1;
    
    [menu addSubview:button];
    
    [menu addSubview:[self creatImage:@"gui__btnShare.png" frame:CGRectMake(516, 0, 63, 63) event:@selector(goShare)]];
    
    [menu addSubview:[self creatImage:@"gui__btnBuy.png" frame:CGRectMake(579, 0, 63, 63) event:@selector(goBuy)]];
    
    [menu addSubview:[self creatImage:@"gui__btnWeb.png" frame:CGRectMake(642, 0, 63, 63) event:@selector(goWeb)]];
    
    [menu addSubview:[self creatImage:@"gui__butHelp.png" frame:CGRectMake(705, 0, 63, 63) event:@selector(goHelp)]];
    
    [menu addSubview:[self creatImage:@"gui__logo.png" frame:CGRectMake(64, 0, 305, 63)]];
    
    [menu addSubview:[self creatImage:@"gui__showdown1.png" frame:CGRectMake(0, 64, 768, 30)]]; 
    
    [self addSubview:menu];
}


-(void)initSubMenu
{
    subMenu = [[UIView alloc] initWithFrame:CGRectMake(0, 63, 768, 208)];
    
    subMenu.backgroundColor = [UIColor colorWithWhite:0xffffff alpha:0.8];
    
    subMenu.alpha = 0;
    
    subMenu.userInteractionEnabled = FALSE;
    
    thumbView = [[[UIScrollView alloc] initWithFrame:CGRectMake(8, 18, 752, 182)] autorelease];
    
    thumbView.scrollEnabled = TRUE;
    
    thumbView.delegate = self;
    
    [thumbView setContentSize:CGSizeMake((thumb.width + 10) * total-10, thumb.height)];
    
    [self creatThumb:thumbView];
    
    [subMenu addSubview:thumbView];
    
    [subMenu addSubview:[self creatImage:@"gui__showdown1.png" frame:CGRectMake(0, 208, 768, 30)]];
    
    [self addSubview:subMenu];
}

-(void)creatPage
{
    int _min = current - 1;
    
    int _max = current + 1;
    
    if(_min < 0)
        _min = 0;
    
    if(_max > total-1)
        _max = total-1;
    
    for (unsigned int i=_min; i<=_max; i++)
    {
        if(![scrollView viewWithTag:i+1])
        {      
            NSString *url = [[config objectAtIndex:i] objectForKey:@"image"];
            
            UIButton *view = [self creatImage:url frame:CGRectMake(0, 0, photo.width, photo.height) event:@selector(singleClick:)];
            
            view.adjustsImageWhenHighlighted = FALSE;
            
            UIScrollView *inner = [[[UIScrollView alloc] initWithFrame:CGRectMake(i*photo.width, 0, photo.width, photo.height)] autorelease];
            
            inner.minimumZoomScale = 1.0;
            
            inner.maximumZoomScale = 2.0;
            
            inner.delegate = self;
            
            inner.tag = i+1;
            
            [inner addSubview:view];
            
            [scrollView addSubview:inner];
        }
    }
    
    //清除没有用的图片
    for (UIScrollView *imgs in scrollView.subviews)
    {
        if(imgs.tag < _min+1 || imgs.tag > _max+1)
        {
            [imgs removeFromSuperview];
        }
    }
}
//放大
-(id)viewForZoomingInScrollView:(UIScrollView *)scroll
{
    return [scroll.subviews objectAtIndex:0];
}

-(void)scrollViewDidZoom:(UIScrollView *)scroll
{
    if(scroll.zoomScale == 1.0f)
    {
        scrollView.ScrollEnabled = TRUE;
    }
    else
    {
        scrollView.ScrollEnabled = FALSE;  
    }
    //居中对齐
    if(scroll.zoomScale <= 1.0f)
    {
        UIImageView *imageView = [scroll.subviews objectAtIndex:0];
        
        [imageView setCenter:CGPointMake(scroll.frame.size.width * 0.5, scroll.frame.size.height * 0.5)];
    }
}
//滑动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self creatPage];
}

-(void)scrollViewDidScroll:(UIScrollView *)scroll
{
    int value = 0;
    
    if(scrollView == scroll)
    {        
        value = floor((scroll.contentOffset.x + scroll.frame.size.width * 0.5) / scroll.frame.size.width);
        
        if(current != value)
        {
            current = value;
            
            //同步缩略图
            for(UIButton *btns in thumbView.subviews)
            {
                if (btns.tag == current+1)
                {
                    btns.backgroundColor = [UIColor greenColor];
                    
                    [thumbView scrollRectToVisible:CGRectMake(current * (thumb.width + 10), 0, (thumb.width + 10), thumb.height) animated:YES];
                }
                else
                {
                    btns.backgroundColor = [UIColor clearColor];
                }
            }
        }
        return;
    }
    
    if(thumbView == scroll)
    {
        value = floor((scroll.contentOffset.x + (thumb.width + 10) * 0.5) / (thumb.width + 10));
        if(thumbPage != value)
        {
            thumbPage = value;
            
            [self creatThumb:thumbView];
        }
        return;
    }
}
//按钮点击
/*-(void)touchClick:(id)button withEvent:(UIEvent*)event
{
    UITouch* touch = [[event allTouches] anyObject];
    
    switch (touch.tapCount)
    {
        case 1:
            [self performSelector:@selector(singleClick:) withObject:button afterDelay:0.2];
            
            break;
            
        case 2:
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleClick:) object:button]; 
            
            [self doubleClick:button]; 
            
            break;
            
        default:
            break;
    }
}

-(void)doubleClick:(UIButton *)button
{
    NSLog(@"doubleClick=%d",button.tag);
}*/

-(void)singleClick:(UIButton *)button
{
    UIButton *menuButton = (UIButton *)[menu viewWithTag:1];
    
    if(menuButton.selected)
    {
        [self hiddenMenu:menuButton];
    }
    
    [UIView beginAnimations:@"menuHidden" context:nil];
    
    [UIView setAnimationDuration:.2];
    
    if (menu.frame.origin.y == 0)
    {
        menu.frame = CGRectMake(0, -63, 768, 63);
    }
    else
    {
        menu.frame = CGRectMake(0, 0, 768, 63);
    }
    
    [UIView commitAnimations];
}

//生成缩略图
-(void)creatThumb:(UIScrollView *)parent
{
    int _min = thumbPage - 3;
    
    int _max = thumbPage + 6;
    
    if(_min < 0)
        _min = 0;
    
    if(_max > total-1)
        _max = total-1;
    
    for (unsigned int i=_min; i<=_max; i++)
    {
        if(![parent viewWithTag:i+1])
        {
            NSString *url = [[config objectAtIndex:i] objectForKey:@"thumb"];
        
            UIButton *btn = [self creatImage:url frame:CGRectMake(i * (thumb.width + 10), 0, thumb.width, thumb.height) event:@selector(thumbClick:)];
        
            btn.tag = i + 1;
        
            [parent addSubview:btn];
        }
    }
    //清除没有用的图片
    for (UIScrollView *imgs in parent.subviews)
    {
        if(imgs.tag < _min+1 || imgs.tag > _max+1)
        {
            [imgs removeFromSuperview];
        }
    }
}

-(void)thumbClick:(UIButton *)button
{
    if (scrollView.isScrollEnabled)
    {
        [scrollView scrollRectToVisible:CGRectMake((button.tag-1)*photo.width, 0, photo.width, photo.height) animated:NO];
        
        [self scrollViewDidEndDecelerating:scrollView];
        
        [self singleClick:button];
    }
}
//隐藏菜单
-(void)hiddenMenu:(UIButton *)button
{
    subMenu.userInteractionEnabled =! subMenu.userInteractionEnabled;
    
    [UIView beginAnimations:@"thumbHidden" context:nil];
    
    [UIView setAnimationDuration:.5];
    
    if (subMenu.userInteractionEnabled)
    {   
        subMenu.alpha = 1;
    }
    else
    {  
        subMenu.alpha = 0;
    }
    
    [UIView commitAnimations];
    
    button.selected = subMenu.userInteractionEnabled;
}

-(void)goShare
{
}

-(void)goBuy
{
}

-(void)goWeb
{
}

-(void)goHelp
{
}

@end

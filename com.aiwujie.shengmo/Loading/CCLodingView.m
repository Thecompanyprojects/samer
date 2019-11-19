//
//  CCLodingView.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CCLodingView.h"

@implementation CCLodingView
{
    CADisplayLink * _link;
    CAShapeLayer *  _animationLayer;
    CGFloat         _lineWidth;
    CGFloat         _startAngle;
    CGFloat         _endAngle;
    CGFloat         _progressQuick;
    CGFloat         _progressSlow;
    BOOL            _isIncrease;
    BOOL            _isIncreaseNeedChange;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _lineWidth = 3;
        _startAngle = -M_PI_2;
        _endAngle = -M_PI_2;
        _progressQuick = 0;
        _progressSlow = 0;
        _isIncrease = true;
        _isIncreaseNeedChange = false;
        
        _animationLayer = [CAShapeLayer layer];
        _animationLayer.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        _animationLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        _animationLayer.fillColor = [UIColor clearColor].CGColor;
        _animationLayer.strokeColor = [UIColor whiteColor].CGColor;
        _animationLayer.lineWidth = _lineWidth;
        _animationLayer.lineCap = kCALineCapRound;
        [self.layer addSublayer:_animationLayer];
        
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        _link.paused = true;
        
        self.backgroundColor = [UIColor clearColor];
        [self setUserInteractionEnabled:false];
    }
    
    return self;
}

-(void)startAnimation {
    _progressQuick = 0;
    _progressSlow = 0;
    _isIncrease = true;
    _isIncreaseNeedChange = false;
    _link.paused = false;
}

-(void)stopAnimation {
    _link.paused = true;
}

-(void)displayLinkAction{
    _progressQuick += 1/60.0f;
    if (_progressQuick >= 1) {
        _progressQuick = 0;
        _isIncreaseNeedChange = true;
    }
    
    _progressSlow += 1/600.0f;
    if (_progressSlow >= 1) {
        _progressSlow = 0;
    }
    
    if (_isIncreaseNeedChange) {
        if (_progressQuick >= _progressSlow) {
            _isIncreaseNeedChange = false;
            _isIncrease = !_isIncrease;
        }
    }
    
    [self updateAnimationLayer];
}

-(void)updateAnimationLayer{
    if (_isIncrease) {
        _startAngle = -M_PI_2 +_progressSlow * M_PI * 2;
        _endAngle = -M_PI_2 +_progressQuick * M_PI * 2;
    } else {
        _startAngle = -M_PI_2 +_progressSlow * M_PI * 2;
        _endAngle = -M_PI_2 +_progressQuick * M_PI * 2;
    }
    
    CGFloat radius = _animationLayer.bounds.size.width/2 - _lineWidth/2;
    CGFloat centerX = _animationLayer.bounds.size.width/2;
    CGFloat centerY = _animationLayer.bounds.size.height/2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:_startAngle endAngle:_endAngle clockwise:_isIncrease];
    path.lineCapStyle = kCGLineCapRound;
    _animationLayer.path = path.CGPath;
}

-(void)drawCircleAnimationLayer{
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    path.lineCapStyle = kCGLineCapRound;
    _animationLayer.path = path.CGPath;
}
@end

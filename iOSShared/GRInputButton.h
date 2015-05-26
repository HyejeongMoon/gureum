//
//  GRInputButton.h
//  iOS
//
//  Created by Jeong YunWon on 2014. 8. 20..
//  Copyright (c) 2014년 youknowone.org. All rights reserved.
//

#import <UIKit/UIKit.h>


@class GRInputEffectView;

@interface GRInputButton: UIButton

@property(readonly) UIImageView *glyphView;
@property(readonly) UILabel *captionLabel;
@property(readonly) GRInputEffectView *effectView;

@property(nonatomic,copy) NSString *title;
@property(nonatomic,retain) UIImage *effectBackgroundImage;

- (void)showEffect;
- (void)hideEffect;
- (void)arrange;

@end


@interface GRInputEffectView: UIView

@property(readonly) UIImageView *backgroundImageView;
@property(readonly) UILabel *textLabel;

@end

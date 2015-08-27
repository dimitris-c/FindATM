//
//  ATMFilterView.m
//  ATMMoney
//
//  Created by Dimitris C. on 07/07/2015.
//  Copyright (c) 2015 Find ATM. All rights reserved.
//

#import "ATMFilterView.h"
#import "Bank.h"
#import "ATMPlainCustomButton.h"
#import "ATMUserSettings.h"

@interface BankButton : ATMPlainCustomButton
@property (nonatomic, assign) EBankType bankType;
@end

@interface ATMFilterView ()
@property (nonatomic, strong, readwrite) NSMutableArray *selectedBanks;

@property (nonatomic, strong) UIView *mainViewContainer;

@property (nonatomic, strong) NSMutableArray *bankViewsArray;
@property (nonatomic, strong) UILabel   *selectBanksLabel;
@property (nonatomic, strong) UIView    *bankViewsContainer;

@property (nonatomic, strong) UILabel   *distanceTitleLabel;
@property (nonatomic, strong) UILabel   *selectedDistanceLabel;
@property (nonatomic, strong) UISlider  *distanceSlider;

@property (nonatomic, strong) UIView *blackBackground;

@property (nonatomic, strong) ATMPlainCustomButton *doneButton;

@end

static CGFloat const kBlackBackgroundAlphaValue = 0.7;
static CGFloat const kAnimationDurationForHideAndShowValue = 0.35;

@implementation ATMFilterView

- (instancetype)initWithFrame:(CGRect)frame andSelectedBanks:(NSMutableArray *)selectedBanks {
    self = [super initWithFrame:frame];
    if (self) {
        self.multipleTouchEnabled = NO;
        
        if (selectedBanks)
            self.selectedBanks = selectedBanks;
        else
            self.selectedBanks = [[NSMutableArray alloc] init];
        
        self.blackBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        self.blackBackground.backgroundColor = [UIColor blackColor];
        self.blackBackground.alpha = kBlackBackgroundAlphaValue;
        
        UITapGestureRecognizer *blackBackgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exit)];
        [self.blackBackground addGestureRecognizer:blackBackgroundTap];
        [self addSubview:self.blackBackground];
        
        self.mainViewContainer = [[UIView alloc] init];
        self.mainViewContainer.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.mainViewContainer];
        
        self.selectBanksLabel = [[UILabel alloc] init];
        self.selectBanksLabel.font = [UIFont boldSystemFontOfSize:13];
        self.selectBanksLabel.textColor = [UIColor blackColor];
        self.selectBanksLabel.text = NSLocalizedStringFromTable(@"filterview.sections.title.selectbanks", @"Localization", nil);
        //@"Select Desired Banks";
        self.selectBanksLabel.textAlignment = NSTextAlignmentCenter;
        self.selectBanksLabel.backgroundColor = [UIColor clearColor];
        [self.mainViewContainer addSubview:self.selectBanksLabel];
        
        self.bankViewsContainer = [[UIView alloc] initWithFrame:frame];
        [self.mainViewContainer addSubview:self.bankViewsContainer];

        
        self.bankViewsArray = [NSMutableArray arrayWithCapacity:TOTAL_BANKS];

        NSInteger maxItemsPerColumn = TOTAL_BANKS * 0.5;
        CGFloat padding = 5;
        CGSize buttonSize = CGSizeMake(60, 60);
        NSInteger count = 0;
        
        for (NSInteger i = 0; i < TOTAL_BANKS; i++) {
            if (i == EBankTypeCitybank) continue;
            
            BankButton *bankButton = [[BankButton alloc] init];
            bankButton.bankType = i;
            [bankButton addTarget:self action:@selector(bankButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            CGFloat col = count / maxItemsPerColumn;
            CGFloat row = count % maxItemsPerColumn;
            CGFloat x = floorf(row * (buttonSize.width + padding));
            CGFloat y = floorf(col * (buttonSize.height + padding));
            
            bankButton.frame = CGRectMake(x,
                                          y,
                                          buttonSize.width,
                                          buttonSize.height);
            bankButton.normalBackgroundColor    = [UIColor colorWithRed:0.47 green:0.83 blue:0.95 alpha:1];
            bankButton.selectedBackgroundColor  = [UIColor colorWithRed:0 green:0.52 blue:0.75 alpha:1];
            
            bankButton.backgroundColor          = bankButton.selectedBackgroundColor;
            if (selectedBanks.count == 0) {
                [bankButton setSelected:YES];
                [self.selectedBanks addObject:@(bankButton.buttonType)];
            }
            else {
                if ([self.selectedBanks containsObject:@(bankButton.bankType)])
                    [bankButton setSelected:YES];
            }
            
            [bankButton setImage:[Bank getBankLogoFromBankType:i] forState:UIControlStateNormal];
            bankButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            
            [self.bankViewsContainer addSubview:bankButton];
            [self.bankViewsArray addObject:bankButton];

            count++;
        }
        
        [ATMUserSettings saveFavouritesBanks:self.selectedBanks];
        
        self.distanceTitleLabel = [[UILabel alloc] init];
        self.distanceTitleLabel.font = [UIFont boldSystemFontOfSize:13];
        self.distanceTitleLabel.textColor = [UIColor blackColor];
        self.distanceTitleLabel.text = NSLocalizedStringFromTable(@"filterview.sections.title.distance", @"Localization", nil);
        self.distanceTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.distanceTitleLabel.backgroundColor = [UIColor clearColor];
        [self.mainViewContainer addSubview:self.distanceTitleLabel];

        
        self.selectedDistanceLabel = [[UILabel alloc] init];
        self.selectedDistanceLabel.font = [UIFont boldSystemFontOfSize:12];
        self.selectedDistanceLabel.textColor = [UIColor darkGrayColor];
        self.selectedDistanceLabel.text = @"200 km";
        [self.selectedDistanceLabel sizeToFit];
        self.selectedDistanceLabel.textAlignment = NSTextAlignmentCenter;
        self.selectedDistanceLabel.backgroundColor = [UIColor clearColor];
        [self.mainViewContainer addSubview:self.selectedDistanceLabel];
        
        self.distanceSlider = [[UISlider alloc] init];
        self.distanceSlider.minimumValue = 0.2; // 200 m
        self.distanceSlider.maximumValue = 5; // 200 km
        CGFloat savedDistance = [ATMUserSettings getDistance];
        self.distanceSlider.value = (savedDistance) ? [ATMUserSettings getDistance] : 2;
        [self.distanceSlider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
        [self.mainViewContainer addSubview:self.distanceSlider];
        
        [self sliderValueChanged];
        
        // Default button size 44...
        self.doneButton = [[ATMPlainCustomButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 44)];
        [self.doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        self.doneButton.normalBackgroundColor = [UIColor colorWithRed:0.47 green:0.83 blue:0.95 alpha:1];
        self.doneButton.selectedBackgroundColor = [UIColor colorWithRed:0.2892 green:0.5278 blue:0.6047 alpha:1.0];
        self.doneButton.backgroundColor = self.doneButton.normalBackgroundColor;
        self.doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.doneButton setTitle:@"DONE" forState:UIControlStateNormal];
        
        [self.mainViewContainer addSubview:self.doneButton];
        
    }
    return self;
}

- (void)bankButtonTapped:(BankButton *)button {
    
    if (!button.isSelected)
        button.selected = YES;
    else
        button.selected = NO;
    
    if ([self.selectedBanks containsObject:@(button.bankType)])
        [self.selectedBanks removeObject:@(button.bankType)];
    else
        [self.selectedBanks addObject:@(button.bankType)];
    
    
}

- (void)sliderValueChanged {
    
    NSInteger distance = (self.distanceSlider.value < 1) ? self.distanceSlider.value * 1000 : self.distanceSlider.value;
    NSString *type = (self.distanceSlider.value < 1) ? @"m" : @"km";
    self.selectedDistanceLabel.text = [NSString stringWithFormat:@"%ld %@", (long)distance, type];
    
}

- (void)doneButtonPressed {
    
    if (self.selectedBanks.count == 0) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedStringFromTable(@"filterview.noselection.errortitle", @"Localization", nil)];
        return;
    }
    
    [ATMUserSettings saveDistance:self.distanceSlider.value];
    [ATMUserSettings saveFavouritesBanks:self.selectedBanks];
    
    [self hideAnimatedWithCompletion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(filterViewDidRequestToFilterData)]) {
            [self.delegate filterViewDidRequestToFilterData];
        }
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 10;
    
    self.blackBackground.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    [self.selectBanksLabel sizeToFit];
    self.selectBanksLabel.frame = CGRectMake(0, padding * 2, CGRectGetWidth(self.frame), CGRectGetHeight(self.selectBanksLabel.frame));
    
    BankButton *bankButton = [self.bankViewsArray objectAtIndex:0]; // get a button
    
    CGFloat bankViewsContainerHeight = (CGRectGetHeight(bankButton.frame) * 2) + padding *2;
    CGFloat bankViewsContainerWidth = (CGRectGetWidth(bankButton.frame) * 4) + padding *2;
    
    self.bankViewsContainer.frame = CGRectMake(floorf((CGRectGetWidth(self.frame) - bankViewsContainerWidth)  * 0.5),
                                               CGRectGetMaxY(self.selectBanksLabel.frame) + padding,
                                               bankViewsContainerWidth,
                                               bankViewsContainerHeight);
    
    [self.distanceTitleLabel sizeToFit];
    self.distanceTitleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.bankViewsContainer.frame) + padding, CGRectGetWidth(self.frame), CGRectGetHeight(self.distanceTitleLabel.frame));
    
    [self.distanceSlider sizeToFit];
    CGRect rect = CGRectInset(self.frame, floorf(CGRectGetWidth(self.selectedDistanceLabel.frame) + padding), 0);
    CGFloat totalWidthOfSliderAndLabel = CGRectGetWidth(rect) + CGRectGetWidth(self.selectedDistanceLabel.frame);
    self.distanceSlider.frame = CGRectMake(floorf((CGRectGetWidth(self.frame) - totalWidthOfSliderAndLabel) * 0.5),
                                           CGRectGetMaxY(self.distanceTitleLabel.frame) + padding,
                                           CGRectGetWidth(rect),
                                           CGRectGetHeight(self.distanceSlider.frame));
    
    self.selectedDistanceLabel.frame = CGRectMake(CGRectGetMaxX(self.distanceSlider.frame) + padding,
                                                  floorf(CGRectGetMinY(self.distanceSlider.frame) + (CGRectGetHeight(self.distanceSlider.frame) - CGRectGetHeight(self.selectedDistanceLabel.frame)) * 0.5),
                                                  CGRectGetWidth(self.selectedDistanceLabel.frame),
                                                  CGRectGetHeight(self.selectedDistanceLabel.frame));
    
    self.doneButton.frame = CGRectMake(0,
                                       CGRectGetMaxY(self.distanceSlider.frame) + padding * 2,
                                       CGRectGetWidth(self.bounds),
                                       CGRectGetHeight(self.doneButton.frame));
    
    
    CGFloat mainViewContainerHeight = CGRectGetMaxY(self.doneButton.frame);
    self.mainViewContainer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), mainViewContainerHeight);
    
    
}

- (void)showAnimatedWithCompletion:(VoidBlock)completion {
    
    self.blackBackground.alpha = 0.0;
    self.mainViewContainer.frame = CGRectMake(0, -CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [UIView animateWithDuration:kAnimationDurationForHideAndShowValue
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                            self.blackBackground.alpha = kBlackBackgroundAlphaValue;
                            self.mainViewContainer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
                     }
                     completion:^(BOOL finished) {
                         if (completion != nil) {
                             completion();
                         }
    }];
    
}

- (void)hideAnimatedWithCompletion:(VoidBlock)completion {
    
    [UIView animateWithDuration:kAnimationDurationForHideAndShowValue
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.blackBackground.alpha = 0.0;
                         self.mainViewContainer.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         if (completion != nil) {
                             completion();
                         }
                     }];
    
}

- (void)exit {
    [self hideAnimatedWithCompletion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(filterViewDidRequestToClose)]) {
            [self.delegate filterViewDidRequestToClose];
        }
    }];
}


@end


@interface BankButton ()
@property (nonatomic, strong) UIView *selectedBackgroundView;
@property (nonatomic, strong) UIImageView *selectedBackgroundIcon;
@end
@implementation BankButton


- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] init];
        self.selectedBackgroundView.userInteractionEnabled = NO;
        self.selectedBackgroundView.backgroundColor = [UIColor blackColor];
        self.selectedBackgroundView.alpha = 0.5;
        [self addSubview:self.selectedBackgroundView];
        
        self.selectedBackgroundIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark-icon"]];
        [self.selectedBackgroundIcon sizeToFit];
        [self addSubview:self.selectedBackgroundIcon];
        
        self.selectedBackgroundView.hidden = YES;
        self.selectedBackgroundIcon.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.selectedBackgroundView.frame = CGRectMake(CGRectGetMinX(self.imageView.frame),
                                                   CGRectGetMinY(self.imageView.frame),
                                                   CGRectGetWidth(self.imageView.frame),
                                                   CGRectGetHeight(self.imageView.frame));
    
    self.selectedBackgroundIcon.frame = CGRectMake(floorf(CGRectGetWidth(self.selectedBackgroundView.frame) - CGRectGetWidth(self.selectedBackgroundIcon.frame)),
                                                   floorf(CGRectGetHeight(self.selectedBackgroundView.frame) - CGRectGetHeight(self.selectedBackgroundIcon.frame)),
                                                   CGRectGetWidth(self.selectedBackgroundIcon.frame),
                                                   CGRectGetHeight(self.selectedBackgroundIcon.frame));
    
}

- (void)setHighlighted:(BOOL)highlighted {
//    [super setHighlighted:highlighted];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.backgroundColor = (selected) ? self.selectedBackgroundColor : self.normalBackgroundColor;

    self.selectedBackgroundView.hidden = !selected;
    self.selectedBackgroundIcon.hidden = !selected;
}

@end

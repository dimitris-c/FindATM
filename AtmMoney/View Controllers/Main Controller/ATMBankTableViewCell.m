//
//  ATMBankTableViewCell.m
//  AtmMoney
//
//  Created by Dimitris C. on 7/4/15.
//  Copyright (c) 2015 Find ATM. All rights reserved.
//

#import "ATMBankTableViewCell.h"
#import "LocationHandler.h"

@interface ATMBankTableViewCell ()
@property (nonatomic,strong) UIImageView    *bankLogoImageView;
@property (nonatomic,strong) UILabel        *titleLabel;
@property (nonatomic,strong) UILabel        *addressLabel;

@property (nonatomic,strong) UIImageView    *visitorsIcon;
@property (nonatomic,strong) UILabel        *visitorsLabel;

@property (nonatomic,strong) UIImageView    *moneyIcon;
@property (nonatomic,strong) UILabel        *moneyLabel;

@property (nonatomic,strong) UILabel        *distanceOfATMLabel;
@property (nonatomic,strong) UIImageView    *disclosureImageView;
@end

@implementation ATMBankTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.contentView.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.91 green:0.96 blue:0.98 alpha:1.0];
        
        self.bankLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"atm-placeholder"]];
        self.bankLogoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.bankLogoImageView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleLabel];

        
        self.addressLabel = [[UILabel alloc] init];
        self.addressLabel.font = [UIFont systemFontOfSize:12];
        self.addressLabel.textColor = [UIColor blackColor];
        self.addressLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.addressLabel];
        
        self.visitorsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"visitors-icon"]];
        [self.visitorsIcon sizeToFit];
        [self.contentView addSubview:self.visitorsIcon];
        
        self.visitorsLabel = [[UILabel alloc] init];
        self.visitorsLabel.font = [UIFont systemFontOfSize:13];
        self.visitorsLabel.textColor = [UIColor colorWithRed:0 green:0.52 blue:0.75 alpha:1.0];
        self.visitorsLabel.backgroundColor = [UIColor clearColor];
        self.visitorsLabel.text = @"10000 visitors";
        [self.contentView addSubview:self.visitorsLabel];
        
        self.moneyIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"money-icon-full"]];
        [self.moneyIcon sizeToFit];
        [self.contentView addSubview:self.moneyIcon];

        self.moneyLabel = [[UILabel alloc] init];
        self.moneyLabel.font = [UIFont systemFontOfSize:13];
        self.moneyLabel.textColor = [UIColor blackColor];
        self.moneyLabel.backgroundColor = [UIColor clearColor];
        self.moneyLabel.text = @"";
        [self.contentView addSubview:self.moneyLabel];

//        self.distanceOfATMLabel = [[UILabel alloc] init];
//        self.distanceOfATMLabel.font = [UIFont systemFontOfSize:12];
//        self.distanceOfATMLabel.textColor = [UIColor lightGrayColor];
//        self.distanceOfATMLabel.backgroundColor = [UIColor clearColor];
//        self.distanceOfATMLabel.text = @"400m";
//        [self.contentView addSubview:self.distanceOfATMLabel];
        
        self.disclosureImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell-disclosure-icon"]];
        [self.disclosureImageView sizeToFit];
        [self.contentView addSubview:self.disclosureImageView];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 5;
    CGFloat disclosurePadding = 12;
    
    self.disclosureImageView.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - CGRectGetWidth(self.disclosureImageView.frame) - disclosurePadding,
                                                floorf((CGRectGetHeight(self.contentView.frame) - CGRectGetHeight(self.disclosureImageView.frame)) * 0.5),
                                                CGRectGetWidth(self.disclosureImageView.frame),
                                                CGRectGetHeight(self.disclosureImageView.frame));
    
//    [self.distanceOfATMLabel sizeToFit];
//    self.distanceOfATMLabel.frame = CGRectMake(CGRectGetMinX(self.disclosureImageView.frame) - CGRectGetWidth(self.distanceOfATMLabel.frame) - padding,
//                                               floorf(CGRectGetMinY(self.disclosureImageView.frame) + (CGRectGetHeight(self.disclosureImageView.frame) - CGRectGetHeight(self.distanceOfATMLabel.frame)) * 0.5),
//                                               CGRectGetWidth(self.distanceOfATMLabel.frame),
//                                               CGRectGetHeight(self.distanceOfATMLabel.frame));
    
    self.bankLogoImageView.frame = CGRectMake(padding,
                                              padding * 2,//floorf((CGRectGetHeight(self.contentView.frame) - CGRectGetHeight(self.bankLogoImageView.frame)) * 0.5),
                                              CGRectGetWidth(self.bankLogoImageView.frame),
                                              CGRectGetHeight(self.bankLogoImageView.frame));
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.bankLogoImageView.frame) + padding,
                                       CGRectGetMinY(self.bankLogoImageView.frame),
                                       CGRectGetWidth(self.titleLabel.frame),
                                       CGRectGetHeight(self.titleLabel.frame));
    
    [self.addressLabel sizeToFit];
    self.addressLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame),
                                         CGRectGetMaxY(self.titleLabel.frame),
                                         CGRectGetMinX(self.disclosureImageView.frame) - padding,
                                         CGRectGetHeight(self.addressLabel.frame));
    
    // the icon on the far right...
    CGFloat maxWidthForIcons = CGRectGetMinX(self.disclosureImageView.frame) - CGRectGetMinX(self.titleLabel.frame);
    CGFloat widthShrinkOffset = 20;
    // the width for each of the bottom icon and label...
    CGFloat widthForEachIcon = floorf(maxWidthForIcons * 0.5) - widthShrinkOffset;
    
    [self.visitorsIcon sizeToFit];
    self.visitorsIcon.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame),
                                         floorf(CGRectGetHeight(self.contentView.frame) - CGRectGetHeight(self.visitorsIcon.frame) - padding),
                                         CGRectGetWidth(self.visitorsIcon.frame),
                                         CGRectGetHeight(self.visitorsIcon.frame));

    [self.visitorsLabel sizeToFit];

    self.visitorsLabel.frame = CGRectMake(CGRectGetMaxX(self.visitorsIcon.frame) + padding,
                                          floorf(CGRectGetMinY(self.visitorsIcon.frame) + (CGRectGetHeight(self.visitorsIcon.frame) - CGRectGetHeight(self.visitorsLabel.frame)) * 0.5 ),
                                          floorf(widthForEachIcon - CGRectGetWidth(self.visitorsIcon.frame) - padding),
                                          CGRectGetHeight(self.visitorsLabel.frame));
    
    
    [self.moneyIcon sizeToFit];
    self.moneyIcon.frame = CGRectMake(CGRectGetMaxX(self.visitorsLabel.frame),
                                      floorf(CGRectGetHeight(self.contentView.frame) - CGRectGetHeight(self.moneyIcon.frame) - padding),
                                      CGRectGetWidth(self.moneyIcon.frame),
                                      CGRectGetHeight(self.moneyIcon.frame));
    
    
    [self.moneyLabel sizeToFit];
    self.moneyLabel.frame = CGRectMake(CGRectGetMaxX(self.moneyIcon.frame) + padding,
                                       floorf(CGRectGetMinY(self.moneyIcon.frame) + (CGRectGetHeight(self.moneyIcon.frame) - CGRectGetHeight(self.moneyLabel.frame)) * 0.5 ),
                                       CGRectGetWidth(self.moneyLabel.frame),
                                       CGRectGetHeight(self.moneyLabel.frame));
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
//    self.titleLabel.text = @"";
//    self.addressLabel.text = @"";
}

- (void)updateWithBank:(Bank *)bank {
    self.titleLabel.text = [Bank getBankNameFromType:bank.bankType];
    self.addressLabel.text = bank.address;
    
    self.moneyLabel.text = [Bank getStateNameFromState:bank.bankState];
    self.moneyLabel.textColor = [Bank getTextColorFromBankState:bank.bankState];
    self.moneyIcon.image = [UIImage imageNamed:[Bank getImageNameFromBankState:bank.bankState]];
    
    self.bankLogoImageView.image = [Bank getBankLogoFromBankType:bank.bankType];
    self.visitorsLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%ld visitors.count", @"Localization", @""), (long)bank.visitors];
    
    [self layoutIfNeeded];
    
}

@end

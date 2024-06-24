//
//  HLAgreementLabel.m
//  HLAgreementLabel
//
//  Created by 黄常翁 on 2024/6/21.
//

#import "HLAgreementLabel.h"

@interface HLAgreementLabel()
@end

@implementation HLAgreementLabel

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self build];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self build];
    }
    return self;
}

#pragma mark - Private Mehtod

- (void)build
{
    self.userInteractionEnabled = YES;
    
    [super setFont:[UIFont systemFontOfSize:14]];
    _normalTextColor = [UIColor blackColor];
    _highlightTextColor = [UIColor blueColor];
    _highlightTextIsBold = NO;
    _iconNormalColor = [UIColor lightGrayColor];
    _iconSelectedColor = [UIColor blueColor];
    _iconImage = [HLAgreementLabel imageNamed:@"checkbox_n"];
    _iconSelectedImage = [HLAgreementLabel imageNamed:@"checkbox_s"];
    _iconTapSize = CGSizeMake(self.font.lineHeight, self.font.lineHeight);
    _hideIcon = NO;
    _textIconSpace = 4;
    _needResponseIconTapAction = NO;
    _disableRenderIcon = YES;
    _lineSpacing = 2;
    _selected = NO;
}

- (void)renderUI
{
    if (!self.allText) {
        return;
    }
    
    CGSize iconSize = CGSizeMake(self.font.pointSize, self.font.pointSize);
    __weak typeof(self) weakSelf = self;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.allText];
    [attributedString addAttribute:NSForegroundColorAttributeName 
                             value:self.normalTextColor
                             range:NSMakeRange(0, self.allText.length)];
    // icon
    if (!self.hideIcon) {
        UIImage *iconImage = [HLAgreementLabel resizeImage:[self currentIconImage] toSize:iconSize];
        NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:iconImage
                                                                                              contentMode:UIViewContentModeCenter
                                                                                           attachmentSize:self.iconTapSize
                                                                                              alignToFont:self.font
                                                                                                alignment:(YYTextVerticalAlignment)YYTextVerticalAlignmentCenter];
        [attachment appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        [attachment addAttribute:NSKernAttributeName
                           value:@(self.textIconSpace - [self blankWidth])
                           range:NSMakeRange(0, attachment.length)];
        [attributedString insertAttributedString:attachment atIndex:0];
    }
    
    // font & lineSpacing
    [attributedString addAttribute:NSFontAttributeName
                             value:self.font
                             range:NSMakeRange(0, attributedString.length)];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing  = self.lineSpacing;
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraph
                             range:NSMakeRange(0, self.allText.length)];
    // highlight text
    NSArray *highlightRanges = [self highlightRanges];
    for (NSValue *highlightRangeValue in highlightRanges) {
        NSRange highlightRange = [highlightRangeValue rangeValue];
        if (self.highlightTextIsBold) {
            [attributedString addAttribute:NSFontAttributeName
                                     value:[UIFont boldSystemFontOfSize:self.font.pointSize]
                                     range:highlightRange];
        }
        [attributedString yy_setTextHighlightRange:highlightRange
                                             color:self.highlightTextColor
                                   backgroundColor:self.backgroundColor
                                         tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (weakSelf.highlightTextTapBlock) {
                weakSelf.highlightTextTapBlock([text.string substringWithRange:range],range);
            }
        }];
    }
    
    // icon tap
    NSMutableArray *iconResponseRanges = [NSMutableArray array];
    if (self.needResponseIconTapAction) {
        iconResponseRanges = [HLAgreementLabel excludeRanges:highlightRanges inStringLength:attributedString.length];
    } else {
        if(!self.hideIcon) {
            iconResponseRanges = [@[[NSValue valueWithRange:NSMakeRange(0, 2)]] mutableCopy];
        }
    }
    for (NSValue *iconRangeValue in iconResponseRanges) {
        [attributedString yy_setTextHighlightRange:[iconRangeValue rangeValue]
                                             color:self.iconNormalColor
                                   backgroundColor:self.backgroundColor 
                                         tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            weakSelf.selected = !weakSelf.selected;
            [weakSelf renderUI];
            if(weakSelf.iconTapBlock){
                weakSelf.iconTapBlock(weakSelf.selected, range);
            }
        }];
    }
    
    self.attributedText = attributedString;
}

/// 空格宽度
- (CGFloat)blankWidth
{
    CGRect rect = [@" " boundingRectWithSize:CGSizeMake(MAXFLOAT, 20)
       options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.font.pointSize]}
       context:nil];
    return rect.size.width;
}

/// 根据高亮的文字数组获取其所在的ranges
- (NSMutableArray *)highlightRanges
{
    NSMutableArray *highlightStrs = [self.highlightText componentsSeparatedByString:@"|"].mutableCopy;
    highlightStrs = [HLAgreementLabel removeSameObjectInArray:highlightStrs];
    NSString *inString = self.allText;
    if (!self.hideIcon) {
        inString = [@"  " stringByAppendingString:self.allText];
    }
    NSMutableArray *highlightRanges = [NSMutableArray array];
    for (NSString *subStr in highlightStrs){
        NSMutableArray *subHighlightRanges = [HLAgreementLabel rangesOfSubString:subStr inString:inString];
        [highlightRanges addObjectsFromArray:subHighlightRanges];
    }
    return highlightRanges;
}

/// 获取当前状态下的选择图标
- (UIImage *)currentIconImage
{
    UIImage *image = nil;
    if(self.selected){
        image = self.disableRenderIcon ? self.iconSelectedImage : [HLAgreementLabel renderImage:self.iconSelectedImage toColor:self.iconSelectedColor];
    }else{
        image = self.disableRenderIcon ? self.iconImage : [HLAgreementLabel renderImage:self.iconImage toColor:self.iconNormalColor];
    }
    return image;
}

#pragma mark - Setter

- (void)setNormalTextColor:(UIColor *)normalTextColor {
    if (_normalTextColor != normalTextColor) {
        _normalTextColor = normalTextColor;
        [self renderUI];
    }
}

- (void)setHighlightTextColor:(UIColor *)highlightTextColor {
    if (_highlightTextColor != highlightTextColor) {
        _highlightTextColor = highlightTextColor;
        [self renderUI];
    }
}

- (void)setHighlightTextIsBold:(BOOL)highlightTextIsBold {
    if (_highlightTextIsBold != highlightTextIsBold) {
        _highlightTextIsBold = highlightTextIsBold;
        [self renderUI];
    }
}

- (void)setIconNormalColor:(UIColor *)iconNormalColor {
    if (_iconNormalColor != iconNormalColor) {
        _iconNormalColor = iconNormalColor;
        [self renderUI];
    }
}

- (void)setIconSelectedColor:(UIColor *)iconSelectedColor {
    if (_iconSelectedColor != iconSelectedColor) {
        _iconSelectedColor = iconSelectedColor;
        [self renderUI];
    }
}

- (void)setIconImage:(UIImage *)iconImage {
    if (_iconImage != iconImage) {
        _iconImage = iconImage;
        [self renderUI];
    }
}

- (void)setIconSelectedImage:(UIImage *)iconSelectedImage {
    if (_iconSelectedImage != iconSelectedImage) {
        _iconSelectedImage = iconSelectedImage;
        [self renderUI];
    }
}

- (void)setIconTapSize:(CGSize)iconTapSize {
    if (_iconTapSize.width != iconTapSize.width || _iconTapSize.height != iconTapSize.height) {
        _iconTapSize = iconTapSize;
        [self renderUI];
    }
}

- (void)setHideIcon:(BOOL)hideIcon {
    if (_hideIcon != hideIcon) {
        _hideIcon = hideIcon;
        [self renderUI];
    }
}

- (void)setTextIconSpace:(CGFloat)textIconSpace {
    if (_textIconSpace != textIconSpace) {
        _textIconSpace = textIconSpace;
        [self renderUI];
    }
}

- (void)setNeedResponseIconTapAction:(BOOL)needResponseIconTapAction {
    if (_needResponseIconTapAction != needResponseIconTapAction) {
        _needResponseIconTapAction = needResponseIconTapAction;
        [self renderUI];
    }
}

- (void)setAllText:(NSString *)allText {
    [super setText:allText];
    if (![_allText isEqualToString:allText]) {
        _allText = allText;
        [self renderUI];
    }
}

- (void)setHighlightText:(NSString *)highlightText {
    if (![_highlightText isEqualToString:highlightText]) {
        _highlightText = highlightText;
        [self renderUI];
    }
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    if (_lineSpacing != lineSpacing) {
        _lineSpacing = lineSpacing;
        [self renderUI];
    }
}

- (void)setSelected:(BOOL)selected {
    if (_selected != selected) {
        _selected = selected;
        [self renderUI];
    }
}

#pragma mark - Util Method

+ (NSBundle *)resourceBundle
{
    static NSBundle *hlBundle = nil;
    if (hlBundle == nil) {
        NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"HLAgreementLabel")];
        NSURL *bundleURL = [bundle URLForResource:@"HLAgreementLabel" withExtension:@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithURL:bundleURL];
        if (!resourceBundle) {
            NSString *bundlePath = [bundle.resourcePath stringByAppendingPathComponent:@"HLAgreementLabel.bundle"];
            resourceBundle = [NSBundle bundleWithPath:bundlePath];
        }
        hlBundle = resourceBundle ?: bundle;
    }
    return hlBundle;
}

+ (UIImage *)imageNamed:(NSString *)imageName
{
    UIImage *image = nil;
    NSURL *mianBundleURL = [[NSBundle mainBundle] URLForResource:@"HLAgreementLabel" withExtension:@"bundle"];
    if (mianBundleURL) {
        image = [UIImage imageWithContentsOfFile:[[[NSBundle bundleWithURL:mianBundleURL] resourcePath] stringByAppendingPathComponent:imageName]];
    } else {
        NSString *path = [[[self resourceBundle] resourcePath] stringByAppendingPathComponent:imageName];
        image = [UIImage imageWithContentsOfFile:path];
        if (!image) {
            image = [UIImage imageNamed:path];
        }
    }
    
    return image;
}

/// 修改图片大小
+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    scaledImage = [scaledImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return scaledImage;
}

/// 将图片渲染成指定颜色
+ (UIImage *)renderImage:(UIImage *)image toColor:(UIColor *)color
{
    image = [HLAgreementLabel resizeImage:image toSize:CGSizeMake(20, 20)];
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return renderedImage;
}

/// 删除数组中重复元素
+ (NSMutableArray *)removeSameObjectInArray:(NSMutableArray *)inArr
{
    return [NSMutableArray arrayWithArray:[[NSSet setWithArray:inArr] allObjects]];
}

/// 获取subStr在字符串中的ranges
+ (NSMutableArray *)rangesOfSubString:(NSString*)subStr inString:(NSString*)inString
{
    NSMutableArray *resultRanges = [NSMutableArray array];
    NSRange searchRange = NSMakeRange(0, [inString length]);
    NSRange range;
    while ((range = [inString rangeOfString:subStr options:0 range:searchRange]).location != NSNotFound) {
        [resultRanges addObject:[NSValue valueWithRange:range]];
        searchRange = NSMakeRange(NSMaxRange(range), [inString length] - NSMaxRange(range));
    }
    return resultRanges;
}

/// 排除目标ranges后的ranges
+ (NSMutableArray *)excludeRanges:(NSArray *)ranges inStringLength:(long)inStringLength
{
    NSMutableArray *resultRanges = [NSMutableArray array];
    for(int i = 0; i < ranges.count;i++){
        NSRange range = [ranges[i] rangeValue];
        if(range.location > 0 && i == 0){
            NSRange rRange = NSMakeRange(0, range.location);
            [resultRanges addObject:[NSValue valueWithRange:rRange]];
            if(ranges.count == 1){
                long rangeEnd = range.location + range.length;
                if(rangeEnd != inStringLength){
                    NSRange rRange = NSMakeRange(rangeEnd, inStringLength - rangeEnd);
                    [resultRanges addObject:[NSValue valueWithRange:rRange]];
                }
                
            }
        }
        if(!(i == 0 && ranges.count == 1)){
            NSRange nextRange;
            if(i + 1 < ranges.count){
                nextRange = [ranges[i + 1] rangeValue];
            }else{
                nextRange = NSMakeRange(inStringLength, 0);
            }
            long rangeEnd = range.location + range.length;
            NSRange rRange = NSMakeRange(rangeEnd, nextRange.location - rangeEnd);
            [resultRanges addObject:[NSValue valueWithRange:rRange]];
        }
    }
    return resultRanges;
}

@end

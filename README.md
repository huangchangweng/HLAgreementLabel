# HLAgreementLabel

一行代码实现项目中“同意协议”或“弹窗协议”，依赖YYText。



##### 支持使用CocoaPods引入, Podfile文件中添加:

```objc
pod 'HLAgreementLabel', '0.1.0'
```

# Demonstration

![image](https://p.ipic.vip/ymqjtx.png)

可设置属性:

```objc
/// 文字颜色，默认[UIColor blackColor]
@property (nonatomic, strong) IBInspectable UIColor *normalTextColor;
/// 高亮文字颜色，默认[UIColor blueColor]
@property (nonatomic, strong) IBInspectable UIColor *highlightTextColor;
/// 高亮文字是否加粗，默认NO
@property (nonatomic, assign) IBInspectable BOOL highlightTextIsBold;
/// 选择图标颜色，默认[UIColor lightGrayColor]
@property (nonatomic, strong) IBInspectable UIColor *iconNormalColor;
/// 选择图标选中颜色，默认[UIColor blueColor]
@property (nonatomic, strong) IBInspectable UIColor *iconSelectedColor;
/// 自定义选择图标，若不设置则使用默认的图片
@property (nonatomic, strong) IBInspectable UIImage *iconImage;
/// 自定义选中选择图标，若不设置则使用默认的图片
@property (nonatomic, strong) IBInspectable UIImage *iconSelectedImage;
/// icon点击范围大小，默认文字的行高font.lineHeight
/// 例：字体14大概为CGSizeMake(17, 17)。不建议设置太大
@property (nonatomic, assign) IBInspectable CGSize iconTapSize;
/// 隐藏选择图标，默认NO
@property (nonatomic, assign) IBInspectable BOOL hideIcon;
/// 设置文字与选择图标的间距，默认为4
@property (nonatomic, assign) IBInspectable CGFloat textIconSpace;
/// 是否允许点击除高亮部分以外的区域都触发选中事件，默认为NO（当点击选择按钮时才触发）
@property (assign, nonatomic) IBInspectable BOOL needResponseIconTapAction;
/// 禁止渲染选择图标的颜色，默认YES
@property (assign, nonatomic) IBInspectable BOOL disableRenderIcon;
/// 所有文字
/// 例：阅读并同意《用户协议》《隐私协议》
@property (nonatomic, copy) IBInspectable NSString *allText;
/// 需要高亮的文字，多个用“|”隔开
/// 例：《用户协议》｜《隐私协议》
@property (nonatomic, copy) IBInspectable NSString *highlightText;
/// 行间距，默认2
@property (nonatomic, assign) IBInspectable CGFloat lineSpacing;
/// 是否已选中，默认为NO
@property (nonatomic, assign) IBInspectable BOOL selected;

/// 点击高亮部分文字点击回调，注意weakSelf
@property (copy, nonatomic) HLAgreementLabelHighlightTextTapBlock highlightTextTapBlock;
/// 点击选择图标回调，注意weakSelf
@property (copy, nonatomic) HLAgreementLabelIconTapBlock iconTapBlock;
```

# Requirements

iOS 9.0 +, Xcode 7.0 +

# Version

- 0. 1.0:
  
  完成HLAgreementLabel基础搭建

# License

HLTimeLineView is available under the MIT license. See the LICENSE file for more info.

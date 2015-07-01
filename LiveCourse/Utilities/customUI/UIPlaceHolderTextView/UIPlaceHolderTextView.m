//
//  UIPlaceHolderTextView.m
//  cat_ios
//  Created by Lu on 14/11/7.
//

#import "UIPlaceHolderTextView.h"

@implementation UIPlaceHolderTextView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setPlaceholder:@""];
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame{
    if( (self = [super initWithFrame:frame]) ){
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (void)textChanged:(NSNotification *)notification{
    if([[self placeholder] length] == 0){
        return;
    }
    if([[self text] length] == 0){
        [[self viewWithTag:KUIPlaceHolderTextViewTag] setAlpha:1];
    }
    else{
        [[self viewWithTag:KUIPlaceHolderTextViewTag] setAlpha:0];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"text"]) {
        if([[self text] length] == 0){
            [[self viewWithTag:KUIPlaceHolderTextViewTag] setAlpha:1];
        }
        else{
            [[self viewWithTag:KUIPlaceHolderTextViewTag] setAlpha:0];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (UILabel *)placeHolderLabel{
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,8,self.bounds.size.width - 20,0)];
        _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.font = self.font;
        _placeHolderLabel.backgroundColor = [UIColor clearColor];
        _placeHolderLabel.textColor = self.placeholderColor;
        _placeHolderLabel.alpha = 0;
        _placeHolderLabel.tag = KUIPlaceHolderTextViewTag;
        [self addSubview:_placeHolderLabel];
    }
    return _placeHolderLabel;
}


- (void)drawRect:(CGRect)rect{
    if( [[self placeholder] length] > 0 ){
        
        self.placeHolderLabel.text = self.placeholder;
        [self.placeHolderLabel sizeToFit];
        [self sendSubviewToBack:self.placeHolderLabel];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 ){
        [[self viewWithTag:KUIPlaceHolderTextViewTag] setAlpha:1];
    }
    
    [super drawRect:rect];
}



@end

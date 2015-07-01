//
//  keyboardImgManageView.m
//  LiveCourse
//
//  Created by Lu on 15/6/2.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "KeyboardImgManageView.h"

@interface KeyboardImgManageView ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton *photoLibraryBtn;//相册
@property (nonatomic, strong) UIButton *cameraBtn;      //相机

@property (nonatomic, strong) UIPopoverController *popoverVC;

@property (nonatomic, strong) UIImageView *showSelectImgView;//选择好后展示的图片

@property (nonatomic, strong) UIButton *deleteButton;   //图片右上角删除功能


@end

@implementation KeyboardImgManageView
{
    NSData *imageData;
}


-(id)init{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, 115)];
    
    if (self) {
        
        self.backgroundColor = kColorBackgroundD0;
        
        [self initAction];
        
    }
    return self;
}


#pragma mark - Action

-(void)initAction{
    self.photoLibraryBtn.backgroundColor = kColorClear;
    self.cameraBtn.backgroundColor = kColorClear;
    
}


-(void)photoLibraryBtnClick:(id)sender{
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self openPhotoPicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
}

-(void)cameraBtnClick:(id)sender{
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self openPhotoPicker:UIImagePickerControllerSourceTypeCamera];
    }];
    
}



- (void)openPhotoPicker:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        imagePickerController.sourceType = sourceType;
        imagePickerController.delegate = self;
        
        if (sourceType == UIImagePickerControllerSourceTypeCamera) {
            [self.viewController presentViewController:imagePickerController animated:YES completion:nil];
        } else {
            
            if (kiPhone) {
                [self.viewController presentViewController:imagePickerController animated:YES completion:nil];
                
            }else{
                if (self.popoverVC) {
                    [self.popoverVC dismissPopoverAnimated:YES];
                    self.popoverVC = nil;
                }
                
                self.popoverVC = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
                
                [self.popoverVC presentPopoverFromRect:CGRectMake(0, 0, 300, 300)  inView:self.viewController.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            }
        }
    }
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self setShowSelectImgAction:image];

    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    //相册
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        if (!kiPhone) {
            [self.popoverVC dismissPopoverAnimated:YES];
        }
        
        NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            //成功就显示操作等
            [self dealImage:asset];
            
//            self.showSelectImgView.image = [UIImage imageWithCGImage:[asset thumbnail]];
//            [self setShowSelectImgAction:[UIImage imageWithCGImage:[asset thumbnail]]];
            
            
        } failureBlock:^(NSError *error) {
            
        }];
        
    }else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        
        //把拍完照片的图片写到相册里
        NSDictionary *metaData = [info objectForKey:UIImagePickerControllerMediaMetadata];
        [assetsLibrary writeImageToSavedPhotosAlbum:image.CGImage metadata:metaData completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error) {
                
            }else{
                [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    [self dealImage:asset];
                    
//                    self.showSelectImgView.image = [UIImage imageWithCGImage:[asset thumbnail]];
//                    [self setShowSelectImgAction:[UIImage imageWithCGImage:[asset thumbnail]]];
                    
                } failureBlock:^(NSError *error) {
                    
                }];
            }
        }];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}



//处理图片
-(void)dealImage:(ALAsset *)asset{
    ALAssetRepresentation *alAssetRep = [asset defaultRepresentation];
    
    CGImageRef cgimage = [alAssetRep fullResolutionImage];
    UIImage *image = [UIImage imageWithCGImage:cgimage scale:alAssetRep.scale orientation:(UIImageOrientation)alAssetRep.orientation];
    UIImage *fixImage = [image fixOrientation]; image = nil;
    //需要上传的图片
    imageData = UIImageJPEGRepresentation(fixImage, 0.5); fixImage = nil;
    
    NSString *imageSize = [HSBaseTool formattedFileSize:[imageData length]];
    DLog(@"imageSize-----%@",imageSize);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardImgManageImageSelectedDelegate:)]) {
        [self.delegate keyboardImgManageImageSelectedDelegate:imageData];
    }
}


//显示
-(void)setShowSelectImgAction:(UIImage *)image{
    self.showSelectImgView.image = image;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.photoLibraryBtn.hidden = YES;
        self.cameraBtn.hidden = YES;
        
        self.showSelectImgView.hidden = NO;
        self.deleteButton.hidden = NO;
        
    } completion:^(BOOL finished) {
        
    }];
}

//删除图片
-(void)deleteImage:(id)sender{
    imageData = nil;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardImgManageImageDeleteDelegate)]) {
        [self.delegate keyboardImgManageImageDeleteDelegate];
    }
    
    
    [UIView animateWithDuration:0.2f animations:^{
        self.photoLibraryBtn.hidden = NO;
        self.cameraBtn.hidden = NO;
        
        self.showSelectImgView.hidden = YES;
        self.deleteButton.hidden = YES;
        
    } completion:^(BOOL finished) {
        self.showSelectImgView.image = nil;
    }];
}

#pragma mark - UI
-(UIButton *)photoLibraryBtn{
    if (!_photoLibraryBtn) {
        _photoLibraryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoLibraryBtn.frame = CGRectMake(15, 15, 60, 80);
        [_photoLibraryBtn setImage:[UIImage imageNamed:@"image_photo"] forState:UIControlStateNormal];
        [_photoLibraryBtn setTitle:MyLocal(@"相册") forState:UIControlStateNormal];
        [_photoLibraryBtn setTitleColor:kColorWord forState:UIControlStateNormal];
        
        _photoLibraryBtn.imageView.layer.cornerRadius = 8;
        _photoLibraryBtn.imageView.layer.masksToBounds = YES;
        
        _photoLibraryBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        _photoLibraryBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _photoLibraryBtn.titleEdgeInsets = UIEdgeInsetsMake(65, -60, 0, 0);
        _photoLibraryBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _photoLibraryBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _photoLibraryBtn.titleLabel.minimumScaleFactor = 0.8f;
        _photoLibraryBtn.titleLabel.numberOfLines = 2;
        _photoLibraryBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [_photoLibraryBtn addTarget:self action:@selector(photoLibraryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_photoLibraryBtn];
    }
    return _photoLibraryBtn;
}


-(UIButton *)cameraBtn{
    if (!_cameraBtn) {
        _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraBtn.frame = CGRectMake(self.photoLibraryBtn.right + 15, 15, 60, 80);
        _cameraBtn.backgroundColor = kColorClear;
        [_cameraBtn setImage:[UIImage imageNamed:@"image_camera"] forState:UIControlStateNormal];
        [_cameraBtn setTitle:MyLocal(@"照相机") forState:UIControlStateNormal];
        [_cameraBtn setTitleColor:kColorWord forState:UIControlStateNormal];
        
        _cameraBtn.imageView.layer.cornerRadius = 8;
        _cameraBtn.imageView.layer.masksToBounds = YES;
        
        _cameraBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        _cameraBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _cameraBtn.titleEdgeInsets = UIEdgeInsetsMake(65, -60, 0, 0);
        _cameraBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _cameraBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _cameraBtn.titleLabel.numberOfLines = 2;
        _cameraBtn.titleLabel.minimumScaleFactor = 0.4f;
        _cameraBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [_cameraBtn addTarget:self action:@selector(cameraBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_cameraBtn];
    }
    return _cameraBtn;
}


-(UIImageView *)showSelectImgView{
    if (!_showSelectImgView) {
        _showSelectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
        
        _showSelectImgView.backgroundColor = kColorClear;
        
        _showSelectImgView.layer.cornerRadius = 4;
        _showSelectImgView.layer.masksToBounds = YES;
        
        _showSelectImgView.hidden = YES;
        
        [self addSubview:_showSelectImgView];
    }
    return _showSelectImgView;
}


-(UIButton *)deleteButton{
    if (!_deleteButton) {
        
        //删除图标
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *deleteIcon = [UIImage imageNamed:@"icon_global_delete"];
        _deleteButton.size = deleteIcon.size;
        _deleteButton.center = CGPointMake(self.showSelectImgView.right, self.showSelectImgView.top);
        
        [_deleteButton setImage:deleteIcon forState:UIControlStateNormal];
        _deleteButton.backgroundColor = kColorClear;
        [_deleteButton addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.hidden = YES;
        [self addSubview:_deleteButton];
    }
    return _deleteButton;
}

@end

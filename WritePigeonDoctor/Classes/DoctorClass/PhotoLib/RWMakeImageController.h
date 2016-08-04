//
//  RWMakeImageController.h
//  RWWeChatController
//
//  Created by zhongyu on 16/7/25.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWMakeImageController : UIImagePickerController

+ (instancetype)makeImageWithSourceType:(UIImagePickerControllerSourceType)sourceType didSelectedImage:(void(^)(NSData *imageData,NSString *imageName))selectedImage;

@end

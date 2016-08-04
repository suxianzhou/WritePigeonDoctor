//
//  RWMakeImageController.m
//  RWWeChatController
//
//  Created by zhongyu on 16/7/25.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWMakeImageController.h"
#import "RWChatManager.h"

@interface RWMakeImageController ()

<
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
>

@property (nonatomic,copy)void(^selectedImage)(NSData *imageData, NSString *imageName);

@end

@implementation RWMakeImageController

+ (instancetype)makeImageWithSourceType:(UIImagePickerControllerSourceType)sourceType didSelectedImage:(void (^)(NSData *imageData, NSString *imageName))selectedImage
{
    RWMakeImageController *makeImage = [[RWMakeImageController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        makeImage.sourceType = sourceType;
        makeImage.selectedImage = selectedImage;
    }
    else
    {
        return nil;
    }
    
    return makeImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(nonnull UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    if (_selectedImage)
    {
        if (!UIImagePNGRepresentation(image))
        {
            _selectedImage(UIImageJPEGRepresentation(image, 1),[RWChatManager imageNameSuffix:@"jpg"]);
        }
        else
        {
            _selectedImage(UIImagePNGRepresentation(image),[RWChatManager imageNameSuffix:@"png"]);
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.delegate = self;
    self.view.backgroundColor = [UIColor clearColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

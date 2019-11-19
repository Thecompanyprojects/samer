//
//  LDCreateGroupViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/14.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDCreateGroupViewController.h"
#import "LDMapViewController.h"

@interface LDCreateGroupViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *groupImage;
@property (weak, nonatomic) IBOutlet UITextField *groupNameField;
@property (weak, nonatomic) IBOutlet UITextView *groupTextView;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (nonatomic,copy) NSString * headUrl;

@end

@implementation LDCreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"创建群组";
    
    [self createButton];
    
    self.groupImage.layer.cornerRadius = 25;
    self.groupImage.clipsToBounds = YES;
    
    [_groupNameField addTarget:self action:@selector(passwordClick:) forControlEvents:UIControlEventEditingChanged];
}

-(void)passwordClick:(UITextField *)textField{
    
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        
        if (self.groupNameField.text.length >= 15) {
            
            self.groupNameField.text = [self.groupNameField.text substringToIndex:15];
            
        }
        
        
    }

}


-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        
        self.introduceLabel.hidden = NO;
        
    }else{
        
        self.introduceLabel.hidden = YES;
    }
    
    if (textView.text.length >= 256) {
        
        textView.text = [textView.text substringToIndex:256];
        
        self.numberLabel.text = @"256/256";
        
    }else{
        
        self.numberLabel.text = [NSString stringWithFormat:@"%ld/256",(unsigned long)self.groupTextView.text.length];
        
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)selectGroupImage:(id)sender {
    
    [self.view endEditing:YES];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        //拍照  调用相机
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从手机相册中选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.delegate=self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];//显示出来
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
    }];
    
    [alertController addAction:cameraAction];
    [alertController addAction:photoAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];

}

#pragma mark  imagePicker的代理方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *img = info[@"UIImagePickerControllerEditedImage"];
    
    if(picker.sourceType==UIImagePickerControllerSourceTypeCamera){
        UIImageWriteToSavedPhotosAlbum(img,nil,nil,nil);
    }
    
    _groupImage.image = img;
    
    NSData *imageData = UIImageJPEGRepresentation(img, 0.1);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Api/fileUpload"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"%@",responseObject);
        
        _headUrl = responseObject[@"data"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)createButton{
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton addTarget:self action:@selector(backButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)backButtonOnClick:(UIButton *)button{
    
    if (self.groupNameField.text.length != 0 && self.groupTextView.text.length != 0 && self.headUrl.length != 0) {
        
        if ([self isEmpty:self.groupNameField.text]) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"群昵称不能包含空格~"];
            
            
        }else  if ([self.groupNameField.text containsString:@"奴"] || [self.groupNameField.text containsString:@"虐"] || [self.groupNameField.text containsString:@"性"] || [self.groupNameField.text containsString:@"狗"] || [self.groupNameField.text containsString:@"畜"] || [self.groupNameField.text containsString:@"贱"] || [self.groupNameField.text containsString:@"骚"] || [self.groupNameField.text containsString:@"淫"] || [self.groupNameField.text containsString:@"阴"] || [self.groupNameField.text containsString:@"肛"] || [self.groupNameField.text containsString:@"SM"] || [self.groupNameField.text containsString:@"sm"] || [self.groupNameField.text containsString:@"Sm"] || [self.groupNameField.text containsString:@"sM"]) {
            
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"很抱歉，您的昵称包含有禁止使用的字：奴、虐、性、狗、畜、贱、骚、淫、阴、肛、SM、sm、Sm、sM，请修改后重试~"];
            
            
        }else if ([self.groupTextView.text containsString:@"奴"] || [self.groupTextView.text containsString:@"虐"] || [self.groupTextView.text containsString:@"性"] || [self.groupTextView.text containsString:@"狗"] || [self.groupTextView.text containsString:@"畜"] || [self.groupTextView.text containsString:@"贱"] || [self.groupTextView.text containsString:@"骚"] || [self.groupTextView.text containsString:@"淫"] || [self.groupTextView.text containsString:@"阴"] || [self.groupTextView.text containsString:@"肛"] || [self.groupTextView.text containsString:@"SM"] || [self.groupTextView.text containsString:@"sm"] || [self.groupTextView.text containsString:@"Sm"] || [self.groupTextView.text containsString:@"sM"]){
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"很抱歉，您的群介绍包含有禁止使用的字：奴、虐、性、狗、畜、贱、骚、淫、阴、肛、SM、sm、Sm、sM，请修改后重试~"];
            
        }else{
        
            LDMapViewController *gvc = [[LDMapViewController alloc] init];
            
            gvc.groupString = @"yes";
            
            gvc.groupname = self.groupNameField.text;
            
            gvc.introduce = self.groupTextView.text;
            
            gvc.headUrl = _headUrl;
            
            [self.navigationController pushViewController:gvc animated:YES];
        }
        
    }else{
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请补全群信息~"];
    
    }

    
}

//判定昵称中是否包含空格
-(BOOL)isEmpty:(NSString *) str {
    
    NSRange range = [str rangeOfString:@" "];
    
    if (range.location != NSNotFound) {
        
        return YES; //yes代表包含空格
        
    }else {
        
        return NO; //反之
    }
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

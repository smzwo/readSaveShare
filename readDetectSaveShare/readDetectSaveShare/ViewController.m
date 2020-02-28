//
//  ViewController.m
//  readDetectSaveShare
//
//  Created by 孙明喆 on 2020/2/28.
//  Copyright © 2020 孙明喆. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIDocumentInteractionControllerDelegate>

@property (strong, nonatomic) NSMutableArray *photoArray;
@property (nonatomic, strong) UIDocumentInteractionController *documentIc;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 图片的批量读取，将保存也写在里面了
    [self getImagePath];
    
    
    // 导出功能
    UIButton *exportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exportBtn.frame = CGRectMake(100, 100, 200, 30);
    [exportBtn setTitle:@"导出excel表格数据" forState: UIControlStateNormal];
    [exportBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [exportBtn addTarget:self action:@selector(exportBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exportBtn];

}

// 将图片存到可变数组photoArray中
- (void)getImagePath
{
    self.photoArray = [[NSMutableArray alloc] init];
    //得到文件的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pic" ofType:@"bundle"];
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:path];
    
    while((path = [enumerator nextObject]) != nil) {
        //把得到的图片添加到数组中
        NSLog(@"地址：%@", path);
        NSString *imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"pic.bundle/%@", path]];
        UIImage *image = [UIImage imageNamed:imagePath];
        
        // 图片保存的功能，这样可以读取一个保存一个图片
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);

        [self.photoArray addObject:image];
    }
    NSLog(@"完成图片读取");
}


- (NSString *)saveToTxt:(NSString *)whatDoYouWangToWrite{
    
    // 1.得到Documents的路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    // 2.创建一个文件路径
    NSString *filePath = [docPath stringByAppendingPathComponent:@"qiuxiang.txt"];
    // 3.创建文件首先需要一个文件管理对象
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 4.创建文件
    [fileManager createFileAtPath:filePath contents:nil attributes:nil];

    // 写的主要内容
    [whatDoYouWangToWrite writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    return filePath;
}

// 导出按钮的响应事件，可以实现iPhone的k隔空传送功能
- (void)exportBtnDidClick {
    NSString* filePath = [self saveToTxt:@"要写的内容，如果需要多数据的话，可以使用数组写，在demo里有例子"];

    // 调用safari分享功能将文件分享出去
    UIDocumentInteractionController *documentIc = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];

    // 记得要强引用UIDocumentInteractionController,否则控制器释放后再次点击分享程序会崩溃
    self.documentIc = documentIc;

    // 如果需要其他safari分享的更多交互,可以设置代理
    documentIc.delegate = self;

    // 设置分享显示的矩形框
    CGRect rect = CGRectMake(0, 0, 300, 300);
    [documentIc presentOpenInMenuFromRect:rect inView:self.view animated:YES];
    [documentIc presentPreviewAnimated:YES];
}


@end

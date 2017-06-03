//
//  MusicViewController.m
//  BluetoothStubOnIOS
//
//  Created by tao on 2017/5/20.
//  Copyright © 2017年 刘彦玮. All rights reserved.
//

#import "MusicViewController.h"
//#import "Utils.h"
#import <AVFoundation/AVFoundation.h>
@interface MusicViewController ()<AVAudioPlayerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSDictionary *lrcDic;

// 现在时间
@property (nonatomic, strong) UILabel *currentLabel;
// 总的时间
@property (nonatomic, strong) UILabel *durationLabel;
// 播放
@property (nonatomic, strong) UIButton *btn;
// 进度
@property (nonatomic, strong) UISlider *slider;
// 声音
@property (nonatomic, strong) UISlider *volumSlider;
// 上一曲
@property (nonatomic, strong) UIButton *lastBtn;
// 下一曲
@property (nonatomic, strong) UIButton *nextBtn;


// 选择
@property (nonatomic, strong) UISegmentedControl *segment;
// 背景图
@property (nonatomic, strong) UIImageView *imageView;
// 歌词
@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSString *currentPath;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MusicViewController


- (void)setupUI{
    
    _imageView = [[UIImageView alloc] init];
    _imageView.alpha = 0.5;
    [self.view addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset = 0;
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"white_arrow"] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(getBack) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 24, 24);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
    
    
    // 播放
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.tag = 1;
    [_btn setBackgroundImage:[UIImage imageNamed:@"btu_orange140"] forState:UIControlStateNormal];
    [_btn setBackgroundImage:[UIImage imageNamed:@"btu_orange140"] forState:UIControlStateSelected];

    [_btn setTitle:@"播放" forState:UIControlStateNormal];
    [_btn setTitle:@"停止" forState:UIControlStateSelected];
    [_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _btn.titleLabel.font = font(realWidth(32));
//    [_btn setBackgroundColor:[UIColor whiteColor]];
    [_btn addTarget:self action:@selector(clickToChangeMusicStateWithButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.width.offset = realWidth(100);
        make.height.offset = realWidth(44);
        make.bottom.offset = realWidth(-30);
    }];
    
    // 现在时间
    _currentLabel = [[UILabel alloc] init];
    _currentLabel.text = @"0";
    _currentLabel.textColor = [UIColor blackColor];
    _currentLabel.font = font(realWidth(28));
    [self.view addSubview:_currentLabel];
    [_currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = realWidth(8);
        make.width.offset = realWidth(50);
        make.top.equalTo(_btn.mas_top).offset = 0;
        make.height.offset = realWidth(14);
    }];
    
    //总的时间
    _durationLabel = [[UILabel alloc] init];
    _durationLabel.text = @"0";
    _durationLabel.textColor = [UIColor blackColor];
    _durationLabel.font = font(realWidth(28));
    [self.view addSubview:_durationLabel];
    [_durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = realWidth(-8);
        make.width.offset = realWidth(50);
        make.top.equalTo(_btn.mas_top).offset = 0;
        make.height.offset = realWidth(14);
    }];
    
    // 进度
    _slider = [[UISlider alloc] init];
    _slider.value = 0;
    _slider.minimumValue = 0;
    [_slider addTarget:self action:@selector(musciCurrentTimeChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_slider];
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = realWidth(8);
        make.right.offset = realWidth(-8);
        make.bottom.equalTo(_currentLabel.mas_top).offset = realWidth(-15);
    }];
    
    // 音量
    _volumSlider = [[UISlider alloc] init];
    _volumSlider.value = 0;
    _volumSlider.minimumValue = 0;
    _volumSlider.maximumValue = 1;
    [_volumSlider addTarget:self action:@selector(voiceChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_volumSlider];
    [_volumSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = realWidth(-8);
        make.width.offset = SSize.width/3;
        make.bottom.equalTo(_slider.mas_top).offset = realWidth(-15);
    }];
    
    // 播放模式
    _segment = [[UISegmentedControl alloc] initWithItems:@[@"循环播放", @"单曲循环", @"随机播放"]];
    _segment.selectedSegmentIndex = 0;
    [self.view addSubview:_segment];
    [_segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.bottom.equalTo(_volumSlider.mas_top).offset = realWidth(-15);
    }];
    
    // 上一曲 下一曲
    _lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_lastBtn setBackgroundImage:[UIImage imageNamed:@"blue_180"] forState:UIControlStateNormal];
    _lastBtn.tag = 2;
    [_lastBtn setTitle:@"上一曲" forState:UIControlStateNormal];
    [_lastBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _lastBtn.titleLabel.font = font(realWidth(28));
    [_lastBtn addTarget:self action:@selector(clickToChangeMusicStateWithButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_lastBtn];
    [_lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset = realWidth(80);
        make.centerY.equalTo(_segment.mas_centerY).offset = 0;
        make.right.equalTo(_segment.mas_left).offset = realWidth(-5);
    }];
    
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setBackgroundImage:[UIImage imageNamed:@"blue_180"] forState:UIControlStateNormal];
    _nextBtn.tag = 3;
    [_nextBtn setTitle:@"下一曲" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = font(realWidth(28));
    [_nextBtn addTarget:self action:@selector(clickToChangeMusicStateWithButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset = realWidth(80);
        make.centerY.equalTo(_segment.mas_centerY).offset = 0;
        make.left.equalTo(_segment.mas_right).offset = realWidth(5);
    }];
    
    
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.mainVc setMusicNotifiyBool:NO];
}

+ (MusicViewController *)sharePlayingVC
{
    static MusicViewController *instance;
    static dispatch_once_t onceToken;
    // onceToken默认等于0, 如果是0就会执行block, 如果不是0就不会执行
    NSLog(@"%ld", onceToken);
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark -生命周期 Life Circle
- (void)viewDidLoad {
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [super viewDidLoad];
    CALayer *layer = self.btn.layer;
    layer.cornerRadius = 10;
    [self.btn setTitle:@"暂停" forState:UIControlStateNormal];
    [self.btn setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateHighlighted];
    
    [self setupUI];
}



//页面将要出现
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self playMusic];
    _btn.selected = self.mainVc.isplaying;
    
    [self.mainVc getTotalTime];
    //页面将要出现的时候加载 timer 页面消失的时候释放 timer
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getCurrentTime) userInfo:nil repeats:YES];
    [self.mainVc setMusicNotifiyBool:YES];
    // 拿到现在音量
    [self.mainVc getCurrentVoice];

}
//- (void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    [self.timer invalidate];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 方法 method
// 上一曲
- (void)clickToChangeMusicStateWithButton:(UIButton *)btn{
    if (!_mainVc.firstPlay) {
        [self.mainVc playMusicStateChangedWithButtonTag:5];
        
        _btn.selected = self.mainVc.isplaying;
        [self.mainVc getTotalTime];
        //页面将要出现的时候加载 timer 页面消失的时候释放 timer
        //    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getCurrentTime) userInfo:nil repeats:YES];
        [self.mainVc setMusicNotifiyBool:YES];
        // 拿到现在音量
        [self.mainVc getCurrentVoice];
        
    }else{
        _mainVc.firstPlay = YES;
        NSLog(@"%ld", _segment.selectedSegmentIndex);
        
        if (btn.tag == 1) {
            btn.selected = !btn.isSelected;
            if (btn.isSelected) {
                [self.mainVc playMusicStateChangedWithButtonTag:5];
            }else{
                [self.mainVc playMusicStateChangedWithButtonTag:6];
            }
        }
        
        if (_segment.selectedSegmentIndex == 1){
            [self.mainVc playMusicStateChangedWithButtonTag:7];
        }else if (_segment.selectedSegmentIndex == 2){
            [self.mainVc playMusicStateChangedWithButtonTag:8];
        }else if (_segment.selectedSegmentIndex == 0) {
           [self.mainVc playMusicStateChangedWithButtonTag:btn.tag];
        }
        
        
        [self getAllTotalTime];
    }


}



- (void)getBack{
    [self.navigationController popViewControllerAnimated:YES];
}

//加载音乐
//- (void)playMusic{
//    if (self.index == -1) {
//        self.index = self.fillPaths.count - 1;
//    }
//    if (self.index == self.fillPaths.count) {
//        self.index = 0;
//    }
//    //播放一首歌的时候将标题加入
//    self.title = [[self.fillPaths[self.index] lastPathComponent] stringByDeletingPathExtension];
//    //播放 暂停
//    self.currentPath = self.fillPaths[self.index];
//    
//    //提曲歌名
////    NSDictionary *musicInfo = [Utils getMusicInfoByPath:self.currentPath];
//    self.title = musicInfo[@"title"];
//    NSData *data = musicInfo[@"artwork"];
//    self.imageView.image = [UIImage imageWithData:data];
//    //判断当前播放的和即将播放的是否是同一首歌曲
//    if (![self.player.url.path isEqualToString:self.currentPath]){
//        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:self.currentPath] error:nil];
//    }
//    self.player.delegate = self;
//    //    self.player = [[AVAudioPlayer alloc]initWithData:[NSData dataWithContentsOfFile:self.currentPath] error:nil];
//    
//    [self.player play];
//    self.player.volume = .5;
//    //总时长加载到 label 上
//    self.slider.maximumValue = (NSInteger)self.player.duration;
//    self.durationLabel.text = [NSString stringWithFormat:@"%d:%d",(int)self.slider.maximumValue/60, (int)self.slider.maximumValue % 60];
//    NSString *lrcPath = [self.currentPath stringByReplacingOccurrencesOfString:@"mp3" withString:@"lrc"];
//    //加载歌词
//    if ([[NSFileManager defaultManager]fileExistsAtPath:lrcPath]) {
//        self.lrcDic = [Utils parseLrcWithPath:lrcPath];
//        [self.tableview reloadData];
//        self.tableview.hidden = NO;
//    }else{
//        self.tableview.hidden = YES;
//    }
//}
//显示现在和总的时间
- (void)getCurrentTime{
    self.slider.value = (NSInteger)self.player.currentTime;
    self.currentLabel.text = [NSString stringWithFormat:@"%d:%d",(int)self.slider.value/60, (int)self.slider.value%60];
    //同步歌词
    
    NSArray *keys = [self.lrcDic.allKeys sortedArrayUsingSelector:@selector(compare:)];
    for (int i = 1; i < keys.count; i++) {
        float time = [keys[i] floatValue];
        if (time > self.player.currentTime) {
            int row = i - 1;
            [self.tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            break;
        }
    }
    
    
    
    
}

- (void)getCurrentVoice:(CGFloat)voice{
    _volumSlider.value = voice;
}


#pragma mark  Music
- (void)getMuicTotalTime:(NSInteger)totalTime{
    self.durationLabel.text = [NSString stringWithFormat:@"%ld", totalTime];
    _slider.maximumValue = totalTime;
}

- (void)getCurrentTime:(NSInteger)currentTime{
    self.slider.value = currentTime;
    _currentLabel.text = [NSString stringWithFormat:@"%ld", (long)currentTime];
}

//得到 slider 的value
- (IBAction)changed:(UISlider *)sender {
    self.player.currentTime = self.slider.value;
}
//上一曲
- (IBAction)clickedLeftBtn:(UIButton *)sender {
    self.index--;
    if (self.segment.selectedSegmentIndex == 2) {
        self.index = arc4random() % self.fillPaths.count;
    }
//    [self playMusic];
}
//下一曲
- (IBAction)clickRightBtn:(UIButton *)sender {
    self.index++;
    if (self.segment.selectedSegmentIndex == 2) {
        self.index = arc4random() % self.fillPaths.count;
    }
//    [self playMusic];
}

- (void)getAllTotalTime{
}

//slider
- (IBAction)volumChange:(UISlider *)sender {
    self.player.volume = self.volumSlider.value;
}

#pragma mark -外部控制
// 上一曲
- (void)lastMusic{
    [self clickedLeftBtn:nil];
}
// 下一曲
- (void)nextMusic{
    [self clickRightBtn:nil];
}
// 播放、暂停
- (void)playStopMusic{
    [self clicked:nil];
}

// 播放进度改变
- (void)musciCurrentTimeChange:(UISlider *)slider{
    [self.mainVc writeCurrentTime:_slider.value];
}

- (void)voiceChange:(UISlider *)slider{
    [self.mainVc writeCurrentVoice:_volumSlider.value];

}

//点击播放暂停
- (IBAction)clicked:(id)sender {
    if (self.player.isPlaying) {
        [self.player pause];
        [self.btn setTitle:@"播放" forState:UIControlStateNormal];
    }else{
        [self.player play];
        [self.btn setTitle:@"暂停" forState:UIControlStateNormal];
        
    }
}


#pragma mark - AVAudio Delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    switch (self.segment.selectedSegmentIndex) {
        case 0://顺序播放
            self.index++;
//            [self playMusic];
            
            break;
            
        case 1://单曲循环
            
//            [self playMusic];
            
            break;
        case 2://随机
            self.index = arc4random()%self.fillPaths.count;
//            [self playMusic];
            
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.lrcDic.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSArray *keys = [self.lrcDic.allKeys sortedArrayUsingSelector:@selector(compare:)];
    NSNumber *timeKey = keys[indexPath.row];
    cell.textLabel.text = self.lrcDic[timeKey];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.bounds];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    cell.textLabel.highlightedTextColor = [UIColor redColor];
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25;
}

@end

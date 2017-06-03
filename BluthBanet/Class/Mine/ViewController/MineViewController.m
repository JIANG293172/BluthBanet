//
//  MineViewController.m
//  BluthBanet
//
//  Created by tao on 17/3/24.
//  Copyright © 2017年 tao. All rights reserved.
//

#import "MineViewController.h"
#import "DirectionView.h"
#import "CenterView.h"
#import "BluetoothHeader.h"
#import "JHShowController.h"
#import "ScanViewController.h"
#import "TopView.h"
#import "Music.h"
#import "BabyCentralManager.h"
@interface MineViewController ()<TopViewDelegate, DirectionViewDelegate, MusicDelegate, CenterViewDelegate, TopViewDelegate>

@property (nonatomic, strong) DirectionView *direView;
@property (nonatomic, strong) CenterView *centerView;
//@property (strong, nonatomic) BluetoothHeader *header;

@property (copy, nonatomic) NSString *identifider;
@property (strong, nonatomic) NSMutableString *string;
@property (nonatomic, strong) TopView *topView;
@property (nonatomic, strong) Music *musicView;
@property (nonatomic, assign) BOOL isJingGao;

@end

#define channelOnPeropheralView @"peripheralView"
#define channelOnCharacteristicView @"CharacteristicView"

@implementation MineViewController

#pragma mark -init
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
    _centerView.speed = 40;
    
}

// 界面设计
- (void)setUpView{
    _topView = [[TopView alloc] init];
    _topView.delegate = self;
    [self.view addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset = 0;
        make.height.offset = 64;
    }];
    
    _centerView = [[CenterView alloc] init];
    _centerView.delegate = self;
    [self.view addSubview:_centerView];
    [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.top.equalTo(_topView.mas_bottom).offset = 0;
        make.height.offset = 60;
    }];
    
    _musicView = [[Music alloc] init];
    _musicView.delegate = self;
    [self.view addSubview:_musicView];
    [_musicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerView.mas_bottom).offset = 15;
        make.left.right.offset = 0;
        make.height.offset  = 140;
    }];
    
    // 50 29
    _direView = [[DirectionView alloc] init];
    _direView.delegate = self;
    [self.view addSubview:_direView];
    [_direView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.bottom.offset = -64;
        make.height.offset = 250;
    }];
    
    
}



#pragma mark - write
// 音乐控制界面音乐控制
- (void)playMusicStateChangedWithButtonTag:(NSInteger)tag{
    [self getCharecterWithCharecterString:@"FFF4"];
    switch (tag) {

        case 2:// 上一曲
        {
            [self writeValueWitByte:0x02];
            _musicView.playBtn.selected = YES;

        }
            break;
        case 3:// 下一曲
        {
            [self writeValueWitByte:0x03];
            _musicView.playBtn.selected = YES;
        }
            break;
        case 5:// 播放
        {
            [self writeValueWitByte:0x05];
            _musicView.playBtn.selected = YES;
            _firstPlay = YES;
            _isplaying = YES;
        }
            break;
        case 6:// 停止
        {
            [self writeValueWitByte:0x06];
            _isplaying = NO;
            _musicView.playBtn.selected = NO;

        }
            break;
        case 7:// 单曲循环
        {
            [self writeValueWitByte:0x07];
            _isplaying = YES;
            _musicView.playBtn.selected = YES;
            
        }
            break;
        case 8:// 随机
        {
            [self writeValueWitByte:0x08];
            _isplaying = YES;
            _musicView.playBtn.selected = YES;
            
        }
            break;
            
        default:
            break;
    }
}

// 写入数据
-(void)writeValueWitByte:(Byte)byte{
    //    int i = 1;
    Byte b = byte;
    NSData *data = [NSData dataWithBytes:&b length:sizeof(b)];
    [self.currPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    
}

#pragma mark - 方法 method
// 跳转音乐控制界面
- (void)getToMusicController{
    MusicViewController *vc = [MusicViewController sharePlayingVC];
    vc.mainVc = self;
    self.musicVC = vc;
    [self.navigationController pushViewController:vc animated:YES];
}

// 搜索到设备后，返回界面时连接设备
- (void)connectToPerhips{
    //初始化
    self.services = [[NSMutableArray alloc]init];
    [self babyDelegate];
    
    //开始扫描设备
    [self performSelector:@selector(loadData) withObject:nil afterDelay:2];
}

// 连接设备
-(void)loadData{
    [SVProgressHUD showInfoWithStatus:@"开始连接设备"];
    baby.having(self.currPeripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    [self loadConnect];
}

// 初始化数组
- (void)loadConnect{
    //初始化数据
    readValueArray = [[NSMutableArray alloc]init];
    descriptors = [[NSMutableArray alloc]init];
    
}




#pragma mark - babyDelegate

-(void)babyDelegate{
    
    __weak typeof(self)weakSelf = self;

    BabyRhythm *rhythm = [[BabyRhythm alloc]init];
    
    
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [baby setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接成功",peripheral.name]];
    }];
    
    //设置设备连接失败的委托
    [baby setBlockOnFailToConnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--连接失败",peripheral.name);
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接失败",peripheral.name]];
    }];
    
    //设置设备断开连接的委托
    __weak typeof (baby)weakBaby = baby;
    [baby setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--断开连接",peripheral.name);
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--断开失败",peripheral.name]];
        [weakBaby AutoReconnect:peripheral];
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *s in peripheral.services) {
            ///插入section到tableview
            [weakSelf insertSectionToTableView:s];// ******
        }

        [rhythm beats];
    }];
    
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        //插入row到tableview
        [weakSelf insertRowToTableView:service];// *****
        
    }];
    
    //设置读取characteristics的委托   === 读取chara
    [baby setBlockOnReadValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        
        // 电量
        if ([characteristics.UUID.description isEqualToString:@"FFF1"]) {
            NSData *data = characteristics.value;
            NSLog(@"%@", [NSString stringWithFormat:@"%@", data]);
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            str = [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@">" withString:@""];
            weakSelf.topView.barreryString = str;
            if (str.length > 0) {
                [weakSelf recordCurrentTimeWithBattery:str];
            }
        }
        
        // 总的音乐时间
        if ([characteristics.UUID.description isEqualToString:@"FFF6"]) {
            NSData *data = characteristics.value;
            NSLog(@"%@", [NSString stringWithFormat:@"%@", data]);
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            str = [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@">" withString:@""];
            if (weakSelf.musicVC) {
                [weakSelf.musicVC getMuicTotalTime:[str integerValue]];
            }
            
        }
        
        // 音量读取
        if ([characteristics.UUID.description isEqualToString:@"FFF8"]) {
            NSData *data = characteristics.value;
            NSLog(@"%@", [NSString stringWithFormat:@"%@", data]);
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            str = [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@">" withString:@""];
            if (weakSelf.musicVC) {
                [weakSelf.musicVC getCurrentVoice:[str floatValue]];
            }
            
        }
        
        
    }];
    //设置发现characteristics的descriptors的委托 ==
    [baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
        
        if ([characteristic.UUID.description isEqualToString:@"FFF5"]) {
            [weakSelf setNotifiyWith:characteristic];
        }
        
        if ([characteristic.UUID.description isEqualToString:@"FFF3"]) {
            [weakSelf getJingGaoWithChara:characteristic];
        }

    }];

    
    //读取rssi的委托
    [baby setBlockOnDidReadRSSI:^(NSNumber *RSSI, NSError *error) {
        NSLog(@"setBlockOnDidReadRSSI:RSSI:%@",RSSI);
    }];
    
    
    //设置beats break委托
    [rhythm setBlockOnBeatsBreak:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsBreak call");
        
        //如果完成任务，即可停止beat,返回bry可以省去使用weak rhythm的麻烦
        //        if (<#condition#>) {
        //            [bry beatsOver];
        //        }
        
    }];
    
    //设置beats over委托
    [rhythm setBlockOnBeatsOver:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsOver call");
    }];
    
#pragma 操作
    // read
    //设置读取Descriptor的委托 ==
    [baby setBlockOnReadValueForDescriptorsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        
        // 读取电量的时候，改变电量值
        for (PeripheralInfo *info in weakSelf.services) {
            NSLog(@"%@", info.serviceUUID.description);
            if ([info.serviceUUID.description isEqualToString:@"FFF0"]) {
                for (CBCharacteristic *chara in info.characteristics) {
                    if ([chara.UUID.description isEqualToString:@"FFF1"]) {
                        NSData *data = chara.value;
                        NSLog(@"%@", [NSString stringWithFormat:@"%@", data]);
                        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        str = [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
                        str = [str stringByReplacingOccurrencesOfString:@">" withString:@""];
                        weakSelf.topView.barreryString = str;
                        if (str.length > 0) {
                           [weakSelf recordCurrentTimeWithBattery:str];
                        }
                        
                    }
                }
            }
        }
        
        // 读取速度
        for (CBService *service in peripheral.services) {
            if ([service.UUID.description isEqualToString:@"FFF0"]) {
                for (CBCharacteristic *chara in service.characteristics) {
                    if ([chara.UUID.description isEqualToString:@"FFF5"]) {
                        
                        NSData *data = chara.value;
                        NSLog(@"%@", [NSString stringWithFormat:@"%@", data]);
                        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        str = [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
                        str = [str stringByReplacingOccurrencesOfString:@">" withString:@""];
                        weakSelf.centerView.speed = [str integerValue];
                        
                    }
                }
            }
            
        }
        
        ///
        // 读取播放状态
        for (CBService *service in peripheral.services) {
            if ([service.UUID.description isEqualToString:@"FFF0"]) {
                for (CBCharacteristic *chara in service.characteristics) {
                    if ([chara.UUID.description isEqualToString:@"FFF9"]) {
                        
                        NSData *data = chara.value;
                        NSLog(@"%@", [NSString stringWithFormat:@"%@", data]);
                        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        str = [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
                        str = [str stringByReplacingOccurrencesOfString:@">" withString:@""];
                        [weakSelf getMusicStateWithState:[str integerValue]];
                        
                    }
                }
            }
            
        }
        
        
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    // wrirte
    //设置写数据成功的block
    [baby setBlockOnDidWriteValueForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBCharacteristic *characteristic, NSError *error) {
        
        
        NSLog(@"setBlockOnDidWriteValueForCharacteristicAtChannel characteristic:%@ and new value:%@",characteristic.UUID, characteristic.value);
    }];
    
    // noti
    //设置通知状态改变的block
    [baby setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"uid:%@,isNotifying:%@",characteristic.UUID,characteristic.isNotifying?@"on":@"off");
        
    }];
    
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    /*连接选项->
     CBConnectPeripheralOptionNotifyOnConnectionKey :当应用挂起时，如果有一个连接成功时，如果我们想要系统为指定的peripheral显示一个提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnDisconnectionKey :当应用挂起时，如果连接断开时，如果我们想要系统为指定的peripheral显示一个断开连接的提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnNotificationKey:
     当应用挂起时，使用该key值表示只要接收到给定peripheral端的通知就显示一个提
     */
    NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
    
    [baby setBabyOptionsAtChannel:channelOnPeropheralView scanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectOptions scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
}

#pragma mark - 保存搜索到的服务
-(void)insertSectionToTableView:(CBService *)service{
    NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
    PeripheralInfo *info = [[PeripheralInfo alloc]init];
    [info setServiceUUID:service.UUID];
    [self.services addObject:info];

}

-(void)insertRowToTableView:(CBService *)service{
    //    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    int sectt = -1;
    for (int i=0;i<self.services.count;i++) {
        PeripheralInfo *info = [self.services objectAtIndex:i];
        if (info.serviceUUID == service.UUID) {
            sectt = i;
        }
    }
    if (sectt != -1) {
        PeripheralInfo *info =[self.services objectAtIndex:sectt];
        for (int row=0;row<service.characteristics.count;row++) {
            CBCharacteristic *c = service.characteristics[row];
            [info.characteristics addObject:c];
            //            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:sect];
            //            [indexPaths addObject:indexPath];
            NSLog(@"add indexpath in row:%d, sect:%d",row,sectt);
        }
        //        PeripheralInfo *curInfo =[self.services objectAtIndex:sect];
        //        NSLog(@"%@",curInfo.characteristics);
        //        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    
    
}

#pragma mark -MusicControl 
- (void)ReadMusicDuration{
    
}

- (void)getMusicStateWithState:(NSInteger)state{
    _musicView.playBtn.selected = state;
}

#pragma mark - LifeCircle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - TopViewDelegate
// 获取设备
- (void)TopClickToGetDevice{
    ScanViewController *vc = [[ScanViewController alloc] init];
    vc.mainVc = self;
    [self.navigationController pushViewController:vc animated:YES];
}

// 电量多少
-(void)TopClickToSeButteryUseHistory{
    for (PeripheralInfo *info in self.services) {
        if ([info.serviceUUID.description isEqualToString:@"FFF0"]) {
            for (CBCharacteristic *chara in info.characteristics) {
                if ([chara.UUID.description isEqualToString:@"FFF1"]) {
                    self.characteristic = chara;
                    
                }
            }
        }
    }
    //读取服务
    if (self.characteristic) {
        baby.channel(channelOnCharacteristicView).characteristicDetails(self.currPeripheral,self.characteristic);
    }}

#pragma mark - DirectionViewDelegate
// 读取服务
-(void)DirectionViewclickToGetMusic{
    //读取服务
    if (self.characteristic) {
        baby.channel(channelOnCharacteristicView).characteristicDetails(self.currPeripheral,self.characteristic);
    }
}

// 电量历史界面
-(void)DirectionViewclickToGetHistory{
//    if (self.characteristic) {
//       baby.channel(channelOnCharacteristicView).characteristicDetails(self.currPeripheral,self.characteristic);
//    }

    
    JHShowController *vc = [[JHShowController alloc] init];
    vc.index = 0;
    [self.navigationController pushViewController:vc animated:YES];
}

// 控制上下左右
- (void)DirectionViewChooseDireciton:(NSInteger)direction{

    [self getCharecterWithCharecterString:@"FFF2"];
    switch (direction) {
        case 1:
        {
            [self writeValueWitByte:0x01];
        }
            break;
        case 2:
        {
            [self writeValueWitByte:0x02];

        }
            break;
        case 3:
        {
            [self writeValueWitByte:0x03];

        }
            break;
        case 4:
        {
            [self writeValueWitByte:0x04];

        }
            break;

        case 5:
        {
            [self writeValueWitByte:0x05];
            
        }
            break;

        case 6:
        {
            [self writeValueWitByte:0x06];
            
        }
            break;

        case 7:
        {
            [self writeValueWitByte:0x07];
            
        }
            break;
        default:
            break;
    }
}

// 特征选定
- (void)getCharecterWithCharecterString:(NSString *)charecterString{
    for (PeripheralInfo *info in self.services) {
        if ([info.serviceUUID.description isEqualToString:@"FFF0"]) {
            for (CBCharacteristic *chara in info.characteristics) {
                if ([chara.UUID.description isEqualToString:charecterString]) {
                    self.characteristic = chara;
                    
                }
            }
        }
    }
}

#pragma mark - MusicDelegate
// 音乐控制
- (void)controlMusicWithIndex:(NSInteger)index{
    [self getCharecterWithCharecterString:@"FFF4"];
    switch (index) {
        case 1:// 上一曲
        {
            [self writeValueWitByte:0x02];
            _musicView.playBtn.selected = YES;

        }
            break;
        case 5:// 播放
        {
            [self writeValueWitByte:0x05];
            _isplaying = YES;
            _firstPlay = YES;
        }
            break;
        case 3:// 下一曲
        {
            [self writeValueWitByte:0x03];
            _musicView.playBtn.selected = YES;

        }
            break;
        case 4:// 我的音乐
        {
            [self getToMusicController];
        }
            break;
        case 6:// 暂停
        {
            [self writeValueWitByte:0x06];
            _isplaying = NO;
        }
            break;
        case 7:// 单曲循环
        {
            [self writeValueWitByte:0x07];
            _isplaying = YES;
            _musicView.playBtn.selected = YES;
            
        }
            break;
        case 8:// 随机
        {
            [self writeValueWitByte:0x07];
            _isplaying = YES;
            _musicView.playBtn.selected = YES;
            
        }
            
        default:
            break;
    }
}

- (void)getTotalTime{
    [self readWithCharaString:@"FFF6"];
}




- (NSInteger)getDecimalByBinary:(NSString *)binary {
    
    NSInteger decimal = 0;
    for (int i=0; i<binary.length; i++) {
        
        NSString *number = [binary substringWithRange:NSMakeRange(binary.length - i - 1, 1)];
        if ([number isEqualToString:@"1"]) {
            
            decimal += pow(2, i);
        }
    }
    return decimal;
}

#pragma mark - 订阅一个值
-(void)setNotifiyWith:(CBCharacteristic *)chara{

                    __weak typeof(self)weakSelf = self;
                    if(self.currPeripheral.state != CBPeripheralStateConnected) {
                        [SVProgressHUD showErrorWithStatus:@"peripheral已经断开连接，请重新连接"];
                        return;
                    }
                    if (chara.properties & CBCharacteristicPropertyNotify ||  chara.properties & CBCharacteristicPropertyIndicate) {
                        
                        if(chara.isNotifying) {
                            return;
                        }else{
                            [weakSelf.currPeripheral setNotifyValue:YES forCharacteristic:chara];

                            [baby notify:self.currPeripheral
                          characteristic:chara
                                   block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {

                                       NSData *data = chara.value;
                                       NSLog(@"%@", [NSString stringWithFormat:@"%@", data]);
                                       NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       str = [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
                                       str = [str stringByReplacingOccurrencesOfString:@">" withString:@""];
                                       
                                       weakSelf.centerView.speed = [str integerValue];

                                   }];
                    }
                        
                        
                    }else{
                        [SVProgressHUD showErrorWithStatus:@"这个characteristic没有nofity的权限"];
                        return;
                    }
    
}

- (void)getJingGaoWithChara:(CBCharacteristic *)chara{
    
    __weak typeof(self)weakSelf = self;
    if(self.currPeripheral.state != CBPeripheralStateConnected) {
        [SVProgressHUD showErrorWithStatus:@"peripheral已经断开连接，请重新连接"];
        return;
    }
    if (chara.properties & CBCharacteristicPropertyNotify ||  chara.properties & CBCharacteristicPropertyIndicate) {
        
        if(chara.isNotifying) {
            return;
        }else{
            
            [weakSelf.currPeripheral setNotifyValue:YES forCharacteristic:chara];
            [baby notify:self.currPeripheral
          characteristic:chara
                   block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                       
 
                       NSData *data = chara.value;
                       NSLog(@"%@", [NSString stringWithFormat:@"%@", data]);
                       NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                       str = [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
                       str = [str stringByReplacingOccurrencesOfString:@">" withString:@""];

                       if ([str integerValue] < 10) {
                           return;
                       }
                       if (!self.isJingGao) {
                           UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"警告" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                           UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                               self.isJingGao = NO;
                           }];
                           [controller addAction:action1];
                           [self presentViewController:controller animated:YES completion:nil];
                       }
                       self.isJingGao = YES;
                       
                   }];
        }
        
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"这个characteristic没有nofity的权限"];
        return;
    }
    
    
    


}


// 主动获取电量
- (void)readWithCharaString:(NSString *)string{
    for (CBService *serice in self.currPeripheral.services ) {
        if ([serice.UUID.description isEqual:@"FFF0"]) {
            for (CBCharacteristic *chare in serice.characteristics) {
                if ([chare.UUID.description isEqualToString:string]) {
                    [self.currPeripheral readValueForCharacteristic:chare];
                }
            }
        }
    }
}

#pragma mark - CenterViewDelegate
-(void)changedSpeedWith:(UIButton *)btn{
//    [self setNotifiy:btn];
}

- (void)recordCurrentTimeWithBattery:(NSString *)battery{
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.locale = [NSLocale currentLocale];
    
    dateFormatter.dateStyle = kCFDateFormatterFullStyle;
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *nowDateStr= [dateFormatter stringFromDate:currentDate];
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr = [[df objectForKey:@"locationTime"] mutableCopy];
    if (arr.count==0) {
        arr = [NSMutableArray array];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:battery forKey:nowDateStr];
    
    // 判断时间间隔
    if (arr.count > 0) {
        NSDictionary *dic = arr.lastObject;
        NSString *str = dic.allKeys.firstObject;
        
        NSDateFormatter *f = [NSDateFormatter new];
        //设置格式Mon Aug 15 15:36:17 +0800 2016
        
        f.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *date1 = [f dateFromString:str];
        
        NSDate *date2 = [NSDate new];
        
        NSTimeInterval timeInterval1 = [date1 timeIntervalSince1970];
        NSTimeInterval timeInterval2 = [date2 timeIntervalSince1970];
        NSInteger timeInterval = timeInterval2 - timeInterval1;
        
        if (timeInterval < 5) {
            return;
        }
    }
    
    [arr addObject:dic];

    [df setObject:arr forKey:@"locationTime"];
    [df synchronize];
    
    NSLog(@"%@", nowDateStr);
    NSLog(@"%@", nowDateStr);
    
}

// 读取电量
- (void)readBattery{
    [self readWithCharaString:@"FFF1"];
}

// 读取音量
- (void)getCurrentVoice{
    [self readWithCharaString:@"FFF8"];
}

// 写入播放时间
- (void)writeCurrentTime:(NSInteger)time{
    [self getCharecterWithCharecterString:@"FFF7"];

    NSString *str = [NSString stringWithFormat:@"%ld", time];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self.currPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
}

// 写入播放音量
- (void)writeCurrentVoice:(CGFloat)voice{
    [self getCharecterWithCharecterString:@"FFF8"];

    NSString *str = [NSString stringWithFormat:@"%f", voice];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self.currPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    
}
#pragma mark - 音乐时间
#pragma mark - 订阅一个值
-(void)setMusicNotifiyBool:(BOOL)iSNoti{
    
    __weak typeof(self)weakSelf = self;
    [self getCharecterWithCharecterString:@"FFF7"];
    if(self.currPeripheral.state != CBPeripheralStateConnected) {
        [SVProgressHUD showErrorWithStatus:@"peripheral已经断开连接，请重新连接"];
        return;
    }
    if (self.characteristic.properties & CBCharacteristicPropertyNotify ||  self.characteristic.properties & CBCharacteristicPropertyIndicate) {
        
        if(!iSNoti) {

            return;
        }else{
            [weakSelf.currPeripheral setNotifyValue:YES forCharacteristic:self.characteristic];
            [baby notify:self.currPeripheral
          characteristic:self.characteristic
                   block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                       [weakSelf getCharecterWithCharecterString:@"FFF7"];

                       NSData *data = self.characteristic.value;
                       NSLog(@"%@", [NSString stringWithFormat:@"%@", data]);
                       NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                       str = [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
                       str = [str stringByReplacingOccurrencesOfString:@">" withString:@""];
                       if (self.musicVC) {
                           [self.musicVC getCurrentTime:[str integerValue]];
                       }
                   }];
        }
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"这个characteristic没有nofity的权限"];
        return;
    }
    
    
}



@end

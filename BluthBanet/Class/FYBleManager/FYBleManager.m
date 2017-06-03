//
//  FYBleManager.m
//  BluthBanet
//
//  Created by tao on 17/3/24.
//  Copyright © 2017年 tao. All rights reserved.
//

#import "FYBleManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
#define centralQueueStr @"centralQueue"
#define Buleuniqueidentifier @"Buleuniqueidentifier"
#define ST_SERVICE_UUID @"d6ca9a9db5d2e3ee8914d4aa09777c2511fdcb47"
#define serviceUUIDs @"d6ca9a9db5d2e3ee8914d4aa09777c2511fdcb47"
#define ST_CHARACTERISTIC_UUID_READ @"d6ca9a9db5d2e3ee8914d4aa09777c2511fdcb47"
#define ST_CHARACTERISTIC_UUID_WRITE @"d6ca9a9db5d2e3ee8914d4aa09777c2511fdcb47"

@interface FYBleManager ()<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) CBCharacteristic *read;
@property (nonatomic, strong) CBCharacteristic *write;

@end

@implementation FYBleManager

// 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        dispatch_queue_t centralQueue = dispatch_queue_create("centralQueue",DISPATCH_QUEUE_SERIAL);
        NSDictionary *dic = @{CBCentralManagerOptionShowPowerAlertKey : @YES, CBCentralManagerOptionRestoreIdentifierKey : Buleuniqueidentifier};
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:centralQueue options:dic];

    }
    return self;
    
}

#pragma mark - Meth
// 扫描
- (void)swept{
    //不重复扫描已发现设备
    NSDictionary *option = @{CBCentralManagerScanOptionAllowDuplicatesKey : [NSNumber numberWithBool:NO],CBCentralManagerOptionShowPowerAlertKey:@YES};
    [self.centralManager scanForPeripheralsWithServices:nil options:option];
    [self.centralManager scanForPeripheralsWithServices:@[serviceUUIDs] options:nil];
}

#pragma mark - CBCentralManagerDelegate
// 设备状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
            // 未知状态
        case CBManagerStateUnknown:
        {
            
        }
            break;
            // 重启状态
        case CBManagerStateResetting:
        {
            
        }
            break;
            // 不支持
        case CBManagerStateUnsupported:
        {
            
        }
            break;
            // 未授权
        case CBManagerStateUnauthorized:
        {
            
        }
            break;
            // 蓝牙未开启
        case CBManagerStatePoweredOff:
        {
            
        }
            break;
            // 蓝牙开启
        case CBManagerStatePoweredOn:
        {
            
        }
            break;
            
        default:
            break;
    }
}


// 连接外设
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    NSLog(@"advertisementData:%@，RSSI:%@",advertisementData,RSSI);
    if([peripheral.name isEqualToString:@"MI"]){
        [self.centralManager connectPeripheral:peripheral options:nil];//发起连接的命令
        self.peripheral = peripheral;
//        CBService *ser = self.peripheral.services.firstObject;
//        CBCharacteristic *tic = ser.characteristics;
        
    }
}

// 重连调用
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict{
    
}

// *********** 连接的状态 **************
//连接成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    //连接成功之后寻找服务，传nil会寻找所有服务
    [peripheral discoverServices:nil];
}

// 连接失败的回调
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    
}

// 连接断开的回调
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    
}

// ************ 读写数据

//发现服务的回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (!error) {
        for (CBService *service in peripheral.services) {
            NSLog(@"serviceUUID:%@", service.UUID.UUIDString);
            if ([service.UUID.UUIDString isEqualToString:ST_SERVICE_UUID]) {
                //发现特定服务的特征值
                [service.peripheral discoverCharacteristics:nil forService:service];
            }
        }
    }
}

//发现characteristics，由发现服务调用（上一步），获取读和写的characteristics
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    for (CBCharacteristic *characteristic in service.characteristics) {
        //有时读写的操作是由一个characteristic完成
        if ([characteristic.UUID.UUIDString isEqualToString:ST_CHARACTERISTIC_UUID_READ]) {
            self.read = characteristic;
            [self.peripheral setNotifyValue:YES forCharacteristic:self.read];
        } else if ([characteristic.UUID.UUIDString isEqualToString:ST_CHARACTERISTIC_UUID_WRITE]) {
            self.write = characteristic;
        }
    }
}

//是否写入成功的代理
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        NSLog(@"===写入错误：%@",error);
    }else{
        NSLog(@"===写入成功");
    }
}

//数据接收
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if([characteristic.UUID.UUIDString isEqualToString:ST_CHARACTERISTIC_UUID_READ]){
        //获取订阅特征回复的数据
        NSData *value = characteristic.value;
        NSLog(@"蓝牙回复：%@",value);
    }
}

// 蓝牙电量
- (void)getBattery{
    Byte value[3]={0};
//    value[0]=x1B;
//    value[1]=x99;
//    value[2]=x01;
    NSData * data = [NSData dataWithBytes:&value length:sizeof(value)];
    //发送数据
    [self.peripheral writeValue:data forCharacteristic:self.write type:CBCharacteristicWriteWithoutResponse];
}

@end

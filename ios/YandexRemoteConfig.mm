//
//  YandexRemoteConfig.m
//  beletsky-react-native-yandex-remote-config
//
//  Created by Ярослав on 31.01.2025.
//
#import "YandexRemoteConfig.h"
#import "MetricaAdapterReflection/MetricaAdapterReflection-Swift.h"
#import "Varioqub/Varioqub-Swift.h"
#import <Foundation/Foundation.h>

@implementation YandexRemoteConfig
 
RCT_EXPORT_MODULE()

// Приватный метод для создания VarioqubConfig
- (VQConfig *)createVarioqubConfigFromJSObject:(NSDictionary *)jsObject {
    VQConfig *vqCfg = [VQConfig defaultConfig];
    
    // baseURL
    NSString *baseURLString = [jsObject objectForKey:@"baseURL"];
    if ([baseURLString isKindOfClass:[NSString class]]) {
        NSURL *baseURL = [NSURL URLWithString:baseURLString];
        if (baseURL) {
            vqCfg.baseURL = baseURL;
        }
    }

    // settings
    id settings = [jsObject objectForKey:@"settings"];
    if ([settings conformsToProtocol:@protocol(VQSettingsProtocol)]) {
        vqCfg.settings = settings;
    }

    // fetchThrottle
    NSNumber *fetchThrottle = [jsObject objectForKey:@"fetchThrottle"];
    if ([fetchThrottle isKindOfClass:[NSNumber class]]) {
        vqCfg.fetchThrottle = [fetchThrottle doubleValue];
    }

    // clientFeatures
    NSDictionary *clientFeatures = [jsObject objectForKey:@"clientFeatures"];
    if ([clientFeatures isKindOfClass:[NSDictionary class]]) {
        vqCfg.initialClientFeatures =
            [[VQClientFeatures alloc] initWithDictionary:clientFeatures];
    }

    // varioqubQueue
    dispatch_queue_t varioqubQueue = [jsObject objectForKey:@"varioqubQueue"];
    if (varioqubQueue) {
        vqCfg.varioqubQueue = varioqubQueue;
    }

    // outputQueue
    dispatch_queue_t outputQueue = [jsObject objectForKey:@"outputQueue"];
    if (outputQueue) {
        vqCfg.outputQueue = outputQueue;
    }

    return vqCfg;
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params {
    return std::make_shared<
        facebook::react::NativeYandexRemoteConfigSpecJSI>(params);
}

- (void)initialize:(NSString *)apiKey
            config:(NSDictionary *)config
           resolve:(RCTPromiseResolveBlock)resolve
            reject:(RCTPromiseRejectBlock)reject {
    @try {
        VQAppmetricaAdapter *adapter = [[VQAppmetricaAdapter alloc] init];
        VQConfig *createdConfig =
            [self createVarioqubConfigFromJSObject:config];
        [[VQVarioqubFacade sharedVarioqub] initializeWithClientId:apiKey
                                                           config:createdConfig
                                                       idProvider:adapter
                                                         reporter:adapter];
        resolve(@(YES));
    } @catch (NSException *exception) {
        NSError *error = [NSError
            errorWithDomain:@"YaFeatureToggles"
                       code:123
                   userInfo:@{
                       NSLocalizedDescriptionKey : @"Initialization failed"
                   }];
        reject(@"INITIALIZATION_ERROR", @"Error initializing", error);
    }
}

- (void)activateConfig:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    [[VQVarioqubFacade sharedVarioqub] activateConfigWithCompletion:^{
        resolve(@"activateConfig completed");
    }];
}

- (void)fetchConfig:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    [[VQVarioqubFacade sharedVarioqub] fetchConfigWithCompletion:^(VQFetchStatus status, NSError *error) {
        if (error) {
            NSError *fetchError = [NSError errorWithDomain:@"YaFeatureToggles" code:123 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Error: %@", error.localizedDescription]}];
            reject(@"FETCH_CONFIG_ERROR", @"Error fetching config", fetchError);
            return;
        }
        
        switch (status) {
            case VQFetchStatusSuccess:
                resolve(@"success");
                break;
            case VQFetchStatusThrottled:
            case VQFetchStatusCached:
                resolve(@"already latest");
                break;
            default:
                reject(@"FETCH_CONFIG_ERROR", @"Unknown option for status", nil);
                break;
        }
    }];
}

- (void)getString:(NSString *)flagName defaultValue:(NSString *)defaultValue resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    if (flagName) {
        NSString *value = [[VQVarioqubFacade sharedVarioqub] getStringFor:flagName defaultValue:defaultValue];
        resolve(value);
    } else {
        NSError *error = [NSError errorWithDomain:@"YaFeatureToggles" code:123 userInfo:@{NSLocalizedDescriptionKey: @"Invalid flag name"}];
        reject(@"INVALID_FLAG_NAME", @"Invalid flag name", error);
    }
}

- (void)getInt:(NSString *)flagName defaultValue:(NSInteger)defaultValue resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    if (flagName) {
        NSInteger value = [[VQVarioqubFacade sharedVarioqub] getIntFor:flagName];
        resolve(@(value));
    } else {
        NSError *error = [NSError errorWithDomain:@"YaFeatureToggles" code:123 userInfo:@{NSLocalizedDescriptionKey: @"Invalid flag name"}];
        reject(@"INVALID_FLAG_NAME", @"Invalid flag name", error);
    }
}

- (void)getDouble:(NSString *)flagName defaultValue:(double)defaultValue resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    if (flagName) {
        double value = [[VQVarioqubFacade sharedVarioqub] getDoubleFor:flagName defaultValue:defaultValue];
        resolve(@(value));
    } else {
        NSError *error = [NSError errorWithDomain:@"YaFeatureToggles" code:123 userInfo:@{NSLocalizedDescriptionKey: @"Invalid flag name"}];
        reject(@"INVALID_FLAG_NAME", @"Invalid flag name", error);
    }
}

- (void)getBool:(NSString *)flagName defaultValue:(BOOL)defaultValue resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    if (flagName) {
        BOOL value = [[VQVarioqubFacade sharedVarioqub] getBoolFor:flagName defaultValue:defaultValue];
        resolve(@(value));
    } else {
        NSError *error = [NSError errorWithDomain:@"YaFeatureToggles" code:123 userInfo:@{NSLocalizedDescriptionKey: @"Invalid flag name"}];
        reject(@"INVALID_FLAG_NAME", @"Invalid flag name", error);
    }
}

- (void)getDeviceId:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    NSString *deviceId = [[VQVarioqubFacade sharedVarioqub] varioqubId];
    if (deviceId) {
        resolve(deviceId);
    } else {
        NSError *error = [NSError errorWithDomain:@"YaFeatureToggles" code:123 userInfo:@{NSLocalizedDescriptionKey: @"No value for deviceId"}];
        reject(@"NO_VALUE", @"No value for deviceId", error);
    }
}

@end



package com.beletsky.yandexremoteconfig;

import com.facebook.react.TurboReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.model.ReactModuleInfo
import com.facebook.react.module.model.ReactModuleInfoProvider


class YandexRemoteConfigPackage : TurboReactPackage() {

  override fun getModule(name: String, reactContext: ReactApplicationContext): NativeModule? =
    if (name == NativeYandexRemoteConfigSpec.NAME) {
      YandexRemoteConfigModule(reactContext)
    } else {
      null
    }

  override fun getReactModuleInfoProvider() = ReactModuleInfoProvider {
    mapOf(
      NativeYandexRemoteConfigSpec.NAME to ReactModuleInfo(
        NativeYandexRemoteConfigSpec.NAME,
        NativeYandexRemoteConfigSpec.NAME,
        false,
        false,
        false,
        true
      )
    )
  }
}

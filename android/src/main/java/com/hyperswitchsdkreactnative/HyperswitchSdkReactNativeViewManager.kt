package com.hyperswitchsdkreactnative

import android.graphics.Color
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp

@ReactModule(name = HyperswitchSdkReactNativeViewManager.NAME)
class HyperswitchSdkReactNativeViewManager :
  HyperswitchSdkReactNativeViewManagerSpec<HyperswitchSdkReactNativeView>() {
  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): HyperswitchSdkReactNativeView {
    return HyperswitchSdkReactNativeView(context)
  }

  @ReactProp(name = "color")
  override fun setColor(view: HyperswitchSdkReactNativeView?, color: String?) {
    view?.setBackgroundColor(Color.parseColor(color))
  }

  companion object {
    const val NAME = "HyperswitchSdkReactNativeView"
  }
}

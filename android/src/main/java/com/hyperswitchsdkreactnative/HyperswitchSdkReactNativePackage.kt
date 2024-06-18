package com.hyperswitchsdkreactnative

import ReactNativeHyperswitchModule
import com.facebook.react.ReactPackage
import com.facebook.react.bridge.Callback
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.ViewManager

import io.hyperswitch.react.HyperHeadlessModule
import java.util.ArrayList

class HyperswitchSdkReactNativeViewPackage : ReactPackage {
  override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
    val viewManagers: MutableList<ViewManager<*, *>> = ArrayList()
    viewManagers.add(HyperswitchSdkReactNativeViewManager())
    return viewManagers
  }

  override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> {
    val nativeModules: MutableList<NativeModule> = ArrayList()
    nativeModules.add(ReactNativeHyperswitchModule(reactContext))
    nativeModules.add(HyperHeadlessModule(reactContext))
    return nativeModules
  }
}
